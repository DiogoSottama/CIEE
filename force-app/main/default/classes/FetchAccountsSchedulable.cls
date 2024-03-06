public with sharing class FetchAccountsSchedulable implements Schedulable {
    private Boolean ordermQueueable;

    public FetchAccountsSchedulable(Boolean ordermQueueable) {
        this.ordermQueueable = ordermQueueable;
    }

    public void execute(SchedulableContext sc) {
        if (ordermQueueable) {
            System.enqueueJob(new FetchAccountsQueueable(0, sc.getTriggerId(), new List<errorAccount>()));
        } else {
            System.enqueueJob(new FetchContractsQueueable(0, sc.getTriggerId()));
        }
    }

    public with sharing class FixCNPJorCPFContractsQueueable implements Queueable, Database.AllowsCallouts {
        private Integer pageNumber;

        private Id schedulableId;

        private Map<Integer, String> codigoGerenciaMap = new Map<Integer, String>();

        private Map<Integer, String> codigoUnidadeMap = new Map<Integer, String>();

        public FixCNPJorCPFContractsQueueable(Integer pageNumber) {
            this.pageNumber = (pageNumber >= 0) ? pageNumber : this.pageNumber;            
        }

        public void execute(QueueableContext qc) {
            Map<String, String> params = new Map<String, String>{ 'page' => String.valueOf(pageNumber), 'size' => '2000' };
            KairosDTO.RetrieveContractDTO jsonData = KairosAPIUtils.retrieveContracts(params);

            List<KairosDTO.ContractDTOP> contratos = jsonData.content;

            List<Account> accountUpdate = new List<Account>();

            List<Decimal> listIdContract = new List<Decimal>();

            for(KairosDTO.ContractDTOP contrato : contratos){
                listIdContract.add(contrato.Id);
            }

            System.debug(listIdContract);

            Map<Decimal, Account> mapName = new Map<Decimal, Account>();
            for(Account acc :  [SELECT Id, Id_Contrato__c, CNPJ_CPF__c FROM Account WHERE Id_Contrato__c IN :listIdContract]){
                mapName.put(acc.Id_Contrato__c, acc);
            }

            for (KairosDTO.ContractDTOP contrato : contratos) {
                Account acc = mapName.get(contrato.id);
                if(acc != null){
                    acc.CNPJ_CPF__c = contrato.cnpj != null ? contrato.cnpj : contrato.cpf;
                    accountUpdate.add(acc);
                }

                
            }
            for (Database.SaveResult ur : Database.update(accountUpdate, false)) {
                System.debug('isSuccess: ' + ur.isSuccess());
                System.debug('AccountId: ' + ur.id);
            }

            if (pageNumber < jsonData.totalPages) {
                System.enqueueJob(new FixCNPJorCPFContractsQueueable(++pageNumber));
            }
        }
    }

    public with sharing class FetchContractsQueueable implements Queueable, Database.AllowsCallouts {
        private Integer pageNumber;

        private Id schedulableId;

        private Map<Integer, String> codigoGerenciaMap = new Map<Integer, String>();

        private Map<Integer, String> codigoUnidadeMap = new Map<Integer, String>();

        public FetchContractsQueueable(Integer pageNumber, Id schedulableId) {
            this.pageNumber = (pageNumber >= 0) ? pageNumber : this.pageNumber;
            this.schedulableId = (schedulableId != null) ? schedulableId : this.schedulableId;
        }

        public void execute(QueueableContext qc) {
            Map<String, String> params = new Map<String, String>{ 'page' => String.valueOf(pageNumber), 'size' => '2000' };
            KairosDTO.RetrieveContractDTO jsonData = KairosAPIUtils.retrieveContracts(params);

            List<KairosDTO.ContractDTOP> contratos = jsonData.content;

            List<Account> accountUpsert = new List<Account>();

            for (Mapeamento_Gerencia_Kairos__mdt gerencia : [
                SELECT Gerencia_Kairos__c, Gerencia_Salesforce__c
                FROM Mapeamento_Gerencia_Kairos__mdt
            ]) {
                codigoGerenciaMap.put((Integer) gerencia.Gerencia_Kairos__c, gerencia.Gerencia_Salesforce__c);
            }

            for (Mapeamento_Unidade_Kairos__mdt unidade : [SELECT Unidade_Kairos__c, Unidade_Salesforce__c FROM Mapeamento_Unidade_Kairos__mdt]) {
                codigoUnidadeMap.put((Integer) unidade.Unidade_Kairos__c, unidade.Unidade_Salesforce__c);
            }

            for (KairosDTO.ContractDTOP contrato : contratos) {
                String codigoGerencia;
                if (codigoGerenciaMap.containsKey(contrato.managementId)) {
                    codigoGerencia = codigoGerenciaMap.get(contrato.managementId);
                } else {
                    codigoGerencia = String.valueOf(contrato.managementId);
                }
                String codigoUnidade;
                if (codigoUnidadeMap.containsKey(contrato.cieeUnitId)) {
                    codigoUnidade = codigoUnidadeMap.get(contrato.cieeUnitId);
                } else {
                    codigoUnidade = String.valueOf(contrato.cieeUnitId);
                }

                Account contaNew = new Account(CNPJ_CPF__c = contrato.cnpj != null ? contrato.cnpj : contrato.cpf, Gerencia_Regional__c = codigoGerencia, Unidade__c = codigoUnidade, Id_Contrato__c = contrato.Id);

                accountUpsert.add(contaNew);
            }
            for (Database.UpsertResult ur : Database.upsert(accountUpsert, Account.CNPJ_CPF__c, false)) {
                System.debug('isSuccess: ' + ur.isSuccess());
                System.debug('AccountId: ' + ur.id);
            }

            if (pageNumber < jsonData.totalPages) {
                System.enqueueJob(new FetchContractsQueueable(++pageNumber, schedulableId));
            }

            if (pageNumber == jsonData.totalPages) {
                if (schedulableId != null) {
                    System.abortJob(schedulableId);
                }
                // // this would increase the time to 1 hour after current time
                Datetime sysTime = System.now().addHours(1);
                String chron_exp =
                    '' +
                    sysTime.second() +
                    ' ' +
                    sysTime.minute() +
                    ' ' +
                    sysTime.hour() +
                    ' ' +
                    sysTime.day() +
                    ' ' +
                    sysTime.month() +
                    ' ? ' +
                    sysTime.year();
                System.schedule('Fetch New Accounts_' + string.valueOf(System.now()), chron_exp, new FetchAccountsSchedulable(true));
            }
        }
    }

    public with sharing class FetchAccountsQueueable implements Queueable, Database.AllowsCallouts {
        private final Id KAIROS_RT_ID = Account.getSObjectType().getDescribe().recordtypeinfosbydevelopername.get('Kairos').getRecordTypeId();

        private Integer pageNumber;

        private Id schedulableId;

        public List<errorAccount> accountsError;

        public FetchAccountsQueueable(Integer pageNumber, Id schedulableId, List<errorAccount> accountsError) {
            this.pageNumber = (pageNumber >= 0) ? pageNumber : this.pageNumber;
            this.schedulableId = (schedulableId != null) ? schedulableId : this.schedulableId;
            this.accountsError = accountsError;
        }

        public void execute(QueueableContext qc) {
            Map<String, String> params = new Map<String, String>{ 'page' => String.valueOf(pageNumber), 'size' => '1000' };
            KairosDTO.RetrieveAllAccountsDTO jsonData = KairosAPIUtils.retrieveAllAccounts(params);
            List<KairosDTO.AccountDTO> contasKairos = jsonData.content;

            List<Account> accountUpsert = new List<Account>();

            for (KairosDTO.AccountDTO conta : contasKairos) {
                Account contaNew = new Account(
                    CNPJ_CPF__c = conta.cnpj != null ? conta.cnpj : conta.cpf,
                    Name = conta.cnpj != null ? conta.companyName : conta.name,
                    AccountSource = 'migracao_kairos',
                    nomeFantasia__c = conta.cnpj != null ? conta.tradingName : conta.name,
                    Numero_de_funcionarios__c = conta.employees,
                    RecordTypeId = KAIROS_RT_ID
                );
                accountUpsert.add(contaNew);
            }

            for (Database.UpsertResult ur : Database.upsert(accountUpsert, Account.CNPJ_CPF__c, false)) {
                System.debug('isSuccess: ' + ur.isSuccess());
                System.debug('AccountId: ' + ur.Id);

                if (!ur.isSuccess()) {
                    errorAccount err = new errorAccount();
                    err.contaId = ur.Id;
                    err.errorText = ur.getErrors().toString();
                    accountsError.add(err);
                }
            }

            if (pageNumber < jsonData.totalPages) {
                System.enqueueJob(new FetchAccountsQueueable(++pageNumber, schedulableId, accountsError));
            }

            if (pageNumber == jsonData.totalPages) {
                if (!accountsError.isEmpty()) {
                    FetchAccountsSchedulable.enviarEmail(accountsError);
                }
                if (schedulableId != null) {
                    System.abortJob(schedulableId);
                }
                Datetime sysTime = System.now().addMinutes(5);
                String chron_exp =
                    '' +
                    sysTime.second() +
                    ' ' +
                    sysTime.minute() +
                    ' ' +
                    sysTime.hour() +
                    ' ' +
                    sysTime.day() +
                    ' ' +
                    sysTime.month() +
                    ' ? ' +
                    sysTime.year();
                System.schedule('Fetch New Accounts_' + string.valueOf(System.now()), chron_exp, new FetchAccountsSchedulable(false));
            }
        }
    }

    public class errorAccount {
        public String errorText;
        public Id contaId;
    }

    public static void enviarEmail(List<errorAccount> accountsError) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        // Set the recipient address
        message.setToAddresses(new List<String>{ 'suporte_ciee@accenture.com', 'matheusdesantacruz@hotmail.com' });
        // Send the message
        message.setSubject('Erro nas contas vindas do Kairos');
        String emailText = '';
        for (errorAccount err : accountsError) {
            emailText += 'Conta de Id ' + err.contaId + ' falhou - (' + err.errorText + ')\n';
        }
        message.setHtmlBody(emailText);
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ message });
    }
}