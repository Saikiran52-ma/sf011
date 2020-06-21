public class PacketApprovalHandler {

	/* Called by:
		- PacketTrigger before update */
	public static void approvalCompleted(List<Packet__c> oldPackets, List<Packet__c> newPackets) {
		List<Packet__c> packets = new List<Packet__c>();
		for (Integer i=0; i<newPackets.size(); i++) {
			// If a packet's approval status is 'Completed' set the completed by and completed date fields
			if (newPackets[i].Status__c == CommonConstant.PACKET_APPROVALSTATUS_COMPLETED && newPackets[i].Status__c != oldPackets[i].Status__c) {
				packets.add(newPackets[i]);
			}
		}
		if (packets.size() > 0) {
			PacketController.approvalCompleted(packets);
		}
	}

	/* Called by:
		- PacketTrigger after update */
	public static void approvalAttachPdf(List<Packet__c> oldPackets, List<Packet__c> newPackets) {
		Set<String> approvedIds = new Set<String>();
		for (Integer i=0; i<newPackets.size(); i++) {
			// Once the caterer acknowledges the packet, create a PDF
			if (oldPackets[i].Status__c == CommonConstant.PACKET_APPROVALSTATUS_CATERERREVIEW && newPackets[i].Status__c == CommonConstant.PACKET_APPROVALSTATUS_APPROVED) {
				approvedIds.add(newPackets[i].Id);
			}
		}
		if (approvedIds.size() > 0) {
			PacketController.insertPdfAttachments(approvedIds);
		}
	}

	

}