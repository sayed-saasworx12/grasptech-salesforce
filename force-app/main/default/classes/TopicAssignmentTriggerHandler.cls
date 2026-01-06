public with sharing class TopicAssignmentTriggerHandler {

    public static void handleAfter(List<TopicAssignment> records) {

        Set<Id> knowledgeArticleIds = new Set<Id>();

        for (TopicAssignment ta : records) {
            if (
                ta.EntityType == 'Knowledge' &&
                ta.TopicId != null &&
                ta.EntityId != null
            ) {
                knowledgeArticleIds.add(ta.EntityId);
            }
        }

        if (!knowledgeArticleIds.isEmpty()) {
            System.enqueueJob(
                new GraspDataKnowledgeQueueable(knowledgeArticleIds)
            );
        }
    }
}