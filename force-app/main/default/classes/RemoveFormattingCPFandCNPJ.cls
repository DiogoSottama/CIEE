public with sharing class RemoveFormattingCPFandCNPJ implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, CNPJ_CPF__c FROM Account WHERE CNPJ_CPF__c LIKE '%.%']);
    }

    public void execute(Database.BatchableContext BC, List<Account> scope){
        try{
            
            for(Account acc : scope){
                String aux = acc.CNPJ_CPF__c;
                if(acc.CNPJ_CPF__c.contains('/')){
                    aux = aux.replace('/','');
                }
                aux = aux.replace('.','').replace('-','');
                acc.CNPJ_CPF__c = aux;
            }

            for(Database.SaveResult sr : Database.update(scope, false)){
                if(!sr.isSuccess()){
                    System.debug(sr.getErrors().toString() + '-->' + sr.id);
                }
            }

        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC){}
}