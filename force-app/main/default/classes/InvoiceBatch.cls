global class InvoiceBatch implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Name,batch_class_update__c FROM Invoice__c ' 
        );
    }
    global void execute(Database.BatchableContext bc, List<Invoice__c> scope){
        // process each batch of records
       list <Invoice__c> kiran = new list<Invoice__c>();
        for(Invoice__c sai:scope){
            
            sai.batch_class_update__c = system.today();
            kiran.add(sai);
        
            
        }
        if(kiran.size()>0)
        update kiran;
       
    }    
    global void finish(Database.BatchableContext bc){
      
    }    
}