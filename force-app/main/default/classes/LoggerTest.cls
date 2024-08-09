@IsTest
public with sharing class LoggerTest {
    
    @IsTest
    public static void testLoggerUpdate() {
        Test.startTest();
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account());
        Logger log = new Logger();
        log.setInfoCab('Teste', 'testTratarUpsertResult');
        log.tratarUpsertResult(Database.upsert(lstAcc,false));
        Test.stopTest();
    }

    @IsTest
    public static void testLoggerInsert() {
        Test.startTest();
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account());
        Logger log = new Logger();
        log.setInfoCab('Teste', 'testTratarUpsertResult');
        log.tratarSaveResult(Database.insert(lstAcc,false));
        Test.stopTest();
    }

    @IsTest
    public static void testLoggerManual() {
        Test.startTest();
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(new Account());
        Logger log = new Logger();
        log.setInfoCab('Teste', 'testTratarUpsertResult');
        log.setInfoException('erro' , 'stackTrace', 'Error');
        log.setInfoIntegracao('response', 'payload', 'Error');
        log.gravarLog();
        log.gerarLog();
        log.reset();
        Test.stopTest();
    }
}