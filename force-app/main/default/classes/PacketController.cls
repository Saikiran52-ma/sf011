public class PacketController {

	// When the packet has been fully approved and is now 'Completed'
	public static void approvalCompleted(List<Packet__c> packets) {
		for (Packet__c p : packets) {
			p.Completed_By__c = UserInfo.getUserId();
			p.Completed_Date__c = Datetime.now();
		}		
	}
	
	// Take a list of packets that have been caterer approved and attach the packet PDFs
	@future(callout=true)
	public static void insertPdfAttachments(Set<String> packetIds) {
		try {
			List<Packet__c> packets = PacketUtil.getPacketsByIds(packetIds);
			List<Attachment> atts = new List<Attachment>();
			//20200106 rwern: test class fix - getContent() not supported in tests
			for (Packet__c p : packets) {
				PageReference pdf = Page.PacketPDF;
				pdf.getParameters().put('packetId', p.Id);
				if (!Test.isRunningTest()) {
					atts.add(PacketUtil.createPdfAttachment(p.Id, p.Packet_PDF_Name__c, pdf.getContent()));
				} else {
					atts.add(PacketUtil.createPdfAttachment(p.Id, p.Packet_PDF_Name__c, Blob.valueOf('test')));
				}
				
			}
			insert atts;
			for (Packet__c p : packets) {
				for (Attachment att : atts) {
					if (att.ParentId == p.Id) {
						p.Num_of_Attached_PDFs__c = p.Num_of_Attached_PDFs__c + 1;
						p.Latest_Attached_PDF_Id__c = att.Id;
						break;
					}
				} 
			}
			update packets;
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketController.insertPdfAttachments | ex: ' + ex.getMessage());
			System.debug('PacketController.insertPdfAttachments | ex: ' + ex.getLineNumber());
			System.debug('PacketController.insertPdfAttachments | ex: ' + ex.getStackTraceString());
		}
	}

	public static void sendPDFEmail(String packetId, String comments, String toAddressString) {
		try {
			// Perform validation on email string
			List<String> toAddresses = CommonUtil.validateToAddresses(toAddressString);
			if (toAddresses.size() > 0) {
				List<Packet__c> packets = PacketUtil.getPacketsByIds(new Set<String>{packetId});
				//20200110 rwern: Phase 1 compromise - email live PDF instead of approved/attached PDF
				/*List<Attachment> atts = PacketUtil.getPacketAttachments(packetId);
				if (atts.size() > 0) {			
					Messaging.EmailFileAttachment att = PacketUtil.createEmailAttachment(atts[0].Name, atts[0].Body);
					PacketUtil.sendEmailWithAttachment(toAddresses, packets[0].Packet_PDF_Name__c, PacketUtil.getPdfEmailHtmlBody(packets[0], comments), att);
				}*/
				PageReference pr = Page.PacketPDF;
				pr.getParameters().put('packetId', packetId);
				Blob pdfBlob;
				if (!Test.isRunningTest()) {
					pdfBlob = pr.getContent();
				} else {
					pdfBlob = Blob.valueOf('test');
				}
				Messaging.EmailFileAttachment att = PacketUtil.createEmailAttachment(packets[0].Packet_PDF_Name__c + '.pdf', pdfBlob);
				PacketUtil.sendEmailWithAttachment(toAddresses, packets[0].Packet_PDF_Name__c, PacketUtil.getPdfEmailHtmlBody(packets[0], comments), att);
				
			} else {
				throw new CommonException(ErrorMessages.EMAIL_TOADDRESSES_ERROR);
			}
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketController.sendPDFEmail() | ex: ' + ex.getMessage() + ', ' + ex.getLineNumber() + ', ' + ex.getStackTraceString());
			throw new CommonException(ex.getMessage());
		}
	}

	

}