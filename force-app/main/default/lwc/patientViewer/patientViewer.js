import { LightningElement, track } from 'lwc';
import getFacilities from '@salesforce/apex/PatientComponentController.getFacilities';
import getPatientList from '@salesforce/apex/PatientComponentController.getPatientList';


const columns = [
    { label: 'id', fieldName: 'patientId' },
    { label: 'First Name', fieldName: 'firstName' },
    { label: 'Last Name', fieldName: 'lastName' }
];

export default class PatientViewer extends LightningElement {
    @track error;
    facilityValue = "a047Q000002khQKQAY";
    columns = columns;
    facilities = [];
    patients = [];



    connectedCallback() {
        this.getFacilityList();
    }

    getFacilityList() {
        getFacilities()
            .then(res => {
                console.log('RESULT: ' + res);
                this.facilities = JSON.parse(res);
            })
            .catch(err => {
                console.log('ERROR 1: ', err);
            })
    }

    getPatients(facilityId) {
        getPatientList(facilityId)
            .then(res => {
                this.patients = JSON.parse(res);
                console.log('PATIENTS: ', this.patients);
            })
            .catch(err => {
                console.log('ERROR 2: ', err);
            })
    }

    handleChange(event) {
        this.facilityValue = event.detail.value;
        getPatients(this.facilityValue);
    }
}