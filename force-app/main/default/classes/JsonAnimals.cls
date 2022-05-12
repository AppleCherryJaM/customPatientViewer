public with sharing class JsonAnimals {

    @AuraEnabled(cacheable=true)
    public static String getAnimalsList() {
        List<AnimalParserSecond> animals = getParsedAnimalsList();
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for (AnimalParserSecond animal : animals) {
            gen.writeObject(animal);
        }
        gen.writeEndArray();

        return gen.getAsString();
    }

    // private static String parseToString(AnimalParserSecond animal) {
    //     JSONGenerator generator = JSON.createGenerator(true);
    //     generator.writeStartObject();
    //     generator.writeObjectField('animal', animal);
    //     generator.writeEndObject();
    //     return generator.getAsString();
    // }

    private static List<AnimalParserSecond> getParsedAnimalsList() {
        List<Animal__c> res = [
            SELECT id__c, Name, food__c, says__c 
            FROM Animal__c];
        List<AnimalParserSecond> animals = new List<AnimalParserSecond>();
        for (Animal__c animal : res) {
            animals.add(new AnimalParserSecond(animal.id__c, animal.name, animal.food__c, animal.says__c));
        }
        return animals;
    }
}