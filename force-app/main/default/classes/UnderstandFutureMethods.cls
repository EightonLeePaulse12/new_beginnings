/*
    Future methods are used:
    - To make callouts to external web services
    - as a process that needs to be executed in a seperate or its own thread
    - Isolating DML operations on different sObject types to prevent the mixed DML error
     */

global class UnderstandFutureMethods {
    @future // Syntax for making a method a future method
    public static void futureMethod(List<Id> recordIds) { // Future method will make it so that this method only runs if the resources are available OR if this needs to run in its own thread
        List<Account> accounts = [SELECT Id from Account WHERE ID in :recordIds];
        // some operation
    }
    
    @future
    public static void countContacts(List<Id> accId) {
        List<Account> accList = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accId];
        
        for(Account acc : accList) {
            acc.Number_of_Contacts__c = acc.Contacts.size();
        }
        if(!accList.isEmpty()) {
            update accList;
        }
    }
}