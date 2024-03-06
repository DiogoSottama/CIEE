@isTest
public with sharing class TestRemoveFormattingCPFandCNPJ {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Teste',
            BillingPostalCode = '01000-000',
            CNPJ_CPF__c = '123.98/00-00',
            Gerencia_Regional__c = '1',
            CNAE__c = '01..03 AGRICULTURA PECUÁRIA PRODUÇÃO FLORESTAL PESCA E AQÜICULTURA',
            CNAE_Divisao__c = '01 AGRICULTURA PECUÁRIA E SERVIÇOS RELACIONADOS',
            Unidade__c = '101'
        );
        insert acc;
    }

    @isTest
    private static void testTestCase() {

        String accCpfCnpj = [SELECT CNPJ_CPF__c FROM Account LIMIT 1].CNPJ_CPF__c;

        Test.startTest();

        Database.executeBatch(new RemoveFormattingCPFandCNPJ());
    
        Test.stopTest();

        String accCpfCnpj2 = [SELECT CNPJ_CPF__c FROM Account LIMIT 1].CNPJ_CPF__c;

        Assert.areNotEqual(accCpfCnpj, accCpfCnpj2);
    }
}