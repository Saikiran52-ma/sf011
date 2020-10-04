public class BaseObjectFlightController {
// Harish changes
	// Called from BaseObjectBatch class
	public static void upload(Base_Object__c obj) {

		// Find our packet if one exists
		Packet__c packet = BaseObjectUtil.getPacketByKey(obj.Account_Name__c, obj.Charter_Departure_Date__c, obj.Charter_Flight_Number__c);

		// If no packet is found then create one
		if (packet == null) {

			// First find the contract
			Charter_Contract__c contract = BaseObjectUtil.getContract(obj.Account_Name__c, obj.Charter_Departure_Date__c);

			// Create the packet
			packet = BaseObjectUtil.createPacket(contract.Id, contract.Account__c, obj.Charter_Departure_Date__c, obj.Charter_Flight_Number__c, CommonConstant.UPLOADTYPE_FLIGHT);

			// Create the template prepopulation
			BaseObjectUtil.createTemplatePrepopulation(packet);
		}

		// Create the flight for the packet
		BaseObjectUtil.createFlight(packet, obj);

		//rwern debug
		System.debug('BaseObjectFlightController | obj.Type__c = ' + obj.Type__c);

		// If this is the charter flight
		if (BaseObjectUtil.isCharterFlight(obj)) {

			// Add the AC type prepopulation
			BaseObjectUtil.createACTypePrepopulation(packet, obj.A_C_Type__c);
		}

		// If this is not a draft, mark the packet as "New" to signal it's ready for the customer
		if (!BaseObjectUtil.isDraft(packet, obj.Upload_Type__c)) {
			BaseObjectUtil.updatePacket(packet, obj);
		}
	}

}