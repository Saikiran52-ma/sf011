public without sharing class Packet_AddLineItems_cntrl1 {
    @AuraEnabled
    public static wrapperclass get_childrecords(string packetId){
        
        // 20191120 rwern: Added some fields for PDFs
        Packet__c packet = [
            select id,name,Account__c,status__c,Num_of_Recalls__c,Allow_Special_Requests__c,Charter_Aircraft__c,Num_of_Submissions__c,Num_of_Admin_Approvals__c, Num_of_Caterer_Approvals__c,Has_F_Cabin__c,Has_M_Cabin__c,Has_Y_Cabin__c, 
            Num_of_Attached_PDFs__c, Latest_Attached_PDF_Id__c, Portal_Download_URL__c,Days_Out_Packet_Locked__c
            from Packet__c 
            where Id = :packetId
        ];
        
        Account Accrecord = [select Id,name,Location__c ,Location_Markup__c,Allow_Long_Text_Special_Requests__c  from Account where Id =:packet.Account__c];
        list<Packet_Line_Item__c> listpacketlineitems=[select id,name,Product__c,Product__r.name,Packet__c,IT_Code__c,F__c,M__c,Y__c,Menu_Section__c,Notes__c,Custom_Product__c from Packet_Line_Item__c where Packet__c =: packet.Id order by CreatedDate ASC];
        list<Account_Product__c> listAccproducts = [select id,name,Account__c,Product__c    from Account_Product__c where Account__c =:packet.Account__c];
        set<Id>AcctproductIds = new set<Id>();
        for(Account_Product__c Accproduct : listAccproducts){
            Packet_Line_Item__c packet_line_Item = new Packet_Line_Item__c();
            packet_line_Item.Product__c = Accproduct.Product__c;
            AcctproductIds.add(Accproduct.Product__c);
        }
        
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        list<Packetwrapperclass> Packetwrapperclasslist = new list<Packetwrapperclass>();
        list<Packet_Line_Item__c> listpacketlineitems1=[select id,name,Product__c,Product__r.name,Packet__c,IT_Code__c,F__c,M__c,Y__c,Menu_Section__c,Notes__c,Custom_Product__c,Product_Name__c from Packet_Line_Item__c where Packet__c =: packet.Id And Menu_Section__c =:'Nosh Bag' And Nosh_Bags_Child__c =false];
        list<Packet_Line_Item__c> listpacketlineitems2=[select id,name,Product__c,Product__r.name,Packet__c,IT_Code__c,F__c,M__c,Y__c,Menu_Section__c,Notes__c,Custom_Product__c,Nosh_Bags_Child__c,Product_Name__c,Nosh_Bags__c from Packet_Line_Item__c where Packet__c =: packet.Id And Menu_Section__c =:'Nosh Bag' And Nosh_Bags_Child__c =true];
        list<Packet_Line_Item__c> packetlist = new list<Packet_Line_Item__c>();
        Packet_Line_Item__c newpacket = new Packet_Line_Item__c();
        if(listpacketlineitems1 .size()>0){
            for(Packet_Line_Item__c PacketItem : listpacketlineitems1){
                packetlist = new list<Packet_Line_Item__c>();
                
                for(Packet_Line_Item__c PacketItem1 : listpacketlineitems2){
                    
                    if(PacketItem.Product_Name__c ==PacketItem1.Nosh_Bags__c){
                        packetlist.add(PacketItem1);
                    }
                    
                }
                if(packetlist.size() == 0){
                    packetlist.add(newpacket);  
                }
                
                
                Packetwrapperclasslist.add(new Packetwrapperclass(PacketItem,packetlist));
            }
        }
        wrapperclass wrap = new wrapperclass(Accrecord,packet,listpacketlineitems,AcctproductIds,profileName,Packetwrapperclasslist);
        
        return wrap; 
    }
    public class wrapperclass{
        @AuraEnabled public  Account Accrecord{get;set;}
        @AuraEnabled public   Packet__c packet {get;set;}
        @auraenabled public set<Id>AcctproductIds{get;set;}
        @AuraEnabled public list<Packet_Line_Item__c> listpacketlineitems{get;set;}
        @AuraEnabled public  String profileName{get;set;}
        @AuraEnabled  public list<Packetwrapperclass> Packetwrapperclasslist {get;set;}
        public wrapperclass(  Account Accrecord, Packet__c packet ,list<Packet_Line_Item__c> listpacketlineitems,set<Id>AcctproductIds, String profileName,list<Packetwrapperclass> Packetwrapperclasslist){
            this.Accrecord =Accrecord;
            this.packet =packet;
            this.listpacketlineitems =listpacketlineitems;
            this.AcctproductIds =AcctproductIds;
            this.profileName =profileName;
            this.Packetwrapperclasslist = Packetwrapperclasslist;
        }
        
    }
    @AuraEnabled
    public static string PacketLineItemsave(string packetId,string packetlineitems,string NoshBagpacketlineitems){
        string error;
        
        try{
            list<Packetwrapperclass> NoshBagpacketlineitem  = ( list<Packetwrapperclass> )JSON.deserialize(NoshBagpacketlineitems,  list<Packetwrapperclass> .class);
            system.debug('==1=='+NoshBagpacketlineitem);
            
            //    system.debug('==2=='+NoshBagpacketlineitem[0].mainpacket);
            list<Packet_Line_Item__c> packetlineitemList  = ( list<Packet_Line_Item__c> )JSON.deserialize(packetlineitems,  list<Packet_Line_Item__c> .class);
            
            list<Packet_Line_Item__c> Insert_packetlineitems = new list<Packet_Line_Item__c>();
            list<Packet_Line_Item__c> Update_packetlineitems = new list<Packet_Line_Item__c>();
            Packet__c packet = [select id,name,Account__c,status__c from Packet__c where Id=:packetId];
            //  packet.Status__c = 'Customer Review';
            //  update packet;
            
            for(Packet_Line_Item__c PacketItems :packetlineitemList){
                if(PacketItems .Id == null ){
                    system.debug('===='+PacketItems.Product__c +'---'+ PacketItems.Custom_Product__c);
                    system.debug('==='+((PacketItems.Product__c !=null || PacketItems.Product__c !='' )|| ( PacketItems.Custom_Product__c != null )));
                    if((PacketItems.Product__c !=null  )|| ( String.isNotBlank(PacketItems.Custom_Product__c ) || String.isNotEmpty(PacketItems.Custom_Product__c )  )){
                        
                        PacketItems.Packet__c = packetId;
                        if(PacketItems.F__c == null){
                            PacketItems.F__c =0;
                        }
                        if(PacketItems.M__c == null){
                            PacketItems.M__c =0;
                        }
                        if(PacketItems.Y__c == null){
                            PacketItems.Y__c =0;
                        }
                        Insert_packetlineitems.add(PacketItems);
                        
                    }
                }
                else{
                    if(PacketItems.F__c == null){
                        PacketItems.F__c =0;
                    }
                    if(PacketItems.M__c == null){
                        PacketItems.M__c =0;
                    }
                    if(PacketItems.Y__c == null){
                        PacketItems.Y__c =0;
                    }
                    Update_packetlineitems.add(PacketItems);
                    
                }
            }
            for(Packetwrapperclass wc : NoshBagpacketlineitem){
                if(wc.mainpacket.Product__c !=null){
                    if(wc.mainpacket.Id == null){
                        if(wc.mainpacket.Product__c !=null  ){
                            wc.mainpacket.Packet__c = packetId;
                            if(wc.mainpacket.F__c == null){
                                wc.mainpacket.F__c =0;
                            }
                            if(wc.mainpacket.M__c == null){
                                wc.mainpacket.M__c =0;
                            }
                            if(wc.mainpacket.Y__c == null){
                                wc.mainpacket.Y__c =0;
                            }
                            Insert_packetlineitems.add(wc.mainpacket); 
                        }
                    }else{
                        if(wc.mainpacket.F__c == null){
                            wc.mainpacket.F__c =0;
                        }
                        if(wc.mainpacket.M__c == null){
                            wc.mainpacket.M__c =0;
                        }
                        if(wc.mainpacket.Y__c == null){
                            wc.mainpacket.Y__c =0;
                        }
                        Update_packetlineitems.add(wc.mainpacket);
                    }
                    
                    for(Packet_Line_Item__c le : wc.Childpacketlist){
                        if(le.Product__c != null){
                            if(le.Id == null){
                                if(le.Product__c !=null  ){
                                    le.Packet__c = packetId;
                                    le.Nosh_Bags__c = wc.mainpacket.Product_Name__c;
                                    le.Nosh_Bags_Child__c = true;	
                                    if(le.F__c == null){
                                        le.F__c =0;
                                    }
                                    if(le.M__c == null){
                                        le.M__c =0;
                                    }
                                    if(le.Y__c == null){
                                        le.Y__c =0;
                                    }
                                    Insert_packetlineitems.add(le);  
                                }
                            }else{
                                if(le.F__c == null){
                                    le.F__c =0;
                                }
                                if(le.M__c == null){
                                    le.M__c =0;
                                }
                                if(le.Y__c == null){
                                    le.Y__c =0;
                                }
                                Update_packetlineitems.add(le);  
                            }
                        }
                    }
                    
                }
            }
            if(Insert_packetlineitems.size() > 0)
                Insert Insert_packetlineitems;
            if(Update_packetlineitems.size() > 0)
                update Update_packetlineitems;
        }
        
        catch(DmlException ex) {
            error =ex.getDmlMessage(0);
            return error;
        }
        
        catch(Exception Ex){
            system.debug('===='+Ex.getMessage());
            error =Ex.getMessage();
        }
        return error;
    }
    @AuraEnabled
    public static string DeletePacketLineItem( string lineitemId){
        string str;
        try{
            string noshbags;
            Packet_Line_Item__c  Packet_Line_Item  =[select id,name,Product__c,Product__r.name,Menu_Section__c,Nosh_Bags_Child__c,Nosh_Bags__c,packet__c	 from Packet_Line_Item__c  where Id=:lineitemId];
            if(Packet_Line_Item.Menu_Section__c !='Nosh Bag'){
                delete Packet_Line_Item;
            }else{
                noshbags =Packet_Line_Item.Nosh_Bags__c;
                id packetId=Packet_Line_Item.packet__c;
                system.debug('==='+Packet_Line_Item.Product__r.name);
                list<Packet_Line_Item__c> Packet_Line_Items = [select id,name,Menu_Section__c,Nosh_Bags_Child__c,Nosh_Bags__c,packet__c from Packet_Line_Item__c  where Nosh_Bags__c =:Packet_Line_Item.Product__r.name And Nosh_Bags_Child__c =true];
                list<Packet_Line_Item__c> Packet_Line_Items1 =new list<Packet_Line_Item__c> ();
                for(Packet_Line_Item__c packetitem:Packet_Line_Items){
                    if(packetitem.Packet__c ==packetId){
                        Packet_Line_Items1.add(packetitem);
                    }
                }
                
                if(Packet_Line_Items1.size()>0){
                    delete Packet_Line_Items1;
                }
                system.debug('==='+Packet_Line_Items.size());
                delete Packet_Line_Item;
            }
            str ='successfully';
        }
        catch(Exception Ex){
            
        }
        return str;
        
    }
    @AuraEnabled
    public static Packet__c submitforApproval(string packetId,string packetlineitems,string NoshBagpacketlineitems){
        try{
            list<Packetwrapperclass> NoshBagpacketlineitem  = ( list<Packetwrapperclass> )JSON.deserialize(NoshBagpacketlineitems,  list<Packetwrapperclass> .class);
            system.debug('==1=='+NoshBagpacketlineitem);
            Packet__c packet = [select id,name,Account__c,status__c,CreatedById,United_Catering_User__c from Packet__c where Id=:packetId];
            
            if(packetlineitems !=null){
                
                list<Packet_Line_Item__c> packetlineitemList  = ( list<Packet_Line_Item__c> )JSON.deserialize(packetlineitems,  list<Packet_Line_Item__c> .class);
                
                list<Packet_Line_Item__c> Insert_packetlineitems = new list<Packet_Line_Item__c>();
                list<Packet_Line_Item__c> Update_packetlineitems = new list<Packet_Line_Item__c>();
                //  packet.Status__c = 'Customer Review';
                //  update packet;
                
                for(Packet_Line_Item__c PacketItems :packetlineitemList){
                    if(PacketItems .Id == null ){
                        system.debug('===='+PacketItems.Product__c);
                        if((PacketItems.Product__c !=null  ) ||  (String.isNotBlank(PacketItems.Custom_Product__c ) || String.isNotEmpty(PacketItems.Custom_Product__c ) )){
                            
                            PacketItems.Packet__c = packetId;
                            if(PacketItems.F__c == null){
                                PacketItems.F__c =0;
                            }
                            if(PacketItems.M__c == null){
                                PacketItems.M__c =0;
                            }
                            if(PacketItems.Y__c == null){
                                PacketItems.Y__c =0;
                            }
                            Insert_packetlineitems.add(PacketItems);
                        }
                    }
                    else{
                        if(PacketItems.F__c == null){
                            PacketItems.F__c =0;
                        }
                        if(PacketItems.M__c == null){
                            PacketItems.M__c =0;
                        }
                        if(PacketItems.Y__c == null){
                            PacketItems.Y__c =0;
                        }
                        Update_packetlineitems.add(PacketItems);
                        
                    }
                }
                for(Packetwrapperclass wc : NoshBagpacketlineitem){
                    if(wc.mainpacket.Product__c !=null){
                        if(wc.mainpacket.Id == null){
                            wc.mainpacket.Packet__c = packetId;
                            if(wc.mainpacket.F__c == null){
                                wc.mainpacket.F__c =0;
                            }
                            if(wc.mainpacket.M__c == null){
                                wc.mainpacket.M__c =0;
                            }
                            if(wc.mainpacket.Y__c == null){
                                wc.mainpacket.Y__c =0;
                            }
                            Insert_packetlineitems.add(wc.mainpacket);  
                        }else{
                            if(wc.mainpacket.F__c == null){
                                wc.mainpacket.F__c =0;
                            }
                            if(wc.mainpacket.M__c == null){
                                wc.mainpacket.M__c =0;
                            }
                            if(wc.mainpacket.Y__c == null){
                                wc.mainpacket.Y__c =0;
                            }
                            Update_packetlineitems.add(wc.mainpacket);  
                        }
                        system.debug('----------wc----------'+wc.mainpacket);
                        for(Packet_Line_Item__c le : wc.Childpacketlist){
                            system.debug('==22=='+le);
                            if(le.Product__c != null){
                                if(le.Id == null){
                                    le.Packet__c = packetId;
                                    le.Nosh_Bags__c = wc.mainpacket.Product_Name__c;
                                    le.Nosh_Bags_Child__c = true;	
                                    if(le.F__c == null){
                                        le.F__c =0;
                                    }
                                    if(le.M__c == null){
                                        le.M__c =0;
                                    }
                                    if(le.Y__c == null){
                                        le.Y__c =0;
                                    }
                                    Insert_packetlineitems.add(le);  
                                }else{
                                    if(le.F__c == null){
                                        le.F__c =0;
                                    }
                                    if(le.M__c == null){
                                        le.M__c =0;
                                    }
                                    if(le.Y__c == null){
                                        le.Y__c =0;
                                    }
                                    Update_packetlineitems.add(le);  
                                }
                            }
                        }
                    }
                    
                    
                }
                if(Insert_packetlineitems.size() > 0)
                    Insert Insert_packetlineitems;
                if(Update_packetlineitems.size() > 0)
                    update Update_packetlineitems;
                
            }
            
            if((packet.Status__c == 'Customer Review')){
                Approval.ProcessSubmitRequest req1 =  new Approval.ProcessSubmitRequest();
                req1.setComments('Submitted request for approval.');
                req1.setObjectId(packet.id);
                req1.setNextApproverIds(new Id[] {packet.United_Catering_User__c});
                req1.setProcessDefinitionNameOrId('Standard_Packet_Approval_Process');
                Approval.ProcessResult result = Approval.process(req1);
            }
        }
        catch(Exception EX){
            system.debug('====test dada'+EX.getMessage());
        }
        Packet__c packet1 = [select id,name,Account__c,status__c,CreatedById from Packet__c where Id=:packetId];
        
        
        return packet1;
    }
    
    
    
    @AuraEnabled
    public static Packet__c submitforApprovalandreject_recall(string packetId,string message,string setAction){
        try{
            system.debug('===test data==='+packetId);
            system.debug('===test data==='+message);
            system.debug('===test data==='+setAction);
            boolean rejectbool =false;
            
            Packet__c[] packetlist = [SELECT Id,status__c from Packet__c WHERE Id=:packetId];
            ID ObjectId=packetId;
            ProcessInstanceWorkitem[] piWorkItems = [SELECT Id, OriginalActorId FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :packetId
                                                     AND ProcessInstance.Status = 'Pending'];
            
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(message);
            
            req.setAction(setAction);       // steps to recall the approval process
            
            req.setWorkitemId(piWorkItems[0].Id);
            
            Approval.ProcessResult result2 =  Approval.process(req);
            
            
            // Unlock the NST
            //  Approval.UnlockResult[] urList = Approval.unlock(packetlist, false);
            list<Packet__c> updatepacket= new list<Packet__c>();
            for(Packet__c packet : packetlist )
            {
                if(setAction =='Approve'){
                    if(packet.Status__c =='Admin Review'){
                        packet.status__c='Caterer Review';
                    }
                    else if(packet.Status__c =='Caterer Review'){
                        packet.status__c=' Approved';
                    }
                    else if(packet.Status__c =='Approved'){
                        packet.status__c='Completed'; 
                    }
                    updatepacket.add(packet);  
                }else  if(setAction =='Reject'){
                    if(packet.Status__c =='Admin Review'){
                        packet.status__c='Customer Review';  
                    }
                    else if(packet.Status__c =='Caterer Review'){
                        packet.status__c='Admin Review'; 
                    }
                    else if(packet.Status__c =='Approved'){
                        rejectbool =true;
                        packet.status__c='Admin Review'; 
                    }
                    updatepacket.add(packet);     
                }
                else{
                    packet.status__c='Customer Review';
                    updatepacket.add(packet);
                }
                
            }
            system.debug('===rejectbool='+rejectbool);
            if(rejectbool == true){
                system.debug('===rejectbool='+rejectbool);
                packetlist = [SELECT Id,status__c from Packet__c WHERE Id=:packetId];
                ProcessInstanceWorkitem[] piWorkItems1 = [SELECT Id, OriginalActorId FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :packetId
                                                          AND ProcessInstance.Status = 'Pending'];
                
                Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
                req1.setComments(message);
                
                req1.setAction(setAction);       // steps to recall the approval process
                
                req1.setWorkitemId(piWorkItems1[0].Id);
                
                Approval.ProcessResult result21 =  Approval.process(req1);   
            }
            
            //  if(updatepacket.size()>0){
            //     update  updatepacket;
            //   }
            Packet__c packet = [SELECT Id,status__c from Packet__c WHERE Id=:packetId];
            return packet; 
        }
        catch(Exception Ex){
            system.debug('===getMessage=='+Ex.getMessage());
            return null;
        }
    }
    
    
    
    @AuraEnabled
    public static Packet__c Packet_Completed(string packetId){
        Packet__c packet = [SELECT Id,status__c from Packet__c WHERE Id=:packetId];
        packet.status__c ='Completed';
        update packet;
        return packet;
        
        
    }
    
    // 20191120 rwern: send packet PDF email
    @AuraEnabled
    public static void emailPacketPDF(String packetId, String comments, String toAddressString) {
        PacketController.sendPDFEmail(packetId, comments, toAddressString);
    }
    
    @AuraEnabled
    public static string Adminchangeorder(string packetId,string message,string setAction,string comments,list<string> reasons) {
        string text = '';
        for (integer i = 0; i < reasons.size(); i++) {
            if (i == 0) {
                text = reasons[i];
            }
            else {
                text = text + ';' + reasons[i];
            }
        }
        
        Packet_Change_Order__c objDetail = new Packet_Change_Order__c();
        objDetail.User_Profile__c ='System Administrator';
        objDetail.Reason__c =text;
        objDetail.Comments__c =comments;
        //   Packet_Change_Order__c objDetail1  = ( Packet_Change_Order__c )JSON.deserialize(objDetail,  Packet_Change_Order__c .class);
        
        //PacketController.sendPDFEmail(packetId, comments, toAddressString);
        string str = Change_Order_Cntrl.save_changeorder(objDetail,packetId,null,null);
        return str;
    }
    public class Packetwrapperclass{
        @AuraEnabled public Packet_Line_Item__c mainpacket{get;set;}
        @AuraEnabled public list<Packet_Line_Item__c> Childpacketlist{get;set;}
        public Packetwrapperclass( Packet_Line_Item__c mainpacket,list<Packet_Line_Item__c> Childpacketlist){
            this.mainpacket = mainpacket;
            this.Childpacketlist =Childpacketlist;
            
        }
        
    }
    
    
}