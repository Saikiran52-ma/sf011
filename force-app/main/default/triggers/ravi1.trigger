trigger ravi1 on Plan__c (before update,after insert,after update) {
    if(trigger.isbefore && trigger.isupdate){
        for(Plan__c sam: trigger.new){
           sam.amount__c =sam.amount__c +100;
                      
            
            
        }
    }
    if(trigger.isafter && trigger.isinsert){
        list<add_ons__c> skuma = new list <add_ons__c>();
        add_ons__c Add = new add_ons__c();
        for(Plan__c sam:trigger.new){
            if(sam.verify__c == true){
            Add = new add_ons__c();
                Add.name  ='FirstAddon';
            Add.amount__c =50;
            Add.Plan__c =sam.Id;
                skuma.add(Add);
            }
        }
        if(skuma.size() >0)
            insert skuma;
    }
    if(trigger.isafter && trigger.isupdate){
        set<id> newyork=new set<id> ();
         list<add_ons__c> Addlistupdate = new  list<add_ons__c>();
        for(plan__c  plan:trigger.new){
            newyork.add(plan.Id);
            
        }
        list<add_ons__c> Addlist = [select id,name,amount__c,plan__c from add_ons__c where plan__c In:newyork];
         for(plan__c  plan:trigger.new){
             for(add_ons__c Add :Addlist){
                 if(plan.Id  ==Add.plan__c){
                    Add.amount__c = plan.amount__c;
                    
                 }
                  Addlistupdate.add(Add);
             }
           
            
        }
        system.debug('===='+Addlistupdate);
        if(Addlistupdate.size()>0)
            update Addlistupdate;
    }
}