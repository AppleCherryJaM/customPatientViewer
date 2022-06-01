import { LightningElement, track } from 'lwc';
import getFacilities from '@salesforce/apex/PatientComponentController.getFacilities';
import getPatientList from '@salesforce/apex/PatientComponentController.getPatientList';
import ContactMobile from '@salesforce/schema/Case.ContactMobile';

const columns = [
    { label: 'id', fieldName: 'id' },
    { label: 'firstName', fieldName: 'first name' },
    { label: 'lastName', fieldName: 'last name' }
];

export default class PatientViewer extends LightningElement {
    @track error;
    facilityValue = 1;
    columns = columns;
    facilities = [];
    patients = [];

    connectedCallback() {
        getFacilities()
            .then(res => {
                this.error = undefined;
                console.log(res);
                this.facilities = JSON.parse(res);
            })
            .catch(err => {
                this.facilities = undefined;
                this.error = err;
                console.log(err);
            })
    }

    connectedCallback() {
        getPatientList(this.facilityValue.toString)
            .then(res => {
                this.error = undefined;
                console.log(res);
                this.patients = JSON.parse(res);
            })
            .catch(err => {
                this.patients = undefined;
                this.error = err;
                console.log(err);
            });
    }

    handleChange(event) {
        this.facilityValue = event.detail.value;
    }
}