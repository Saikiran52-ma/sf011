trigger pravik on passenger__c (before insert,before update,before delete,after insert,after update,after undelete) {
    
    
    if(trigger.isbefore && trigger.isinsert){
        for(passenger__c pass : trigger.new){
            system.debug('kiran'+pass);
            
        }
        
        
    }
    if(trigger.isupdate && trigger.isbefore){
        for(passenger__c pass : trigger.new){
            system.debug('kiran1'+pass);
        }
        
    }
    if(trigger.isafter && trigger.isundelete){
        for(passenger__c pass : trigger.old){
            system.debug('kiran2'+pass);
        }
        
    }
    if(trigger.isupdate && trigger.isbefore){
        for(passenger__c pass : trigger.old){
            system.debug('kiran3'+pass);
        }
    }
    if(trigger.isinsert && trigger.isafter){
        for(passenger__c pass : trigger.old){
            system.debug('kiran3'+pass);
        }
        
    }
    if(trigger.isdelete && trigger.isbefore){
        for(passenger__c pass : trigger.old){
            system.debug('kiran3'+pass);
        }
        
    }

    }