//Mock Class for HttpCallOut
@isTest
global class MockHttpResponseGenerator implements HTTPCallOutMock{
//Mock test method for success HttpCallOut
	global HttpResponse respond(HttpRequest req){
		System.assertEquals('https://nfapihub.herokuapp.com/'.req.getEndpoint());
		HttpResponse res = new Httpespnse();
		string response = '{"success":true,"secretKey":"secret key"}';
		res.setHeader('Contect-Type','application/jso');
		res.setBody(response);
		res.setStatusCode(200);
		return res;
	}
}