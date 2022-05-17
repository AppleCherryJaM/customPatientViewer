public with sharing class AnimalLocatorParser {
    public AnimalParser animal;
    
    public class AnimalParser {
        public Decimal id;
        public String name;
        public String eats;
        public String says;
    }

    public static AnimalLocatorParser parseAnimal(String json) {
        return (AnimalLocatorParser) System.JSON.deserialize(json, AnimalLocatorParser.class);
    }
}