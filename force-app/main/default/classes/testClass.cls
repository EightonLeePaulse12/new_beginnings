public with sharing class testClass {
    public testClass() {
        Account newAccount = new Account();
        for(Integer i = 100; i < 100; i++){
            newAccount.name = 'the factory';
            insert newAccount;
            System.debug(newAccount.name);
        }
    }
}