public class intialclass {
    public static void intial(){
        list<Employment_Website__c> kumar = new list <Employment_Website__c>();
                list<Employment_Website__c> kumar1 = new list <Employment_Website__c>();

        kumar =[select id,Maximum_Budget__c,web_adress__c from Employment_Website__c ];
        system.debug('==='+ kumar.size());
        for(Employment_Website__c Emp :kumar){
            kumar1.add(Emp);
            
        }
        List<Integer> myList = new List<Integer>();
myList.add(47);
        myList.add(8);
        myList.add(89);
        
Integer myNumber = myList.get(2);
        Integer myNumber1 = myList.get(0);
Integer myNumber2 = myList.get(1);

        system.debug('==='+ myNumber);
        system.debug('==='+ myNumber1);
        system.debug('==='+ myNumber2);
        
        
        map<string,list<Employment_Website__c>> mapplan =new map<string,list<Employment_Website__c>>();
        mapplan.put('test',kumar);
        system.debug('==='+ mapplan);
        Map<Integer, String> m1 = new Map<Integer, String>();
m1.put(1, 'First item');
m1.put(2, 'Second item');
        system.debug('==='+ m1);
        
        
    }
    public static void m3(){
        
    }
     public static void m34(){
        
    }
        
    
        
    }