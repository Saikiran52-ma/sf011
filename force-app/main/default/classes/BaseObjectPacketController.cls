public class BaseObjectPacketController {

	public static void upload(Base_Object__c obj) {

		// Find our packet if one exists
		Packet__c packet = BaseObjectUtil.getPacketByKey(obj.Account_Name__c, obj.Charter_Departure_Date__c, obj.Charter_Flight_Number__c);

		// If no packet is found then create one
		if (packet == null) {

			// First find the contract
			Charter_Contract__c contract = BaseObjectUtil.getContract(obj.Account_Name__c, obj.Charter_Departure_Date__c);

			// Create the packet
			packet = BaseObjectUtil.createPacket(contract.Id, contract.Account__c, obj.Charter_Departure_Date__c, obj.Charter_Flight_Number__c, CommonConstant.UPLOADTYPE_PACKET);

			// Create the template prepopulation
			BaseObjectUtil.createTemplatePrepopulation(packet);

		}

		// Find the stations needed for the packet
		Map<String, Account> catererMap = BaseObjectUtil.getCatererAccountsMap(new Set<String>{obj.Station_1__c, obj.Station_2__c, obj.Station_3__c});	

		// Create the stations
		BaseObjectUtil.createStations(packet, catererMap, obj.Station_1__c, obj.Station_2__c, obj.Station_3__c, obj.Advance_Shipment_Station__c);

		// Create 'United Catering Contact' member
		BaseObjectUtil.createPacketMember(packet, obj.United_Catering_User_Email__c, CommonConstant.PACKET_MEMBERTYPE_ADMIN); 
		
		// Create 'IFC' member
		BaseObjectUtil.createPacketMember(packet, obj.Inflight_Coordinator_Email__c, CommonConstant.PACKET_MEMBERTYPE_IFC);

		// Create 'Caterer' member
		//20201217 rwern: Don't use departure location to determine caterer
		//BaseObjectUtil.createPacketMember(packet, obj.Departure_Location__c, CommonConstant.PACKET_MEMBERTYPE_CATERER);
		BaseObjectUtil.createPacketMember(packet, obj.Caterer_Location__c, CommonConstant.PACKET_MEMBERTYPE_CATERER);

		// Create 'Charter planner' member
		BaseObjectUtil.createPacketMember(packet, obj.Charter_Planner_Name__c, obj.Charter_Planner_Email__c, obj.Charter_Planner_Phone__c);

		// Update base packet details
		BaseObjectUtil.updatePacket(packet, obj);		
	}

}