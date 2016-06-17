<% 
	String pageCharEncoding = (String) session.getAttribute("__PAGE_ENCODING__");
	if(pageCharEncoding == null || 
		(!pageCharEncoding.equalsIgnoreCase("UTF-8")
				&& !pageCharEncoding.equalsIgnoreCase("ISO-8859-1")
				&& !pageCharEncoding.equalsIgnoreCase("Windows-1252"))){
		pageCharEncoding = "UTF-8";
	}
	response.setContentType("text/html; charset="+pageCharEncoding); 
%>