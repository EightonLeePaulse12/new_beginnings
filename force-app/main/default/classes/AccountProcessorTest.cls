@isTest public class AccountProcessorTest {
    @isTest private static void testContactCount() {
        Account newAcc = new Account(Name = 'Test Account');
        insert newAcc;
        Contact newContact = new Contact();
        newContact.FirstName = 'Rahul';
        newContact.LastName = 'Soni';
        newContact.Description = 'Salesforce challanges';
        newContact.AccountId =  newAcc.id;
        insert newContact;
        Contact newContact2 = new Contact();
        newContact2.FirstName = 'Gagan';
        newContact2.LastName = 'Soni';
        newContact2.Description = 'Salesforce challanges';
        newContact2.AccountId = newAcc.id;
        insert newContact2;
        List<Id> accountIds = new List<Id>();
        accountIds.add(newAcc.Id);
        Test.startTest();
        AccountProcessor.countContacts(accountIds);
        Test.stopTest();
    }
}