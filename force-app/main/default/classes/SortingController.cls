public class SortingController{

  private String SortOrder = 'Lastname';
  private String ascordesc = ' ASC';


  public SortingController(){}


  public List<Contact> getcontacts(){
   list<Contact> clst = new List<Contact> ();
    String query = '';
    query = 'Select Id, Firstname, lastname, email, title, phone from Contact' + ' Order By ' + SortOrder + ascordesc + ' LIMIT 100';
   
    clst  = Database.query(query);
  
  
    return clst  ;
  }
  
  public void sortByFirstname() {
   this.SortOrder = 'FirstName';
   if(ascordesc == ' ASC'){
      ascordesc = ' DESC';
   }else{
      ascordesc = ' ASC';
   }
  
  }
  
   public void sortByLastname() {
   this.SortOrder = 'LastName';
   if(ascordesc == ' ASC'){
      ascordesc = ' DESC';
   }else{
      ascordesc = ' ASC';
   }
  
  }


}