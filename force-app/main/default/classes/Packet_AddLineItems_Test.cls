@istest
public class Packet_AddLineItems_Test {
    public static testMethod void Packet_AddLineItems_Test() {
        Test.startTest();
        Packet_Change_Order__c changeorder = Utility_cntrl.Packet_Change_Order_Insert(null);
        Change_Order_Cntrl.getDependentMap(JSON.serialize(changeorder),'User_Profile__c	','Reason__c');
        Account Acc = Utility_cntrl.Account_Insert('testAccount');
        product2 product =   Utility_cntrl.Product_Insert('test Product');
        Charter_Contract__c charter = Utility_cntrl.chartercontract_Insert(Acc.Id);
        Aircraft__c Aircraft =  Utility_cntrl.Aircraft_Insert('Testdat','tes',2,2);
        
        Packet__c packet =   Utility_cntrl.Packet_Insert(Acc.Id,charter.Id,Aircraft.Id);
         Packet__c packet11 =   Utility_cntrl.Packet_Insert(Acc.Id,charter.Id,Aircraft.Id);
        list<Packet_Line_Item__c> packetlineitemlist = new list<Packet_Line_Item__c>();
        Packet_Line_Item__c packetlineitem = new Packet_Line_Item__c();
        packetlineitem.Product__c =product.Id;
        packetlineitem.Packet__c =packet.Id;
        packetlineitemlist.add(packetlineitem);
        
          Packet_Line_Item__c packetlineitem1 = new Packet_Line_Item__c();
         packetlineitem1.Product__c =product.Id;
        packetlineitem1.Packet__c =packet.Id;
        packetlineitem1.Menu_Section__c ='Nosh Bag';
         packetlineitem1.Nosh_Bags_Child__c =false;
        packetlineitem1.Product_Name__c ='Nosh Bags data';
        insert packetlineitem1;
        
          Packet_Line_Item__c packetlineitem111 = new Packet_Line_Item__c();
         packetlineitem111.Product__c =product.Id;
        packetlineitem111.Packet__c =packet11.Id;
        packetlineitem111.Menu_Section__c ='Nosh Bag';
         packetlineitem111.Nosh_Bags_Child__c =false;
        packetlineitem111.Product_Name__c ='Nosh Bags data';
        insert packetlineitem111;
        
         Packet_Line_Item__c packetlineitem11 = new Packet_Line_Item__c();
         packetlineitem11.Product__c =product.Id;
        packetlineitem11.Packet__c =packet.Id;
        packetlineitem11.Menu_Section__c ='Nosh Bag';
         packetlineitem11.Nosh_Bags_Child__c =true;
        packetlineitem11.Nosh_Bags__c ='Nosh Bags data';
        insert packetlineitem11;
        
        Account_Product__c AccountProduct = new Account_Product__c();
        AccountProduct.Account__c = Acc.Id;
        AccountProduct.Product__c=product.Id;
        insert AccountProduct;
        
       Packet_AddLineItems_cntrl1.wrapperclass  wrap =   Packet_AddLineItems_cntrl1.get_childrecords(packet.Id);
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,null,null);
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitem),Json.serialize(wrap.Packetwrapperclasslist));
        insert packetlineitem;
        packetlineitemlist.add(packetlineitem);
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        Packet__c packet1 = Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        system.debug('==='+packet1); 
        Packet_Sendmails_Cntrl.sendmailtoCharterPlanner(null);
          Packet_Sendmails_Cntrl.sendmailtoCharterPlanner1(null);
          Packet_Sendmails_Cntrl.sendmailtoCharterPlanner2(null);
         Packet_Sendmails_Cntrl.sendmailtoCharterPlanner(packet1.Id);
          Packet_Sendmails_Cntrl.sendmailtoCharterPlanner1(packet1.Id);
          Packet_Sendmails_Cntrl.sendmailtoCharterPlanner2(packet1.Id);
        
        Packet_AddLineItems_cntrl1.DeletePacketLineItem(null);
        Packet_AddLineItems_cntrl1.DeletePacketLineItem(packetlineitem.Id);
           Packet_AddLineItems_cntrl1.DeletePacketLineItem(packetlineitem1.Id);
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,null,null);
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,null,null);
        
        Packet__c packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packet1.Id,'Test data','Approve');
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Approve');
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Approve');
        
        Packet_AddLineItems_cntrl1.Packet_Completed(packet.Id);
        Packet_AddLineItems_cntrl1.emailPacketPDF(packet.Id, 'comments', 'test@gmail.com');
        list<string> strlist = new list<string>();
        strlist.add('test data');
        strlist.add('test data1');
        Packet_AddLineItems_cntrl1.Adminchangeorder(packet.Id,'Test','Approve','test',strlist);
        Test.stopTest(); 
        
    }
    public static testMethod void Packet_AddLineItems_Test1() {
        Test.startTest();
        Packet_Change_Order__c changeorder = Utility_cntrl.Packet_Change_Order_Insert(null);
        Change_Order_Cntrl.getDependentMap(JSON.serialize(changeorder),'User_Profile__c	','Reason__c');
        Account Acc = Utility_cntrl.Account_Insert('testAccount');
        product2 product =   Utility_cntrl.Product_Insert('test Product');
        Charter_Contract__c charter = Utility_cntrl.chartercontract_Insert(Acc.Id);
        Aircraft__c Aircraft =  Utility_cntrl.Aircraft_Insert('Testdat','tes',2,2);
        
        Packet__c packet =   Utility_cntrl.Packet_Insert(Acc.Id,charter.Id,Aircraft.Id);
        list<Packet_Line_Item__c> packetlineitemlist = new list<Packet_Line_Item__c>();
        Packet_Line_Item__c packetlineitem = new Packet_Line_Item__c();
        packetlineitem.Product__c =product.Id;
        packetlineitem.Packet__c =packet.Id;
        packetlineitemlist.add(packetlineitem);
           Packet_Line_Item__c packetlineitem1 = new Packet_Line_Item__c();
         packetlineitem1.Product__c =product.Id;
        packetlineitem1.Packet__c =packet.Id;
        packetlineitem1.Menu_Section__c ='Nosh Bag';
         packetlineitem1.Nosh_Bags_Child__c =false;
        packetlineitem1.Product_Name__c ='Nosh Bags data';
        insert packetlineitem1;
        
         Packet_Line_Item__c packetlineitem11 = new Packet_Line_Item__c();
         packetlineitem11.Product__c =product.Id;
        packetlineitem11.Packet__c =packet.Id;
        packetlineitem11.Menu_Section__c ='Nosh Bag';
         packetlineitem11.Nosh_Bags_Child__c =true;
        packetlineitem11.Nosh_Bags__c ='Nosh Bags data';
        insert packetlineitem11;
        Account_Product__c AccountProduct = new Account_Product__c();
        AccountProduct.Account__c = Acc.Id;
        AccountProduct.Product__c=product.Id;
        insert AccountProduct;
        
     Packet_AddLineItems_cntrl1.wrapperclass  wrap =     Packet_AddLineItems_cntrl1.get_childrecords(packet.Id);
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,null,null);
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitem),Json.serialize(wrap.Packetwrapperclasslist));
        insert packetlineitem;
        packetlineitemlist.add(packetlineitem);
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        Packet__c packet1 = Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        system.debug('==='+packet1);
        
        Packet__c packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packet1.Id,'Test data','Approve');
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Reject');
        
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Approve');
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Reject');
        
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Approve');
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Reject');
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Approve');
        packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Reject');
        
        //   packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Reject');
        //   packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packetrecord.Id,'Test data','Reject');
        
        
        Test.stopTest(); 
        
    }
    
    public static testMethod void test_approvedPacketBudget_delete() {
        Test.startTest();
        Packet_Change_Order__c changeorder = Utility_cntrl.Packet_Change_Order_Insert(null);
        Change_Order_Cntrl.getDependentMap(JSON.serialize(changeorder),'User_Profile__c	','Reason__c');
        Account Acc = Utility_cntrl.Account_Insert('testAccount');
        product2 product =   Utility_cntrl.Product_Insert('test Product');
        Charter_Contract__c charter = Utility_cntrl.chartercontract_Insert(Acc.Id);
        Aircraft__c Aircraft =  Utility_cntrl.Aircraft_Insert('Testdat','tes',2,2);
        
        Packet__c packet =   Utility_cntrl.Packet_Insert(Acc.Id,charter.Id,Aircraft.Id);
        list<Packet_Line_Item__c> packetlineitemlist = new list<Packet_Line_Item__c>();
        Packet_Line_Item__c packetlineitem = new Packet_Line_Item__c();
        packetlineitem.Product__c =product.Id;
        packetlineitem.Packet__c =packet.Id;
        packetlineitemlist.add(packetlineitem);
        Account_Product__c AccountProduct = new Account_Product__c();
        AccountProduct.Account__c = Acc.Id;
        AccountProduct.Product__c=product.Id;
        insert AccountProduct;
           list<Packet_AddLineItems_cntrl1.Packetwrapperclass> Packetwrapperclasslist = new list<Packet_AddLineItems_cntrl1.Packetwrapperclass>();
        
     Packet_AddLineItems_cntrl1.wrapperclass  wrap = Packet_AddLineItems_cntrl1.get_childrecords(packet.Id);
       
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,null,null);
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitem),Json.serialize(wrap.Packetwrapperclasslist));
        insert packetlineitem;
        packetlineitemlist.add(packetlineitem);
        Packet_AddLineItems_cntrl1.PacketLineItemsave(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        Packet__c packet1 = Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,JSON.serialize(packetlineitemlist),Json.serialize(wrap.Packetwrapperclasslist));
        system.debug('==='+packet1); 
        
        Packet_AddLineItems_cntrl1.DeletePacketLineItem(null);
        Packet_AddLineItems_cntrl1.DeletePacketLineItem(packetlineitem.Id);
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,null,null);
        Packet_AddLineItems_cntrl1.submitforApproval(packet.Id,null,null);
        
        Packet__c packetrecord =    Packet_AddLineItems_cntrl1.submitforApprovalandreject_recall(packet1.Id,'Test data','Approve');
        
        List<Packet__c> packets = [
            SELECT Id, Status__c, Packet_Status__c, Count_Towards_Contract_Usage__c
            FROM Packet__c
            WHERE Id = :packetrecord.Id
        ];
        
        System.debug(packets[0].Status__c);
        System.debug(packets[0].Count_Towards_Contract_Usage__c);
        
        delete packetrecord;
        
        Test.stopTest(); 
        
    }
    
}