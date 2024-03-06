public with sharing class LeadTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob;
    public static boolean isFromUploadAPI = false;

    public LeadTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Lead> newLead) {
        List<Carteira__c> carteiras;

        if (newLead[0].CEPSemFormatacao__c != null) {
            carteiras = [
                SELECT Id, Consultor__c, DoCEPSemFormatacao__c, AteOCEPSemFormatacao__c, Apoio__C
                FROM Carteira__c
                WHERE DoCEPSemFormatacao__c <= :newLead[0].CEPSemFormatacao__c AND AteOCEPSemFormatacao__c >= :newLead[0].CEPSemFormatacao__c
                LIMIT 1
            ];

            if (carteiras.size() > 0) {
                newLead[0].OwnerId = carteiras[0].Apoio__c;
                newLead[0].Consultor__c = carteiras[0].Consultor__c;
            }
        }
        
        ZipCodeLead.setAssignedUserByPostalCode(newLead);
    }

    public void OnBeforeUpdate(List<Lead> newLead, List<Lead> oldLead, Map<ID, Lead> newLeadMap, Map<ID, Lead> oldLeadMap) {
        List<Carteira__c> carteiras;

        if (newLead[0].CEPSemFormatacao__c != null) {
            carteiras = [
                SELECT Id, Consultor__c, DoCEPSemFormatacao__c, AteOCEPSemFormatacao__c, Apoio__C
                FROM Carteira__c
                WHERE DoCEPSemFormatacao__c <= :newLead[0].CEPSemFormatacao__c AND AteOCEPSemFormatacao__c >= :newLead[0].CEPSemFormatacao__c
                LIMIT 1
            ];

            if (carteiras.size() > 0) {
                newLead[0].OwnerId = carteiras[0].Apoio__c;
                newLead[0].Consultor__c = carteiras[0].Consultor__c;
            }
        }
    }

    public void OnAfterInsert(List<Lead> newLead) {
    }

    public void OnAfterUpdate(List<Lead> newLead, List<Lead> oldLead, Map<ID, Lead> newLeadMap, Map<ID, Lead> oldLeadMap) {
    }
}