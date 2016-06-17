<%@page import="java.util.Enumeration"%>
<%
Enumeration ss = request.getParameterNames();
String value;
while(ss.hasMoreElements()){
	String key = (String)ss.nextElement();
	value = request.getParameter(key);
	System.out.println(key+" : "+value+" ");
}

String getS = request.getParameter("node");

System.out.println("ss : "+getS);
if (getS.equals("source")){
%>
[{"text":"1","id":"1","cls":"folder"},{"text":"4","id":"4","leaf":true,"cls":"file"},{"text":"3","id":"3","cls":"folder"},{"text":"2","id":"2","leaf":true,"cls":"file"}]
<%
} else if(getS.equals("3")) {
%>
[{"text":"7","id":"7","leaf":true,"cls":"file"},{"text":"8","id":"8","cls":"folder"}]
<%} %> 