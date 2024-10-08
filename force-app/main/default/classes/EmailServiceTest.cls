@IsTest
public class EmailServiceTest {
    @IsTest
    static void testSendEmailWithAttachment() {

        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('This is a test PDF file content'),
            IsMajorVersion = true
        );
        insert testContentVersion;

        List<ContentDocument> testContentDocument = [SELECT Id FROM ContentDocument];

        EmailService.EmailParams params = new EmailService.EmailParams();
        params.recipientEmail = 'recipient@example.com';
        params.senderEmail = 'sender@example.com'; 
        params.subject = 'Test Email';
        params.body = 'This is a test email body';
        params.contentDocumentId = testContentDocument[0].Id;

        Test.startTest();
            EmailService.sendEmailWithAttachment(new List<EmailService.EmailParams> { params });
        Test.stopTest();
    }
    
    @IsTest
    static void testSendEmailWithoutSender() {
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('This is a test PDF file content'),
            IsMajorVersion = true
        );
        insert testContentVersion;

        List<ContentDocument> testContentDocument = [SELECT Id FROM ContentDocument];

        EmailService.EmailParams params = new EmailService.EmailParams();
        params.recipientEmail = 'recipient@example.com';
        params.subject = 'Test Email Without Sender';
        params.body = 'This is a test email body without sender';
        params.contentDocumentId = testContentDocument[0].Id;

        Test.startTest();
        EmailService.sendEmailWithAttachment(new List<EmailService.EmailParams> { params });
        Test.stopTest();
    }
}