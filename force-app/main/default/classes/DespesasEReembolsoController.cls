public without sharing class DespesasEReembolsoController {
    private ApexPages.StandardSetController standardSetController;

    public List<Despesa_e_Reembolso__c> despesas { get; set; }

    public DespesasEReembolsoController(ApexPages.StandardController controller) {
        List<String> fieldsList = new List<String>();

        Map<String, Schema.SObjectField> fieldSchemaMap = Schema.getGlobalDescribe().get('Despesa_e_Reembolso__c').getDescribe().fields.getMap();

        for (String fieldName : fieldSchemaMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldSchemaMap.get(fieldName).getDescribe();

            if (fieldDescribe.isCreateable()) {
                fieldsList.add(fieldName);
            }
        }

        despesas = Database.Query(
            'SELECT ' + String.join(fieldsList, ', ') + ' FROM Despesa_e_Reembolso__c WHERE Id = \'' + controller.getId() + '\''
        );
    }

    public PageReference clonar() {
        Despesa_e_Reembolso__c clone = despesas[0].clone(false, true, false, true);
        clone.Status__c = 'Rascunho';
        clone.Name += ' - Clone';
        insert clone;

        PageReference redirectPage = new PageReference('/' + clone.Id);
        redirectPage.setRedirect(true);
        return redirectPage;
    }
}