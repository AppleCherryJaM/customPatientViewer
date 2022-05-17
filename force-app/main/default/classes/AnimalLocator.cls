global with sharing class AnimalLocator {
    global static String getAnimalNameById(Integer id) {
        Http http = new Http();
        AnimalLocatorParser parsedAnimal = new AnimalLocatorParser();
        HttpRequest request = new Httprequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com' + '/animals/' + String.valueOf(id));
        request.setMethod('GET');
        HttpResponse res = http.send(request);
        if (res.getStatusCode() == 200) {
            parsedAnimal = (AnimalLocatorParser) AnimalLocatorParser.parseAnimal(res.getBody());
        }
        return parsedAnimal.animal.name;
    }
}