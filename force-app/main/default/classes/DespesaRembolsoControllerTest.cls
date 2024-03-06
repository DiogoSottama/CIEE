@IsTest
public class DespesaRembolsoControllerTest {
    @TestSetup
    static void makeData() {
        Codigo_de_Reembolso__c codigoReembolso = new Codigo_de_Reembolso__c(Codigo__c = 300000);
        insert codigoReembolso;

        Account acc = new Account(
            Name = 'teste',
            BillingPostalCode = '01000-000',
            CNPJ_CPF__c = '12345678998',
            Unidade__c = '103',
            Gerencia_Regional__c = '1',
            CNAE__c = '01..03 AGRICULTURA PECUÁRIA PRODUÇÃO FLORESTAL PESCA E AQÜICULTURA',
            CNAE_Divisao__c = '01 AGRICULTURA PECUÁRIA E SERVIÇOS RELACIONADOS'
        );
        insert acc;

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Administrador do sistema' OR Name = 'System Administrator'].Id;
        User user = new User(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = idProfile,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'standarduser@cieetest.com',
            Unidade__c = 'São Paulo Capital',
            CPF__c = '12345678998',
            Matricula__c = '21321',
            CR__c = 'sadsa',
            Cargo__c = 'Consultor'
        );
        insert user;

        Despesa_e_Reembolso__c despesa = new Despesa_e_Reembolso__c(
            Name = 'Teste',
            Check_in__c = System.now(),
            Tipo_de_Despesa__c = 'KM',
            KM__c = 90,
            Status__c = 'Enviado_para_o_Relatorio',
            CreatedById = user.Id,
            Conta__c = acc.Id
        );
        insert despesa;
    }

    @IsTest
    public static void clonarTest() {
        Despesa_e_Reembolso__c despesa = [
            SELECT Id, Name, Check_in__c, Tipo_de_Despesa__c, KM__c, Status__c, CreatedById, Conta__c
            FROM Despesa_e_Reembolso__c
            LIMIT 1
        ];

        ApexPages.StandardController standardController = new ApexPages.StandardController(despesa);

        DespesasEReembolsoController controller = new DespesasEReembolsoController(standardController);
        Pagereference redirectPage = controller.clonar();
        
        Despesa_e_Reembolso__c clone = [
            SELECT Id, Name, Check_in__c, Tipo_de_Despesa__c, KM__c, Status__c, CreatedById, Conta__c
            FROM Despesa_e_Reembolso__c
            WHERE Name LIKE '%Clone'
        ];

        Assert.areEqual('/' + clone.Id, redirectPage.getUrl());
        Assert.areEqual('Teste - Clone', clone.Name);
        Assert.areEqual('Rascunho', clone.Status__c);
        Assert.areEqual(despesa.Check_In__c, clone.Check_In__c);
        Assert.areEqual(despesa.Tipo_de_Despesa__c, clone.Tipo_de_Despesa__c);
        Assert.areEqual(despesa.KM__c, clone.KM__c);
        Assert.areEqual(despesa.Conta__c, clone.Conta__c);
    }
}