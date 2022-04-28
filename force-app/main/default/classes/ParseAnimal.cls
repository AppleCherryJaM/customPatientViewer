public class ParseAnimal {
	
    public Animal animal;
    
    public class Animal {
        public Integer id;
        public String name;
        public String eats;
        public String says;
    }
    
    public static ParseAnimal parseAnimal(String json) {
        return (ParseAnimal) System.JSON.deserialize(json, ParseAnimal.class);
    }
}