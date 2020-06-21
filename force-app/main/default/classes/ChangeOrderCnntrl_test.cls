@iStest
public class ChangeOrderCnntrl_test {
    public static testMethod void ChangeOrderCnntrl_test() {
        Test.startTest();
        //  Packet_Change_Order__c changeorder = Utility_cntrl.Packet_Change_Order_Insert(null);
        Packet_Change_Order__c	 Packet_Change_Order  = new Packet_Change_Order__c	();
        
        
        Packet_Change_Order.User_Profile__c ='Caterer';
        Change_Order_Cntrl.getDependentMap(JSON.serialize(Packet_Change_Order),'User_Profile__c','Reason__c');
        Account Acc = Utility_cntrl.Account_Insert('testAccount');
        
        Charter_Contract__c charter = Utility_cntrl.chartercontract_Insert(Acc.Id);
        Aircraft__c Aircraft =  Utility_cntrl.Aircraft_Insert('Te','tes',2,2);
        Packet__c packet =   Utility_cntrl.Packet_Insert(Acc.Id,charter.Id,Aircraft.Id);
        Change_Order_Cntrl.save_changeorder(Packet_Change_Order, packet.Id, 'packetlineitems','Noshbaglist');
        Utility_cntrl.Product_Insert('searchString');
        product2 product =   Utility_cntrl.Product_Insert('test Product');
        list< string> productlist = new list<string>();
        productlist.add(product.id);
        LookupSObjectController_Cntrl.lookup('searchString', 'Product2', 'name', 'Pre-Departure',productlist,productlist,'ParentRecord' );
        //  LookupSObjectController_Cntrl.getRecentRecords( 'Product2', 'test Product', 'searchFieldValue',null,null );
        LookupSObjectController_Cntrl.getRecentRecords( 'Product2', 'name', 'Pre-Departure',productlist,productlist,'ParentRecord' );
           LookupSObjectController_Cntrl.lookup('searchString', 'Product2', 'name', 'Pre-Departure',productlist,productlist,'Null' );
        //  LookupSObjectController_Cntrl.getRecentRecords( 'Product2', 'test Product', 'searchFieldValue',null,null );
        LookupSObjectController_Cntrl.getRecentRecords( 'Product2', 'name', 'Pre-Departure',productlist,productlist,'Null' );
        
        Test.stopTest();
    }
}