@isTest
public with sharing class ParkLocatorTest {
    @isTest
    static void countryMethodTest() {
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        List<String> result = new List<String>();
        List<String> expected = new List<String>();
        expected.add('Park1');
        expected.add('Park2');
        expected.add('Park3');

        result = ParkLocator.country('India');
        System.assertEquals(expected, result);
    }
}
