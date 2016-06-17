<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
	import =	"java.io.*,
				org.w3c.dom.*,
				org.apache.xerces.dom.DocumentImpl,
				org.apache.xml.serialize.*,
				java.net.*,
				java.util.*,
				org.jboss.resource.connectionmanager.JBossManagedConnectionPool"

%><%@ include file="configDB.jsp"
%><%

dbConnCAT.close();
dbConnCAT.flush();

//out.println(dbConnCAT.getInUseConnectionCount());

%>