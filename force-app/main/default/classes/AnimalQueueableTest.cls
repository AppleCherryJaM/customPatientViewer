@isTest
public with sharing class AnimalQueueableTest {
	@TestSetup
	static void setup() {
		List<Animal__c> testAnimalList = new List<Animal__c>();
		for (Integer i = 1; i < 100; i++) {
			testAnimalList.add(new Animal__c (id__c = 1,
			Name = 'Animal ' + i));
		}
		insert testAnimalList;
	}
		@isTest
		public static void queueableTest() {
			Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
			List<Animal__c> animalList = [SELECT Id__c, Name, food__c, says__c FROM Animal__c];
			System.debug(animalList);
			Test.startTest();
			System.enqueueJob(new AnimalQueueable(animalList));
			Test.stopTest();
			System.debug([SELECT id__c, Name, food__c, says__c FROM Animal__c]);
			Animal__c animal1 = [SELECT id__c, Name, food__c, says__c FROM Animal__c WHERE Id__c = 1 LIMIT 1];
			System.assertEquals('chicken', animal1.Name);	
			Animal__c animal2 = [SELECT id__c, Name, food__c, says__c FROM Animal__c WHERE id__c = 2 LIMIT 1];
			System.assertEquals('bear', animal2.Name);
		}
}