@isTest
public class TestRestrictContactByName {
    @isTest static void testContactName() {
        Contact cont = new Contact(LastName = 'INVALIDNAME');
        try{
            insert cont;
        } catch (Exception e) {
            System.assertEquals(e.getMessage(), 'Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The last name "INVALIDNAME" is not allowed for DML: []');
        }
    }
}