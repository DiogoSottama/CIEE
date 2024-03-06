@IsTest
public with sharing class FetchAccountsSchedulableTest {
    @IsTest
    static void methodName(){

        Kairos__c kt = new Kairos__c();
        kt.Base_Url__c = 'https://api.ciee.org.br';
        kt.Password__c = 'yfKW6E4nF7s9jD';
        kt.Username__c = 'ciee.salesforce';
        insert kt;

        Datetime sysTime = System.now().addHours(1);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KairosApiUtilsMock('Retrieve all Accounts'));
        Id jobId = System.schedule('Fetch New Accounts_Test' + string.valueOf(System.now()), chron_exp, new FetchAccountsSchedulable(true));
        Test.setMock(HttpCalloutMock.class, new KairosApiUtilsMock('Retrieve Contracts'));
        System.enqueueJob(new FetchAccountsSchedulable.FetchContractsQueueable(0, jobId));
        Test.stopTest();        

        Assert.areNotEqual(jobId, null); 
        
    }

    @IsTest
    static void methodName3(){
        Kairos__c kt = new Kairos__c();
        kt.Base_Url__c = 'https://api.ciee.org.br';
        kt.Password__c = 'yfKW6E4nF7s9jD';
        kt.Username__c = 'ciee.salesforce';
        insert kt;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new KairosApiUtilsMock('Retrieve Contracts'));
        System.enqueueJob(new FetchAccountsSchedulable.FixCNPJorCPFContractsQueueable(0));
        Test.stopTest();        

    }

    @IsTest
    static void methodName4(){
        Kairos__c kt = new Kairos__c();
        kt.Base_Url__c = 'https://api.ciee.org.br';
        kt.Password__c = 'yfKW6E4nF7s9jD';
        kt.Username__c = 'ciee.salesforce';
        insert kt;

        Datetime sysTime = System.now().addHours(1);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Test.startTest();
        Id jobIdIntegration = System.schedule('IntegrationLogCleaner_Test' + string.valueOf(System.now()), chron_exp, new IntegrationLogCleaner());
        Test.stopTest();        

        Assert.areNotEqual(jobIdIntegration, null);    

    }
}