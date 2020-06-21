trigger useFucturemethod on Account (before insert){

        
        Account a = new Account(Name='Acme');
    
        
        
        
        Util.insertUserWithRole(
            'mruiz@awcomputing.com.saikirandev', 'mruiz', 
            'mruiz@awcomputing.com', 'Ruiz');        
    }