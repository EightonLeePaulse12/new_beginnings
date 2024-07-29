public with sharing class UnderstandingIntegration {
    public learnIntegration() {
        // We have a JSON string:
        /*
            {
                "FirstName": "Apex",
                "LastName": "Learning"
            }
        */

        // And we have an Apex class:
        /*
            public class Student {
            public String FirstName;
            public String LastName;
            }
        */

        // JSON to Apex Deserialization
        /*
            String jsonString = '{"FirstName": "Apex", "LastName": "Learning"}';
            Student st = (Student) System.JSON.deserialize(jsonString, Student.class);
            st - WILL GIVE YOU ACCESS TO THAT JSON DATA
        */
        // Apex uses Http, HttpRequest & HttpResponse to perform callouts
        // Apex also includes a JSON class, that makes it very easy to work with JSON strings.
    }
    
}