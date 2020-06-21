public without sharing class PacketPDFController {
	String packetId;
	public Packet__c packet {get;set;}
	public List<Packet_Flight__c> flights {get;set;}
	public List<MenuSection> menuSections {get;set;}
	public Packet_Member__c memberAdmin {get;set;}
	public Packet_Member__c memberIfc {get;set;}
	public Packet_Member__c memberCaterer {get;set;}
	public Packet_Member__c memberPlanner {get;set;}
	public Station station1 {get;set;}
	public Station station2 {get;set;}
	public Station station3 {get;set;}

	public PacketPDFController() {
		packetId = ApexPages.currentPage().getParameters().get('packetId');
		if (packetId != null) {
			packet = (Packet__c)QueryUtil.queryRecord('Packet__c', 'Id = \'' + packetId + '\'');
			flights = (List<Packet_Flight__c>)QueryUtil.queryRecords('Packet_Flight__c', 'Packet__c = \'' + packetId + '\'', 'Departure_Date_Time__c ASC', null);		
			createMembers();
			createStations();
			createMenuSections();
		}
	}

	public void createMembers() {
		List<Packet_Member__c> members = (List<Packet_Member__c>)QueryUtil.queryRecords('Packet_Member__c', 'Packet__c = \'' + packetId + '\'', 'Name ASC', null);
		if (members.size() > 0) {
			for (Packet_Member__c m : members) {
				if (m.Member_Type__c == BaseObjectConstant.PACKETMEMBERTYPE_UNITED) {
					memberAdmin = m;
				} else if (m.Member_Type__c == BaseObjectConstant.PACKETMEMBERTYPE_IFC) {
					memberIfc = m;
				} else if (m.Member_Type__c == BaseObjectConstant.PACKETMEMBERTYPE_CATERER) {
					memberCaterer = m;
				} else if (m.Member_Type__c == BaseObjectConstant.PACKETMEMBERTYPE_PLANNER) {
					memberPlanner = m;
				}
			}
		}
	}

	public void createStations() {
		List<Packet_Station__c> stations = (List<Packet_Station__c>)QueryUtil.queryRecords('Packet_Station__c', 'Packet__c = \'' + packetId + '\'', 'Station_Number__c ASC', null);
		if (stations.size() > 0) {
			Set<Id> acctIds = new Set<Id>();
			for (Packet_Station__c s : stations) {
				acctIds.add(s.Account__c);
			}
			Map<Id, List<User>> acctUsersMap = PacketUtil.getStationUsersMap(acctIds);
			for (Packet_Station__c s : stations) {
				List<User> stationUsers = acctUsersMap.get(s.Account__c);	
				User primary;
				User secondary;
				// Match user contacts
				for (User u : stationUsers) {
					// Find the primary's first match
					if (u.Primary_Contact__c && primary == null) {
						primary = u;

					// Find the secondary's first match
					} else if (!u.Primary_Contact__c && secondary == null) {
						secondary = u;
					}
				}
				Station st = new Station(s, primary, secondary);
				if (s.Station_Number__c == 1) {
					station1 = st;
				} else if (s.Station_Number__c == 2) {
					station2 = st;
				} else if (s.Station_Number__c == 3) {
					station3 = st;
				}
			}


		}
	}

	public void createMenuSections() {
		List<Packet_Line_Item__c> lineItems = (List<Packet_Line_Item__c>)QueryUtil.queryRecords('Packet_Line_Item__c', 'Packet__c = \'' + packetId + '\'', 'CreatedDate ASC', null);
          list<Packetwrapperclass> Packetwrapperclasslist = new list<Packetwrapperclass>();
                list<Packet_Line_Item__c> listpacketlineitems1=[select id,name,Product__c,Product__r.name,Packet__c,IT_Code__c,F__c,M__c,Y__c,Menu_Section__c,Notes__c,Custom_Product__c,Product_Name__c,Total_Quantity__c from Packet_Line_Item__c where Packet__c =:packetId And Menu_Section__c =:'Nosh Bag' And Nosh_Bags_Child__c =false];
        list<Packet_Line_Item__c> listpacketlineitems2=[select id,name,Product__c,Product__r.name,Packet__c,IT_Code__c,F__c,M__c,Y__c,Menu_Section__c,Notes__c,Custom_Product__c,Nosh_Bags_Child__c,Product_Name__c,Nosh_Bags__c,Total_Quantity__c from Packet_Line_Item__c where Packet__c =:packetId And Menu_Section__c =:'Nosh Bag' And Nosh_Bags_Child__c =true];
       list<Packet_Line_Item__c> packetlist = new list<Packet_Line_Item__c>();
        Packet_Line_Item__c newpacket = new Packet_Line_Item__c();
        if(listpacketlineitems1 .size()>0){
        for(Packet_Line_Item__c PacketItem : listpacketlineitems1){
             packetlist = new list<Packet_Line_Item__c>();
          
            for(Packet_Line_Item__c PacketItem1 : listpacketlineitems2){
               
                if(PacketItem.Product_Name__c ==PacketItem1.Nosh_Bags__c){
                    packetlist.add(PacketItem1);
                }
                
            }
            if(packetlist.size() == 0){
               packetlist.add(newpacket);  
            }
                
            
                 Packetwrapperclasslist.add(new Packetwrapperclass(PacketItem,packetlist));
        }
        }
		menuSections = new List<MenuSection>();
		for (String s : CommonUtil.getMenuSections()) {
            if(s != 'Nosh Bag'){
			List<Packet_Line_Item__c> items = new List<Packet_Line_Item__c>();	
			for (Packet_Line_Item__c item : lineItems) {
				if (item.Menu_Section__c == s) {
					items.add(item);
				}
			}
			MenuSection ms = new MenuSection(s, items ,new  list<Packetwrapperclass>());
			menuSections.add(ms);
            }else{
           MenuSection ms = new MenuSection(s, new List<Packet_Line_Item__c>() ,Packetwrapperclasslist);
			menuSections.add(ms);     
            }
		}
	}

	public class MenuSection {
		public String SectionName {get;set;}
		public List<Packet_Line_Item__c> Items {get;set;}
        public  list<Packetwrapperclass> Packetwrapperclasslist {get;set;}
		public MenuSection(String sectionName, List<Packet_Line_Item__c> items,list<Packetwrapperclass> Packetwrapperclasslist) {
			this.SectionName = sectionName;
			this.Items = items;
            this.Packetwrapperclasslist = Packetwrapperclasslist;
		}
	}

	public class Station {
		public Packet_Station__c Station {get;set;}
		public User PrimaryContact {get;set;}
		public User SecondaryContact {get;set;}

		public Station(Packet_Station__c station, User primaryContact, User secondaryContact) {
			this.Station = station;
			this.PrimaryContact = primaryContact;
			this.SecondaryContact = secondaryContact;
		}

	}
     public class Packetwrapperclass{
        @AuraEnabled public Packet_Line_Item__c mainpacket{get;set;}
        @AuraEnabled public list<Packet_Line_Item__c> Childpacketlist{get;set;}
        public Packetwrapperclass( Packet_Line_Item__c mainpacket,list<Packet_Line_Item__c> Childpacketlist){
            this.mainpacket = mainpacket;
            this.Childpacketlist =Childpacketlist;
            
        }
        
    }
}