@IsTest
public class GraspDataTopicBatchTest {

    @testSetup
    static void setupData() {

        String testTopicName = 'graspDATA_TEST';
        Topic t = new Topic(Name = testTopicName);
        insert t;

        Knowledge__kav kav = new Knowledge__kav(
            Title = 'Test Article',
            Language = 'en_US',
            UrlName = 'test-article',
            Has_GraspDATA_Topic__c = false
        );
        insert kav;

        insert new TopicAssignment(
            TopicId = t.Id,
            EntityId = kav.Id
        );
    }

    @IsTest
    static void testBatchBehavior() {

        Test.startTest();
        Database.executeBatch(new GraspDataTopicBatch('graspDATA_TEST'),50);
        Test.stopTest();

        Knowledge__kav result = [
            SELECT Has_GraspDATA_Topic__c
            FROM Knowledge__kav
            WHERE Title = 'Test Article'
            LIMIT 1
        ];

        System.assertEquals(true, result.Has_GraspDATA_Topic__c);
    }
}