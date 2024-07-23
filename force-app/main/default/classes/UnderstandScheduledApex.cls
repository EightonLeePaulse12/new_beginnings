/*
    - You can run Apex classes at a specified time
    - Run Maintenance tasks on Daily or Weekly basis
    - Implement Schedulable interface in Apex class
*/


// Syntax
global class UnderstandScheduledApex implements Schedulable {
    global void execute(SchedulableContext ctx) {
        // write some code
    }
}

//EXAMPLES:

// Task utils

public class Taskutils {
    public static void remindOwners(List<Opportunity> oppList) {
        // code
    }
}

// RemindOppOwners
public class RemindOppOwners implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Opportunity> oppList = [SELECT Id, Name, OwnerId, CloseDate FROM Opportunity WHERE IsClosed = false AND CloseDate < TODAY];

        TaskUtils.RemindOwners(oppList);
    }
}

// Schedulable timing: Seconds minutes hours dayofmonth month dayofweek year
// JobID: System.schedule('Name of schedule', time, instance of scheduled class)