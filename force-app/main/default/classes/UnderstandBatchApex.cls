/*
Batch Apex must:
    - implement the Database.Batchable interface
    - include following methods: start, execute, finish
     */

/*
Start:
    - Collects the records that will be passed to the execute method for processing
    - called at the beginning of a Batch Apex Job
    - returns a Database.QueryLocator object or an Iterable that contains the records passed to the job
    - When QueryLocator object is used, governor limit for total number of records retrieved by SOQL queries is bypassed and 50 million records can be queried
    - With an Iterable, governor limit by SOQL queries is enforced
     */

/*
Execute:
    - Performs actual processing for each batch of data passed
    - Default batch size is 200
    - Batches of records can execute in any other, does not depend on the order in which they were retrieved from the start method
    - Takes a reference to the Database.BatchableContext object and a List<sObject> or a list of parameterized types
    - Use the returned list when using Database.QueryLocator
     */

/*
Finish:
    - Execute post-processing operations
    - Calls once after all batches are processed
    - example: sending an email process can be implemented in finish method
     */

public class UnderstandBatchApex implements Database.Batchable<sObject> {
    public (Database.QueryLocator | Iterable<sObject>) start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute method
    }
    
    public void execute(Database.BatchableContext bc, List<P> records) {
        // Process each batch of records
    }
    
    public void finish(Database.BatchableContext bc) {
        // execute post-processing operations
    }
}

// Invoking a batch class:

MyBatch myBatchObj = new MyBatch();
Id BatchId = Database.executeBatch(myBatchObj);

// Pass Batch Size if needed:
Id batchId = Database.executeBatch(myBatchObj, 100);

/*
AsyncApexJob Records:
    - Each Batch Apex invocation creates an AsyncApexJob record
    - It helps to track progress of the job
    
Example:
     */

AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchId];

// Example of Code:

public class oppProcessor implements Database.Batchable<sObject>, Database.stateful {§
    
    public Integer recordCount = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name FROM Opportunity]);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> oppList) {
        for(Opportunity op : oppList) {
            op.LeadSource = 'Web';
        }
        update oppList;
        recordCount = oppList.size();
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Total records Processed: ' + recordCount); 
    }
}