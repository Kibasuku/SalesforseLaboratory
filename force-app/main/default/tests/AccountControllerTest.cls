
@isTest
private class AccountControllerTest {

    /**
     * Test method for AccountController.getAccounts.
     * Verifies that the method returns accounts based on the search key.
     */
    @isTest
    static void testGetAccounts() {
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(Name = 'Test Account 1', Type = 'Customer'));
        testAccounts.add(new Account(Name = 'Test Account 2', Type = 'Partner'));
        insert testAccounts;

        Test.startTest();
        List<Account> resultAccounts = AccountController.getAccounts('Test');
        Test.stopTest();


        System.assertEquals(2, resultAccounts.size());
    }

    /**
     * Test method for AccountController.createAccount.
     * Verifies that a new account is created successfully.
     */
    @isTest
    static void testCreateAccount() {
        Test.startTest();
        AccountController.createAccount('New Test Account', 'Technology Partner');
        Test.stopTest();

        List<Account> createdAccounts = [SELECT Id, Name, Type FROM Account WHERE Name = 'New Test Account'];
        System.assertEquals(1, createdAccounts.size());
    }
}