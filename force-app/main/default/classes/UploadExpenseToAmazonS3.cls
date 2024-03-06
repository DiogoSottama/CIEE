public class UploadExpenseToAmazonS3 implements Queueable, Database.AllowsCallouts {
    private static final String CALLOUT_URL = 'callout:AWS_S3';
    private static final String HTTP_METHOD = 'PUT';

    private final String FILE_TO_UPLOAD;
    private final String FILE_NAME;

    public UploadExpenseToAmazonS3(String fileToUpload, String fileName) {
        this.FILE_TO_UPLOAD = fileToUpload;
        this.FILE_NAME = fileName;
    }

    public void execute(QueueableContext qc) {
        HttpRequest request = new HttpRequest();
        request.setMethod(HTTP_METHOD);
        request.setEndpoint(CALLOUT_URL + '/' + FILE_NAME);
        request.setBody(FILE_TO_UPLOAD);
        
        HttpResponse response = new Http().send(request);

        System.debug(response.getBody());
    }
}