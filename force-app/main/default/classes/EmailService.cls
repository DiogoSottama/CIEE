public without sharing class EmailService {
    
    @InvocableMethod(label = 'Send Email with Attachments')
    public static void sendEmailWithAttachment(List<EmailParams> lstEmail) {
        EmailParams params = lstEmail[0];

        ContentVersion contentVersion = [SELECT Id, Title, VersionData 
                                         FROM ContentVersion 
                                         WHERE ContentDocumentId = :params.contentDocumentId 
                                         LIMIT 1];

        Blob attachmentBlob = contentVersion.VersionData;

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { params.recipientEmail });
        email.setSubject(params.subject);
        email.setHtmlBody(params.body);

        if(!String.isBlank(params.senderEmail)){
            List<OrgWideEmailAddress> emails = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :params.senderEmail];
            if(emails.size() > 0){
                email.setOrgWideEmailAddressId(emails[0].Id);
            }
        }
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setBody(attachmentBlob);
        attachment.setFileName(contentVersion.Title + '.pdf');
        
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }

    public class EmailParams{
        @InvocableVariable
        public String recipientEmail;

        @InvocableVariable
        public String senderEmail;

        @InvocableVariable
        public String subject;

        @InvocableVariable
        public String body;

        @InvocableVariable
        public String contentDocumentId;
    }
}