import { LightningElement, track } from 'lwc';
import getFacilities from '@salesforce/apex/PatientComponentController.getFacilities';
import getPatientList from '@salesforce/apex/PatientComponentController.getPatientList';


const COLUMNS = [{
        label: 'First Name',
        fieldName: 'firstName',
        cellAttributes: {
            class: 'slds-box slds-theme_shade',
            alignment: 'center'
        }
    },
    {
        label: 'Last Name',
        fieldName: 'lastName',
        cellAttributes: {
            class: 'slds-box slds-theme_shade',
            alignment: 'center'
        }
    }
];

const componentHeader = 'Patient viewer';

export default class PatientViewer extends LightningElement {
    @track error;
    facilityValue = "a047Q000002khQKQAY";
    columns = COLUMNS;
    facilities = [];
    patients = [];
    header = componentHeader;

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

    getPatients() {
        getPatientList({ currentFacility: this.facilityValue })
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
        console.log(this.facilityValue);
        this.getPatients();
    }
}