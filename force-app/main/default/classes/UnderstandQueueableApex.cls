/*
    Queueable Apex:
    - Is a superset of future methods with extra features
    - Combination of future methods and batch apex
    - works beyond primitive arguments
    - Called by a simple System.enqueueJob() method.
    - enqueueJob() returns a job ID that can be monitored
*/

// Additional benefits:
// - Non-primitive types
// - Monitoring
// - Chaining Jobs

public class UnderstandQueueableApex implements Queueable {
    public void execute(QueueableContext ctx) {
        // code
    }
}

// Example of Queueable method that updates certain parent account records:

public class UpdateParentAccount implements Queueable {
    
    private List<Account> accList; // List of accounts
    private Id parentAccId;

    public UpdateParentAccount(List<Account> accRecords, Id id) {
        this.accList = accRecords;
        this.parentAccId = id;
    }

    public void execute(QueueableCOntext ctx) {
        for(Accoutn acc: accList) {
            acc.ParentId = parentAccId;  
        }
    }
}

// How to execute this method:
    List<Account> accList = [SELECT Id FROM Account WHERE BillingState = 'NY'];

    Id parentId = [SELECT Id FROM Account WHERE Name='Account 025'][0].Id;

    UpdateParentAccount updateJob = new UpdateParentAccount(accList, parentId);
    Id jobId = System.enqueueJob(updateJob);

// Test class for this method:
@isTest
public class UpdateParentAccountTest {
    @testSetup
    static void testSetup() {
        List<Account> accList = new List<Account>;

        accList.add(new Account(Name='Parent'));

        for(Integer 1 = 0; i < 100; i++) {
            accList.add(new Account(name='Test Account' + 1));
        }

        insert accList;
    }

    @isTest
    static void testQueueable() {
        Id parentId = [SELECT Id FROM Account WHERE Name = 'Parent'][0].Id;

        List<Account> accList = [SELECT Id, Name FROM Account WHERE Name Like 'Test Account%'];

        UpdateParentAccount updateJob = new UpdateParentAccount(accList, parentId);
        Test.startTest();
            System.enqueueJob(updateJob);
        Test.stopTest();

        System.assertEquals(100, [SELECT COUNT() FROM Account WHERE parentId = :parentId]);
    }
}