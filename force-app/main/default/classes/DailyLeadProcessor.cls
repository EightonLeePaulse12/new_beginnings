public class DailyLeadProcessor implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Lead> listOfLeads = [SELECT Id, FirstName, LastName FROM Lead WHERE LeadSource = null LIMIT 200];
        if(listOfLeads.size() > 0) {
            List<Lead> newLeads = new List<Lead>();
            for(Lead lead : listOfLeads) {
            lead.LeadSource = 'Dreamforce';
            newLeads.add(lead);
        }
        update newLeads;
        }
    }
}