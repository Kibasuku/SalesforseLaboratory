public with sharing class AccountTriggerHandler {
    /**
     * Handles the before insert trigger event.
     * @param newAccounts List of newly inserted accounts.
     */
    public static void handleBeforeInsert(List<Account> newAccounts) {
        for (Account acc : newAccounts) {
            if (String.isBlank(acc.Name)) {
                acc.addError('Account Name cannot be blank.');
            }
        }
    }

    /**
     * Handles the before update trigger event.
     * @param newAccounts List of updated accounts.
     * @param oldAccountMap Map of old accounts before the update.
     */
    public static void handleBeforeUpdate(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        for (Account acc : newAccounts) {
            Account oldAccount = oldAccountMap.get(acc.Id);
            if (oldAccount.Type != 'Technology Partner' && acc.Type == 'Technology Partner') {
                if (String.isBlank(acc.Phone)) {
                    acc.addError('Phone number is required for Technology Partner accounts.');
                }
            }
        }
    }

    /**
     * Handles the before delete trigger event.
     * @param oldAccountMap Map of old accounts before the delete.
     */
    public static void handleBeforeDelete(Map<Id, Account> oldAccountMap) {
        for (Account acc : oldAccountMap.values()) {
            if (acc.Type == 'Technology Partner') {
                acc.addError('Cannot delete Technology Partner accounts.');
            }
        }
    }

    /**
     * Handles after insert event for Account records.
     * Creates tasks for Technology Partner accounts.
     * @param newAccounts List of new Account records inserted.
     */
    public static void handleAfterInsert(List<Account> newAccounts) {
        createTasksForTechnologyPartners(newAccounts);
    }

    /**
     * Handles after update event for Account records.
     * Updates tasks for Technology Partner accounts.
     * @param newAccounts List of new Account records updated.
     * @param oldAccountMap Map of old Account records before update.
     */
    public static void handleAfterUpdate(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        createTasksForTechnologyPartners(newAccounts);
    }

    /**
     * Handles after delete event for Account records.
     * Creates tasks for deleted Technology Partner accounts.
     * @param oldAccountMap List of deleted Account records.
     */
    public static void handleAfterDelete(Map<Id, Account> oldAccountMap) {
            createTasksForTechnologyPartners(oldAccountMap.values());
    }

    /**
     * Handles after undelete event for Account records.
     * Creates tasks for Technology Partner accounts that were undeleted.
     * @param undeletedAccounts List of undeleted Account records.
     */
    public static void handleAfterUndelete(List<Account> undeletedAccounts) {
        createTasksForTechnologyPartners(undeletedAccounts);
    }

    /**
     * Creates tasks for Technology Partner accounts.
     * @param accounts List of Account records to process.
     */
    private static void createTasksForTechnologyPartners(List<Account> accounts) {
        List<Task> tasksToCreate = new List<Task>();
        for (Account acc : accounts) {
            if (acc.Type == 'Technology Partner') {
                Task task = new Task(
                    Subject = 'Follow up with Technology Partner',
                    Priority = 'High',
                    Status = 'Not Started',
                    WhatId = acc.Id,
                    ActivityDate = Date.today().addDays(7)
                );
                tasksToCreate.add(task);
            }
        }
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
}