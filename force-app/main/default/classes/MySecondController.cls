public class MySecondController {

   Private String sortorder = 'Firstname';

   public MySecondController (){
   
     
   }
   
   public List<Contact> getContacts(){
     
     String q = 'Select Id,Firstname, lastname, title, email from Contact' +  ' Order by ' + '' + sortorder + ' Asc LIMIT 100';
     List<Contact> c = new List<Contact> ();
     c = Database.query (q);
   
     return c;
   }
   
   public void sortbyFirstname(){
   
   this.sortorder = 'Firstname';
   
   }
   
  public void sortBylastname(){
   
    this.sortorder = 'LastName';
   
   }
   


}