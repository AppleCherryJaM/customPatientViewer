public with sharing class AnimalBatch implements Database.Batchable<sObject>, Schedulable {   
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT id__c, name, eats__c, says__c FROM Animal__c';
        return Database.getQueryLocator(query);
    }

    public void execute (Database.BatchableContext BC, List<Animal__c> scope) {
        Map<Decimal, ParseAnimal> animals = getRequestedAnimals(filteredIdList(scope));
        for (Animal__c animal: scope) {
            ParseAnimal pAnimal = AnimalTriggerHandler.requestSend(animal.id__c);
            animal.name = pAnimal.animal.name;
            animal.food__c = pAnimal.animal.eats;
            animal.says__c = pAnimal.animal.name;
        }    
        update scope;
    }

    public void finish(Database.BatchableContext BC) {

    }

    public void execute(SchedulableContext schedubleContext) {
        Database.executeBatch(new AnimalBatch());
    }

    private List<Decimal> filteredIdList (List<Animal__c> animals) {
        List<Decimal> idList = new List<Decimal>();
        for (Animal__c animal : animals) {
            if (idList.contains(animal.id__c)) continue;
            else {
                idList.add(animal.id__c);
            }
        }
        return idList;
    }

    private static Map <Decimal,ParseAnimal> getRequestedAnimals(List<Decimal> idList) {
        Map <Decimal, ParseAnimal> animals = new Map <Decimal, ParseAnimal>();
        for (Decimal id : idList) {
          animals.put(id, AnimalTriggerHandler.requestSend(id));
        }
        return animals;
      }
}