trigger UserTrigger on User (after insert) {
	if (Trigger.isAfter) {	
		if (Trigger.isInsert) {
			// Add new users to groups
			System.debug('UserTrigger.afterInsert | adding # users = ' + Trigger.new);
			PacketSharingHandler.addUsersToGroups(Trigger.new);
		} 
	}
}