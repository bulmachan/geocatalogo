<%@ page 
	contentType="text/html; charset=utf-8"
	language="java"
%><%

response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

Cookie cookies[] = request.getCookies();
Cookie myCookie = null;
String str="";
String[] cookieVal=null;
if (cookies != null){
	for (int i = 0; i < cookies.length; i++){
		cookieVal=cookies[i].getValue().split("----");
		if(cookieVal.length==4){
			if (cookieVal[0].equals("GEOCATALOGOSGSS")){
				String nomeCookie=new String(org.apache.xerces.impl.dv.util.Base64.decode(cookieVal[2]));
				//str+="<li>"+cookies[i].getName()+" ["+cookieVal[1]+"]"+" <button class=\"button\" onclick=\"javascript: loadCookie('"+cookies[i].getName()+"')\" onkeypress=\"if (event.keyCode == 13) {loadCookie('"+cookies[i].getName()+"')}\">carica</button>"+"</li>";			
				str+="<li><span class=\"name_cookie\">"+nomeCookie+" <br/>["+cookieVal[1]+"]"+"</span> <span class=\"button_cookie\"><input type=\"button\" class=\"button\" onclick=\"javascript: loadCookie('"+cookies[i].getName()+"')\" title=\"Carica mappa precedentemente memorizzata\" value=\"Carica\">"+" <input type=\"button\" class=\"button\" onclick=\"javascript: clearCookie('"+cookies[i].getName()+"')\" onkeypress=\"if (event.keyCode == 13) {clearCookie('"+cookies[i].getName()+"')}\" title=\"Cancella mappa precedentemente memorizzata\" value=\"Cancella\" />"+"</span></li>";		
				//str += "<li></li>";
			}
		}
	}
}
if(!str.equals("")) {
	out.println("<ul>"+str+"</ul>");
}
%>