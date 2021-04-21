//Wrapper class for Request
global class RequestWrapper
{
	string id;
	string agentid;
	
	global RequestWrapper(string id, string agentid){
		this.id=id;
		this.agentid=agentid;
	}
}