public class ContractHandler {

	public static void updateContractUsage(List<Packet__c> oldPackets, List<Packet__c> newPackets) {
		Set<Id> contractIds;		
		if (newPackets == null) {
			contractIds = getContractIdsForBudgetUsage(oldPackets);
		} else {
			contractIds = getContractIdsForBudgetUsage(oldPackets, newPackets);
		}
		if (contractIds.size() > 0) {
			ContractController.updateCurrentUsage(contractIds);
		}
	}

	public static Set<Id> getContractIdsForBudgetUsage(List<Packet__c> packets) {
		Set<Id> contractIds = new Set<Id>();
		for (Packet__c p : packets) {
			contractIds.add(p.Charter_Contract__c);
		}
		return contractIds;
	}

	public static Set<Id> getContractIdsForBudgetUsage(List<Packet__c> oldPackets, List<Packet__c> newPackets) {
		Set<Id> contractIds = new Set<Id>();
		for (Integer i=0; i<newPackets.size(); i++) {
			if (newPackets[i].Status__c != oldPackets[i].Status__c) {
				if (newPackets[i].Count_Towards_Contract_Usage__c) {
					contractIds.add(newPackets[i].Charter_Contract__c);
				}
			}
		}
		return contractIds;
	}
	
}