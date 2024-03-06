trigger TriggerCarteira on Carteira__c (before insert, after insert, before update, after update) {
	 CarteiraTriggerHandler handler = new CarteiraTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if( Trigger.isInsert ){
        if(Trigger.isBefore){
            handler.OnBeforeInsert(trigger.New);
        }
        else if(Trigger.isAfter){
            handler.OnAfterInsert(trigger.New);
        }
    }
    
    if( Trigger.isUpdate ){
        if(Trigger.isBefore){
            handler.OnBeforeUpdate(trigger.New, trigger.Old, Trigger.NewMap, Trigger.OldMap);
        }
        else if(Trigger.isAfter){
            handler.OnAfterUpdate(trigger.New, trigger.Old, Trigger.NewMap, Trigger.OldMap);
        }
    }
}