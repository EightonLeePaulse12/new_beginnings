trigger TriggerPractice on Account (after update) {
    Map<Id, Account> accMap = new Map<Id, Account>();
    
    if(trigger.isAfter && trigger.isUpdate) {
        
        if(!trigger.new.isEmpty()) {
            
            for(Account acc : trigger.new) {
                if(trigger.oldMap.get(acc.Id).Phone != acc.Phone) {
                    accMap.put(acc.Id, acc);
                }
            }
            
        }
    }
    
    List<Contact> conList = [SELECT Id, AccountId, Phone FROM Contact WHERE AccountId IN :accMap.keySet()];
    List<Contact> listToUpdateContacts = new List<Contact>();
    if(!conList.isEmpty()) {
        for(Contact con : conList) {
            con.Phone = accMap.get(con.AccountId).Phone;
            listToUpdateContacts.add(con);
        }
    }
    
    if(!listToUpdateContacts.isEmpty()) {
        update listToUpdateContacts;
    }
}

// Update Parent from child

trigger conTrigger on Contact (after Update) {
    
    Set<Id> accIds = new Set<Id>();
    
    if(trigger.isAfter && trigger.isUpdate) {

        if(!trigger.new.isEmpty()) {

            for(Contact con : trigger.new) {

                if(con.AccountId != null && trigger.oldMap.get(con.Id).Description != con.Description) {
                    accIds.add(con.AccountId);
                }
            }
        }
    }
    
    Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Description FROM Account WHERE Id IN :accIds]);
    List<Account> listToBeUpdated = new List<Account>();
    
    if(!trigger.new.isEmpty()) {

        for(Contact cont : trigger.new) {

            Account acc = accMap.get(cont.AccountId);
            acc.Description = cont.Description;
            listToUpdated.add(acc);
        }
    }

    if(!listToBeUpdated.isEmpty()) {
        update listToBeUpdated; 
    }
    
}