public with sharing class AnimalTriggerHandler {

    public static void animalIdListComparator(List<Animal__c> newAnimals) {
        List<Decimal> idList = new List<Decimal>();
        for (Animal__c animal : newAnimals) {
            idList.add(animal.id__c);
        }
        updateByRequest(idList);
    }

    @future(callout = true)
    public static void updateByRequest(List<Decimal> idNumberList) {
        List<Animal__c> animalList = [SELECT id__c, name, food__c, says__c FROM Animal__c WHERE id__c IN : idNumberList];
        List<Animal__c> updatedAnimalList = new List<Animal__c>();
        for (Animal__c animal : animalList) {
            ParseAnimal parsingAnimal = requestSend(animal.id__c);
            animal.Name = parsingAnimal.animal.name;
            animal.food__c = parsingAnimal.animal.eats;
            animal.says__c = parsingAnimal.animal.says;
            updatedAnimalList.add(animal);
        }
        update updatedAnimalList;
    }


    public static ParseAnimal requestSend (Decimal id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + id.toPlainString());
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {       
            // ParseAnimal animalParser = ParseAnimal.parseAnimal(response.getBody()); 
            return (ParseAnimal) ParseAnimal.parseAnimal(response.getBody());
        }
        return null;
    }
}