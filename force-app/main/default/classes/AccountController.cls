public with sharing class AccountController {
    
     /**
     * Fetches a list of accounts based on the provided search key.
     * @param searchKey The search key to filter accounts by name.
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String searchKey) {
        String searchKeyword = '%' + searchKey + '%';
        return [SELECT Id, Name, Type, CreatedDate, Owner.Name
                FROM Account
                WHERE Name LIKE :searchKeyword 
                OR Type LIKE :searchKeyword 
                OR Owner.Name LIKE :searchKeyword
                LIMIT 50];
    }

    
    // Creates a new account with the provided name and type.
    @AuraEnabled
    public static void createAccount(String name, String type) {
        Account acc = new Account(Name = name, Type = type);
        insert acc;
    }
}