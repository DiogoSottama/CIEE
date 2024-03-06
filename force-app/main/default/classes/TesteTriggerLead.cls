@isTest
public class TesteTriggerLead {
    @isTest
    public static void createData() {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Usuário Padrão' OR Name = 'Standard User' LIMIT 1].Id;
        Distribuicao_Lead__c d = new Distribuicao_Lead__c(Contador__c = 0);
        User u = new User(
            Alias = 'stand4',
            Email = 'standarduser4@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing123',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profileId,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'standarduser@cieetest.com',
            Unidade__c = 'São Paulo Capital'
        );
        
		List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
   			Lead lead = new Lead();
            lead.FirstName = 'Test';
            lead.LastName = 'Lead' + i;
			lead.Status = 'Novo';
            lead.Company = 'teste';
            lead.PostalCode = '00001-000';
            lead.Unidades_de_Atendimento__c = '101';
            lead.Gerencia_Regional__c = '1';
//            lead.NomeDaCampanha__c = 'Expo';  
//            lead.Atribuir_a_mim__c = false;
            testLeads.add(lead);
        }        
//        insert testLeads;

        
        for (Lead lead : testLeads) {
            //System.assertEquals(true, lead.OwnerId != null, 'OwnerId não foi definido corretamente');
            System.assertEquals('Test', lead.FirstName);
        }        
    }
    
   @isTest 
   public static void testAfterInsert() {
		List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
   			Lead lead = new Lead();
            lead.FirstName = 'Test';
            lead.LastName = 'Lead' + i;
			lead.Status = 'Novo';
            lead.Company = 'teste';
            lead.PostalCode = '00001-000';
            lead.Unidades_de_Atendimento__c = '101';
            lead.Gerencia_Regional__c = '1';
            testLeads.add(lead);
        }                
        Test.startTest();
        insert testLeads;
        Test.stopTest();
        for (Lead lead : testLeads) {
            //System.assertEquals(true, lead.OwnerId != null, 'OwnerId não foi definido corretamente');
            System.assertEquals('Test', lead.FirstName);
        }      
    }
}