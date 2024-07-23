public class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    public Integer recordsPassed = 1;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Lead');
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToAdd = new List<Lead>();
        for(Lead lead : scope) {
            lead.leadSource = 'Dreamforce';
            leadsToAdd.add(lead);
            recordsPassed = recordsPassed++;
        }
        update leadsToAdd;
    }
    public void finish(Database.BatchableContext bc) {
        System.debug(recordsPassed + ' records processed!');
        AsyncApexJob aaj = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bc.getJobId()];
    }
}