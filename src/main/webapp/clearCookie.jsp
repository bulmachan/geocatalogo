<%@ page language="java"
%><%

response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

javax.servlet.http.Cookie cookies[] = request.getCookies();
javax.servlet.http.Cookie cookieDaEliminare=null;
if (cookies != null){
	for (int i = 0; i < cookies.length; i++){
		if(cookies[i].getName().equals(request.getParameter("c"))){
			cookieDaEliminare=cookies[i];
			break;
		}
	}
	
	if(cookieDaEliminare!=null){
		javax.servlet.http.Cookie killMyCookie = new javax.servlet.http.Cookie(cookieDaEliminare.getName(), null);
		killMyCookie.setMaxAge(0);
		killMyCookie.setPath("/");
		response.addCookie(killMyCookie);
		out.print("OK");
	}

}
%>