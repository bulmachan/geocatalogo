<%@ page language="java"
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
		if(cookies[i].getName().equals(request.getParameter("c"))){
			cookieVal=cookies[i].getValue().split("----");
			if(cookieVal.length==4){
				if (cookieVal[0].equals("GEOCATALOGOSGSS")){
					String nomeCookie=new String(org.apache.xerces.impl.dv.util.Base64.decode(cookieVal[2]));
					str=cookieVal[3]+"<||>"+nomeCookie;
				}
				break;
			}
		}
	}
}
if(!str.equals("")) {
	out.println(str);
}
%>