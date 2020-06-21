public class BaseObjectTriggerHandler {

	public static void beforeInsert(List<Base_Object__c> triggerNew, List<Base_Object__c> triggerOld) {
		// Send to validation method
		BaseObjectValidationController.validate(triggerNew);
	}

	public static void afterInsert(List<Base_Object__c> triggerNew, List<Base_Object__c> triggerOld) {
		// Send to batch job
		BaseObjectBatch b = new BaseObjectBatch(triggerNew);
		Database.executeBatch(b, 1);
	}

}