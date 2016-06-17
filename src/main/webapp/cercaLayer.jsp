<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
%><%@ include file="configDB.jsp"
%><% 

response.setHeader("Cache-Control","no-store"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader("Expires", 0); 

%><%

String s = request.getParameter("s");
String op = "";

if(request.getParameter("output")!=null)
	op=request.getParameter("output");

String[] wheres=request.getParameter("s").split("\\@");
String where1="";
String where2="";

for(int j=0; j<wheres.length-1; j++){
	where1+="lower(a.table_name) like lower('%" + wheres[j] + "%') or lower(a.table_desc) like lower('%" + wheres[1] + "%') or lower(a.table_desc_long) like lower('%" + wheres[j] + "%') or lower(a.table_desc_long) like lower('%" + wheres[j] + "%')" + " or ";
	
	where2+="lower(group_desc) like lower('%" + wheres[j] + "%')" + " or ";
}
where1+="lower(a.table_name) like lower('%" + wheres[wheres.length-1] + "%') or lower(a.table_desc) like lower('%" + wheres[wheres.length-1] + "%') or lower(a.table_desc_long) like lower('%" + wheres[wheres.length-1] + "%') or lower(a.table_desc_long) like lower('%" + wheres[wheres.length-1] + "%')";

where2+="lower(group_desc) like lower('%" + wheres[wheres.length-1] + "%')";


String stmt_Sql = "";
String str = "";
String strSoloId = "";
String famGroup = "";

ResultSet rs = null;
Statement stm = null;

try
{
	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
	stmt_Sql = "(select b.GROUP_ID  from CAT_USER.cat_v_oggetti a, CAT_USER.cat_v_oggetti_gruppi b where a.id_oggetto=b.id_oggetto and (" + where1 +") group by b.GROUP_ID) union (select group_id from CAT_USER.cat_v_gruppi where "+ where2 +")";
	
	rs = stm.executeQuery(stmt_Sql);
	
	//out.println(stmt_Sql);

	while(rs.next()){
		str = str + rs.getString("GROUP_ID") + "||";
	}
	rs.close();

	str=str + "@";

	stmt_Sql = "select a.ID_OGGETTO, b.group_id from CAT_USER.cat_v_oggetti a, CAT_USER.cat_v_oggetti_gruppi b where a.id_oggetto=b.id_oggetto and ("+where1+")";
	rs = stm.executeQuery(stmt_Sql);

	while(rs.next()){
		famGroup="Gr" + rs.getString("GROUP_ID") + "_Og" + rs.getString("ID_OGGETTO");
		str=str + famGroup + "||";
		strSoloId+="L"+famGroup + "||";
	}
	rs.close();

	stmt_Sql = "select count(*) as C from CAT_USER.cat_v_gruppi where "+where2;
	rs = stm.executeQuery(stmt_Sql);
	rs.next();

	str=str + "@" + rs.getString("C");

	rs.close();

	stmt_Sql = "select count(*) as C from CAT_USER.cat_v_oggetti a, CAT_USER.cat_v_oggetti_gruppi b where a.id_oggetto=b.id_oggetto and ("+where1+")";
	rs = stm.executeQuery(stmt_Sql);
	rs.next();

	str=str + "@" + rs.getString("C");
	
	rs.close();
	stm.close();
	dbConnCAT.close();

	if(op.equals("id")){
		
		//out.print(strSoloId.substring(0,strSoloId.length()-2));
		out.print(strSoloId);
	} else {
		
		out.print(str);

	}
} catch(Exception ee) {
	out.print(ee.getMessage());
	ee.printStackTrace();

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	dbConnCAT.close();

}


%>
