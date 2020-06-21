public class CommonConstant {
	
	// Profile names
	public static final String PROFILE_ADMIN = 'System Administrator';
	public static final String PROFILE_CATERER = 'Caterer';
	public static final String PROFILE_CUSTOMER = 'Customer';
	public static final String PROFILE_IFC = 'United IFC';

	// DML actions
	public static final String DMLACTION_INSERT = 'INSERT';
	public static final String DMLACTION_UPDATE = 'UPDATE';

	// Packet member - member types
	public static final String PACKET_MEMBERTYPE_ADMIN = 'United Catering Contact';
	public static final String PACKET_MEMBERTYPE_IFC = 'Inflight Coordinator';
	public static final String PACKET_MEMBERTYPE_PLANNER = 'Charter Planner';
	public static final String PACKET_MEMBERTYPE_CATERER = 'Caterer Contact';

	// Packet member - member access
	public static final String MEMBERACCESS_NONE = 'None';
	public static final String MEMBERACCESS_USER = 'User';
	public static final String MEMBERACCESS_ADMIN = 'Admin';
	public static final String MEMBERACCESS_ACCOUNT = 'Account';

	// Error messages
	public static final String ERRORMSG_NOCONTRACT = 'No contract found';

	// Contract status
	public static final String CONTRACT_STATUS_ACTIVE = 'Active';
	public static final String CONTRACT_STATUS_PENDING = 'Pending';
	public static final String CONTRACT_STATUS_EXPIRED = 'Expired';
	public static final String CONTRACT_STATUS_TERMINATED = 'Terminated';

	// Group names
	public static final String GROUP_NAME_CUSTOMER = 'Customers';
	public static final String GROUP_NAME_IFC = 'IFCs';
	public static final String GROUP_NAME_CATERER = 'Caterers';

	// Packet approval statuses
	public static final String PACKET_APPROVALSTATUS_CUSTOMERREVIEW = 'Customer Review';
	public static final String PACKET_APPROVALSTATUS_ADMINREVIEW = 'Admin Review';
	public static final String PACKET_APPROVALSTATUS_CATERERREVIEW = 'Caterer Review';
	public static final String PACKET_APPROVALSTATUS_APPROVED = 'Approved';
	public static final String PACKET_APPROVALSTATUS_COMPLETED = 'Completed';

	// Packet statuses
	public static final String PACKET_STATUS_DRAFT = 'Draft';
	public static final String PACKET_STATUS_INPROGRESS = 'In Progress';
	public static final String PACKET_STATUS_COMPLETED = 'Completed';
	public static final String PACKET_STATUS_CANCELLED = 'Cancelled';

	// Record Types - Account
	public static final String RECORDTYPE_ACCOUNT_CUSTOMER = 'Customer';
	public static final String RECORDTYPE_ACCOUNT_CATERER = 'Caterer';
	public static final String RECORDTYPE_ACCOUNT_IFC = 'United IFC';
	public static final Id RECORDTYPEID_ACCOUNT_CUSTOMER = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	public static final Id RECORDTYPEID_ACCOUNT_CATERER = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Caterer').getRecordTypeId();
	public static final Id RECORDTYPEID_ACCOUNT_IFC = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('United_IFC').getRecordTypeId();

	// FLIGHTS
	public static final String FLIGHT_TYPE_FERRY = 'Ferry';
	public static final String FLIGHT_TYPE_CHARTER = 'Charter';
	public static final String FLIGHT_TYPE_LIVE = 'Live';

	// Upload types
	public static final String UPLOADTYPE_FLIGHT = 'Flight';
	public static final String UPLOADTYPE_PACKET = 'Packet';
}