public class Contact_PaginationCntrl {


  public Integer size{get;set;}
  public Integer noOfRecords {get;set;}
  public List<SelectOption> PaginationSizeOptions{get;set;}
  
  
  public Contact_PaginationCntrl(){
    size=5;
    PaginationSizeOptions = new List<SelectOption> ();
    PaginationSizeOptions.add(new SelectOption('5','5'));
    PaginationSizeOptions.add(new SelectOption('10','10'));
    PaginationSizeOptions.add(new SelectOption('20','20'));
    PaginationSizeOptions.add(new SelectOption('50','50'));
    PaginationSizeOptions.add(new SelectOption('100','100'));
    
 
  }
  
  public ApexPages.StandardSetController setCon{
   get{
       if(setCon == Null){
         setCon = new ApexPages.StandardSetcontroller(DataBase.getQueryLocator([Select Id,Firstname, lastname, email,Phone,AccountId, Account.Name,
                           CreatedDate from Contact]));
                           
         setCon.setPageSize(size);
         noOfRecords = setCon.getResultSize();
      }
      return setCon;
   }
   set;
  }

  //Changes the size of pagination
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
         return null;
    }
    
    // Initialize setCon and return a list of record    
     
    public List<Contact> getcontacts() {
         return (List<Contact>) setCon.getRecords();
    }

}