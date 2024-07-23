public with sharing class FutureMethods {
    @future public static void someFutureMethod(List<Id> recordIds) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :recordIds];
        // process account records after this
    }
}