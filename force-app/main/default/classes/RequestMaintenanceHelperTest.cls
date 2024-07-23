@isTest
public with sharing class MaintenanceRequestHelperTest {
    
    private static final string STATUS_NEW = 'New';
    private static final string WORKING = 'Working';
    private static final string CLOSED = 'Closed';
    private static final string REPAIR = 'Repair';
    private static final string REQUEST_ORIGIN = 'Web';
    private static final string REQUEST_TYPE = 'Routine Maintenance';
    private static final string REQUEST_SUBJECT = 'Testing subject';

    private static Vehicle__c createVehicle() {
        Vehicle__c vehicle = new Vehicle__c(name = 'SuperTruck');
        return vehicle;
    }

    private static product2 createEquipment() {
        product2 equipment = new product2(
            name = 'SuperEquipment',
            lfiespan_months__c = 10,
            maintenance_cycle__c = 10,
            replacement_part__c = true
        );
        return equipment;
    }

    private static Case createMaintenanceRequest(Id vehicleId, Id equipmentId) {
        Case cs = new Case(
            Type = REPAIR,
            Status = STATUS_NEW,
            Origin = REQUEST_ORIGIN,
            Subject = REQUEST_SUBJECT,
            Equipment__c = equipmentId,
            Vehicle__c = vehicleId
        );
        return cs;
    }

    private static Equipment_Maintenance_Item__c createWorkPart(Id equipmentId, Id requestId) {
        Equipment_Maintenance_Item__c wp = new Equipment_Maintenance_Item__c(
            Equipment__c = equipmentId,
            Maintenance_Request__c = requestId
        );
        return wp;
    }

    @isTest static void testMaintenanceRequestPositive() {
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        Id vehicleId = vehicle.Id;

        Product2 equipment = createEquipment();
        insert equipment;
        Id equipmentId = equipment.Id;

        Case somethingToUpdate = createMaintenanceRequest(vehicleId, equipmentId);
        insert somethingToUpdate;

        Equipment_Maintenance_Item__c workP = createWorkPart(equipmentId, somethingToUpdate.Id);
        insert workP;

        test.startTest();
            somethingToUpdate.status = CLOSED;
            update somethingToUpdate;
        test.stopTest();

        Case newRequest = [SELECT Id, Subject, Type, Equipment__c, Date_Reported__c, Vehicle__c, Date_Due__c FROM Case WHERE Status = :STATUS_NEW];

        Equipment_Maintenance_Item__c workPart = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :newRequest.Id];

        System.assert(workPart != null);
        System.assert(newRequest.Subject != null);
        System.assertEquals(newRequest.Type, REQUEST_TYPE);
        System.assertEquals(newRequest.Equipment__c, equipmentId);
        System.assertEquals(newRequest.Vehicle__c, vehicleId);
        System.assertEquals(newRequest.Date_Reported__c, System.Today());
    }

    @isTest static void testMaintenanceRequestNegative() {
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        Id vehicleId = vehicle.Id;

        Product2 equipment = createEquipment();
        insert equipment;
        Id equipmentId = equipment.Id;

        Case emptyReq = createMaintenanceRequest(vehicleId, equipmentId);
        insert emptyReq;

        Equipment_Maintenance_Item__c workP = createWorkPart(equipmentId, emptyReq.Id);
        insert workP;

        test.startTest();
            emptyReq.Status = WORKING;
            update emptyReq;
        test.stopTest();

        List<Case> allRequests = [SELECT Id FROM Case];

        Equipment_Maintenance_Item__c workPart = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :emptyReq.Id];

        System.assert(workPart != null);
        System.assert(allRequests.size() == 1);
    }

    @isTest static void testMaintenanceRequestBulk() {
        List<Vehicle__c> vehicleList = new List<Vehicle__c>();
        List<Product2> equipmentList = new List<Product2>();
        List<Equipment_Maintenance_Item__c> workPartList = new List<Equipment_Maintenance_Item__c>();
        List<Case> requestList = new List<Case>();
        List<Id> oldRequestIds = new List<Id>();

        for(Integer i = 0; i < 500; i++) {
            vehicleList.add(createVehicle());
            equipmentList.add(createEquipment());
        }
        insert vehicleList;
        insert equipmentList;

        for(Integer i = 0; i < 500; i++) {
            requestList.add(createMaintenanceRequest(vehicleList.get(i).Id, equipmentList.get(i).Id));
        }
        insert requestList;

        for(Integer = i; i < 500; i++) {
            workPartList.add(createWorkPart(equipmentList.get(i).Id, requestList.get(i).Id));
        }
        insert workPartList;

        test.startTest();
            for(Case req : requestList) {
                req.status = CLOSED;
                oldRequestIds.add(req.Id);
            }
            update requestList;
        test.stopTest();

        List<Case> allRequests = [SELECT Id FROM Case WHERE status = :STATUS_NEW];

        List<Equipment_Maintenance_Item__c> workParts = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :oldRequestIds];

        System.assert(allRequests.size() == 500);
    }
}