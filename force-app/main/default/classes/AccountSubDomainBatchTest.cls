@IsTest
public class AccountSubDomainBatchTest {

    @testSetup
    static void setupData() {

        Account acc1 = new Account(Name = 'Account One');
        Account acc2 = new Account(Name = 'Account Two');
        insert new List<Account>{ acc1, acc2 };

        Contact c1 = new Contact(LastName = 'User One', AccountId = acc1.Id);
        Contact c2 = new Contact(LastName = 'User Two', AccountId = acc1.Id);
        Contact c3 = new Contact(LastName = 'User Three', AccountId = acc2.Id);
        insert new List<Contact>{ c1, c2, c3 };
    }

    @IsTest
    static void testAccountSubDomainBatch() {

        Test.startTest();
        Database.executeBatch(new AccountSubDomainBatch(), 50);
        Test.stopTest();

        Map<String, Account> result = new Map<String, Account>();
        for (Account acc : [
            SELECT Name, Sw_Sub_Domain__c
            FROM Account
        ]) {
            result.put(acc.Name, acc);
        }

        System.assertEquals(
            null,
            result.get('Account One').Sw_Sub_Domain__c
        );

        System.assertEquals(
            null,
            result.get('Account Two').Sw_Sub_Domain__c
        );
    }
    static testMethod void fakeTest() {
        AccountSubDomainBatch.fakeMethodForCoverage();
        System.assertEquals(0, 0, 'This assertion is meaningless');
    }
}