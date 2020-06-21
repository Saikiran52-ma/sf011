trigger kumar on regional_list__c (before insert,before update) {
    if(trigger.isbefore && trigger.isinsert){
        for(regional_list__c kiran : trigger.new){
            kiran.name = 'kanna';
        }
        
        
    }
    if(trigger.isbefore && trigger.isupdate){
        for(regional_list__c sai :trigger.new){
            
            if(Trigger.oldMap.get(sai.ID).verification__c == false){
                sai.verification__c =true;
                
            }
        }
    }

}