trigger TestTrigger on Account (before insert, before update) {

    for (Account acc : Trigger.NEW) {
        if (Trigger.isInsert) {
            TestClass.onInsert(acc);
        }
        if (Trigger.isUpdate) {
            TestClass.onUpdate(acc);
        }
    }
}