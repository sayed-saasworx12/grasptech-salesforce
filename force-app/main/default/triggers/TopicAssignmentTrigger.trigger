trigger TopicAssignmentTrigger on TopicAssignment (after insert, after delete) {
    if (Trigger.isAfter) {
        TopicAssignmentTriggerHandler.handleAfter(
            Trigger.isInsert ? Trigger.new : Trigger.old
        );
    }
}