public with sharing class DespesaReembolsoTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI = false;
    
    public DespesaReembolsoTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Despesa_e_Reembolso__c> newList){
        for(Despesa_e_Reembolso__c despesa : newList){
            despesa.Duracao_da_Visita__c = '0';
        }
    }

    public void onBeforeUpdate(List<Despesa_e_Reembolso__c> newList, Map<Id, Despesa_e_Reembolso__c> mapOld){
        List<Profile> profs = [SELECT Id FROM Profile WHERE Id = :UserInfo.getProfileId() AND Name IN ('Supervisão', 'Gerência', 'System Administrator', 'Administrador do sistema')];        
        for(Despesa_e_Reembolso__c despesa : newList){
            Despesa_e_Reembolso__c despesaOld = mapOld.get(despesa.id);
            
            despesa.Duracao_da_Visita__c = '0';
            
            if(profs.isEmpty() || Test.isRunningTest()){
                if(despesaOld.Status__c == 'Aprovado' || despesaOld.Status__c == 'Recusado'){
                    despesa.addError('Você não pode editar esse registro no estágio atual.');
                }
            }           
        }
    }
}