public class Utility_cntrl {
    
    Public static Account Account_Insert( string Accountname){
        Account Acc = new Account();
        Acc.name = Accountname;
        Insert Acc;
        return Acc;
    }
    
     
   
    Public static Product2 Product_Insert( String Productname ){
        Product2 Product = new Product2();
        Product.name = Productname;
        Product.Menu_Sections__c	='Pre-Departure';
        Product.IsActive =true;
        insert product;
        return Product;
    }
    Public static Charter_Contract__c	 chartercontract_Insert(Id AccountId){
        Charter_Contract__c	 chartercontract = new Charter_Contract__c	();
        chartercontract.Account__c =AccountId;
        insert chartercontract;
        return chartercontract;
    }
    
    Public static Aircraft__c		 Aircraft_Insert(string Aircraftname,string	AircraftDesignator, integer PilotCount,integer FA_RA_Count	){
        Aircraft__c		 Aircraft = new Aircraft__c		();
        Aircraft.name = Aircraftname;
        Aircraft.Aircraft_Designator__c =AircraftDesignator;
        Aircraft.Pilot_Count__c = PilotCount;
        Aircraft.FA_RA_Count__c =FA_RA_Count;
        insert Aircraft; 
        return Aircraft;
    }
    
    public static Packet_Flight__c Packet_Flight_Insert(){
        Packet_Flight__c Packet_Flight  = new Packet_Flight__c();
        return Packet_Flight;
    }
     public static Packet_Change_Order__c	 Packet_Change_Order_Insert(Id packetId){
        Packet_Change_Order__c	 Packet_Change_Order  = new Packet_Change_Order__c	();
         if(packetId != null)
         Packet_Change_Order.Packet__c = packetId;
         Packet_Change_Order.User_Profile__c ='System Administrator	';
        return Packet_Change_Order	;
    }
     public static Packet__c	 Packet_Insert(Id AccountId,Id chartercontractId,Id AircraftId){
        Packet__c	 Packet  = new Packet__c	();
         packet.Account__c = AccountId;
         packet.Charter_Contract__c = chartercontractId;
         packet.Charter_Aircraft__c =AircraftId;
        packet.United_Catering_User__c	= userinfo.getuserId();
         packet.Caterer_User__c	= userinfo.getuserId();
		 Packet.Charter_Departure_Date__c = Date.today();
         insert packet;
        return Packet	;
    }
    
     public static Packet_Line_Item__c	 PacketLineItem_Insert(Id packetId,Id ProductId){
        Packet_Line_Item__c	 PacketLineItem  = new Packet_Line_Item__c	();
         PacketLineItem.Packet__c = packetId;
         PacketLineItem.Product__c = ProductId;
        return PacketLineItem	;
    }
    
    
}