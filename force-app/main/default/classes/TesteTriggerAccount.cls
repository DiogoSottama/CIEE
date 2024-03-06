@isTest
public class TesteTriggerAccount {
    @isTest
    public static void criaContaComCarteira(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuário Padrão'];  
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@cieetest.com', Unidade__c='São Paulo Capital');
        insert u;
        Carteira__c carteira = new Carteira__C(Apoio__c = u.Id , Consultor__c = u.Id);
        carteira.Ate_o_CEP__c = '10000-000';
        carteira.Do_CEP__c = '00000-000';        
        insert carteira;
        Account acc = new Account();
        acc.Name = 'teste';
        acc.CNPJ_CPF__c = '61.600.839/0001-55'; 
        acc.BillingPostalCode = '01000-000';
        insert acc;
    }
    @isTest
    public static void atualizaContaComCarteira(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuário Padrão'];  
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@cieetest.com', Unidade__c='São Paulo Capital');
        insert u;
        Carteira__c carteira = new Carteira__C(Apoio__c = u.Id , Consultor__c = u.Id);
        carteira.Ate_o_CEP__c = '10000-000';
        carteira.Do_CEP__c = '00000-000';  
       
        insert carteira;
        Account acc = new Account();
        acc.Name = 'teste';
        acc.CNPJ_CPF__c = '61.600.839/0001-55'; 
        acc.BillingPostalCode = '01000-000';
        insert acc;
        acc.BillingPostalCode = '00100-000';
        update acc;
    }
}