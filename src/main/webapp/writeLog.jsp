<%@ page
	language="java" 
	contentType="text/html; charset=iso-8859-1"
	pageEncoding="ISO8859-1"
	errorPage=""
	import="org.apache.log4j.Category"
%><%
	Category log = Category.getInstance("GEOCATALOGO");
	
	String tipo="";
	if (request.getParameter("tipo")!=null){ 
		if (!request.getParameter("tipo").equals("")) {
			tipo=request.getParameter("tipo");
		}
	}

	String testo="";
	if (request.getParameter("testo")!=null){ 
		if (!request.getParameter("testo").equals("")) {
			testo=request.getParameter("testo");
		}
	}

	
	if(tipo.equalsIgnoreCase("info"))
		log.info(testo);
	else if(tipo.equalsIgnoreCase("error"))
		log.error(testo);
	else if(tipo.equalsIgnoreCase("warn"))
		log.warn(testo);
	else
		log.debug(testo);

%>