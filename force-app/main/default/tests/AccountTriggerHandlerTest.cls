@isTest
public class AccountTriggerHandlerTest {
    /**
     * Test the handleBeforeInsert method.
     * Verify that accounts with blank names are not allowed to be inserted.
     */
    @isTest
    static void testHandleBeforeInsert() {
        Account accWithBlankName = new Account(Name = '');
        Account accWithValidName = new Account(Name = 'Valid Name');

        Test.startTest();
        try {
            insert new List<Account> { accWithBlankName, accWithValidName };
            System.assert(false, 'Account Name is not emptyu');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Account Name cannot be blank.'));
        }
        Test.stopTest();

        Account insertedAccount = [SELECT Id, Name FROM Account WHERE Name = 'Valid Name'];
        System.assertEquals('Valid Name', insertedAccount.Name);
    }

    /**
     * Test the handleBeforeUpdate method.
     * Verify that Technology Partner accounts must have a phone number.
     */
    @isTest
    static void testHandleBeforeUpdate() {
        Account acc = new Account(Name = 'Test Account', Type = 'Customer');
        insert acc;

        acc.Type = 'Technology Partner';
        acc.Phone = '';

        Test.startTest();
        try {
            update acc;
            System.assert(false, 'Account Phone is not empty');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Phone number is required for Technology Partner accounts.'));
        }
        Test.stopTest();
    }

    /**
     * Test the handleBeforeDelete method.
     * Verify that Technology Partner accounts cannot be deleted.
     */
    @isTest
    static void testHandleBeforeDelete() {
        Account acc = new Account(Name = 'Test Account', Type = 'Technology Partner');
        insert acc;

        Test.startTest();
        try {
            delete acc;
            System.assert(false, 'Expected a DmlException due to attempt to delete Technology Partner account.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot delete Technology Partner accounts.'));
        }
        Test.stopTest();
    }

    /**
     * Test the handleAfterInsert method.
     * Verify that a task is created for Technology Partner accounts upon insert.
     */
    @isTest
    static void testHandleAfterInsert() {
        Account acc = new Account(Name = 'Tech Partner Account', Type = 'Technology Partner');
        
        Test.startTest();
        insert acc;
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(1, tasks.size());
        System.assertEquals('Follow up with Technology Partner', tasks[0].Subject);
    }

    /**
     * Test the handleAfterUpdate method.
     * Verify that a task is created for accounts updated to Technology Partner.
     */
    @isTest
    static void testHandleAfterUpdate() {
        Account acc = new Account(Name = 'Test Account', Type = 'Customer');
        insert acc;

        acc.Type = 'Technology Partner';

        Test.startTest();
        update acc;
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(1, tasks.size());
        System.assertEquals('Follow up with Technology Partner', tasks[0].Subject);
    }

    /**
     * Test the handleAfterUndelete method.
     * Verify that a task is created for undeleted Technology Partner accounts.
     */
    @isTest
    static void testHandleAfterUndelete() {
        Account acc = new Account(Name = 'Tech Partner Account', Type = 'Technology Partner');
        insert acc;
        delete acc;

        Test.startTest();
        undelete acc;
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(1, tasks.size());
        System.assertEquals('Follow up with Technology Partner', tasks[0].Subject);
    }
}