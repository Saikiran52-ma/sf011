public class BaseObjectConstant {
// Test2kjasdhsad
	// Upload types
	public static final String UPLOADTYPE_CONTRACT = 'Contract';
	public static final String UPLOADTYPE_FLIGHT = 'Flight';
	public static final String UPLOADTYPE_PACKET = 'Packet';

	// Packet member types
	public static final String PACKETMEMBERTYPE_UNITED = 'United Catering Contact';
	public static final String PACKETMEMBERTYPE_IFC = 'Inflight Coordinator';
	public static final String PACKETMEMBERTYPE_PLANNER = 'Charter Planner';
	public static final String PACKETMEMBERTYPE_CATERER = 'Caterer Contact';

	// Packet statuses (Packet__c.Packet_Status__c)
	//Sai Kiran
	public static final String PACKET_STATUS_DRAFT = 'Draft';
	public static final String PACKET_STATUS_INPROGRESS = 'In Progress';
	public static final String PACKET_STATUS_COMPLETED = 'Completed';
	public static final String PACKET_STATUS_CANCELLED = 'Cancelled';

	// Contract status values
	public static final String CONTRACTSTATUS_ACTIVE = 'Active';
	public static final String CONTRACTSTATUS_PENDING = 'Pending';
	public static final String CONTRACTSTATUS_TERMINATED = 'Terminated';
	public static final String CONTRACTSTATUS_EXPIRED = 'Expired';

	// BaseObject errors
	public static final String ERROR_BASEOBJ_NOACCOUNT = 'No account found for given account name';
	public static final String ERROR_BASEOBJ_DATECHECK = 'A contract in this date range already exists';
	public static final String ERROR_BASEOBJ_NOCONTRACT = 'No contract found for given account';
	
	// Account record types
	public static final String RECORDTYPE_ACCOUNT_CUSTOMER = 'Customer';
	public static final String RECORDTYPE_ACCOUNT_CATERER = 'Caterer';
	public static final String RECORDTYPE_ACCOUNT_IFC = 'United IFC';
	public static final Id RECORDTYPEID_ACCOUNT_CUSTOMER = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	public static final Id RECORDTYPEID_ACCOUNT_CATERER = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Caterer').getRecordTypeId();
	public static final Id RECORDTYPEID_ACCOUNT_IFC = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('United_IFC').getRecordTypeId();

	public static final String FLIGHT_TYPE_FERRY = 'Ferry';
	public static final String FLIGHT_TYPE_CHARTER = 'Charter';
	public static final String FLIGHT_TYPE_LIVE = 'Live';

	public static final String PROFILE_ADMIN = 'System Administrator';
	public static final String PROFILE_CATERER = 'Caterer';
	public static final String PROFILE_CUSTOMER = 'Customer';
	public static final String PROFILE_IFC = 'United IFC';
	//git sai
	punlijjiewfniewffik

	
}