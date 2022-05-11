@RestResource(urlMapping='/animalObject/*')
global without sharing class AnimalRest {
    @HttpGet
    global static void getRecord() {
        RestRequest request = RestContext.request;
        String animalId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/') + 1);
        List<Animal__c> res = [SELECT id__c, Name, food__c, says__c FROM Animal__c WHERE id__c = :Decimal.valueOf(animalId)];
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(parseToJson(res));
        // return parseToJson(res);
    }

    @HttpPost
    global static ID createAnimal (Decimal id) {
        ParseAnimal animal = AnimalTriggerHandler.requestSend(id);
        if (animal.animal.id != 0) {
            Animal__c thisAnimal = new Animal__c (Id__c = animal.animal.id,
            Name = animal.animal.name,
            food__c = animal.animal.eats,
            says__c = animal.animal.says);
            insert thisAnimal;
            return thisAnimal.id;
        }
        return null;
    }

    private static String parseToJson (List<Animal__c> animals) {
        // List<String> jsonObj = new List<String>();
        // for (Animal__c animal : animals) {
        //     jsonObj.add(JSON.serialize(new AnimalParserSecond(animal.id__c, animal.name, animal.food__c, animal.says__c)));
        // }
        // return jsonObj;

        JSONGenerator generator = JSON.createGenerator(true);

        generator.writeStartObject();
        
        generator.writeObjectField('My animals', animals);
        generator.writeEndObject();
        return generator.getAsString();
    }
}