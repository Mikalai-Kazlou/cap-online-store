sap.ui.define(
  [
    './BaseController',
    'sap/m/MessagePopover',
    'sap/m/MessageItem',
    'sap/m/MessageBox',
    'sap/m/MessageToast',
    'sap/ui/model/json/JSONModel',
    'sap/ui/core/syncStyleClass',
    'sap/ui/core/message/Message',
    'sap/ui/core/MessageType',
    'sap/ui/core/Core',
    'sap/ui/core/Element',
    '../model/constants',
  ],
  function (
    BaseController,
    MessagePopover,
    MessageItem,
    MessageBox,
    MessageToast,
    JSONModel,
    syncStyleClass,
    Message,
    MessageType,
    Core,
    Element,
    constants
  ) {
    'use strict';

    return BaseController.extend('ns.shop.controller.Cart', {
      onInit: function () {
        const oModel = new JSONModel({
          name: '',
          deliveryAddress: '',
          phoneNumber: '',
          email: '',
          cardNumber: '',
          valid: '',
          cvv: '',
        });

        this.requiredFieldsIDs = [
          'idDialogInputName',
          'idDialogInputDeliveryAddress',
          'idDialogInputPhoneNumber',
          'idDialogInputEmail',
          'idDialogInputCardNumber',
          'idDialogInputValid',
          'idDialogInputCVV',
        ];

        this.constrainedFieldsIDs = [
          'idDialogInputPhoneNumber',
          'idDialogInputEmail',
          'idDialogInputCardNumber',
          'idDialogInputValid',
          'idDialogInputCVV',
        ];

        this._oMessageManager = Core.getMessageManager();
        this._oMessageManager.removeAllMessages();

        this.oView = this.getView();
        this.oView.setModel(oModel);
        this.oView.setModel(this._oMessageManager.getMessageModel(), 'message');

        this.oResourceBundle = this.getResourceBundle();

        const oRouter = this.getRouter();
        oRouter.getRoute('cart').attachPatternMatched(this._onPatternMatched, this);
      },

      _onPatternMatched: function (oEvent) {
        const oArgs = oEvent.getParameter('arguments');
        const oQuery = oArgs['?query'];

        if (oQuery && oQuery.action === constants.actions.buyNow) {
          const oConfirmOrderDialogButton = this.byId('idConfirmOrderDialogButton');
          oConfirmOrderDialogButton.firePress();
        }
      },

      onCartListUpdateFinished: function () {
        const oCartList = this.byId('idCartList');
        const aCartItems = oCartList.getItems();

        aCartItems.forEach((oCartItem) => {
          const oCartItemData = oCartItem.getBindingContext('localdata').getObject();
          oCartItem.bindElement({ path: `/Products(ID=${oCartItemData.id},IsActiveEntity=true)`, model: 'main' });
        });
      },

      onCartListDelete: function (oEvent) {
        const oCartItem = oEvent.getParameter('listItem');
        const oCartItemData = oCartItem.getBindingContext('localdata').getObject();

        this.oCart.drop(oCartItemData.id);

        this._refreshCartModel();
        this._refreshLocalDataModel();
      },

      onOpenConfirmOrderDialog: function () {
        if (!this.oCart.get().length) {
          MessageToast.show(this.oResourceBundle.getText('noProductsInCart'));
          return;
        }

        if (!this.oConfirmOrderDialog) {
          this.oConfirmOrderDialog = this.loadFragment({
            name: 'ns.shop.view.ConfirmOrderDialog',
          });
        }

        this.oConfirmOrderDialog.then(
          function (oDialog) {
            syncStyleClass(this.getOwnerComponent().getContentDensityClass(), this.getView(), oDialog);

            this.oDialog = oDialog;
            this.oDialog.open();

            this._oMessageManager.registerObject(this.oView.byId('idConfirmOrderContainer'), true);
            this.createMessagePopover();
          }.bind(this)
        );
      },

      onMessagePopoverPress: function (oEvent) {
        if (!this.oMP) {
          this.createMessagePopover();
        }
        this.oMP.toggle(oEvent.getSource());
      },

      createMessagePopover: function () {
        const that = this;

        this.oMP = new MessagePopover({
          activeTitlePress: function (oEvent) {
            const oItem = oEvent.getParameter('item');
            const oPage = that.getView().byId('idCartPage');
            const oMessage = oItem.getBindingContext('message').getObject();
            const oControl = Element.registry.get(oMessage.getControlId());

            if (oControl) {
              oPage.scrollToElement(oControl.getDomRef(), 200, [0, -100]);
              setTimeout(() => oControl.focus(), 300);
              oEvent.getSource().close();
            }
          },
          items: {
            path: 'message>/',
            template: new MessageItem({
              title: '{message>message}',
              subtitle: '{message>additionalText}',
              groupName: {
                parts: [
                  {
                    path: 'message>controlIds',
                  },
                ],
                formatter: this.getGroupName,
              },
              activeTitle: {
                parts: [
                  {
                    path: 'message>controlIds',
                  },
                ],
                formatter: this.isReachable,
              },
              type: '{message>type}',
              description: '{message>description}',
            }),
          },
          groupItems: true,
        });

        this.getView().byId('idMessagePopoverButton').addDependent(this.oMP);
      },

      getGroupName: function (sControlId) {
        const oControl = Element.registry.get(sControlId[0]);

        if (oControl) {
          const sFormSubtitle = oControl.getParent().getParent().getTitle().getText();
          const sFormTitle = oControl.getParent().getParent().getParent().getTitle();

          return sFormTitle + ' > ' + sFormSubtitle;
        }

        return '';
      },

      isReachable: function (sControlId) {
        // Such a hook can be used by the application to determine if a control can be found/reached on the page and navigated to.
        return sControlId ? true : true;
      },

      onDialogInputChange: function (oEvent) {
        const oInput = oEvent.getSource();

        if (oInput.getRequired()) {
          this.handleRequiredField(oInput);
        }

        const sID = oInput.getId();
        if (this.constrainedFieldsIDs.find((id) => sID.includes(id))) {
          this.handleConstrainedField(oInput);
        }
      },

      handleRequiredField: function (oInput) {
        const sTarget = oInput.getBindingPath('value');
        this.removeMessageFromTarget(sTarget);

        if (!oInput.getValue()) {
          const sLabelText = oInput.getLabels()[0].getText();

          this._oMessageManager.addMessages(
            new Message({
              message: this.oResourceBundle.getText('requiredFieldMessage', [sLabelText]),
              type: MessageType.Error,
              additionalText: sLabelText,
              description: this.oResourceBundle.getText('requiredFieldDescription'),
              target: sTarget,
              processor: this.getView().getModel(),
            })
          );
        }
      },

      handleConstrainedField: function (oInput) {
        const sTarget = oInput.getBindingPath('value');
        const oBinding = oInput.getBinding('value');
        let sValueState = 'None';

        try {
          oBinding.getType().validateValue(oInput.getValue());
        } catch (oException) {
          const sID = oInput.getId();
          sValueState = 'Warning';

          const oMessage = new Message({
            type: MessageType.Warning,
            additionalText: oInput.getLabels()[0].getText(),
            description: this.oResourceBundle.getText('constrainedFieldDescription'),
            target: sTarget,
            processor: this.getView().getModel(),
          });

          switch (true) {
            case sID.includes('idDialogInputPhoneNumber'):
              oMessage.setMessage(this.oResourceBundle.getText('validationMessagePhoneNumber'));
              this._oMessageManager.addMessages(oMessage);
              break;
            case sID.includes('idDialogInputEmail'):
              oMessage.setMessage(this.oResourceBundle.getText('validationMessageEmail'));
              this._oMessageManager.addMessages(oMessage);
              break;
            case sID.includes('idDialogInputCardNumber'):
              oMessage.setMessage(this.oResourceBundle.getText('validationMessageCardNumber'));
              this._oMessageManager.addMessages(oMessage);
              break;
            case sID.includes('idDialogInputValid'):
              oMessage.setMessage(this.oResourceBundle.getText('validationMessageValid'));
              this._oMessageManager.addMessages(oMessage);
              break;
            case sID.includes('idDialogInputCVV'):
              oMessage.setMessage(this.oResourceBundle.getText('validationMessageCVV'));
              this._oMessageManager.addMessages(oMessage);
              break;
            default:
              break;
          }
        }

        oInput.setValueState(sValueState);
      },

      removeMessageFromTarget: function (sTarget) {
        this._oMessageManager
          .getMessageModel()
          .getData()
          .forEach(
            function (oMessage) {
              if (oMessage.target === sTarget) {
                this._oMessageManager.removeMessages(oMessage);
              }
            }.bind(this)
          );
      },

      // Display the button type according to the message with the highest severity
      // The priority of the message types are as follows: Error > Warning > Success > Info
      buttonTypeFormatter: function () {
        let sHighestSeverity;
        const aMessages = this._oMessageManager.getMessageModel().oData;
        aMessages.forEach(function (sMessage) {
          switch (sMessage.type) {
            case 'Error':
              sHighestSeverity = 'Negative';
              break;
            case 'Warning':
              sHighestSeverity = sHighestSeverity !== 'Negative' ? 'Critical' : sHighestSeverity;
              break;
            case 'Success':
              sHighestSeverity =
                sHighestSeverity !== 'Negative' && sHighestSeverity !== 'Critical' ? 'Success' : sHighestSeverity;
              break;
            default:
              sHighestSeverity = !sHighestSeverity ? 'Neutral' : sHighestSeverity;
              break;
          }
        });

        return sHighestSeverity;
      },

      // Display the number of messages with the highest severity
      highestSeverityMessages: function () {
        let sHighestSeverityMessageType;
        const sHighestSeverityIconType = this.buttonTypeFormatter();

        switch (sHighestSeverityIconType) {
          case 'Negative':
            sHighestSeverityMessageType = 'Error';
            break;
          case 'Critical':
            sHighestSeverityMessageType = 'Warning';
            break;
          case 'Success':
            sHighestSeverityMessageType = 'Success';
            break;
          default:
            sHighestSeverityMessageType = !sHighestSeverityMessageType ? 'Information' : sHighestSeverityMessageType;
            break;
        }

        return (
          this._oMessageManager.getMessageModel().oData.reduce(function (iNumberOfMessages, oMessageItem) {
            return oMessageItem.type === sHighestSeverityMessageType ? ++iNumberOfMessages : iNumberOfMessages;
          }, 0) || ''
        );
      },

      // Set the button icon according to the message with the highest severity
      buttonIconFormatter: function () {
        let sIcon;
        const aMessages = this._oMessageManager.getMessageModel().oData;

        aMessages.forEach(function (sMessage) {
          switch (sMessage.type) {
            case 'Error':
              sIcon = 'sap-icon://error';
              break;
            case 'Warning':
              sIcon = sIcon !== 'sap-icon://error' ? 'sap-icon://alert' : sIcon;
              break;
            case 'Success':
              sIcon = 'sap-icon://error' && sIcon !== 'sap-icon://alert' ? 'sap-icon://sys-enter-2' : sIcon;
              break;
            default:
              sIcon = !sIcon ? 'sap-icon://information' : sIcon;
              break;
          }
        });

        return sIcon;
      },

      onCancelOrder: function () {
        this.oDialog.close();
      },

      onConfirmOrder: function () {
        const oButton = this.byId('idMessagePopoverButton');
        oButton.setVisible(true);

        // this.byId('idDialogInputName').setValue('Test name');
        // this.byId('idDialogInputDeliveryAddress').setValue('Test address');
        // this.byId('idDialogInputPhoneNumber').setValue('+123456789');
        // this.byId('idDialogInputEmail').setValue('test.name@test.com');
        // this.byId('idDialogInputCardNumber').setValue('1234567890123456');
        // this.byId('idDialogInputValid').setValue('12/25');
        // this.byId('idDialogInputCVV').setValue('111');

        this.requiredFieldsIDs.forEach((id) => {
          const oInput = this.byId(id);
          this.handleRequiredField(oInput);
        });

        this.constrainedFieldsIDs.forEach((id) => {
          const oInput = this.byId(id);
          this.handleConstrainedField(oInput);
        });

        this.oMP.getBinding('items').attachChange(
          function (oEvent) {
            this.oMP.navigateBack();
            oButton.setType(this.buttonTypeFormatter());
            oButton.setIcon(this.buttonIconFormatter());
            oButton.setText(this.highestSeverityMessages());
          }.bind(this)
        );

        if (this.oMP.getItems().length) {
          setTimeout(() => this.oMP.openBy(oButton), 100);
        } else {
          this._createSalesOrder();
        }
      },

      _createSalesOrder: async function () {
        const oNewSalesOrder = {};

        const oFieldMapping = new Map();
        oFieldMapping.set('idDialogInputName', 'customerName');
        oFieldMapping.set('idDialogInputDeliveryAddress', 'customerDeliveryAddress');
        oFieldMapping.set('idDialogInputPhoneNumber', 'customerPhoneNumber');
        oFieldMapping.set('idDialogInputEmail', 'customerEmail');

        oFieldMapping.forEach((value, key) => {
          const oDialogInput = this.byId(key);
          oNewSalesOrder[value] = oDialogInput.getValue();
        });

        const oModel = this.getModel('main');
        const oSalesOrderBinding = oModel.bindList('/SalesOrders');
        const oNewSalesOrderContext = oSalesOrderBinding.create(oNewSalesOrder, true);

        try {
          await oNewSalesOrderContext.created();
        } catch (error) {
          throw new Error(`The Order has not been created: ${error.message}`);
        }

        await this._createSalesOrderItems(oNewSalesOrderContext);
        await this._activateSalesOrder(oNewSalesOrderContext);

        this._showOrderCreationSuccessMessageBox();
      },

      _createSalesOrderItems: async function (oNewSalesOrderContext) {
        const oModel = this.getModel('main');
        const oSalesOrderItemBinding = oModel.bindList('items', oNewSalesOrderContext);
        const aCartItems = this.oCart.get();

        const aItemsCreated = aCartItems.map((oCartItem) => {
          const oItem = {
            product_ID: oCartItem.id,
            quantity: oCartItem.q,
            price: oCartItem.p,
          };

          const oNewSalesOrderItemsContext = oSalesOrderItemBinding.create(oItem, true);
          return oNewSalesOrderItemsContext.created();
        });

        try {
          await Promise.all(aItemsCreated);
        } catch (error) {
          throw new Error(`The Order items have not been created: ${error.message}`);
        }
      },

      _activateSalesOrder: async function (oNewSalesOrderContext) {
        const oModel = this.getModel('main');
        const oOperation = oModel.bindContext('OnlineStoreService.draftActivate(...)', oNewSalesOrderContext);

        try {
          await oOperation.execute();
        } catch (error) {
          throw new Error(`The Order has not been activated: ${error.message}`);
        }
      },

      _showOrderCreationSuccessMessageBox: function () {
        MessageBox.success(this.oResourceBundle.getText('confirmOrderSuccess'), {
          title: this.oResourceBundle.getText('cartSummaryConfirmOrderButtonText'),
          styleClass: this.getOwnerComponent().getContentDensityClass(),
          onClose: () => {
            this.oCart.clear();

            this._refreshCartModel();
            this._refreshLocalDataModel();

            this.navTo('main');
          },
        });
        this.oDialog.close();
      },
    });
  }
);
