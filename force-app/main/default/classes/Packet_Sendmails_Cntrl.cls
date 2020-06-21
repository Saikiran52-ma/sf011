public class Packet_Sendmails_Cntrl {
    @future(callout = true)
    public static void sendmailtoCharterPlanner( string newPacketsId){
        
        try{
            packet__c packet = [select id,name,Charter_Departure_Date__c,Account__c,Account__r.name,Departure_Location__c,Arrival_Location__c,Charter_Aircraft__r.name	 from packet__c where Id=:newPacketsId];
            list<Packet_Member__c> packetmemberlist = [select id,name,Packet__c,Member_Type__c,Member_Email__c,Email__c from Packet_Member__c where Packet__c =:newPacketsId AND Member_Type__c ='Charter Planner' limit 1	];
            PageReference pdf =  Page.PacketPDF;
            pdf.getParameters().put('packetId',newPacketsId);
            // Take the PDF content
            Blob b;
            
            if(Test.isRunningTest()) { 
                b = Blob.valueOf('Unit.Test');
            } else {
                b = pdf.getContent();
            }
                        date date1 = packet.Charter_Departure_Date__c;

            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(formatDate(date1) +  ' '+ packet.Account__r.name +' '+  packet.Departure_Location__c+'-'+packet.Arrival_Location__c + ' '+ packet.Charter_Aircraft__r.name  +'.pdf');
            efa.setBody(b);
            String email ;
            if(packetmemberlist[0].Member_Email__c !=null){
                email = packetmemberlist[0].Member_Email__c;
            }
            else{
                email = packetmemberlist[0].Email__c; 
            }
            
            String[] emailList = email.split(',');
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = emailList;
            message.optOutPolicy = 'FILTER';
            message.subject = '“Charter Catering Packet Notification”';
            String body ='Hello, <br/><br/> Attached is Packet <b>“'+ date1.month()+'/'+date1.day()+'/'+date1.year() + ' '+ packet.Account__r.name+' ' + packet.Departure_Location__c+'-'+packet.Arrival_Location__c+ +'”</b> for your reference.';
            
            message.setHtmlBody(body);
            message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            Messaging.SingleEmailMessage[] messages = 
                new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                
                System.debug('The email was sent successfully.');
            } 
        }catch(Exception Ex){
            
        }
        
    }      
    
    @future(callout = true)
    public static void sendmailtoCharterPlanner1( string newPacketsId){
        
        try{
            packet__c packet = [select id,name,Charter_Departure_Date__c,Account__c,Account__r.name,Departure_Location__c,Arrival_Location__c,Charter_Aircraft__r.name		 from packet__c where Id=:newPacketsId];
            
            PageReference pdf =  Page.PacketPDF;
            pdf.getParameters().put('packetId',newPacketsId);
            // Take the PDF content
            Blob b;
            
            if(Test.isRunningTest()) { 
                b = Blob.valueOf('Unit.Test');
            } else {
                b = pdf.getContent();
            }
             date date1 = packet.Charter_Departure_Date__c;
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(formatDate(date1)   +  ' '+packet.Account__r.name + ' ' + packet.Departure_Location__c+'-'+packet.Arrival_Location__c + ' '+ packet.Charter_Aircraft__r.name +'.pdf');
            efa.setBody(b);
            String email =Label.Advance_Shipment_Mails;
            
            
            String[] emailList = email.split(',');
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = emailList;
            message.optOutPolicy = 'FILTER';
            message.subject = '“Charter Catering Advance Shipment Notification”';
           
            String body ='Hello, <br/><br/> Please view the attached Packet <b>“'+ date1.month()+'/'+date1.day()+'/'+date1.year() +' ' + packet.Account__r.name+ ' '+ packet.Departure_Location__c+'-'+packet.Arrival_Location__c+'”</b> for Advance Shipment details.';
            
            message.setHtmlBody(body);
            message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            Messaging.SingleEmailMessage[] messages = 
                new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                
                System.debug('The email was sent successfully.');
            } 
        }catch(Exception Ex){
            
        }
        
    }  

 @future(callout = true)
    public static void sendmailtoCharterPlanner2( string newPacketsId){
        
        try{
            packet__c packet = [select id,name,Charter_Departure_Date__c,Account__c,Account__r.name,Departure_Location__c,Arrival_Location__c,Charter_Aircraft__r.name		 from packet__c where Id=:newPacketsId];
            list<Packet_Flight__c> flightlist=[select id,name,Aircraft_Stripping_Location__c,Arrival_Location__c,packet__c	from 	Packet_Flight__c where  packet__c =:newPacketsId And  Aircraft_Stripping_Location__c = True limit 1];
            Packet_Flight__c flight = new Packet_Flight__c();
            if(flightlist.size()>0){
              flight =   flightlist[0];
            }
            Account Acc =[select id,name,Location__c,(select id,name,Email,Primary_Contact__c from contacts where Primary_Contact__c =true) from Account  where Location__c =: flight.Arrival_Location__c];
            if(flight.Aircraft_Stripping_Location__c){
            PageReference pdf =  Page.PacketPDF;
            pdf.getParameters().put('packetId',newPacketsId);
            // Take the PDF content
            Blob b;
            
            if(Test.isRunningTest()) { 
                b = Blob.valueOf('Unit.Test');
            } else {
                b = pdf.getContent();
            }
                   date date1 = packet.Charter_Departure_Date__c;
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(formatDate(date1)  +' '  + packet.Account__r.name + ' ' + packet.Departure_Location__c+'-'+packet.Arrival_Location__c +''+ packet.Charter_Aircraft__r.name  +'.pdf');
            efa.setBody(b);
            String email =Acc.contacts[0].Email;
            
            
            String[] emailList = email.split(',');
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = emailList;
            message.optOutPolicy = 'FILTER';
            message.subject = '“Charter Catering Stripping Notification”';
         
            String body ='Hello, <br/><br/> Please strip inbound Ferry/Charter flight.';
            
            message.setHtmlBody(body);
            message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            Messaging.SingleEmailMessage[] messages = 
                new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                
                System.debug('The email was sent successfully.');
            } 
            }
        }catch(Exception Ex){
            
        }
        
    }  
    
    	public static String formatDate(Date d) {
		String s = String.valueOf(d).split(' ')[0];		// Returns YYYY-MM-DD
		String m = s.split('-')[1];
		String d1 = s.split('-')[2];
		String y = s.split('-')[0];
		String mName;
		System.debug('PacketUtil.formatDate() | m = ' + m);
		if (m == '01') {
			mName = 'Jan';
		} else if (m == '02') {
			mName = 'Feb';
		} else if (m == '03') {
			mName = 'Mar';
		} else if (m == '04') {
			mName = 'Apr';
		} else if (m == '05') {
			mName = 'May';
		} else if (m == '06') {
			mName = 'Jun';
		} else if (m == '07') {
			mName = 'Jul';
		} else if (m == '08') {
			mName = 'Aug';
		} else if (m == '09') {
			mName = 'Sep';
		} else if (m == '10') {
			mName = 'Oct';
		} else if (m == '11') {
			mName = 'Nov';
		} else {
			mName = 'Dec';
		}
		return d1+mName ;
	}
    
    
}