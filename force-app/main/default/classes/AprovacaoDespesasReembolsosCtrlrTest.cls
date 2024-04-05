@IsTest
public class AprovacaoDespesasReembolsosCtrlrTest {
    @TestSetup
    static void makeData() {
        Codigo_de_Reembolso__c codigoReembolso = new Codigo_de_Reembolso__c(Codigo__c = 300000);
        insert codigoReembolso;

        Account acc = new Account(
            Name = 'Teste',
            BillingPostalCode = '01000-000',
            CNPJ_CPF__c = '06566005005',
            Gerencia_Regional__c = '1',
            CNAE__c = '01..03 AGRICULTURA PECUÁRIA PRODUÇÃO FLORESTAL PESCA E AQÜICULTURA',
            CNAE_Divisao__c = '01 AGRICULTURA PECUÁRIA E SERVIÇOS RELACIONADOS',
            Unidade__c = '101'
        );
        insert acc;

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Administrador do sistema' OR Name = 'System Administrator'].Id;
        User user = new User(
            Alias = 'standt',
            Email = 'standarduser@ciee.org.br',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = idProfile,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'standarduser@cieetest.com',
            Unidade__c = 'São Paulo Capital',
            CPF__c = '65809450016',
            Matricula__c = '21321',
            CR__c = 'sadsa',
            Cargo__c = 'Consultor'
        );
        insert user;

        System.runAs(user) {
            Despesa_e_Reembolso__c despesa = new Despesa_e_Reembolso__c(
                Name = 'Teste',
                Check_in__c = System.now(),
                Tipo_de_Despesa__c = 'KM',
                KM__c = 90,
                Status__c = 'Enviado_para_o_Relatorio',
                CreatedById = user.id,
                Conta__c = acc.id
            );
            insert despesa;
        }
    }

    @IsTest
    public static void buscarDadosTest() {
        Despesa_e_Reembolso__c despesa = [SELECT Id, Status__c FROM Despesa_e_Reembolso__c LIMIT 1];
        System.debug(despesa.Status__c);
        User user = [SELECT Id FROM User WHERE Username = 'standarduser@cieetest.com'];
        List<Despesa_e_Reembolso__c> despesas;
        System.runAs(user) {
            despesas = AprovacaoDespesasReembolsosController.buscarDados('Todos');
        }

        Assert.isNotNull(despesas);
        Assert.areEqual(1, despesas.size());
    }

    @IsTest
    public static void reprovarDespesaReembolso() {
        List<Despesa_e_Reembolso__c> despesas = [SELECT Id, Name FROM Despesa_e_Reembolso__c];

        String retorno = AprovacaoDespesasReembolsosController.reprovarDespesaReembolso(despesas, 'Teste Motivo', 'Teste');

        Assert.areEqual('Sucesso', retorno);

        Despesa_e_Reembolso__c despesa = [SELECT Status__c, Motivo_da_Recusa__c FROM Despesa_e_Reembolso__c LIMIT 1];

        Assert.areEqual('Recusado', despesa.Status__c);
        Assert.areEqual('Teste Motivo', despesa.Motivo_da_Recusa__c);
    }

    @IsTest
    public static void aprovarDespesaReembolso() {
        List<Despesa_e_Reembolso__c> despesas = [
            SELECT Id, CreatedById, Check_In__c, Duracao_da_Visita__c, Nome_da_Empresa__c, Km__c, Valor_do_Reembolso_de_KM__c
            FROM Despesa_e_Reembolso__c
        ];

        String retorno;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpRequestsMockGenerator());
        retorno = AprovacaoDespesasReembolsosController.aprovarDespesaReembolso(despesas);
        Test.stopTest();

        Assert.areEqual('Sucesso', retorno);

        Despesa_e_Reembolso__c despesa = [SELECT Status__c FROM Despesa_e_Reembolso__c LIMIT 1];

        Assert.areEqual('Aprovado', despesa.Status__c);
    }
}