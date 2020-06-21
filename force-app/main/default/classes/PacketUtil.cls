public class PacketUtil {

	/*public static Packet__c getPacketById(String packetId) {
		return [
			SELECT Id, Packet_PDF_Name__c 
			FROM Packet__c 
			WHERE Id = :packetId
		];
	}*/
	
	public static List<Packet__c> getPacketsByIds(Set<String> packetIds) {
		return [
			SELECT Id, Name, Account_Name__c, Packet_PDF_Name__c, Packet_Number__c, Portal_URL__c, Num_of_Attached_PDFs__c,
			Departure_Location__c, Arrival_Location__c, Charter_Departure_Date__c, Charter_Aircraft__r.Aircraft_Designator__c,
			United_Catering_User__r.FirstName, United_Catering_User__r.LastName, United_Catering_User__r.Email, United_Catering_User__r.Phone,
			Caterer_User__r.FirstName, Caterer_User__r.LastName, Caterer_User__r.Email, Caterer_User__r.Phone
			FROM Packet__c 
			WHERE Id IN :packetIds
		];
	}

	public static List<Attachment> getPacketAttachments(String packetId) {
		return [
			SELECT Id, Name, Body, CreatedDate
			FROM Attachment
			WHERE ParentId = :packetId
			ORDER BY CreatedDate DESC
		];
	}

	public static Attachment createPdfAttachment(String parentId, String fileName, Blob fileBody) {
		Attachment att = new Attachment();
		att.ParentId = parentId;
		att.Name = fileName + '.pdf';
		att.Body = fileBody;
		att.IsPrivate = false;
		return att;
	}

	public static Messaging.EmailFileAttachment createEmailAttachment(String fileName, Blob fileBody) {
		Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
		att.setFileName(fileName);
		att.setBody(fileBody);
		return att;
	}

	public static void sendEmailWithAttachment(List<String> toAddresses, String subject, String htmlBody, Messaging.EmailFileAttachment att) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(toAddresses);
		mail.setSubject(subject);
		mail.setHtmlBody(htmlBody);
		mail.setReplyTo(UserInfo.getUserEmail());
		mail.setSenderDisplayName(UserInfo.getName());
		mail.setFileAttachments(new Messaging.EmailFileAttachment[] { att });
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	
	}

	public static Map<Id, List<User>> getStationUsersMap(Set<Id> acctIds) {
		Map<Id, List<User>> acctUsersMap = new Map<Id, List<User>>();
		List<User> users = [SELECT Id, FirstName, LastName, Email, AccountId, Phone, Primary_Contact__c FROM User WHERE AccountId IN :acctIds AND IsActive = true];
		for (Id acctId : acctIds) {
			List<User> acctUsers = new List<User>();
			for (User u : users) {
				if (u.AccountId == acctId) {
					acctUsers.add(u);
				}
			}
			acctUsersMap.put(acctId, acctUsers);
		}
		return acctUsersMap;
	}

	public static String getPdfEmailHtmlBody(Packet__c packet, String comments) {
		String htmlBody = 'Packet <b>' 
			+ packet.Packet_PDF_Name__c + 
			+ '</b> has been attached to this email and sent to you for review.'
			+ '<br/><br/>'
			+ '<b>Sent by:</b> ' + UserInfo.getName()
			+ '<br/>'
			+ '<b>Customer:</b> ' + packet.Account_Name__c
			+ '<br/>'
			+ '<b>Packet #:</b> ' + packet.Name
			+ '<br/>'
			+ '<b>Departure Date:</b> ' + formatDate(packet.Charter_Departure_Date__c)
			+ '<br/>'
			+ '<b>Departure Location:</b> ' + packet.Departure_Location__c
			+ '<br/>'
			+ '<b>Arrival Location:</b> ' + packet.Arrival_Location__c
			+ '<br/>'
			+ '<b>A/C Type:</b> ' + packet.Charter_Aircraft__r.Aircraft_Designator__c;
			if (comments != null && comments != '') {
				htmlBody += '<br/><br/><b>Sender Comments:</b><br/>'
					+ '<table><tr><td style="width:16px">&nbsp</td>'
					+ '<td style="width:640px">'
					+ comments
					+ '</td></tr></table>';
			}
			htmlBody += '<br/><br/>'
			+ '<a href="' + packet.Portal_URL__c + '">Click here to view more packet details</a>';
		return htmlBody;
	}

	public static String formatDate(Date d) {
		String s = String.valueOf(d).split(' ')[0];		// Returns YYYY-MM-DD
		String m = s.split('-')[1];
		String d1 = s.split('-')[2];
		String y = s.split('-')[0];
		String mName;
		System.debug('PacketUtil.formatDate() | m = ' + m);
		if (m == '01') {
			mName = 'Jan';
		} else if (m == '02') {
			mName = 'Feb';
		} else if (m == '03') {
			mName = 'Mar';
		} else if (m == '04') {
			mName = 'Apr';
		} else if (m == '05') {
			mName = 'May';
		} else if (m == '06') {
			mName = 'Jun';
		} else if (m == '07') {
			mName = 'Jul';
		} else if (m == '08') {
			mName = 'Aug';
		} else if (m == '09') {
			mName = 'Sep';
		} else if (m == '10') {
			mName = 'Oct';
		} else if (m == '11') {
			mName = 'Nov';
		} else {
			mName = 'Dec';
		}
		return d1 + '-' + mName + '-' + y.right(2);
	}
}