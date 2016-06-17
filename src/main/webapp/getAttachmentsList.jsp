<%@ page 
	language="java" 
	contentType="text/html; charset=iso-8859-1" 
	pageEncoding="ISO8859-1"
	import= "java.io.*,
			java.util.Date,
			java.text.*,
			java.net.URL"
	errorPage=""
%><%@ include file="configDB.jsp"
%><%@ include file="params.jsp"
%><%

response.setHeader("Cache-Control","no-store"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader("Expires", 0); 

Statement stm = null;
ResultSet rs = null;
try {
	String layer = request.getParameter("layer");
	if (layer == null || layer == "") {
		throw new Exception("Missing layer argument");
	}
	
	String[] layerParams=layer.split("\\.");

	if(layerParams.length>2)
		layer=layerParams[0]+"."+layerParams[1];

	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
	String stmt_Sql = "SELECT decode(TABLE_DESC_TREE, null, TABLE_DESC, TABLE_DESC_TREE) as TABLE_DESC_TREE, METALAYER FROM CAT_USER.cat_v_oggetti WHERE (OWNER || '.' || TABLE_NAME) = '"+layer+"' and WHERE_IS = 'geo04srv:geo04_sde'";
	rs = stm.executeQuery(stmt_Sql);
	rs.next();
	
	String layerName=rs.getString("TABLE_DESC_TREE").replaceAll("à","a");
	String metaLayer=rs.getString("METALAYER");
	
	rs.close();
	stm.close();
	dbConnCAT.close();

	String strOutput="";
	Integer fileSize=0;
	for (int i = 0; i < legendExtensions.length; i++) {
		File f = new File(attachmentsPath+layerName+"."+legendExtensions[i]);
		if(f.exists()){
			strOutput+=layerName+"."+legendExtensions[i]+",";
			fileSize+=Integer.valueOf((int)f.length());
		}
	}
	
	for (int i = 0; i < dwnAttachments.length; i++) {
	
		File f = new File(attachmentsPath+dwnAttachments[i]);
		if(f.exists()){
			strOutput+=dwnAttachments[i]+",";
			fileSize+=Integer.valueOf((int)f.length());
		}			
	}
	
	if(!strOutput.equals(""))
		if(strOutput.substring(strOutput.length()-1,strOutput.length()).equals(","))
			strOutput=strOutput.substring(0,strOutput.length()-1);

	out.println(strOutput+"<|>"+fileSize+"<|>"+metaLayer);


} catch(Exception ee) {
	out.print("Errore pagina: "+ee.getMessage());
	ee.printStackTrace();

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	dbConnCAT.close();

}


%>