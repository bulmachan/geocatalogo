<%@ page
	contentType="text/html; charset=utf-8"
	import="java.text.SimpleDateFormat, java.net.URLDecoder"
%><%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires", 0);

	//long now = System.currentTimeMillis();
	//response.setDateHeader("Expires", now+1296000000); // DUE SETTIMANE A PARTIRE DA OGGI

	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy (HH:mm:ss)");
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMMddHHmmss");

	// create a new Cookie object.  
	//javax.servlet.http.Cookie c = new javax.servlet.http.Cookie(request.getParameter("nome"), "GEOCATALOGOSGSS"+"--"+sdf.format(new java.util.Date())+"--"+java.net.URLEncoder.encode(request.getParameter("url"))); 
	
	String cookieUrl = request.getParameter("url").replace("$", "&");
	if(!cookieUrl.equals("")){
	
		String nomeCookie = URLDecoder.decode(request.getParameter("nome"));
		if(!nomeCookie.equals("")){
			
			
			/*byte[] stringArray;

			try {
				
				stringArray = nomeCookie.getBytes("UTF-8");  // use appropriate encoding string!
			
			} catch (Exception ignored) {
				
				stringArray = nomeCookie.getBytes();  // use locale default rather than croak
			
			}*/
			//nomeCookie=org.apache.xerces.impl.dv.util.Base64.encode(stringArray);
			
			//byte[] decoded = org.apache.xerces.impl.dv.util.Base64.decode(encoded);
			
			javax.servlet.http.Cookie c = new javax.servlet.http.Cookie(new java.util.Date().getTime()+"", "GEOCATALOGOSGSS"+"----"+sdf.format(new java.util.Date())+"----"+org.apache.xerces.impl.dv.util.Base64.encode(nomeCookie.getBytes("UTF-8"))+"----"+cookieUrl);
			c.setPath("/");
			c.setMaxAge(1209600);

			response.addCookie(c);
			out.print("OK");
		} else {
			out.print("0");
		}
	} else {
		out.print("0");
	}

%>