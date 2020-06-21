trigger ContractTrigger on Charter_Contract__c (before insert, before update) {
	if (Trigger.isBefore) {	
		if (Trigger.isInsert) {
			ContractController.updateContractsStatus(Trigger.new, Trigger.old);
		} else if (Trigger.isUpdate) {
			ContractController.updateContractsStatus(Trigger.new, Trigger.old);
		}
	}
}