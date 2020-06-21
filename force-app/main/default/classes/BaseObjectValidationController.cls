public class BaseObjectValidationController {
	
	// For flight upload perform the following validation for each record in trigger:
	//		1) Check that an account exists for given account name
	//		2) Check that a contract exists for given departure date
	public static void validate(List<Base_Object__c> objs) {

		// Add given account names to a set to query accounts and contracts
		Set<String> acctNames = new Set<String>();
		for (Base_Object__c obj : objs) {
			acctNames.add(obj.Account_Name__c);
		}
		List<Account> accts = BaseObjectValidationUtil.getAccountsWithContracts(acctNames);

		// Start looping through the trigger and perform validation for each item
		for (Base_Object__c obj : objs) {

			// 1) Check that an account has been found
			Account acct = matchAccount(obj, accts);
			if (acct == null) {
				obj.addError(ErrorMessages.NO_ACCOUNT_FOUND);
				// Continue to next item in trigger
				continue;
			}

			// 2) Check that a contract has been found
			Charter_Contract__c cont = matchContract(obj, acct.Charter_Contracts__r);
			if (cont == null) {
				obj.addError(ErrorMessages.NO_CONTRACT_FOUND);
				// Continue to next item in trigger
				continue;
			}
		}
	}

	public static Charter_Contract__c matchContract(Base_Object__c obj, List<Charter_Contract__c> conts) {
		Charter_Contract__c cont;
		for (Charter_Contract__c c : conts) {
			if (CommonUtil.dateWithinRange(obj.Charter_Departure_Date__c, c.Start_Date__c, c.End_Date__c)) {
				cont = c;
				break;
			}
		}
		return cont;
	}

	public static Account matchAccount(Base_Object__c obj, List<Account> accts) {
		Account acct;
		for (Account a : accts) {
			if (a.Account_Unique_Name__c == obj.Account_Name__c) {
				acct = a;
				break;
			}
		}
		return acct;
	}

	

	
}