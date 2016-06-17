<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
%><%@ include file="configDB.jsp"
%><%


	String schema="";
	String tempVar = request.getParameter("schema");
	if (tempVar != null && !tempVar.equals("")){
		try{
			schema=" and CAT_V_TREE.OWNER='"+request.getParameter("schema")+"' ";
		} catch (Exception e) {
			
		}
	}
	
	
	String stmt_Sql = "select CAT_V_TREE.*,id_metadato from CAT_USER.CAT_V_TREE left join CAT_USER.cat_oggetti on CAT_V_TREE.id = cat_oggetti.id where CAT_V_TREE.sorgente is not null and CAT_V_TREE.topo <> 'Folder' and CAT_V_TREE.topo <> 't' and CAT_V_TREE.sorgente <> '-' "+ schema + " order by CAT_V_TREE.owner, CAT_V_TREE.sorgente";
	
	Statement stm = null;
	ResultSet rs = null;
	
	try	{
		stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		rs = stm.executeQuery(stmt_Sql);
		
		out.print("<table>");
		while(rs.next()){


				out.print("<tr><td valign=\"top\" align=\"right\" style=\"background:#eee\"><b>"+rs.getString("ETICHETTA_TREE")+" - "+rs.getString("OWNER")+"."+rs.getString("SORGENTE")+" ("+rs.getString("ID_METADATO")+")</b>:</td><td style=\"background:#eee\"><img style=\"vertical-align: top;\" src=\"getThumbnail.jsp?layer="+rs.getString("OWNER")+"."+rs.getString("SORGENTE")+"&w=400\" /></td></tr>");
				out.print("<tr><td>&nbsp;</td><td>&nbsp;</td></tr>");
				
	
		}
		out.print("</table>");
	
	} catch (Exception e) {
			System.err.println("Exception: "+e.getMessage());
			out.println("Exception: "+e.getMessage());
			
			if(rs!=null)
				rs.close();

			if(stm!=null)
				stm.close();
			
			dbConnCAT.close();

	}
%>
