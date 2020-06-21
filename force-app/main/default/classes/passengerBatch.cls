global class passengerBatch implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Name,batch_class_update__c FROM passenger__c ' 
        );
    }
        
        global void execute(Database.BatchableContext bc, List<passenger__c> scope){
        
       list <passenger__c> kumar = new list<passenger__c>();
        for(passenger__c sam:scope){
            
            sam.batch_class_update__c = system.today();
            kumar.add(sam);
        
            
        }
        if(kumar.size()>0)
        update kumar;
       
    }
         global void finish(Database.BatchableContext bc){
      
         }
    }