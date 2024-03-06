trigger TriggerAccount on Account (before insert, before update, after insert, after update) {
    AccountTriggerHandler handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if( Trigger.isInsert ){
        if(Trigger.isBefore){
            handler.OnBeforeInsert(trigger.New);
        }
       /* if(Trigger.isAfter){
            handler.OnAfterInsert(trigger.New);
        }*/
    }
    if( Trigger.isUpdate ){
        if(Trigger.isBefore){
            handler.OnBeforeUpdate(trigger.New, trigger.Old, Trigger.NewMap, Trigger.OldMap);
        }
       /* if(Trigger.isAfter){
            handler.OnAfterUpdate(trigger.New, trigger.Old, Trigger.NewMap, Trigger.OldMap);
        }*/
    }
}