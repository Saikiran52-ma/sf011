Global Class MyBatch implements  Database.Batchable <sobject> {

    
     global Database.QueryLocator start(database.batchablecontext BC) {
        
      return Database.getQueryLocator([Select ID,Name from Account ]); 
       //return null;                                   
     }
     
     global void execute(Database.BatchableContext BC, List<Account> batchList) {
      
      
      
  try{  
     
         
         }catch(Exception ex){
             
         }
         
        }
       
       
     global void finish(Database.BatchableContext info) {
         //We cant send emails once execution get processed or errored out.   
          
     }
     
      
   
}