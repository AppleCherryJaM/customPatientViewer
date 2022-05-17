@isTest
public with sharing class AnimalLocatorTest {
    @isTest
    static void getAnimalNameByIdTest() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String result = AnimalLocator.getAnimalNameById(1);
        String expected = 'chicken';
        System.assertEquals(expected, result); 
    }
}