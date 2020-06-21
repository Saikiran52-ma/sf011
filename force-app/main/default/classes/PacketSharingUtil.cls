public class PacketSharingUtil {

	public static Id getGroupIdByName(String groupName) {
		return [SELECT Id FROM Group WHERE Name = :groupName LIMIT 1].Id;
	}

	public static GroupMember createGroupMember(Id userId, Id groupId) {
		GroupMember gm = new GroupMember();
		gm.UserOrGroupId = userId;
		gm.GroupId = groupId;
		return gm;
	}

	public static List<User> getUsersByAccountIds(Set<Id> acctIds) {
		return [SELECT Id FROM User WHERE AccountId IN :acctIds];
	}

	public static List<Packet__Share> getPacketShares(Set<Id> packetIds, Set<Id> userIds) {
		return [SELECT Id FROM Packet__Share WHERE ParentId IN :packetIds AND UserOrGroupId IN :userIds];
	}

	public static Packet__Share createPacketShare(Id packetId, Id userId) {
		Packet__Share share = new Packet__Share();
		share.ParentId = packetId;
		share.UserOrGroupId = userId;
		share.AccessLevel = 'Edit';
		return share;
	}

	public static List<Account> getAccountsWithUsers(Set<Id> acctIds) {
		return [SELECT Id, (SELECT Id FROM Users WHERE IsActive = true) FROM Account WHERE Id IN :acctIds];
	}

	public static List<Packet__c> getPackets(Set<Id> packetIds) {
		return [SELECT Id FROM Packet__c WHERE Id IN :packetIds];
	}
}