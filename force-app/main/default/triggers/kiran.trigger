trigger kiran on Invoice__c (before insert,after insert) {
    if(trigger.isbefore && trigger.isinsert){
        for(Invoice__c kiran:trigger.new){
            kiran.Start_Date__c =system.today();
            kiran.Due_Date__c =  kiran.Start_Date__c.adddays(15);
            // kiran.Time__c =time();
            kiran.Status__c ='draft';
                
        }
       
    }
     if(trigger.isafter && trigger.isinsert){
         Map<string,list< Invoice_Line_Item__c>> kiranmai=new Map<string,list< Invoice_Line_Item__c>>();
         Invoice_Line_Item__c InvoiceLineItem = new Invoice_Line_Item__c();
         List<Invoice_Line_Item__c> InvoiceLineItemList= new List<Invoice_Line_Item__c>();
          Invoice__c ravi =new  Invoice__c();
         List<Invoice__c> ravilist= new List<Invoice__c>();
         Plan__c suresh =new  Plan__c();
         List< Plan__c> sureshlist = new List< Plan__c>();
         
         for(Invoice__c kumar:trigger.new){
             Date  sai;
             Date kiran;
           // kumar
             FOR(integer i=0;i<kumar.child_invoice__c ;i++){
           InvoiceLineItem = new Invoice_Line_Item__c();
             InvoiceLineItem.Name =kumar.Name;
                 if(sai==null){
            InvoiceLineItem.start_date__c	=kumar.start_date__c;
                 }
                 else{
                          InvoiceLineItem.start_date__c	=sai;
                 }
                  InvoiceLineItem.end_date__c =InvoiceLineItem.start_date__c.addDays(15);    
                
                 
             InvoiceLineItem.Invoice__c =kumar.Id;
             InvoiceLineItem.Invoice_Amount__c =250;
             InvoiceLineItemList.add(InvoiceLineItem);
                 sai=InvoiceLineItem.end_date__c;
             kiranmai.put(kumar.Name,InvoiceLineItemList);
             }
         }
         if(InvoiceLineItemList.size()>0)
         insert InvoiceLineItemList;
        }

}