public with sharing class KairosAPIUtils {
    private static final String ACCESS_TOKEN;
    private static final Kairos__c CREDENTIALS;
    private static final Map<String, String> HEADERS;

    static {
        CREDENTIALS = Kairos__c.getOrgDefaults() ;
        ACCESS_TOKEN = generateToken();
        HEADERS = new Map<String, String>{ 'Accept' => 'application/json', 'Authorization' => 'Bearer ' + ACCESS_TOKEN };
    }

    public static String generateToken() {
        HttpResponse response;
        try{
            PostToken postT = new PostToken(
                CREDENTIALS.Username__c,
                CREDENTIALS.Password__c
            );

            response = new HttpRequestBuilder().post(CREDENTIALS.Base_Url__c + getEndpoint('Authentication', null)).json(postT).send();

            String token = ((KairosDTO.ClientCredentialsDTO) JSON.deserialize(response.getBody(), KairosDTO.ClientCredentialsDTO.class)).token;

            return token;
        }catch(Exception ex){
            logResponse(response, getEndpoint('Authentication', null));
            return '';
        }        
    }

    public static KairosDTO.RetrieveAllAccountsDTO retrieveAllAccounts(Map<String, String> params) {
        HttpResponse response;
        try{
            response = getRequest(getEndpoint('Retrieve all Accounts', params));

            KairosDTO.RetrieveAllAccountsDTO responseData = (KairosDTO.RetrieveAllAccountsDTO) JSON.deserialize(
                response.getBody(),
                KairosDTO.RetrieveAllAccountsDTO.class
            );
    
            logResponse(response, getEndpoint('Retrieve all Accounts', params));

            return responseData;
        }catch(Exception ex){
            logResponse(response, getEndpoint('Retrieve all Accounts', params));
            reagendamento();
            return new KairosDTO.RetrieveAllAccountsDTO();
        }
        
    }

    public static KairosDTO.RetrieveContractDTO retrieveContracts(Map<String, String> params){
        HttpResponse response;
        try{
            response = getRequest(getEndpoint('Retrieve Contracts', params));
            
            KairosDTO.RetrieveContractDTO responseData = (KairosDTO.RetrieveContractDTO) JSON.deserialize(
                response.getBody(),
                KairosDTO.RetrieveContractDTO.class
            );

            logResponse(response, getEndpoint('Retrieve Contracts', params));
    
            return responseData;
        }catch(Exception ex){
            logResponse(response, getEndpoint('Retrieve Contracts', params));
            reagendamento();
            return new KairosDTO.RetrieveContractDTO();
        }
        
    }
    
    private static void reagendamento(){
        Datetime sysTime = System.now().addHours(1);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('Fetch New Accounts_' + string.valueOf(System.now()), chron_exp, new FetchAccountsSchedulable(true));
    }

    private static void logResponse(HttpResponse response, String endpoint){
        Log_de_Integracao__c log = new Log_de_Integracao__c();
        log.Classe_Apex__c = 'FetchAccountsQueueable';
        log.Endpoint_Utilizado__c = endpoint;
        log.Status_da_Resposta__c = response.getStatus();
        log.Codigo_do_Status_da_Resposta__c = ''+response.getStatusCode();
        log.Comentarios__c = 'Inserindo e/ou atualizando contas Kairos';
        log.Headers__c = 'Content-Type: application/json';

        insert log;
    }

    private static HttpResponse getRequest(String endpointName) {
        System.debug('accessToken: ' + ACCESS_TOKEN);         
        return new HttpRequestBuilder().get(CREDENTIALS.Base_Url__c + endpointName).setHeaders(HEADERS).send();
    }

    private static String getEndpoint(String endpointName, Map<String, String> urlParams) {
        if(!Test.isRunningTest()){
            endpointName = [SELECT Endpoint__c FROM Kairos_Endpoint__mdt WHERE MasterLabel = :endpointName].Endpoint__c;
        }else{
            endpointName = endpointName == 'Authentication' ? '/auth/login' : endpointName == 'Retrieve all Accounts' ? '/company/company' : '/company/contract/search/';
        }

        return (urlParams != null) ? endpointName + '?' + String.join(flatMap(urlParams), '&') : endpointName;
    }

    private static List<String> flatMap(Map<String, String> mapToFlat) {
        List<String> returnList = new List<String>();
        for (String key : mapToFlat.keySet()) {
            returnList.add(key + '=' + mapToFlat.get(key));
        }

        return returnList;
    }

    public class PostToken{
        public String username;
        public String password;

        public PostToken(String username, String password){
            this.username = username;
            this.password = password;
        }
    }
}