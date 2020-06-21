public class PacketSharingController {

	// DONE
	public static void createAccountSharing(List<Packet_Member__c> members) {
		try {
			List<Packet__Share> shares = new List<Packet__Share>();
			Set<Id> acctIds = new Set<Id>();
			for (Packet_Member__c m : members) {
				if (m.User_AccountId__c != null) {
					acctIds.add(m.User_AccountId__c);
					System.debug('PacketSharingController.createAccountSharing | acctId = ' + m.User_AccountId__c);
				}
			}
			Map<Id, Account> accts = new Map<Id, Account>(PacketSharingUtil.getAccountsWithUsers(acctIds));
			for (Packet_Member__c m : members) {
				Account acct = accts.get(m.User_AccountId__c);
				System.debug('PacketSharingController.createAccountSharing | found acctId = ' + acct.Id);
				if (acct != null) {
					for (User u : acct.Users) {
						System.debug('PacketSharingController.createAccountSharing | found user Id = ' + u.Id);
						shares.add(PacketSharingUtil.createPacketShare(m.Packet__c, u.Id));
					}
				}
			}
			insert shares;
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketSharingController.createAccountSharing | exception = ' + ex.getMessage());
		}
	}

	// DONE
	public static void removeAccountSharing(List<Packet_Member__c> members) {
		try {
			Set<Id> packetIds = new Set<Id>();
			Set<Id> acctIds = new Set<Id>();
			for (Packet_Member__c m : members) {
				if (m.User_AccountId__c != null) {
					packetIds.add(m.Packet__c);
					acctIds.add(m.User_AccountId__c);
				}
			}
			Map<Id, User> users = new Map<Id, User>(PacketSharingUtil.getUsersByAccountIds(acctIds));
			List<Packet__Share> shares = PacketSharingUtil.getPacketShares(packetIds, users.keySet());
			delete shares;
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketSharingController.removeAccountSharing | exception = ' + ex.getMessage());
		}
	}

	// DONE
	public static void removeUserSharing(List<Packet_Member__c> members) {
		try {
			Set<Id> packetIds = new Set<Id>();
			Set<Id> userIds = new Set<Id>();
			for (Packet_Member__c m : members) {
				packetIds.add(m.Packet__c);
				userIds.add(m.User__c);
			}
			List<Packet__Share> shares = PacketSharingUtil.getPacketShares(packetIds, userIds);
			delete shares;
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketSharingController.removeUserSharing | exception = ' + ex.getMessage());
		}
	}

	// DONE
	public static void createUserSharing(List<Packet_Member__c> members) {
		try {
			List<Packet__Share> shares = new List<Packet__Share>();
			for (Packet_Member__c m : members) {
				shares.add(PacketSharingUtil.createPacketShare(m.Packet__c, m.User__c));
			}	
			insert shares;
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketSharingController.createUserSharing | exception = ' + ex.getMessage());
		}
	}

	// DONE
	public static void updatePacketUsers(List<Packet_Member__c> members) {
		try {
			Set<Id> packetIds = new Set<Id>();
			for (Packet_Member__c m : members) {
				packetIds.add(m.Packet__c);
			}
			List<Packet__c> packets = PacketSharingUtil.getPackets(packetIds);
			for (Packet__c p : packets) {
				for (Packet_Member__c m : members) {
					if (m.Packet__c == p.Id) {
						if (m.Member_Type__c == CommonConstant.PACKET_MEMBERTYPE_ADMIN) {
							p.United_Catering_User__c = m.User__c;
						} else if (m.Member_Type__c == CommonConstant.PACKET_MEMBERTYPE_IFC) {
							p.IFC_User__c = m.User__c;
							p.IFC_Account__c = m.User_AccountId__c;
						} else if (m.Member_Type__c == CommonConstant.PACKET_MEMBERTYPE_CATERER) {
							p.Caterer_User__c = m.User__c;
							p.Caterer_Account__c = m.User_AccountId__c;
						}
					}
				}
			}
			update packets;
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketSharingController.updatePacketUsers | exception = ' + ex.getMessage());
		}
	}

	// DONE
	public static void insertCustomerSharing(List<Packet__c> packets) {
		try {
			Set<Id> acctIds = new Set<Id>();
			for (Packet__c p : packets) {
				acctIds.add(p.Account__c);
			}
			Map<Id, Account> accts = new Map<Id, Account>(PacketSharingUtil.getAccountsWithUsers(acctIds));
			List<Packet__Share> shares = new List<Packet__Share>();
			for (Packet__c p : packets) {
				Account acct = accts.get(p.Account__c);
				for (User u : acct.Users) {
					shares.add(PacketSharingUtil.createPacketShare(p.Id, u.Id));
				}
			}
			insert shares;
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketSharingController.insertCustomerSharing | exception = ' + ex.getMessage());
		}
	}

	// DONE
	public static void insertGroupMembers(List<User> users, String groupName) {
		try {
			List<GroupMember> members = new List<GroupMember>();
			Id groupId = PacketSharingUtil.getGroupIdByName(groupName);
			for (User u : users) {
				members.add(PacketSharingUtil.createGroupMember(u.Id, groupId));
			}
			if (!Test.isRunningTest()) {
				insert members;
			}
		} catch(Exception ex) {
			// TODO: handle exception
			System.debug('PacketSharingController.insertGroupMembers | exception = ' + ex.getMessage());
		}
	}

}