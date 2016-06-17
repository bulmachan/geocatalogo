<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
	import = "java.io.File,
			  java.io.IOException,
			  java.io.FileNotFoundException"

%><%
try {
	String warFileName = "";
	File warFile = new File(getServletContext().getRealPath("/"));
	warFileName = warFile.getName();
	out.println("WAR FILE NAME: " + warFileName);

} catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }


%>

