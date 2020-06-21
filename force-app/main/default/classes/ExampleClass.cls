public class ExampleClass {
    
    
    public static  List<passenger__c> Example(string str,Integer ints,list<string>strlist,map<string,integer> map2){
        List<Plan__c> my_list = new List<Plan__c>();
     my_list =[select id,name,yes_or_no__c,add_on_count__c from Plan__c];
        system.debug('====LIstOf record'+my_list);
        
        List<passenger__c> my_list2 = new List<passenger__c>();
        my_list2=[select id,name,Contact_Num__c,destination__c from passenger__c];
          system.debug('Sai'+my_list2);
        
        Set<string> praveen  = new Set<string>();
       
                   system.debug('Sai'+praveen);
        
		map<string,list<Plan__c>> mapplan =new map<string,list<Plan__c>>();
        mapplan.put('test',my_list);
        
        return my_list2;
        

        

        
    }
    
     public static string Example1(){
         
         string str;
         List<String> myStrings = new List<String>{'a', 'b'};
Boolean result = myStrings.contains('z');
System.assertEquals(false, result);
         
         
        return str;
    }

}