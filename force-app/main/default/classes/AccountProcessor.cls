public with sharing class AccountProcessor {
    @future public static void countContacts(List<Id> accountIds) {
        // List to bulkify trigger
        List<Account> accToUpdate = new List<Account>();
        // add to account and associated contacts to a list 
        List<Account> accs = [SELECT Id, name, (SELECT ID FROM Contacts) FROM Account WHERE Id IN :accountIds];
        // Iterate all the accounts one by one
        for(Account acc : accs) {
            // create list for contacts
            List<Contact> contactList = acc.contacts;
            // size of the list in this field
            acc.Number_Of_Contacts__c = contactList.size();
            // added the accounts to the list
            accToUpdate.add(acc);
        }
        update accToUpdate;
    }
}