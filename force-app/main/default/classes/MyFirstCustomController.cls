Public Class MyFirstCustomController{

  public Account account {get;set;} 

  public MyFirstCustomController(){
  
    Id id  = ApexPages.currentPage().getParameters().get('Id');
    account = (Id == null) ? new Account() : [Select Id, Name, phone,Industry from Account Where ID =: Id];
  }
  
  
  public PageReference Save(){
    try{
    
       upsert (account);
    }catch(Exception ex){
        return null;
    }
    Pagereference pg =  new ApexPages.StandardController(Account).view();
    return pg;
  }



}