public with sharing class AnimalQueueable implements Queueable, Database.AllowsCallouts {

    private List<Animal__c> animalList = new List<Animal__c>();
    private Map<Decimal, Animal__c> animalMap = new Map<Decimal, Animal__c>();

    public AnimalQueueable (List<Animal__c> scope) {
        this.animalList = [SELECT Name, id__c, food__c, says__c FROM Animal__c WHERE id IN :scope];
    }

    public void execute(QueueableContext context) {
        List<Animal__c> limitedAnimalList = new List<Animal__c>();
        List<Animal__c> filter = new List<Animal__c>();
        for (Animal__c animal : this.animalList) {
            if (limitedAnimalList.size() < 50) {
                limitedAnimalList.add(animal);
            } else {
                filter.add(animal);
            }
        }

        fromListToMap(filterRequestedList(limitedAnimalList));

        this.animalList.clear();
        this.animalList.addAll(filter);

        limitedAnimalList.clear();
        // System.debug(this.animalList);
        if (this.animalList.size() != 0) {
            System.enqueueJob(new AnimalQueueable(this.animalList));
        }
    }

    private void fromListToMap (List<Decimal> idList) {
        Map<Decimal, ParseAnimal> animalMap = new Map<Decimal, ParseAnimal>();
        for (Decimal idNumber : idList) {
            animalMap.put(idNumber, AnimalTriggerHandler.requestSend(idNumber));
        }

        updateByRequest(animalMap);
    }

    private void updateByRequest(Map<Decimal, ParseAnimal> animalMap) {
        List<Animal__c> updatedAnimalList = new List<Animal__c>();
        for (Animal__c animal : this.animalList) {
            System.debug('Fuck: ' + animalMap.get(animal.id__c).animal.name);
            animal.Name = animalMap.get(animal.id__c).animal.name;
            animal.food__c = animalMap.get(animal.id__c).animal.eats;
            animal.says__c = animalMap.get(animal.id__c).animal.says;
            updatedAnimalList.add(animal);
        }
        update updatedAnimalList;
    }

    private List<Decimal> filterRequestedList(List<Animal__c> newAnimals) {
        List<Decimal> idList = new List<Decimal>();
        for (Animal__c animal : newAnimals) {
            if (!idList.contains(animal.id__c) ) {
                idList.add(animal.id__c);
            }
        }
        return idList;
    }
}