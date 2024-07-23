public with sharing class MaintenanceRequestHelper {
    public static void updateWorkOrders(List<Case> updWorkOrders, Map<Id, Case> nonUpdCaseMap) {
        Set<Id> validIds = new Set<Id>();
        
        for(Case c : updWorkOrders) {
            if(nonUpdCaseMap.get(c.Id).Status != 'Closed' && c.Status == 'Closed') {
                if(c.Type == 'Repair' || c.Type == 'Routine Maintenance') {
                    validIds.add(c.Id);
                }
            }
        }
        
        if(!validIds.isEmpty()) {
            List<Case> newCases = new List<Case>();
            Map<Id, Case> closedCases = new Map<Id, Case>([SELECT Id, Vehicle__c, Equipment__c, Equipment__r.Maintenance_Cycle__c, (SELECT Id, Equipment__c, Quantity__c FROM Equipment_Maintenance_Items_r) FROM Case WHERE Id IN :validIds]);
            Map<Id, Decimal> maintenanceCycles = new Map<Id, Decimal>();
            
            AggregateResult[] results = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c)cycle FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :validIds GROUP BY Maintenance_Request__c];
            
            for(AggregateResult ar : results) {
                maintenanceCycles.put((Id) ar.get('Maintenance_Request__c'), (Decimal) ar.get('cycle'));
            }
            
            for(Case cc : closedCases.values()) {
                Case nc = new Case (
                ParentId = cc.Id,
                Status = 'New',
                Subject = 'Routine Maintenance',
                Type = 'Routine Maintenance',
                Vehicle__c = cc.Vehicle__c,
                Equipment__c = cc.Equipment__c,
                Origin = 'Web',
                Date_Reported__c = Date.today()
                    );
                
                if(maintenanceCycles.containsKey(cc.Id)) {
                    nc.Date_Due__c = Date.today().addDays((Integer) maintenanceCycles.get(cc.Id));
                } else{
                    nc.Due_Date__c = Date.today().addDays((Integer) cc.Equipment__r.Maintenance_Cycle__c);
                }
                
                newCases.add(nc)
            }
            insert newCases;
            
            List<Equipment_Maintenance_Item__c> clonedWps = new List<Equipment__c>();
            
            for(Case nc : newCases) {
                for(Equipment_Maintenance_Item__c wp : closedCases.get(nc.ParentId).Equipment_Maintenance_Items_r) {
                    Equipment_Maintenance_Item__c wpClone = wp.clone();
                    wpClone.Maintenance_Request__c = nc.Id;
                    clonedWps.add(wpClone);
                }
            }
            insert clonedWps;
        }
    }
}