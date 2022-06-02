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

const COMPONENT_HEADER = 'Patient viewer';

export default class PatientViewer extends LightningElement {
    facilityValue;
    columns = COLUMNS;
    facilities = [];
    patients = [];
    header = COMPONENT_HEADER;

    connectedCallback() {
        this.getFacilityList();
    }

    getFacilityList() {
        getFacilities()
            .then(res => {
                if (res.isSuccess) {
                    this.facilities = res.data;
                }
            })
            .catch(err => {
                console.log('ERROR 1: ', err);
            })
    }

    getPatients() {
        getPatientList({ currentFacility: this.facilityValue })
            .then(res => {
                if (res.isSuccess) {
                    this.patients = res.data;
                }
            })
            .catch(err => {
                console.log('ERROR 2: ', err);
            })
    }

    handleChange(event) {
        this.facilityValue = event.detail.value;
        this.getPatients();
    }
}