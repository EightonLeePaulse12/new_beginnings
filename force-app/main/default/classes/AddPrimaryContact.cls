public class AddPrimaryContact implements Queueable {
    private Contact c;
    private String state;

    public AddPrimaryContact(Contact c, String state) {
        this.c = c;
        this.state = state;
    }

    public void execute(QueueableContext context) {
        List<Account> listAccount = [SELECT ID, Name, (SELECT Id, FirstName, LastName FROM Contacts) FROM ACCOUNT WHERE BillingState = :state LIMIT 200];
        List<Contact> listContact = new List<Contact>();
        for(Account acc : listAccount) {
            Contact cont = c.clone(false, false, false, false);
            cont.accountId = acc.id;
            listContact.add(cont);
        }
        if(listContact.size() > 0) {
            insert listContact;
        }
    }
}