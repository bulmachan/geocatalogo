<%@ page
	language="java" 
	contentType="text/html; charset=iso-8859-1"
	pageEncoding="ISO8859-1"
	errorPage=""
%><%@ include file="configDB.jsp"
%><%

String stmt_Sql = "";

String pubflag = "";
String tableDesc = "";
String tableDescLong = "";
String table="";
String layerName="";
String type="";
String owner="";
String campo="";

String[] layer = request.getParameter("layer").split("\\.");
String layerSelection = request.getParameter("layerSelection");

owner=layer[0];
table=layer[1];

Statement stm = null;
ResultSet rs = null;

try {
	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

	stmt_Sql = "SELECT OWNER, TABLE_NAME, PUB_FLAG, TABLE_DESC_TREE, TABLE_DESC_LONG, TOPO, CAMPO FROM CAT_USER.cat_v_oggetti WHERE upper(OWNER) = upper('" + owner + "') and upper(TABLE_NAME)=upper('"+ table + "') and WHERE_IS = 'geo04srv:geo04_sde'";
	//out.println(stmt_Sql);
	rs = stm.executeQuery(stmt_Sql);
	rs.next();
	
	tableDesc = rs.getString("TABLE_DESC_TREE");
	tableDescLong = rs.getString("TABLE_DESC_LONG");
	pubflag = rs.getString("PUB_FLAG"); 
	campo = rs.getString("CAMPO"); 
	
	owner = rs.getString("OWNER");
	//layer = owner+"."+rs.getString("TABLE_NAME");
	//layerName = layer.substring(layer.indexOf(".")+1,layer.length());
	
	type = rs.getString("TOPO");
	if(type.equals("p"))
		type="point";
	else if(type.equals("a"))
		type="polygon";
	else if(type.equals("l"))
		type="line";
	else if(type.equals("R"))
		type="raster";
	else if(type.equals("t"))
		type="table";
	else if(type.equals("wms"))
		type="wms";
	else
		type="error";
	

	rs.close();
	
	String nomeSel = "selezione";

	if(campo!=(null)){
		String sqlNome="select " + campo + " as NOME from " + owner + "." + table + " where " + layer[3];
		//out.println(sqlNome);

		rs = stm.executeQuery(sqlNome);
		rs.next();
		nomeSel = rs.getString("NOME");

		rs.close();
	}

	stm.close();
	dbConnCAT.close();
	
	out.print(request.getParameter("i")+"<|>"+table+"<|>"+tableDesc+"<|>"+tableDescLong+"<|>"+pubflag+"<|>"+layerSelection+"<|>"+nomeSel);

} catch(Exception ee) {
	out.print("Errore: "+ee.getMessage());
	ee.printStackTrace();

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	if(dbConnCAT!=null)
		dbConnCAT.close();

}
%>
