//Test Class for BatchSync class
private class BatchSync_Test{
	static testmethod void testBatchSync(){
		List<Case> lstCase = new List<Case>();
		//Creation of test records for Account
		Account newAccount = new Account();
		newAccount.name = 'Test Batch account';
		insert newAccount;
		//Creation of test records for Contact
		Contact newContact = new Contact();
		newContact.FirstName = 'Test Contact';
		newContact.LastName = 'Contact Test';
		insert newContact;
		//Creation of test records for Case
		for(integer i=0;i<=200;i++){
			Case objcase = new Case();
			objcase.ContactId = newContact.Id;
			objCase.AccountId= newAccount.Id;
			objCase.Status= 'Working;
			objCase.Origin = 'Phone';
			lstCase.add(objCase);			
		}
		insert lstCase;
		//updating status of Case records to Closed
		for(Case objCase: lstCase){
			objCase.Status = 'Closed';
		}
		update lstCase;
		Test.startTest();
		//Calling the MockHttpResponseGenerator class
		Test.setMock(HttpCalloutMock.class,new MockHttpResponseGenerator());
		BatchSync batchSync = new BatchSync();
		Datbase.executeBatch(batchSync,200);
		Test.stopTest();
		//START ASSERT
		List<Case>
 lstcase=[Select Id, ClosedFlag__c,secretKey__c where LastModifiedDate > Yesterday();];
		for(Case objCase : lstCase)
		{
			System.assert(false,objCase.ClosedFlag__c);
			System.assert(true,objCase.secretKey__c!=null);
		}			
		//STOP ASSERT
}
		
			
		
