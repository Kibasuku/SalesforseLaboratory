import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import createAccount from '@salesforce/apex/AccountController.createAccount';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountTable extends LightningElement {
    @track accounts;
    @track error;
    @track searchKey = '';
    @track isLoading = true;
    @track isModalOpen = false;
    @track accountName = '';
    @track accountType = '';
    wiredAccounts;

    // Options for the account type combobox
    accountTypeOptions = [
        { label: 'Customer - Direct', value: 'Customer - Direct' },
        { label: 'Customer - Channel', value: 'Customer - Channel' },
        { label: 'Channel Partner / Reseller', value: 'Channel Partner / Reseller' },
        { label: 'Installation Partner', value: 'Installation Partner' },
        { label: 'Technology Partner', value: 'Technology Partner' },
        { label: 'Other', value: 'Other' }
    ];

    // Wire method to fetch accounts based on the search key
    @wire(getAccounts, { searchKey: '$searchKey' })
    wiredAccounts(result) {
        this.wiredAccounts = result;
        if (result.data) {
            this.accounts = result.data;
            this.error = undefined;
            this.isLoading = false;
        } else if (result.error) {
            this.error = result.error;
            this.accounts = undefined;
            this.isLoading = false;
        }
    }

    // Handle search input change
    handleSearch(event) {
        this.searchKey = event.target.value;
        this.isLoading = true;
        refreshApex(this.wiredAccounts);
    }

    // Handle open modal button click
    handleOpenModal() {
        this.isModalOpen = true;
    }

     // Handle close modal button click
    handleCloseModal() {
        this.isModalOpen = false;
        this.accountName = '';
        this.accountType = '';
    }

    // Handle name input change in the modal
    handleNameChange(event) {
        this.accountName = event.target.value;
    }

    // Handle type selection change in the modal
    handleTypeChange(event) {
        this.accountType = event.target.value;
    }

    // Handle save button click in the modal
    handleSave() {
        if (this.accountName && this.accountType) {
            this.isLoading = true;
        createAccount({ name: this.accountName, type: this.accountType })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Account created successfully',
                        variant: 'success'
                    })
                );
                this.handleCloseModal();
                return refreshApex(this.wiredAccounts);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating account',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
                this.isLoading = false;
            });
            
        } else {
            // Show error toast message if required fields are missing
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please enter all required fields',
                    variant: 'error'
                })
            );
        }
        
    }
}