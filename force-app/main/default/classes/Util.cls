public class Util {
    @future
    public static void insertUserWithRole(
        String uname, String al, String em, String lname) {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
        // Create new user with a non-null user role ID 
        User u = new User ();
            u.alias = al;
            u.email= em;
            u.emailencodingkey='UTF-8'; 
            u.lastname=lname;
            u.languagelocalekey='en_US';
            u.localesidkey='en_US';
            u.profileid = p.Id;
            u.userroleid = r.Id;
            u.timezonesidkey='America/Los_Angeles';
            u.username=uname;
        insert u;
    }
}