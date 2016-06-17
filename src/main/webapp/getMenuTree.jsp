<%@ page 
	language="java" 
	contentType="text/html; charset=iso-8859-1" 
	pageEncoding="ISO8859-1"
	import =	"java.io.*,
				org.w3c.dom.*,
				org.apache.xerces.dom.DocumentImpl"
%><%@ include file="params.jsp"
%><%@ include file="configDB.jsp"
%><%@ include file="classes/menuTreeClasses.jsp"
%>
	<a tabindex="0" name="menu_catalogo"></a>
<%

	menuTreeClasses mt=new menuTreeClasses();
	
	Document objDocument = new DocumentImpl();
	
	StringBuffer reportLoadXMLData = new StringBuffer();
	mt.loadXMLData(objDocument,reportLoadXMLData,dbConnCAT);
	
	//STAMPA IL REPORT DELLA CLASSE loadXMLData:
	//out.println(reportLoadXMLData.toString());
	
	// CREA IL FILE XML DEL MENU TREE:
	//String pathXML = application.getRealPath(request.getServletPath().toString().replace("/menuTree.jsp","/")+"menuTree.xml");
	//mt.writeXML(objDocument,pathXML);

	dbConnCAT.close();


%>
	<div class="search" id="risultatoricerca">&nbsp;<br />&nbsp;</div>

	<div class="tabella_menu">
		<!--<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td>
					<form name="frmMenu" action="" method="post">-->



<%	


	StringBuffer sb = new StringBuffer();
	int[] iElement = new int[1];
	iElement[0]=0;
	mt.displayNode(objDocument.getChildNodes(), iElement, "", "", 0, sb, g_UrlSrvMetadati);
	
	out.print(sb);

%>


						<!--<input type="hidden" name="hdnOpenFolders" value="<%//=sOpenFolders%>">
					</form>
				</td>
			</tr>
		</table>-->



</div><!-- chiude div tabella_menu-->

<%	
out.print("<|>");
	
	for (int ii = 1; ii <= iElement[0]; ii++){
		out.print(ii+",");
	}
	

%>

