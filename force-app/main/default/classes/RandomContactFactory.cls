public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer contsToGenerate, String surname) {
        List<Contact> conts = new List<Contact>();
        for(Integer i = 0; i < contsToGenerate; i++) {
            Contact cont = new Contact(FirstName = 'Test ' + i, LastName = surname);
            conts.add(cont);
        }
        return conts;
    }
}