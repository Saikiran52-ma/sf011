public class BaseObjectValidationUtil {

	public static List<Account> getAccountsWithContracts(Set<String> acctNames) {
		return [
			SELECT Id, Name, Account_Unique_Name__c,
				(SELECT Id, Start_Date__c, End_Date__c, Status__c 
				FROM Charter_Contracts__r 
				WHERE Finished__c = false
				ORDER BY Start_Date__c ASC)
			FROM Account
			WHERE Account_Unique_Name__c IN :acctNames
		];
	}
}