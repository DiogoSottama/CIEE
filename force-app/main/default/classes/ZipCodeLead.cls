public with sharing class ZipCodeLead {
    public static void setAssignedUserByPostalCode(List<Lead> leadList) {
        Set<String> zipcodesSet = new Set<String>();
        for (Lead l : leadList) {
            zipcodesSet.add(l.PostalCode);
        }

        Map<String, ZipCode__c> mapCepToZipCode = new Map<String, ZipCode__c>();
        for (ZipCode__c zc : [SELECT Id, Assigned__c, Zip_Code__c FROM ZipCode__c WHERE Zip_Code__c IN :zipcodesSet]) {
            mapCepToZipCode.put(zc.Zip_Code__c, zc);
        }

        for (Lead l : leadList) {
            l.OwnerId = mapCepToZipCode.containsKey(l.PostalCode) ? mapCepToZipCode.get(l.PostalCode).Assigned__c : l.OwnerId;
        }
    }
}