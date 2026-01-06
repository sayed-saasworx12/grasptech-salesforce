import { api, LightningElement } from "lwc";

export default class CustomPreChatFormField extends LightningElement {
    choiceListDefaultValue;
    prechatDetails = {};

    /**
    * Form field data.
    * @type {Object}
    */
    @api fieldInfo = {};

    @api
    get name() {
        return this.fieldInfo.name;
    }

    @api
    get value() {
        const lightningCmp = this.isTypeChoiceList
            ? this.template.querySelector("lightning-combobox")
            : this.template.querySelector("lightning-input");
        return this.isTypeCheckbox ? lightningCmp.checked : lightningCmp.value;
    }

    @api
    reportValidity() {
        const lightningCmp = this.isTypeChoiceList
            ? this.template.querySelector("lightning-combobox")
            : this.template.querySelector("lightning-input");
        return lightningCmp.reportValidity();
    }

    get type() {
        switch (this.fieldInfo.type) {
            case "Phone":
                return "tel";
            case "Text":
            case "Email":
            case "Number":
            case "Checkbox":
            case "ChoiceList":
                return this.fieldInfo.type.toLowerCase();
            default:
                return "text";
        }
    }

    get isTypeCheckbox() {
        return this.type === "checkbox";
    }

    get isTypeChoiceList() {
        return this.type === "choicelist";
    }

    /**
    * Formats choiceList options and sets the default value.
    * @type {Array}
    */
    get choiceListOptions() {
        let choiceListOptions = [];
        const choiceListValues = [...(this.fieldInfo.choiceListValues || [])];
        choiceListValues.sort((valueA, valueB) => valueA.order - valueB.order);
        for (const listValue of choiceListValues) {
            if (listValue.isDefaultValue) {
                this.choiceListDefaultValue = listValue.choiceListValueName;
            }
            choiceListOptions.push({
                label: listValue.label,
                value: listValue.choiceListValueName
            });
        }
        return choiceListOptions;
    }

    /**
    * 🔹 Field-level validation logic added below
    */
    handleOnChange(event) {
        const { name, value } = event.target;
        switch (name) {
            case 'firstName':
                this.prechatDetails._firstName = value;
                break;
            case 'lastName':
                this.prechatDetails._lastName = value;
                break;
            case 'email':
                this.prechatDetails._email = value;
                break;
            case 'description':
                this.prechatDetails._description = value;
                break;
        }
        this.validateField(event.target);
    }

    // Validate each field
    validateField(input) {
        const value = input.value?.trim() || '';
        let errorMsg = '';

        switch (input.name) {
            case 'firstName':
            case 'lastName':
                if (!value) errorMsg = 'This field is required';
                else if (/[^a-zA-Z\s]/.test(value))
                    errorMsg = 'Only letters allowed';
                break;

            case 'Email':
                if (!value) errorMsg = 'Email is required';
                else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value))
                    errorMsg = 'Enter a valid email (e.g., abc@email.com)';
                break;
        }

        input.setCustomValidity(errorMsg);
        input.reportValidity();
        return !errorMsg;
    }

    // Validate all fields before submission
    validateFields() {
        const inputs = this.template.querySelectorAll('lightning-input, lightning-textarea');
        let isValid = true;
        inputs.forEach(input => {
            if (!this.validateField(input)) isValid = false;
        });
        return isValid;
    }
}