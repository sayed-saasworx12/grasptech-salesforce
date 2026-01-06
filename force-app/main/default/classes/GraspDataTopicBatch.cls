global class GraspDataTopicBatch
    implements Database.Batchable<SObject>, Database.Stateful {

    global Set<Id> articleIdsWithTopic = new Set<Id>();

    // -------------------------------
    // START
    // -------------------------------
    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
            SELECT EntityId
            FROM TopicAssignment
            WHERE Topic.Name = 'graspDATA'
            AND EntityType = 'Knowledge'
            AND IsDeleted = FALSE
        ]);
    }

    // -------------------------------
    // EXECUTE
    // -------------------------------
    global void execute(Database.BatchableContext bc, List<TopicAssignment> scope) {

        for (TopicAssignment ta : scope) {
            if (ta.EntityId != null) {
                articleIdsWithTopic.add(ta.EntityId);
            }
        }
    }

    // -------------------------------
    // FINISH
    // -------------------------------
    global void finish(Database.BatchableContext bc) {

        List<Knowledge__kav> articlesToUpdate = new List<Knowledge__kav>();

        // 1️⃣ Set TRUE where topic exists
        if (!articleIdsWithTopic.isEmpty()) {
            for (Knowledge__kav kav : [
                SELECT Id, Has_GraspDATA_Topic__c
                FROM Knowledge__kav
                WHERE Id IN :articleIdsWithTopic AND PublishStatus = 'Draft'
            ]) {
                if (kav.Has_GraspDATA_Topic__c == false) {
                    kav.Has_GraspDATA_Topic__c = true;
                    articlesToUpdate.add(kav);
                }
            }
        }

        // 2️⃣ Reset FALSE where topic removed
        for (Knowledge__kav kav : [
            SELECT Id
            FROM Knowledge__kav
            WHERE Has_GraspDATA_Topic__c = TRUE
            AND Id NOT IN :articleIdsWithTopic
        ]) {
            kav.Has_GraspDATA_Topic__c = false;
            articlesToUpdate.add(kav);
        }

        if (!articlesToUpdate.isEmpty()) {
            update articlesToUpdate;
        }
    }
}