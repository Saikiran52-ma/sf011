public class BaseObjectBatch implements Database.Batchable<Base_Object__c>, Database.Stateful {
	List<Base_Object__c> objs;
	List<Base_Object__c> successObjs;
	Map<Base_Object__c, String> failObjs;
	Datetime submittedDate;
	String uploadType;
	
	public BaseObjectBatch(List<Base_Object__c> objs) {
		// Test
		this.objs = objs;
		this.failObjs = new Map<Base_Object__c, String>();
		this.successObjs = new List<Base_Object__c>();
		this.submittedDate = Datetime.now();
	}

	public Iterable<Base_Object__c> start(Database.BatchableContext bc) {
		return (Iterable<Base_Object__c>)this.objs;
	}

	public void execute(Database.BatchableContext bc, List<Base_Object__c> scope) {
		Base_Object__c obj = scope[0];
		try {
			if (obj.Upload_Type__c == CommonConstant.UPLOADTYPE_FLIGHT) {
				BaseObjectFlightController.upload(obj);
			} else if (obj.Upload_Type__c == CommonConstant.UPLOADTYPE_PACKET) {
				BaseObjectPacketController.upload(obj);
			}
			if (uploadType == null) {
				uploadType = obj.Upload_Type__c;
			}
			successObjs.add(obj);		
		} catch(Exception ex) {
			String errorMsg = ex.getMessage() + ' ' + ex.getStackTraceString();
			System.debug('BaseObjectBatch.execute | exception = ' + errorMsg);
			BaseObjectUtil.createError('BaseObjectBatch', 'Execute', errorMsg, submittedDate, obj);
			failObjs.put(obj, errorMsg);
		}
		BaseObjectUtil.debugLimits();
	}
	//double check

	public void finish(Database.BatchableContext bc) {
		String userEmail = UserInfo.getUserEmail();
		List<String> toAddresses = new List<String>{ userEmail };
		string htmlBody = '<b># Success = </b>' + successObjs.size() + '<br/>' + '<b># Fail = </b>' + failObjs.keySet().size() + '<br/><br/>';
		if (failObjs.keySet().size() > 0) {
			htmlBody += '<b>ERRORS:</b><br/><table>';
			for (Base_Object__c obj : failObjs.keySet()) {
				htmlBody += '<tr><td>' + obj.Id + '</td><td>' + failObjs.get(obj) + '</td></tr>';
			}
			htmlBody += '</table>';
		}
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(userEmail);
        mail.setSubject('Upload results - ' + uploadType + ' upload ' + String.valueOf(Date.today()));
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
	}

}