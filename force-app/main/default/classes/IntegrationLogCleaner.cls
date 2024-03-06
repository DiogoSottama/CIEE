public with sharing class IntegrationLogCleaner implements Schedulable {

    public void execute(SchedulableContext sc) {
        List<Log_de_Integracao__c > scope = [SELECT Id FROM Log_de_Integracao__c WHERE CreatedDate < LAST_MONTH];

        if(!scope.isEmpty()){
            Database.delete(scope, false);
        }
    }

}