@isTest
public class TestDatafactory {
    public static List<Account> createAccountWithOpps(Integer numAccts, Integer numOppsPerAcct) {
        List<Account> accts = new List<Account>();
        for(Integer i = 0; i < numAccts; i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer j = 0; j < numAccts; j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for(Integer k = 0; k < numOppsPerAcct; k++) {
                opps.add(new Opportunity(Name = acct.name + ' Opportunity' + k,
                StageName = 'Prospecting',
                CloseDate = System.today().addMonths(1),
                AccountId = acct.Id));
            }
        }
        // Insert all opportunity for all accounts
        insert opps;
        return accts;
    }
}