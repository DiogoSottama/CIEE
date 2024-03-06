public with sharing class KairosApiUtilsMock implements HttpCalloutMock{

    private static final String retrieveAllBodyAcc = buildRetrieveAllBodyAcc();
	private static final String retrieveAllBodyContract = buildRetrieveAllBodyContract();
	private final String  endpoint;

	public KairosApiUtilsMock(String endpoint) {
        this.endpoint = endpoint;
    }
   
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();

		if (endpoint == 'Retrieve all Accounts') {
            response.setBody(retrieveAllBodyAcc);
        }

        if (endpoint == 'Retrieve Contracts') {
            response.setBody(retrieveAllBodyContract);
        }

        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
		response.setStatus('Sucesso');
        return response;
    }

	private static String buildRetrieveAllBodyContract(){
		String body = '{';
		body += '"content":[{';
		body += '"id": 5675,';
		body += '"cnpj": "55186654000143",';
		body += '"cpf": null,';
		body += '"name": "BRUNO MANGINI DE PAULA MACHADO",';
		body += '"companyName": null,';
		body += '"tradeName": null,';
		body += '"cieeUnitId": 2407,';
		body += '"cieeUnitDescription": "NITEROI/RJ - UNID. OPERACAO",';
		body += '"managementId": 7,';
		body += '"managementDescription": "Rio de Janeiro",';
		body += '"companyType": "INDEPENDENT_PROFESSIONAL",';
		body += '"multiCompanyTypeId": 0,';
		body += '"multiCompany": false,';
		body += '"serviceType": "APPRENTICESHIP",';
		body += '"contractStatus": "FINALIZED",';
		body += '"contractSituationStatus": "ACTIVE",';
		body += '"companyStatus": "ACTIVE",';
		body += '"contractingMethod": "TRAINER",';
		body += '"companyId": 165287,';
		body += '"paymentMethod": null,';
		body += '"paymentMethodCategory": null,';
		body += '"ticketHabilitado": false';
		body += '}], "totalPages": 0}';
        return body;
	}



    private static String buildRetrieveAllBodyAcc() {
        String body = '{';
        body += '"content":[{';
		body += '"creationDate": "2021-05-19T12:31:06-03:00",';
		body += '"modifiedDate": "2021-05-20T12:53:33-03:00",';
		body += '"modifiedBy": "PROCESSAMENTO",';
		body += '"createdBy": "PROCESSAMENTO",';
		body += '"id": 161088,';
		body += '"companyName": "PORTOFARMA DROGARIA E MANIPULACAO DE FORMULAS LTDA",';
		body += '"cnpj": "55186654000143",';
		body += '"tradingName": "PORTOFARMA DROGARIA E MANIPULACAO DE FORMULAS LTDA",';
		body += '"corporateSegment": "PRIVATE",';
		body += '"state": "SP",';
		body += '"cpf": null,';
		body += '"name": null,';
		body += '"cei": 296043151088,';
		body += '"caepf": null,';
		body += '"cno": null,';
		body += '"registerValidity": null,';
		body += '"councilNumber": null,';
		body += '"classCouncil": null,';
		body += '"statusRegionalCouncil": false,';
		body += '"homePage": null,';
		body += '"companyType": "LEGAL_ENTITY",';
		body += '"statusCompany": "ACTIVE",';
		body += '"employees": 0,';
		body += '"serviceContractors": 0,			';
		body += '"codigoObjeto": "55186654000143",';
		body += '"chaveObjeto": 161088,';
		body += '"tipoEntidade": "EMPRESA",';
		body += '"isClassCouncilActive": false';
        body += '}], "totalPages": 0}';
        return body;
    }
}