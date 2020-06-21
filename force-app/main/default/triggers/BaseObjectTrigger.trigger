trigger BaseObjectTrigger on Base_Object__c (before insert, after insert) {
	if (Trigger.isInsert) {
		if (Trigger.isBefore) {
			BaseObjectTriggerHandler.beforeInsert(Trigger.new, Trigger.old);
		} else if (Trigger.isAfter) {
			BaseObjectTriggerHandler.afterInsert(Trigger.new, Trigger.old);
		}
	} 
}