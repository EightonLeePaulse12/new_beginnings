@isTest
private class LeadProcessorTest {
    @testSetup static void setup() {
        List<Lead> leads = new List<Lead>();
        // insert 200 records
        for(Integer i = 0; i < 200; i++) {
            leads.add(new Lead(salutation = 'Mr.', firstname='Joe ' + i, lastname='worked', status='Open - Not Contacted', company='jiro'));
        }
        insert leads;
    }
    @isTest static void test() {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
        
        System.assertEquals(200, [select count() from lead where leadSource = 'Dreamforce']);
    }
}