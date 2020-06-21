public class WrapperController{

 public List<cContact> contactList{get;set;}

 public WrapperController(){}
 
 public List<cContact> getcontacts(){
   if(contactList == Null)
     contactList = new List<cContact> ();
     for(Contact c : [Select Id, Name , email, Phone from Contact LIMIT 20]){
     
        contactList.add(new cContact(c));
     }
  
   return contactList;
 }
 
 //Action method.
 public PageReference processSelected(){
   List<Contact> selectedContacts = new List<Contact> ();
    List<Contact> updatelst= new List<Contact> ();
   
   for(cContact ccon : getcontacts()){
       if(ccon.selected == True)
       selectedContacts.add(ccon.con);
   }
   
   if(!selectedContacts.IsEmpty())
   for(Contact c : selectedContacts){
   
       c.email = 'saikiran@gmail.com';
       updatelst.add(c);
   }
 
  contactList = null;
  update updatelst;
  return null;
 }
 
 
 //Define a Wrapper class.
 public class cContact{
 
   public Contact con {get;set;}
   public Boolean selected {get;set;}
   
   public cContact(Contact c){
     con  = c; 
     selected = false;
   
   }
   
 
 }

}