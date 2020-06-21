trigger PacketTrigger on Packet__c (after insert, before update, after update, after delete,before insert) {
    
    
   
	if (Trigger.isBefore) {
		if (Trigger.isUpdate) {

			// If the packet's approval is 'Completed' make sure to timestamp who completed it and when
			PacketApprovalHandler.approvalCompleted(Trigger.old, Trigger.new);

		}
	} else if (Trigger.isAfter) {
		if (Trigger.isInsert) {

			// Open packet sharing to all users on the customer account
			PacketSharingHandler.openCustomerSharing(null, Trigger.new);
   
		} else if (Trigger.isUpdate) {

			// Open packet sharing to all users on the customer account
			PacketSharingHandler.openCustomerSharing(Trigger.old, Trigger.new);

			// Update contract budget on cancellation, etc
			ContractHandler.updateContractUsage(Trigger.old, Trigger.new);

			// If the packet has been approved (but not completed) by the caterer create the packet pdf
			PacketApprovalHandler.approvalAttachPdf(Trigger.old, Trigger.new);
           

		} else if (Trigger.isDelete) {

			// Update contract budget on cancellation, etc
			ContractHandler.updateContractUsage(Trigger.old, null);

		}
        }
         if(trigger.isAfter && trigger.isupdate){
             for(packet__c packet :Trigger.new){
                 if(Trigger.oldMap.get(packet.ID).Status__c	 =='Admin Review' &&  packet.Status__c =='Caterer Review' && packet.Num_of_Admin_Approvals__c ==1){
            	Packet_Sendmails_Cntrl.sendmailtoCharterPlanner(packet.Id);
                    Packet_Sendmails_Cntrl.sendmailtoCharterPlanner2(packet.Id);
                     if(packet.Advance_Shipment__c =='YES')  {
                       	Packet_Sendmails_Cntrl.sendmailtoCharterPlanner1(packet.Id);  
                     } 
                 }
            }
        }
	

}