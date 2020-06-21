public class BaseObjectUtil {

	//20191217 rwern: Account name easy fix
	public static String getFormattedAcctName(String acctName) {
		return acctName.toLowerCase().trim().replace(' ', '');
	}

	public static String getPacketKey(String acctName, Date charterDepartDate, String charterFlightNum) {
		return acctName + '-' + String.valueOf(charterDepartDate).split(' ')[0] + '-' + charterFlightNum;
	}

	public static Packet__c getPacketByKey(String acctName, Date charterDepartDate, String charterFlightNum) {
		//20191217 rwern: Account name easy fix
		//String formattedAcctName = acctName.toUpperCase();
		String formattedAcctName = getFormattedAcctName(acctName);
		List<Packet__c> packets = [
			SELECT Id, Account__c, Packet_Upload__c, Flight_Upload__c, Charter_Departure_Date__c, 
			Catering_Instructions__c, Status__c, Packet_Status__c
			FROM Packet__c 
			WHERE Packet_Key__c = :getPacketKey(formattedAcctName, charterDepartDate, charterFlightNum)
		];
		if (packets.size() > 0) {
			return packets[0];
		} else {
			return null;
		}
	}

	public static Charter_Contract__c getContract(String acctName, Date charterDeptDate) {
		Charter_Contract__c contract;
		//20191217 rwern: Account name easy fix
		String formattedAcctName = getFormattedAcctName(acctName);
		List<Charter_Contract__c> contracts = [
			SELECT Id, Account__c, Account__r.Name, Start_Date__c, End_Date__c, Status__c, Account__r.Formatted_Name__c
			FROM Charter_Contract__c
			WHERE Account__r.Formatted_Name__c = :formattedAcctName
			AND (Status__c = :CommonConstant.CONTRACT_STATUS_ACTIVE 
			OR Status__c = :CommonConstant.CONTRACT_STATUS_PENDING)
			ORDER BY Start_Date__c ASC
		];
		for (Charter_Contract__c c : contracts) {
			if (CommonUtil.dateWithinRange(charterDeptDate, c.Start_Date__c, c.End_Date__c)) {
				contract = c;
				break;
			}
		}
		if (contract != null) {
			return contract;
		} else {
			throw new CommonException(CommonConstant.ERRORMSG_NOCONTRACT);
		}
		
	}

	public static Packet__c createPacket(Id contractId, Id accountId, Date charterDeptDate, String charterFlightNum, String uploadType) {
		Packet__c packet = new Packet__c();
		packet.Charter_Contract__c = contractId;
		packet.Account__c = accountId;
		packet.Charter_Departure_Date__c = charterDeptDate;
		packet.Charter_Flight_Number__c = charterFlightNum;
		if (uploadType == CommonConstant.UPLOADTYPE_FLIGHT) {
			packet.Flight_Upload__c = true;
		} else if (uploadType == CommonConstant.UPLOADTYPE_PACKET) {
			packet.Packet_Upload__c = true;
		}
		insert packet;
		return packet;
	}

	public static void createTemplatePrepopulation(Packet__c packet) {
		List<Packet_Line_Item__c> items = new List<Packet_Line_Item__c>();
		List<Template__c> templates = [
			SELECT Id, Catering_Instructions__c, PAX_Count__c,
			(SELECT Id, Product__c, Product__r.Unit_Price__c, Product__r.Name, Product__r.Use_Location_Markup__c, Product__r.IT_Code__c, F__c, M__c, Y__c, Menu_Section__c, Notes__c
			FROM Template_Line_Items__r)
			FROM Template__c
			WHERE Account__c = :packet.Account__c
			ORDER BY LastModifiedDate DESC
		];
		if (templates.size() > 0) {
			if (packet.Catering_Instructions__c != null) {
				packet.Catering_Instructions__c += '<br><br>' + templates[0].Catering_Instructions__c;
			} else {
				packet.Catering_Instructions__c = templates[0].Catering_Instructions__c;
			}		
			if (packet.PAX_Count__c == null) {
				packet.PAX_Count__c = templates[0].PAX_Count__c;
			}
			update packet;
			for (Template_Line_Item__c item : templates[0].Template_Line_Items__r) {
				Packet_Line_Item__c newItem = new Packet_Line_Item__c();
				newItem.Packet__c = packet.Id;
				newItem.Product__c = item.Product__c;
				newItem.IT_Code__c = item.Product__r.IT_Code__c;
				newItem.F__c = item.F__c;
				newItem.M__c = item.M__c;
				newItem.Y__c = item.Y__c;
				newItem.Product_Unit_Price__c = item.Product__r.Unit_Price__c;
				newItem.Product_Name__c = item.Product__r.Name;
				newItem.Use_Location_Markup__c = item.Product__r.Use_Location_Markup__c;
				newItem.Menu_Section__c = item.Menu_Section__c;
				items.add(newItem);
			}
		}
		insert items;
	}

	public static Boolean isCharterFlight(Base_Object__c obj) {
		if (obj.Type__c == CommonConstant.FLIGHT_TYPE_CHARTER) {
			return true;
		} else {
			return false;
		}
	}

	public static void createFlight(Packet__c packet, Base_Object__c obj) {
		// If the flight is the packet's charter flight, update the packet-level flight info
		if (isCharterFlight(obj)) {	
			packet.Departure_Location__c = obj.Departure_Location__c;
			packet.Arrival_Location__c = obj.Arrival_Location__c;
			update packet;
		}	
		// Insert flight to packet
		Packet_Flight__c flight = new Packet_Flight__c();
		flight.Packet__c = packet.Id;
		flight.Flight_Number__c = obj.Flight_Number__c;
		flight.Charter_Flight_Number__c = obj.Charter_Flight_Number__c;
		flight.Catering_DOW__c = obj.Catering_DOW__c;
		flight.Departure_Date__c = obj.Departure_Date__c;
		flight.Departure_Time__c = obj.Departure_Time__c;
		flight.Departure_Date_Time__c = Datetime.newInstance(obj.Departure_Date__c, obj.Departure_Time__c);
		flight.Arrival_Date__c = obj.Arrival_Date__c;
		flight.Arrival_Time__c = obj.Arrival_Time__c;
		flight.Arrival_Date_Time__c = Datetime.newInstance(obj.Arrival_Date__c, obj.Arrival_Time__c);
		flight.Departure_Location__c = obj.Departure_Location__c;
		flight.Arrival_Location__c = obj.Arrival_Location__c;		
		flight.Aircraft_Stripping_Location__c = obj.Aircraft_Stripping_Location__c;
		flight.Block_Time__c = obj.Block_Time__c;
		flight.Type__c = obj.Type__c;
		flight.Catering_Loading_Begins__c = obj.Catering_Loading_Begins__c;
		if (obj.A_C_Type__c != null) {
			flight.A_C_Type__c = obj.A_C_Type__c.toUpperCase();
			List<Aircraft__c> acs = [
				SELECT Id
				FROM Aircraft__c
				WHERE Aircraft_Designator__c = :obj.A_C_Type__c.toUpperCase()
			];
			if (acs.size() > 0) {
				flight.Aircraft__c = acs[0].Id;
			}
		}
		insert flight;
	}
	
	public static void createACTypePrepopulation(Packet__c packet, String acType) {
		List<Packet_Line_Item__c> items = new List<Packet_Line_Item__c>();
		List<Aircraft__c> ac = [
			SELECT Id, Aircraft_Designator__c, FA_RA_Count__c, Pilot_Count__c, Catering_Instructions__c,
			(SELECT Id, Product__c, Product__r.Name, Product__r.Use_Location_Markup__c, Product__r.Unit_Price__c, 
			Product__r.IT_Code__c, F__c, M__c, Y__c, Menu_Section__c, Notes__c
			FROM Aircraft_Line_Items__r)
			FROM Aircraft__c
			WHERE Aircraft_Designator__c = :acType.toUpperCase()
		];
		if (ac.size() > 0) {
			packet.Charter_Aircraft__c = ac[0].Id;
			packet.Pilot_Count__c = ac[0].Pilot_Count__c;
			packet.FA_RA_Count__c = ac[0].FA_RA_Count__c;
			if (packet.Catering_Instructions__c != null) {
				packet.Catering_Instructions__c += '<br><br>' + ac[0].Catering_Instructions__c;
			} else {
				packet.Catering_Instructions__c = ac[0].Catering_Instructions__c;
			}
			update packet;
			for (Aircraft_Line_Item__c item : ac[0].Aircraft_Line_Items__r) {
				Packet_Line_Item__c newItem = new Packet_Line_Item__c();
				newItem.Packet__c = packet.Id;
				newItem.Product__c = item.Product__c;
				newItem.IT_Code__c = item.Product__r.IT_Code__c;
				newItem.Notes__c = item.Notes__c;
				newItem.F__c = item.F__c;
				newItem.M__c = item.M__c;
				newItem.Y__c = item.Y__c;
				newItem.Menu_Section__c = item.Menu_Section__c;
				newItem.Use_Location_Markup__c = item.Product__r.Use_Location_Markup__c;
				newItem.Product_Unit_Price__c = item.Product__r.Unit_Price__c;
				newItem.Product_Name__c = item.Product__r.Name;
				items.add(newItem);
			}
		}
		insert items;
	}

	//20191121 rwern: Include sandbox emails
	public static User getUserByEmail(String email) {
		String fixedEmail = email + '%';
		List<User> users = [
			SELECT Id, AccountId
			FROM User
			WHERE IsActive = true
			AND Email LIKE :fixedEmail
		];
		if (users.size() > 0) {
			return users[0];
		} else {
			return null;
		}
	}

	public static Map<String, Account> getCatererAccountsMap(Set<String> locations) {
		locations.remove(null);
		Map<String, Account> acctMap = new Map<String, Account>();
		List<Account> accts = [
			SELECT Id, Location__c,
			(SELECT Id, Primary_Contact__c FROM Contacts)
			FROM Account
			WHERE RecordType.DeveloperName = :CommonConstant.RECORDTYPE_ACCOUNT_CATERER
			AND Location__c IN :locations
		];
		for (Account a : accts) {
			acctMap.put(a.Location__c, a);
		}
		return acctMap;
	}

	public static void createStations(Packet__c packet, Map<String, Account> acctMap, String loc1, String loc2, String loc3, String advanceShipment) {
		List<Packet_Station__c> stations = new List<Packet_Station__c>();
		List<String> locs = new List<String>();
		if (loc1 != null) {
			locs.add(loc1);
		}
		if (loc2 != null) {
			locs.add(loc2);
		}
		if (loc3 != null) {
			locs.add(loc3);
		}
		for (Integer i=0; i<locs.size(); i++) {
			Packet_Station__c station = new Packet_Station__c();
			station.Packet__c = packet.Id;
			station.Account__c = acctMap.get(locs[i]).Id;
			station.Station_Number__c = i + 1;
			if (locs[i] == advanceShipment) {
				station.Advance_Shipment__c = true;
			}
			stations.add(station);
		}
		insert stations;
	}

	public static User getCatererUserByLocation(String loc) {
		User caterer;
		List<User> users = [
			SELECT Id, AccountId, Contact.Primary_Contact__c
			FROM User
			WHERE Account.Location__c = :loc
			AND Account.RecordType.DeveloperName = :CommonConstant.RECORDTYPE_ACCOUNT_CATERER
			AND IsActive = true
		];
		for (User u : users) {
			if (u.Contact.Primary_Contact__c) {
				caterer = u;
				break;
			}
		}
		if (caterer != null) {
			return caterer;
		} else {
			if (users.size() > 0) {
				return users[0];
			} else {
				return null;
			}
		}
	}

	public static void createPacketMember(Packet__c packet, String memberName, String memberEmail, String memberPhone) {
		if (memberName != null) {
			Packet_Member__c member = new Packet_Member__c();
			member.Packet__c = packet.Id;
			member.Member_Type__c = CommonConstant.PACKET_MEMBERTYPE_PLANNER;
			member.Access_Type__c = CommonConstant.MEMBERACCESS_NONE;
			member.Member_Name__c = memberName;
			member.Member_Email__c = memberEmail;
			member.Member_Phone__c = memberPhone;
			insert member;
		}
	}

	public static void createPacketMember(Packet__c packet, String keyWord, String memberType) {
		User u;
		if (memberType == CommonConstant.PACKET_MEMBERTYPE_CATERER) {
			u = getCatererUserByLocation(keyWord);
		} else {
			u = getUserByEmail(keyWord);
		}
		if (u != null) {
			Packet_Member__c member = new Packet_Member__c();
			member.Packet__c = packet.Id;
			member.Member_Type__c = memberType;
			member.User__c = u.Id;
			if (memberType == CommonConstant.PACKET_MEMBERTYPE_ADMIN) {
				member.Access_Type__c = CommonConstant.MEMBERACCESS_ADMIN;
				packet.United_Catering_User__c = u.Id;
			} else if (memberType == CommonConstant.PACKET_MEMBERTYPE_IFC) {
				member.Access_Type__c = CommonConstant.MEMBERACCESS_USER;
				packet.IFC_User__c = u.Id;
				packet.IFC_Account__c = u.AccountId;
			} else if (memberType == CommonConstant.PACKET_MEMBERTYPE_CATERER) {
				member.Access_Type__c = CommonConstant.MEMBERACCESS_ACCOUNT;
				packet.Caterer_User__c = u.Id;
				packet.Caterer_Account__c = u.AccountId;
			}
			insert member;
			update packet;
		}
	}

	public static void updatePacket(Packet__c packet, Base_Object__c obj) {
		if (obj.Upload_Type__c == CommonConstant.UPLOADTYPE_FLIGHT) {
			packet.Packet_Status__c = CommonConstant.PACKET_STATUS_INPROGRESS;
			packet.Flight_Upload__c = true;
		} else if (obj.Upload_Type__c == CommonConstant.UPLOADTYPE_PACKET) {
			if (obj.PAX_Count__c != null) {
				packet.PAX_Count__c = obj.PAX_Count__c;
			}
			packet.Advance_Shipment__c = obj.Advance_Shipment__c;
			packet.Advance_Shipment_Station__c = obj.Advance_Shipment_Station__c;
			packet.Issue_Date__c = obj.Issue_Date__c;
			if (!isDraft(packet, obj.Upload_Type__c)) {
				packet.Packet_Status__c = CommonConstant.PACKET_STATUS_INPROGRESS;
			}
			packet.Packet_Upload__c = true;
			//20191217 rwern: add catering instructions
			if (packet.Catering_Instructions__c != null) {
				packet.Catering_Instructions__c += '<br/>' + obj.Catering_Instructions__c;
			} else {
				packet.Catering_Instructions__c = obj.Catering_Instructions__c;
			}
		}
		update packet;
	}

	public static Boolean isDraft(Packet__c packet, String uploadType) {
		if (packet == null) {
			return true;
		} else if (uploadType == CommonConstant.UPLOADTYPE_FLIGHT && packet.Flight_Upload__c) {
			return true;
		} else if (uploadType == CommonConstant.UPLOADTYPE_PACKET && packet.Packet_Upload__c) {
			return true;
		} else {
			return false;
		}
	}

	public static void createError(String className, String methodName, String errorMsg, Datetime submittedDate, Base_Object__c obj) {
		Error_Log__c log = new Error_Log__c();
		log.Class__c = className;
		log.Method__c = methodName;
		log.Message__c = errorMsg;
		log.Base_Object__c = obj.Id;
		log.Submitted_Date_Time__c = submittedDate;
		insert log;
	}

	public static void debugLimits() {
		System.debug('LIMITS | CPU TIME | Current = ' + Limits.getCPUTime() + ', Limit = ' + Limits.getLimitCPUTime());
		System.debug('LIMITS | DML ROWS | Current = ' + Limits.getDMLRows() + ', Limit = ' + Limits.getLimitDMLRows()); 
		System.debug('LIMITS | DML STATEMENTS | Current = ' + Limits.getDMLStatements() + ', Limit = ' + Limits.getLimitDMLStatements()); 
		System.debug('LIMITS | SOQL QUERIES | Current = ' + Limits.getQueries() + ', Limit = ' + Limits.getLimitQueries()); 
		System.debug('LIMITS | QUERY ROWS | Current = ' + Limits.getQueryRows() + ', Limit = ' + Limits.getLimitQueryRows()); 
	}

}