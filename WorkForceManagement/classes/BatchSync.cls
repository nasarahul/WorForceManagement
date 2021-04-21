//Batch Class that runs in a scheduled manner at 12 AM daily and pick the Today CaseRecords
global class BatchSync implements DataBase.Batchable<Case>,Database.AllowCallOuts{
global DataBase.QueryLocator start(DataBase.BatchableContext Bc){
	string query = 'Select Id,AgentId__c,ClosedFlag__c,secretKey__c from Case where LastModfiedDate> Yerterday() and ClosedFlag__c =true';
	return DataBase.getQueryLocator(query);
}
//exceute method to pick the case records in the batch of 200
global void execute(DateBase.BatchableContext BC,List<Case> scope){
	//endpoint
	string endpoint;
	//List of RequestWrapper
	List<RequestWrapper> reqwrappers = new List<RequestWrapper>();
	//List of LogObject
	List<LogObject> lstLogObject = new List<LogObject>();
	
	for(case case: scope){
		if(case.ClosedFlag__c)
		{
			try{
				HttpRequest req = new HttpRequest();
				HttpResponse res= new HttpResponse();
				Http http = new Http();
				endpoint = 'https://nfapihub.herokuapp.com/';
				req.setHeader('Authorization',header);
				req.setHeader('Contect-Type','application/json');
				req.setEndpoint(endpoint);
				req.setMethod('POST');
				RequestWrapper reqwrapper = new RequestWrapper();
				//setting the case Id and AgentId__c of the case to RequestWrapper object.
				reqwrapper.id = case.Id;
				reqwrapper.agentid = case.AgentId__c;
				reqwrappers.add(reqwrapper);
				string body= json.serialize(reqwrappers);
				req.setBody(body);
				req.setCompressed(true);
				//Sending the http request
				if(!Test.isRunningTest()){
				res=http.send(req);
				//If res is successful
				if(res.getStatusCode = 200)
				{
				//desiarializing the json response into ResponseWrapper class
					ResponseWrapper lstresponsewrapper =(ResponseWrapper) JSON.desiliaze(res.getBody(),ResponseWrapper.class);
					if(lstresponsewrapper !=null){
						//setting the secretKey from json response
						case.secretKey__c = lstresponsewrapper.secretKey;}
					cases.add(case);
				}
				//If res is unsuccessful
				if(res.getStatusCode = 500)
				{
					//desiarializing the json response into ResponseWrapper class
					ResponseWrapper sJson =(ResponseWrapper) JSON.desiliaze(res.getBody(),ResponseWrapper.class);
					//inserting the LogObject
					LogObject obj = new LogObject();
					obj.error = sJson.error;
					obj.CaseId__c= case.Id;
					obj.Error_Type__c = 'WorkForce Integration Error';
					obj.Logged_In_User__c = Userinfo.getUserId();
					lstLogObject.add(obj);
				}
		
					//setting the ClosedFlag to False
					case.ClosedFlag__c = false;	
					cases.add(case);
				}			
		} 
				if(cases.size()>0)
				{
					//updating the casesList
					Database.update(cases,false);
				}
				if(lstLogObject.size()>0)
				{
					//inserting the LogObject List
					Database.insert(lstLogObject,false);
				}
			}
			//to hanlde the callout exception
			catch(System.CallOutException e)
			{
				LogObject obj = new LogObject();
				obj.Error_Code__c = e.errorCode;
				obj.Error_Line_Number__c = e. getLineNumber();
				obj.Error_Message__c = e.getMessage();
				obj.Error_Time__c = System.Now();
				obj.Error_Type__c = 'Call Out Exception WorkForce Integration';
				obj.Logged_In_User__c = Userinfo.getUserId();
				obj.Business_Function_Name__c = e.businessString;
				obj.Error_payload__c = e.getStackTraceString();
				insert obj;
	
			}
			//to handle the generic exception
			catch(System.Exception e)
			{
				LogObject obj = new LogObject();
				obj.Error_Code__c = e.errorCode;
				obj.Error_Line_Number__c = e. getLineNumber();
				obj.Error_Message__c = e.getMessage();
				obj.Error_Time__c = System.Now();
				obj.Error_Type__c = 'Exception WorkForce Integration';
				obj.Logged_In_User__c = Userinfo.getUserId();
				obj.Business_Function_Name__c = e.businessString;
				obj.Error_payload__c = e.getStackTraceString();
				insert obj;
	
			}
}
//finish method of batch class
global void finish(DataBase.BatchableContext BC){
}
}
				
