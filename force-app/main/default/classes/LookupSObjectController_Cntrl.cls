public with sharing class LookupSObjectController_Cntrl 
{
    /**
* Aura enabled method to search a specified SObject for a specific string
*/
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName,string searchField ,string searchFieldValue,string[] AcctproductIds,string[] ProductIdList,string parenrtname)
    {      
        List<Result> results = new List<Result>();       
        list<string >Ids = new list<String >();
        map<string,string> mapproductlist = new  map<string,string>();
        for(string str :ProductIdList){
            system.debug('===='+str);
            mapproductlist.put(str,str);
        }
        
        system.debug('====='+AcctproductIds);
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
        String sanitizedSearchField,sanitizedSearchFieldvalue;
        if(searchField != null)
            sanitizedSearchField = String.escapeSingleQuotes(searchField);
        if(searchFieldValue != null)
            sanitizedSearchFieldValue = String.escapeSingleQuotes(searchFieldValue);        
        
        String searchQuery = 'SELECT id,Name';   
        
        if(sanitizedSObjectAPIName == 'Product2')
            searchQuery +=',IT_Code__c,Unit_Price__c,Use_Location_Markup__c,Sponsored_Product__c' ;
        
        searchQuery += ' From '+sanitizedSObjectAPIName ;
        if(sanitizedSearchField != null && sanitizedSearchField != '')
            searchQuery += ' Where '+sanitizedSearchField +' like \'%'+ sanitizedSearchString + '%\' ';
        else
            searchQuery += ' Where Name like \'%'+ sanitizedSearchString + '%\' ';
        if(sanitizedSearchFieldValue != null && sanitizedSObjectAPIName == 'Product2')
            searchQuery += ' AND Menu_Sections__c INCLUDES  (\''+sanitizedSearchFieldValue+'\') AND IsActive = true ' ;
        //  if(Ids.size()>0){
        //          searchQuery += ' AND Id NOT IN'+ Ids;
        
        //  }
        if(sanitizedSearchFieldValue =='Nosh Bag' && parenrtname =='ParentRecord'){
            searchQuery +=' AND Nosh_Bag_Parent__c = true ' ;
        }
                system.debug('===parent'+parenrtname);

        if(sanitizedSearchFieldValue =='Nosh Bag' && parenrtname =='Null'){
            searchQuery +=' AND Nosh_Bag_Parent__c = false';
        }
        
        searchQuery += ' order by Name limit 20' ;
        system.debug('===='+searchQuery);
        List<sObject> sobjList = Database.query(searchQuery );
        List<sObject> sobjList1 =new list<sObject>();
        system.debug('=mapproductlist=='+mapproductlist.size());
        for (SObject so : sobjList )
        {
            if(mapproductlist.size() > 0){
                if(!mapproductlist.containsKey(so.id)){
                    sobjList1.add(so) ;   
                }
            }else{
                sobjList1.add(so) ; 
            }
            
        }
        for (SObject so : sobjList1 )
        {
            if(sanitizedSObjectAPIName == 'Product2'){
                if((boolean)so.get('Sponsored_Product__c') == true ){
                    for(string str :AcctproductIds){
                        if(str == so.Id)
                            results.add(new Result((String)so.get('name'),so.Id,so));
                    }
                }else{
                    results.add(new Result((String)so.get('name'),so.Id,so));
                    
                }
            }
            else{
                results.add(new Result((String)so.get('name'),so.Id,so));
                
            }
        }        
        return results;
        
    }
    
    
    /**
* Inner class to wrap up an SObject Label and its Id
*/
    public class Result
    {
        @AuraEnabled public String Name{get; set;}
        @AuraEnabled public Id SObjectId {get; set;}
        @AuraEnabled public SObject SObjectRecord {get;set;}
        
        public Result(String sObjectLabel, Id sObjectId,SObject sobj)
        {
            this.Name = sObjectLabel;
            this.SObjectId = sObjectId;
            this.SObjectRecord = sobj ;
        }
    }
    @AuraEnabled
    public static Result[] getRecentRecords( String sObjectAPIName,string searchField,string searchFieldValue,string[] AcctproductIds,string[] ProductIdList,string parenrtname)
    {
        system.debug('===='+ProductIdList.size());
        system.debug('===='+ProductIdList);
        list<string >Ids = new list<String >();
        map<string,string> mapproductlist = new  map<string,string>();
        for(string str :ProductIdList){
            system.debug('===='+str);
            
            mapproductlist.put(str,str);
        }
        
        
        
        system.debug('===='+AcctproductIds);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
        String sanitizedSearchField ,sanitizedSearchFieldValue ;
        if(searchField != null)
            sanitizedSearchField = String.escapeSingleQuotes(searchField);        
        if(searchFieldValue != null)
            sanitizedSearchFieldValue = String.escapeSingleQuotes(searchFieldValue);        
        List<Result> results = new List<Result>();         
        String searchQuery = 'SELECT id,Name';    
        
        if(sanitizedSObjectAPIName == 'Product2')
            searchQuery +=',IT_Code__c,Unit_Price__c,Use_Location_Markup__c,Sponsored_Product__c' ;        
        searchQuery += ' From '+sanitizedSObjectAPIName ;
        
        if(sanitizedSearchFieldValue != null && sanitizedSObjectAPIName == 'Product2')
            searchQuery += ' where Menu_Sections__c INCLUDES  (\''+sanitizedSearchFieldValue+'\')  AND IsActive = true ';
        // if(Ids.size()>0){
        //   searchQuery += ' AND Id NOT IN'+ Ids;
        
        //  }
        if(sanitizedSearchFieldValue =='Nosh Bag' && parenrtname =='ParentRecord'){
            searchQuery +=' AND Nosh_Bag_Parent__c = true';
        }
        system.debug('===parent'+parenrtname);
       if(sanitizedSearchFieldValue =='Nosh Bag' && parenrtname =='Null'){
            searchQuery +=' AND Nosh_Bag_Parent__c = false';
        }
        
        searchQuery +=' order by CreatedDate limit 10' ;
        system.debug('==='+searchQuery);
        List<sObject> sobjList = Database.query(searchQuery);
        List<sObject> sobjList1 =new list<sObject>();
        for (SObject so : sobjList )
        {
            if(mapproductlist.size() > 0){
                if(!mapproductlist.containsKey(so.id)){
                    sobjList1.add(so) ;   
                }
            }else{
                sobjList1.add(so) ; 
            }
            
        }
        
        for (SObject so : sobjList1 )
        {      
            if(sanitizedSObjectAPIName == 'Product2'){
                if((boolean)so.get('Sponsored_Product__c') == true  ){
                    
                    for(string str :AcctproductIds){
                        if(str == so.Id)
                            results.add(new Result((String)so.get('name'),so.Id,so));
                    }
                }else{
                    results.add(new Result((String)so.get('name'),so.Id,so));
                    
                }
            }else{
                results.add(new Result((String)so.get('name'),so.Id,so));   
            }
        }
        return results;
        
    }
}