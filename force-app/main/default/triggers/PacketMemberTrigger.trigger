trigger PacketMemberTrigger on Packet_Member__c (after insert, after update, after delete) {
	if (Trigger.isAfter) {	
		if (Trigger.isInsert) {
			PacketSharingHandler.insertSharing(Trigger.new);
		} else if (Trigger.isUpdate) {
			PacketSharingHandler.updateSharing(Trigger.new, Trigger.old);
		} else if (Trigger.isDelete) {
			PacketSharingHandler.deleteSharing(Trigger.old);
		}
	}
}