public class ContractController {

	public static void updateCurrentUsage(Set<Id> contractIds) {
		try {
			List<Charter_Contract__c> contracts = getContractsWithPackets(contractIds);
			for (Charter_Contract__c c : contracts) {
				Decimal usage = 0;
				for (Packet__c p : c.Packets__r) {
					if (p.Count_Towards_Contract_Usage__c) {
						usage += p.Total_Cost__c;
					}
				}
				c.Current_Usage__c = usage;
			}
			update contracts;
		} catch(Exception ex) {
			// TODO: handle exception
		}
	}

	public static List<Charter_Contract__c> getContractsWithPackets(Set<Id> contractIds) {
		return [
			SELECT Id, 
			(SELECT Id, Total_Cost__c, Packet_Status__c, Status__c, Count_Towards_Contract_Usage__c FROM Packets__r) 
			FROM Charter_Contract__c 
			WHERE Id IN :contractIds
		];
	}

	public static void updateContractsStatus(List<Charter_Contract__c> contracts, Boolean doUpdate) {
		List<Charter_Contract__c> updateList = new List<Charter_Contract__c>();
		for (Charter_Contract__c c : contracts) {
			String newStatus = CommonUtil.getContractStatus(c.Start_Date__c, c.End_Date__c);
			if (newStatus != c.Status__c && c.Status__c != CommonConstant.CONTRACT_STATUS_TERMINATED) {
				c.Status__c = newStatus;
				updateList.add(c);
			}
		}
		if (doUpdate) {
			update updateList;
		}
	}

	public static void updateContractsStatus(List<Charter_Contract__c> newContracts, List<Charter_Contract__c> oldContracts) {
		List<Charter_Contract__c> contracts = new List<Charter_Contract__c>();
		// Trigger.beforeInsert - Send all contracts to status update
		if (oldContracts == null) {
			contracts.addAll(newContracts);
		// Trigger.beforeUpdate - Send only date changed contracts to status update
		} else {
			for (Integer i=0; i<newContracts.size(); i++) {
				if (newContracts[i].Start_Date__c != oldContracts[i].Start_Date__c || newContracts[i].End_Date__c != oldContracts[i].End_Date__c) {
					contracts.add(newContracts[i]);
				}
			}
		}
		updateContractsStatus(contracts, false);
	}

}