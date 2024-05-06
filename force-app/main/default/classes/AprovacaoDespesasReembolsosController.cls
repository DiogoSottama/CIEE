public class AprovacaoDespesasReembolsosController {
    private static final Codigo_de_Reembolso__c CODIGO_REEMBOLSO = Codigo_de_Reembolso__c.getOrgDefaults();
    private static final String[] USER_FIELDS = new List<String>{ 'Id', 'Unidade__c', 'Cargo__c', 'Profile.Name' };

    private static final String[] DESPESAS_FIELDS = new List<String>{
        'Id',
        'Name',
        'Data_da_Visita__c',
        'Duracao_da_Visita__c',
        'Hora_da_Visita__c',
        'Km__c',
        'Nome_da_Empresa__c',
        'Valor_do_Reembolso_de_KM__c',
        'Nome_do_Consultor__c',
        'CreatedById',
        'Check_In__c'
    };

    @AuraEnabled(cacheable=true)
    public static List<Despesa_e_Reembolso__c> buscarDados(String criador) {
        Boolean allUsers = String.isBlank(criador) || criador == 'Todos';
        Id userId = UserInfo.getUserId();

        String userQuery = 'SELECT ' + String.join(USER_FIELDS, ', ') + ' FROM User WHERE Id = :userId';

        User user = Database.query(userQuery);
        Boolean isAdmin = user.Profile.Name == 'Administrador do sistema' || user.Profile.Name == 'System Administrator';
        Boolean isSuperIntendencia = user.Profile.Name == 'Superintendência';
        Boolean isGerente = user.Cargo__c == 'Gerente';
        String unidade = user.Unidade__c;
        String cargo = user.Cargo__c;

        String query = 'SELECT ' + String.join(DESPESAS_FIELDS, ', ') + ' ';
        query += 'FROM Despesa_e_Reembolso__c ';
        query += 'WHERE Status__c = \'Enviado_para_o_Relatorio\' AND Tipo_de_Despesa__c = \'KM\'';

        if (isSuperIntendencia) {
            query += ' AND CreatedBy.Cargo__c = \'Gerente\' ';
        }

        if (!isAdmin && !isSuperIntendencia && !isGerente) {
            query += ' AND CreatedBy.Unidade__c = :unidade';
        }

        if (cargo == 'Gerente') {
            query += ' AND (CreatedBy.Unidade__c = :unidade OR CreatedBy.ManagerId = :userId)';
            query += ' AND (CreatedBy.Cargo__c = \'Supervisor\' OR CreatedBy.Cargo__c = \'Consultor\')';
        }

        if (cargo == 'Supervisor') {
            query += ' AND CreatedBy.Cargo__c = \'Consultor\'';
        }

        if (!allUsers) {
            query += ' AND CreatedBy.Name = :criador ';
        }

        System.debug(query);
        return Database.query(query);
    }

    @AuraEnabled
    public static String reprovarDespesaReembolso(List<Despesa_e_Reembolso__c> despesas, String motivo, String despesaNameRecusa) {
        System.debug('despesa' + despesaNameRecusa);
        System.debug('motivo' + motivo);

        for (Despesa_e_Reembolso__c despesa : despesas) {
            despesa.Status__c = 'Recusado';
            if (despesa.Name == despesaNameRecusa) {
                despesa.Motivo_da_Recusa__c = motivo;
            }
        }

        Database.update(despesas);

        return 'Sucesso';
    }

    @InvocableMethod(label = 'Integrar Despesas e Reembolsos')
    public static void aprovarDespesaReembolso(List<IntegrationParams> params) {

        List<Despesa_e_Reembolso__c> despesas = params[0].lstDespesas;

        User user = [
            SELECT Id, CPF__c, CR__c, Matricula__c, Name
            FROM User
            WHERE Id = :despesas[0].CreatedById
        ];

        String txtFile = String.format(
            'C|01|0001|U_CEAIA38|3|{0}|{1}|{2}|{3}|{4}\n',
            new List<Object>{ user.CPF__c, user.Matricula__c, user.Name, user.CR__c, (Integer) CODIGO_REEMBOLSO.Codigo__c }
        );

        String placeholder = 'I|{0}|{1}|{2}|{3}|{4}|{5}|0|0|0|0|0|{5}\n';

        for (Despesa_e_Reembolso__c despesa : despesas) {
            txtFile += String.format(
                placeholder,
                new List<Object>{
                    despesa.Check_In__c.format('yyyyMMdd'),
                    despesa.Check_in__c.format('HH:mm'),
                    despesa.Duracao_da_Visita__c,
                    despesa.Nome_da_Empresa__c,
                    despesa.Km__c,
                    Integer.valueOf(despesa.Valor_do_Reembolso_de_KM__c * 100)
                }
            );

            despesa.Status__c = 'Aprovado';
        }

        System.debug('txtFile:' + txtFile);

        System.enqueueJob(new UploadExpenseToAmazonS3(txtFile, (Integer) CODIGO_REEMBOLSO.Codigo__c + '.txt'));

        update despesas;

        CODIGO_REEMBOLSO.Codigo__c += 1;

        update CODIGO_REEMBOLSO;

       // return 'Sucesso';
    }

    public class IntegrationParams{
        @invocableVariable
        public List<Despesa_e_Reembolso__c> lstDespesas;
    }
}