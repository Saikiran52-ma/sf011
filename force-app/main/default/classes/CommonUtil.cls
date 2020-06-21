public class CommonUtil {

	public static List<String> getMenuSections() {
		List<String> menuSections = new List<String>();
		Schema.DescribeFieldResult dfr = Packet_Line_Item__c.Menu_Section__c.getDescribe();
		Schema.SObjectField sobjf = dfr.getSObjectField();
		List<PicklistEntry> entries = sobjf.getDescribe().getPicklistValues();
		for (PicklistEntry e : entries) {
			menuSections.add(e.getLabel());
		}
		return menuSections;
	}
	
	public static String getContractStatus(Date startDate, Date endDate) {		
		if (endDate < Date.today()) {
			return CommonConstant.CONTRACT_STATUS_EXPIRED;
		} else if (startDate > Date.today()) {
			return CommonConstant.CONTRACT_STATUS_PENDING;
		} else {
			return CommonConstant.CONTRACT_STATUS_ACTIVE;
		}
	}

	public static Id getGroupId(String groupName) {
		List<Group> groups = [
			SELECT Id
			FROM Group
			WHERE Name = :groupName
		];
		if (groups.size() > 0) {
			return groups[0].Id;
		} else {
			return null;
		}
	}

	public static Boolean datesCheck(Date start1, Date end1, Date start2, Date end2) {
		if (((start1 >= start2 && start1 < end2) || (end1 > start2 && end1 <= end2)))  {
			return false;
		} else {
			return true;
		}
	}

	public static Boolean dateWithinRange(Date d, Date start1, Date end1) {
		if (d >= start1 && d <= end1) {
			return true;
		} else {
			return false;
		}
	}

	public static List<String> validateToAddresses(String toAddressString) {
		List<String> toAddresses = new List<String>();
		if (toAddressString != null && toAddressString != '') {
			toAddressString = toAddressString.replaceAll(' ', ',').replaceAll(';', ',').deleteWhitespace();
			for (String s : toAddressString.split(',')) {
				if (s.contains('@')) {
					toAddresses.add(s.replaceAll(',', ''));
				}
			}
		}
		return toAddresses;
	}

}