<%@ page language="java" %>
<%
String cookieName = request.getParameter("cookie");
Cookie cookies[] = request.getCookies();
Cookie myCookie = null;
if (cookies != null){
	for (int i = 0; i < cookies.length; i++){
		if (cookies[i].getDomain().equals("GEOCATALOGOSGSS") && cookies[i].getName().equals(cookieName)){
			myCookie = cookies[i];
			break;
		}
	}
}
out.println(myCookie.getValue());
%>
 
 
 
 
