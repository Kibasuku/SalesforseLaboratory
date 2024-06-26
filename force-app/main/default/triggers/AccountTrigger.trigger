trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    // Check if the trigger is executing in a 'before' context
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            AccountTriggerHandler.handleBeforeDelete(Trigger.oldMap);
        }
    // Check if the trigger is executing in a 'after' context
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            AccountTriggerHandler.handleAfterDelete(Trigger.oldMap);
        } else if (Trigger.isUndelete) {
            AccountTriggerHandler.handleAfterUndelete(Trigger.new);
        }
    }
}