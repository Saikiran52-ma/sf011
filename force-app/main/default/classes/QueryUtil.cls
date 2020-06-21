public without sharing class QueryUtil {

	public static SObject queryRecord(String sObjectName, String whereClause) {
		Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().SObjectType.getDescribe().fields.getMap();
		Set<String> fields = new Set<String>();
		for (Schema.SObjectField f : fieldsMap.values()) {
			if (f.getDescribe().isAccessible()) {
				fields.add(f.getDescribe().getName());
			}
    	}  
    	String allFields = ''; 
    	for (String f : fields) {
      		allFields += f + ',';
		}
		String q = 'SELECT ' + allFields.removeEnd(',') + ' FROM ' + sObjectName;
		if (whereClause != null) {
			q += ' WHERE ' + whereClause;
		}
		q += ' LIMIT 1';
    	return Database.query(q);
	}

	public static List<SObject> queryRecords(String sObjectName, String whereClause, String orderBy, Integer limitNum) {
		Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().SObjectType.getDescribe().fields.getMap();
		Set<String> fields = new Set<String>();
		for (Schema.SObjectField f : fieldsMap.values()) {
			if (f.getDescribe().isAccessible()) {
				fields.add(f.getDescribe().getName());
			}
    	}  
    	String allFields = ''; 
    	for (String f : fields) {
      		allFields += f + ',';
		}	
		String q = 'SELECT ' + allFields.removeEnd(',') + ' FROM ' + sObjectName;
		if (whereClause != null) {
			q += ' WHERE ' + whereClause;
		}
		if (orderBy != null) {
			q += ' ORDER BY ' + orderBy;
		}
		if (limitNum != null) {
			q += ' LIMIT ' + limitNum;
		}
    	return Database.query(q);
	}

}