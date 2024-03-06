public with sharing class AccountTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI = false;
    
    public AccountTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(List<Account> newAccount){
        List<Carteira__c> carteiras;
        
        if(newAccount[0].CEPSemFormatacao__c!= null){
            carteiras = [SELECT Id, Consultor__c, DoCEPSemFormatacao__c, AteOCEPSemFormatacao__c,Apoio__C
                         FROM Carteira__c
                         WHERE DoCEPSemFormatacao__c <= :newAccount[0].CEPSemFormatacao__c
                         AND AteOCEPSemFormatacao__c >= :newAccount[0].CEPSemFormatacao__c 
                        LIMIT 1];
            
            if(carteiras.size() > 0){
         
                newAccount[0].OwnerId = carteiras[0].Apoio__c;
                newAccount[0].Consultor__c = carteiras[0].Consultor__c;
            }
        }
    }
    
    public void OnBeforeUpdate( List<Account> newAccount, List<Account> oldAccount, Map<ID, Account> newAccountMap , Map<ID, Account> oldAccountMap ){
        List<Carteira__c> carteiras;
        
        if(newAccount[0].CEPSemFormatacao__c!= null){
            carteiras = [SELECT Id, Consultor__c, DoCEPSemFormatacao__c, AteOCEPSemFormatacao__c,Apoio__C
                         FROM Carteira__c
                         WHERE DoCEPSemFormatacao__c <= :newAccount[0].CEPSemFormatacao__c
                         AND AteOCEPSemFormatacao__c >= :newAccount[0].CEPSemFormatacao__c 
                        LIMIT 1];
            
            if(carteiras.size() > 0){
                
                newAccount[0].OwnerId = carteiras[0].Apoio__c;
                newAccount[0].Consultor__c = carteiras[0].Consultor__c;
            }
        }
    }
    
    /*public void OnAfterInsert(List<Account> newAccount){
        AccountActions.insertAccountTeamMember(newAccount);
    }
    
    public void OnAfterUpdate(List<Account> newAccount, List<Account> oldAccount, Map<ID, Account> newAccountMap , Map<ID, Account> oldAccountMap){
        AccountActions.deleteAccountTeamMember(newAccount); 
        AccountActions.insertAccountTeamMember(newAccount);
    }*/
}