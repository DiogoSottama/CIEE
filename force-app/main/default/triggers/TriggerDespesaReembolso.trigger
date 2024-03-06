trigger TriggerDespesaReembolso on Despesa_e_Reembolso__c (before insert, after insert, before update, after update) {
    DespesaReembolsoTriggerHandler handler = new DespesaReembolsoTriggerHandler(Trigger.isExecuting, Trigger.size);

    if( Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(trigger.New);
    }

    if(Trigger.isUpdate && Trigger.isBefore){
        handler.onBeforeUpdate(trigger.New, Trigger.OldMap);
    }
   
//    if( Trigger.isInsert ){
//        if(Trigger.isBefore){
//            
//        }
//        else if(Trigger.isAfter){
//            handler.OnAfterInsert(trigger.New);
//        }
//    }
   
//    if( Trigger.isUpdate ){
//        if(Trigger.isBefore){
//            handler.OnBeforeUpdate(trigger.New, trigger.Old, Trigger.NewMap, Trigger.OldMap);
//        }
//        else if(Trigger.isAfter){
//            handler.OnAfterUpdate(trigger.New, trigger.Old, Trigger.NewMap, Trigger.OldMap);
//        }
//    }
}