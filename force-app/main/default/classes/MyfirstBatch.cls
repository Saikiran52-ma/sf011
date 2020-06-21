Global Class MyfirstBatch implements  Database.Batchable <sobject> {

    
     global Database.QueryLocator start(database.batchablecontext BC) {
        
      return Database.getQueryLocator([Select ID,Name,NumberofLocations__c,CreatedByID
                 from Account WHERE NumberofLocations__c != null]); 
                                          
     }
     
     global void execute(Database.BatchableContext BC, List<Account> batchList) {
      
      List<Account> a = new List<Account>();
      
  try{  
     
         If(!batchList.isEmpty())
         for(Account acc : batchList){
         acc.BillingStreet = '39939 Stevenson Blvd';
         acc.BillingCity = 'Fremont';
         acc.BillingState = 'CA';
         acc.BillingPostalcode = '94538';
         acc.BillingCountry = 'US';
         
         a.add(acc);
         
         
         }
         }
         catch(Exception ex){
             
         }
         If(!a.isEmpty()){
         Update a;
         
         }
        }
       
       
     global void finish(Database.BatchableContext info) {
         //We cant send emails once execution get processed or errored out.   
          
     }
     
      
   
}