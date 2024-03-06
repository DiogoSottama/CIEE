public with sharing class CarteiraTriggerHandler {
	private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI = false;
    
    public CarteiraTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
	
    public void OnBeforeInsert(List<Carteira__c> newCarteira){
       
    }
    public void OnAfterInsert(List<Carteira__c> newCarteira){
        CarteiraActions.UpdateLeadsCarteiraNova(newCarteira);
        CarteiraActions.UpdateContasCarteiraNova(newCarteira);
    }
    public void OnAfterUpdate( List<Carteira__c> newCarteira, List<Carteira__c> oldCarteira, Map<ID, Carteira__c> newCarteiraMap , Map<ID, Carteira__c> oldCarteiraMap ){
        CarteiraActions.UpdateLeadsCarteiraAtualizada(newCarteira, oldCarteira); 
        CarteiraActions.UpdateContasCarteiraAtualizada(newCarteira, oldCarteira);
    }
    public void OnBeforeUpdate( List<Carteira__c> newCarteira, List<Carteira__c> oldCarteira, Map<ID, Carteira__c> newCarteiraMap , Map<ID, Carteira__c> oldCarteiraMap ){
        
    }
}