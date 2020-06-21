trigger packet_Trigger on Packet__c (After insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        system.debug('=====Afterinsert');
        list<Packet_Line_Item__c> insertpacketlineitems = new list<Packet_Line_Item__c>();
        boolean Accountboolean;
        for(Packet__c packet : trigger.new){
          
            Accountboolean =true;
            for(Packet__c packet1 :[select id,name ,Account__c,LastModifiedDate,Charter_Departure_Date__c,Createddate,(select id,Calculated_Cost__c,Charter_Contract_Id__c,Custom_Product__c,F__c,IT_Code__c,Item_Num__c	,Location_Markup__c,M__c	,Menu_Section__c,Nosh_Bags__c	,Nosh_Bags_Child__c	,Notes__c	,Packet__c	,Product__c,Product_Name__c	,Product_Unit_Price__c	,Total_Cost__c	,Total_Quantity__c	,Use_Location_Markup__c	,Y__c	from Packet_Line_Items__r) from Packet__c where Account__c =:packet.Account__c AND  Id !=:packet.Id ORDER BY Charter_Departure_Date__c DESC limit 1]){
              
                if(packet.Account__c == packet1.Account__c ) {
                    Accountboolean =false;
                    system.debug('=packet1=='+packet1.Packet_Line_Items__r.size());
                    for(Packet_Line_Item__c packetitems :packet1.Packet_Line_Items__r){
                      
                        Packet_Line_Item__c newpacketlineitem = new Packet_Line_Item__c();
                        newpacketlineitem.IT_Code__c =packetitems.IT_Code__c;
                        newpacketlineitem.Packet__c = packet.id;
                        newpacketlineitem.Custom_Product__c =packetitems.Custom_Product__c;
                        newpacketlineitem.F__c=	packetitems.F__c;
                        newpacketlineitem.Location_Markup__c	= packetitems.Location_Markup__c;
                        newpacketlineitem.M__c = packetitems.M__c;
                        newpacketlineitem.Menu_Section__c= packetitems.Menu_Section__c;
                        newpacketlineitem.Nosh_Bags__c	= packetitems.Nosh_Bags__c	;
                        newpacketlineitem.Nosh_Bags_Child__c  = packetitems.Nosh_Bags_Child__c;
                        newpacketlineitem.Notes__c  = packetitems.Notes__c;
                        newpacketlineitem.Product__c  = packetitems.Product__c;
                        newpacketlineitem.Product_Name__c  = packetitems.Product_Name__c;
                        newpacketlineitem.Product_Unit_Price__c  = packetitems.Product_Unit_Price__c;
                        newpacketlineitem.Total_Cost__c	  = packetitems.Total_Cost__c	;
                        newpacketlineitem.Use_Location_Markup__c	  = packetitems.Use_Location_Markup__c	;
                        newpacketlineitem.Y__c	  = packetitems.Y__c;
                        insertpacketlineitems.add(newpacketlineitem);
                    }
                }  
            }     
        }
        if(insertpacketlineitems.size()>0){
            insert insertpacketlineitems;
        } 
        
    }
    
}