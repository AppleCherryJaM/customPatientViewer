import { LightningElement, track } from 'lwc';
import getAnimalsList from '@salesforce/apex/JsonAnimals.getAnimalsList';

const columns = [
    { label: 'id', fieldName: 'id' },
    { label: 'name', fieldName: 'name' },
    { label: 'food', fieldName: 'eats' },
    { label: 'says', fieldName: 'says' }
];

export default class AnimalComponent extends LightningElement {
    @track error;
    animals = [];
    columns = columns;

    connectedCallback() {
        getAnimalsList()
            .then(res => {
                this.error = undefined;
                // res.forEach(animal => {
                //     console.log('First: ' + typeof(animal));
                //     animal = JSON.parse(animal);
                //     console.log('Second: ' + typeof(animal));
                // });
                // for (let animal of res) {
                //     this.animals.push(JSON.parse(animal));
                // }
                this.animals = JSON.parse(res);
            })
            .catch(err => {
                this.error = err;
                this.animals = undefined;
                console.log('ERR: ' + err);
            });
    }

}