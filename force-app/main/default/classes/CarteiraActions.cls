public without sharing class CarteiraActions {
    
    public static void UpdateLeadsCarteiraNova (List<Carteira__c> newCarteira){
        List<Lead> leads = new List<Lead>();
        List<Lead> leadsUpd = new List<Lead>();  
        
        boolean estaAtivo = [SELECT Id, isActive
                            FROM User
                            WHERE Id = :newCarteira[0].Consultor__c].isActive;
        
        if(estaAtivo){
            System.debug('olar');
            leads = [SELECT Id, OwnerId, PostalCode, CEPSemFormatacao__c
                     FROM Lead
                     WHERE isConverted = false 
                     AND CEPSemFormatacao__c <= :newCarteira[0].AteOCEPSemFormatacao__c
                     AND CEPSemFormatacao__c >= :newCarteira[0].DoCEPSemFormatacao__c];
            for(Lead lead : leads){
                leadsUpd.add(lead);
                
            }  
            
            if(leadsUpd.size() > 0)
                update leadsUpd;
        }
    }
    public static void UpdateContasCarteiraNova (List<Carteira__c> newCarteira){
        List<Account> accs = new List<Account>();
        List<Account> accsUpd = new List<Account>();
        
        boolean estaAtivo = [SELECT Id, isActive
                             FROM User
                             WHERE Id = :newCarteira[0].Consultor__c].isActive;
        
        if(estaAtivo){
            System.debug('olar');
            accs = [SELECT Id, OwnerId, CEPSemFormatacao__c, Consultor__c
                     FROM Account
                     WHERE CEPSemFormatacao__c <= :newCarteira[0].AteOCEPSemFormatacao__c
                     AND CEPSemFormatacao__c >= :newCarteira[0].DoCEPSemFormatacao__c];
            for(Account acc : accs){
                accsUpd.add(acc);
            }  
            
            if(accsUpd.size() > 0)
                update accsUpd;
        }
    }
    public static void UpdateLeadsCarteiraAtualizada (List<Carteira__c> newCarteira, List<Carteira__c> oldCarteira){
        System.debug('CARTEIRA NOVA ' + newCarteira[0]);
        System.debug('CARTEIRA VELHA ' + oldCarteira[0]);
        
        List<Carteira__c> carteiraMudada = new List<Carteira__c>();
        for(Carteira__c carteiraNova: newCarteira){
            for(Carteira__c carteiraVelha: oldCarteira){
                System.debug('antes if');                
                if(carteiraNova.AteOCEPSemFormatacao__c != carteiraVelha.AteOCEPSemFormatacao__c || 
                   carteiraNova.DoCEPSemFormatacao__c != carteiraVelha.DoCEPSemFormatacao__c ||
                   carteiraNova.Consultor__c != carteiraVelha.Consultor__c || carteiraNova.Apoio__c != carteiraVelha.Apoio__c ){
                       carteiraMudada.add(carteiraNova);
                   }
            }
        }
        
        if(carteiraMudada.size()>0){
            boolean estaAtivo = [SELECT Id, isActive
                                 FROM User
                                 WHERE Id = :carteiraMudada[0].Consultor__c].isActive;
            System.debug('AAAAAAAAAAA ' + estaAtivo);
            
            if(estaAtivo){
                List<Lead> leads = new List<Lead>();
                List<Lead> leadsUpd = new List<Lead>(); 
                
                leads = [SELECT Id, OwnerId, PostalCode, CEPSemFormatacao__c, Consultor__c
                         FROM Lead
                         WHERE CEPSemFormatacao__c <= :carteiraMudada[0].AteOCEPSemFormatacao__c
                         AND CEPSemFormatacao__c >= :carteiraMudada[0].DoCEPSemFormatacao__c];
                for(Lead lead : leads){
                    System.debug('CARTEIRA ' + lead.OwnerId);
                    System.debug('LEADS ' + lead.Id);
                    update lead;
                }  
                
                //if(leadsUpd.size() > 0){
                    //system.debug('aa2' + leadsUpd);
                    //update leadsUpd;
                //}
            }
        }
    }
    public static void UpdateContasCarteiraAtualizada (List<Carteira__c> newCarteira, List<Carteira__c> oldCarteira){
        List<Carteira__c> carteiraMudada = new List<Carteira__c>();
        for(Carteira__c carteiraNova: newCarteira){
            for(Carteira__c carteiraVelha: oldCarteira){
                System.debug('antes if');                
                if(carteiraNova.AteOCEPSemFormatacao__c != carteiraVelha.AteOCEPSemFormatacao__c || 
                   carteiraNova.DoCEPSemFormatacao__c != carteiraVelha.DoCEPSemFormatacao__c ||
                   carteiraNova.Consultor__c != carteiraVelha.Consultor__c || carteiraNova.Apoio__c != carteiraVelha.Apoio__c){
                       carteiraMudada.add(carteiraNova);
                   }
                
            }
        }
        if(carteiraMudada.size()>0){
            List<Account> accs = new List<Account>();
            List<Account> accsUpd = new List<Account>();  
            
            system.debug('Depois do If');
            
            boolean estaAtivo = [SELECT Id, isActive
                                 FROM User
                                 WHERE Id = :carteiraMudada[0].Consultor__c].isActive;
            
            if(estaAtivo){
                System.debug('olar');
                accs = [SELECT Id, OwnerId, CEPSemFormatacao__c, Consultor__c
                        FROM Account
                        WHERE CEPSemFormatacao__c <= :carteiraMudada[0].AteOCEPSemFormatacao__c
                        AND CEPSemFormatacao__c >= :carteiraMudada[0].DoCEPSemFormatacao__c];
                for(Account acc : accs){
                    accsUpd.add(acc);
                }  
                
                if(accsUpd.size() > 0)
                    update accsUpd;
            }
        }  
    }
}