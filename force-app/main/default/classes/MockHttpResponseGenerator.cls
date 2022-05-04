global class MockHttpResponseGenerator implements HttpCalloutMock {
    
    private String endpoint = 'https://th-apex-http-callout.herokuapp.com/animals/';

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        switch on req.getEndpoint() {
            when ('https://th-apex-http-callout.herokuapp.com/animals/1') {
                res.setBody('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');       
            }
            when ('https://th-apex-http-callout.herokuapp.com/animals/2') {
                res.setBody('{"animal":{"id":2,"name":"bear","eats":"berries, campers, adam seligman","says":"yum yum"}}');
            }
            when else {
                res.setBody('{"animal":{"id":0,"name":"","eats":"","says":""}}');
            }
        }
        res.setStatusCode(200);
        return res;
    }
}