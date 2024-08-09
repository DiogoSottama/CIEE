public with sharing class Logger {
    
    private Map<String, String> mapCampoValue = new Map<String, String>();
    
    public void reset(){
        this.mapCampoValue = new Map<String, String>();
    }


    public void setInfoCab(String className,String methodName){
        this.mapCampoValue.put('Class__c', className);
        this.mapCampoValue.put('Method__c', methodName);
    }


    public void setInfoIntegracao(String response, String payload, String status){
        if(response.length()>131075){
            this.mapCampoValue.put('Response__c', response.substring(0,131070));
        }else{
            this.mapCampoValue.put('Response__c', response);
        }
        
        this.mapCampoValue.put('Payload__c', payload);
        if(status != null)
            this.mapCampoValue.put('Status__c',status);
    }

    public void setInfoException(String erro, String stackTrace, String status){
        this.mapCampoValue.put('Erro__c', erro);
        this.mapCampoValue.put('ErrorStackTrace__c', stackTrace);
        if(status != null)
            this.mapCampoValue.put('Status__c',status);
    }

    public String getInfoException(){
        return this.mapCampoValue.get('Status__c') + '\n'
               + this.mapCampoValue.get('Erro__c') + '\n'
               + this.mapCampoValue.get('ErrorStackTrace__c');
        
    }

    public Log__c gerarLog() {
        Log__c log = new Log__c();
        Set<String> setKey = this.mapCampoValue.keySet();
        for(String chave:setKey){
            log.put(chave, this.mapCampoValue.get(chave));
        }
        return log;
    }


    public void gravarLog() {
        System.debug('Gravando log');
        System.debug('Log_keys:'+this.mapCampoValue.keySet());
       
        Log__c log = new Log__c();
        System.debug('Log:'+log);
        Set<String> setKey = this.mapCampoValue.keySet();
        for(String chave:setKey){
            log.put(chave, this.mapCampoValue.get(chave));
        }
        insert log;
    }

    public List<log__c> tratarSaveResult(List<Database.SaveResult> lstResult){
        List<log__c> lstLog = new List<Log__c>();
        for(Database.SaveResult rs:lstResult){
            if(!rs.success){
                System.debug('rs.getErrors():'+rs.getErrors());
                List<Database.Error> lstErr = rs.getErrors();
                String msg='';
                String fields=' Fields with error: \n';
                for(Database.Error err: lstErr){
                    msg += 'Erro message: '+err.getMessage()+'\n';
                    fields += err.getFields()+'\n';
                }
                msg +=rs+'\n';
                
                this.setInfoException(msg, fields, 'Error');
                lstLog.add(this.gerarLog());
                
            }
        }
        if(!lstLog.isEmpty())
            insert lstLog;
        return lstLog;
    }

    public void tratarUpsertResult(List<Database.UpsertResult> lstResult){
        List<log__c> lstLog = new List<Log__c>();
        for(Database.UpsertResult rs:lstResult){
            if(!rs.success){
                System.debug('rs.getErrors():'+rs.getErrors());
                List<Database.Error> lstErr = rs.getErrors();
                String msg=rs+'\n';
                String fields=' Fields with error: \n';
                for(Database.Error err: lstErr){
                    msg += 'Erro message: '+err.getMessage()+'\n';
                    fields += err.getFields()+'\n';
                }
                this.setInfoException(msg, fields, 'Error');
                lstLog.add(this.gerarLog());
            }
                
        }
        if(!lstLog.isEmpty())
            insert lstLog;
    }
}