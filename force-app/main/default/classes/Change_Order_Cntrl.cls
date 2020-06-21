public class Change_Order_Cntrl {
    
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(string objDetail, string contrfieldApiName,string depfieldApiName) {
      
        Packet_Change_Order__c objDetail1  = ( Packet_Change_Order__c )JSON.deserialize(objDetail,  Packet_Change_Order__c .class);
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>(); 
        
        Schema.sObjectType objType = objDetail1.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        system.debug('=123=='+objFieldMap.get('User_Profile__c'));
      //  if(!Test.isRunningTest()){

        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
         //   return objResults;     
        }
      //  }
       Schema.SObjectField ctrlField = objFieldMap.get('User_Profile__c');
        Schema.SObjectField theField = objFieldMap.get(dependentField);
            
         system.debug('==4=='+ctrlField);
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    @Auraenabled
    public static string save_changeorder(Packet_Change_Order__c objDetail,string parentId,string packetlineitems,string NoshBagpacketlineitems){
        try{
            system.debug('======'+parentId);
              system.debug('======'+objDetail);
            Packet__c packet = [select id,name,Account__c,status__c,CreatedById,United_Catering_User__c from Packet__c where Id=:parentId];
            system.debug('======'+packet.status__c);
            // Packet_Change_Order__c objDetail1  = ( Packet_Change_Order__c )JSON.deserialize(objDetail,  Packet_Change_Order__c .class);
            objDetail.Packet__c = parentId;
            insert objDetail;
            if(packet.status__c =='Customer Review'){
                Packet_AddLineItems_cntrl1.submitforApproval( parentId,packetlineitems,NoshBagpacketlineitems);
            }else{
              Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall( parentId,'','Approve');
            }
        }
        catch(Exception Ex){
            system.debug('==='+Ex.getMessage());
            
        }
        return null;
    }
    
}