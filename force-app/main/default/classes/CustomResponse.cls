global class CustomResponse {
    @AuraEnabled global String myMessage{get;set;}
    @AuraEnabled global String data{get;set;}
    @AuraEnabled global Boolean isSuccess = true;

    public CustomResponse(String data, String msg) {
        this.data = data;
        this.myMessage = msg;
    }

    public CustomResponse(Boolean result, String msg) {
        this.isSuccess = result;
        this.myMessage = msg;
    }
}
