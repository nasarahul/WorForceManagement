//Sxchedulable class for BatchSync Batch Job
global with sharing class BatchSync_Scheduler implements Schedulable{
	public void execute(SchedulableContext ctx){
		BatchSync batchSync = new BatchSync();
		Database.executeBatch(batchsync,200);
	}
}