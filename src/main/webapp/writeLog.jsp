<%@ page
	language="java" 
	contentType="text/html; charset=iso-8859-1"
	pageEncoding="ISO8859-1"
	errorPage=""
	import="org.apache.log4j.Category"
%><%
	Category logWrite = Category.getInstance("GEOCATALOGO");
	
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
		logWrite.info(testo);
	else if(tipo.equalsIgnoreCase("error"))
		logWrite.error(testo);
	else if(tipo.equalsIgnoreCase("warn"))
		logWrite.warn(testo);
	else
		logWrite.debug(testo);

%>