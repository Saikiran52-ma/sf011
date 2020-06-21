public class PacketSharingHandler {

	/* Called by:
		- PacketMemberTrigger after insert
		- PacketShareController.updateSharing() */
	public static void insertSharing(List<Packet_Member__c> members) {
		List<Packet_Member__c> userMembers = new List<Packet_Member__c>();
		List<Packet_Member__c> acctMembers = new List<Packet_Member__c>();
		for (Integer i = 0; i < members.size(); i++) {
			if (members[i].User__c != null) {
				if (members[i].Access_Type__c == CommonConstant.MEMBERACCESS_USER) {
					userMembers.add(members[i]);
				} else if (members[i].Access_Type__c == CommonConstant.MEMBERACCESS_ACCOUNT) {
					acctMembers.add(members[i]);
					System.debug('acct sharing found');
				}
			}
		}
		PacketSharingController.createUserSharing(userMembers);
		PacketSharingController.createAccountSharing(acctMembers);
		PacketSharingController.updatePacketUsers(members);
	}

	/* Called by:
		- PacketMemberTrigger after update */
	public static void updateSharing(List<Packet_Member__c> newMembers, List<Packet_Member__c> oldMembers) {
		// If user changes
		List<Packet_Member__c> newUsers = new List<Packet_Member__c>();
		List<Packet_Member__c> oldUsers = new List<Packet_Member__c>();
		for (Integer i = 0; i < newMembers.size(); i++) {
			if (newMembers[i].User__c != oldMembers[i].User__c || newMembers[i].Access_Type__c != oldMembers[i].Access_Type__c) {
				newUsers.add(newMembers[i]);
				oldUsers.add(oldMembers[i]);
			}
		}
		deleteSharing(oldUsers);
		insertSharing(newUsers);
		PacketSharingController.updatePacketUsers(newMembers);
	}

	/* Called by:
		- PacketMemberTrigger after delete
		- PacketShareController.updateSharing() */
	public static void deleteSharing(List<Packet_Member__c> members) {
		List<Packet_Member__c> userMembers = new List<Packet_Member__c>();
		List<Packet_Member__c> acctMembers = new List<Packet_Member__c>();
		for (Packet_Member__c m : members) {
			if (m.Access_Type__c == CommonConstant.MEMBERACCESS_USER) {
				userMembers.add(m);
			} else if (m.Access_Type__c == CommonConstant.MEMBERACCESS_ACCOUNT) {
				acctMembers.add(m);
			}
		}
		PacketSharingController.removeUserSharing(userMembers);
		PacketSharingController.removeAccountSharing(acctMembers);
	}

	/* Called by:
		- PacketTrigger after insert
		- PacketTrigger after update */
	public static void openCustomerSharing(List<Packet__c> oldPackets, List<Packet__c> newPackets) {
		List<Packet__c> packets = new List<Packet__c>();
		if (oldPackets != null) {
			for (Integer i=0; i<newPackets.size(); i++) {
				// If the packet goes from 'Draft' to 'In Progress' open sharing for all users on account
				if (newPackets[i].Packet_Status__c == CommonConstant.PACKET_STATUS_INPROGRESS && oldPackets[i].Packet_Status__c == CommonConstant.PACKET_STATUS_DRAFT) {
					packets.add(newPackets[i]);
				}
			}
		} else {
			for (Packet__c p : newPackets) {
				if (p.Packet_Status__c == CommonConstant.PACKET_STATUS_INPROGRESS) {
					packets.add(p);
				}
			}
		}
		if (packets.size() > 0) {
			PacketSharingController.insertCustomerSharing(packets);
		}
	}

	/* Called by:
		- UserTrigger after insert */
	public static void addUsersToGroups(List<User> users) {
        System.debug('PacketSharingHandler.addUsersToGroups | start method');
		List<User> customers = new List<User>();
		List<User> ifcs = new List<User>();
		List<User> caterers = new List<User>();
		for (User u : users) {
			if (u.Profile_Name__c == CommonConstant.PROFILE_CUSTOMER) {
                System.debug('PacketSharingHandler.addUsersToGroups | adding CUSTOMER = ' + u.FirstName + ' ' + u.LastName);
				customers.add(u);
			} else if (u.Profile_Name__c == CommonConstant.PROFILE_IFC) {
                System.debug('PacketSharingHandler.addUsersToGroups | adding IFC = ' + u.FirstName + ' ' + u.LastName);
				ifcs.add(u);
			} else if (u.Profile_Name__c == CommonConstant.PROFILE_CATERER) {
                System.debug('PacketSharingHandler.addUsersToGroups | adding CATERER = ' + u.FirstName + ' ' + u.LastName);
				caterers.add(u);
			}
		}
		if (customers.size() > 0) {
            System.debug('PacketSharingHandler.addUsersToGroups | inserting CUSTOMERS size = ' + customers.size());
			PacketSharingController.insertGroupMembers(customers, CommonConstant.GROUP_NAME_CUSTOMER);
		}
		if (ifcs.size() > 0) {
            System.debug('PacketSharingHandler.addUsersToGroups | inserting IFC size = ' + ifcs.size());
			PacketSharingController.insertGroupMembers(ifcs, CommonConstant.GROUP_NAME_IFC);
		}
		if (caterers.size() > 0) {
            System.debug('PacketSharingHandler.addUsersToGroups | inserting CATERERS size = ' + caterers.size());
			PacketSharingController.insertGroupMembers(caterers, CommonConstant.GROUP_NAME_CATERER);
		}
	}

	
}