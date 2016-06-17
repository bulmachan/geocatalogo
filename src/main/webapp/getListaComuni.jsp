<%@ page
	language="java" 
	contentType="text/html; charset=iso-8859-1"
	pageEncoding="ISO8859-1"
	errorPage=""
%><%@ include file="configDB.jsp"
%>
<%

Statement stm = null;
ResultSet rs = null;
try	{

	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

	String stmt_Sql = "select id_comune, nome_com, sigla_pro from BASE_USER.BASE_V_COM_PRO_REG where istat_reg ='08' order by sigla_pro, nome_com";
	rs = stm.executeQuery(stmt_Sql);

	while (rs.next()){
		String idCom = rs.getString("ID_COMUNE");
		String nomeCom = rs.getString("NOME_COM");
		String siglaPro = rs.getString("SIGLA_PRO");
		
		out.println("<option value=\"" + idCom+ "\"" + ">" + nomeCom + " ("+siglaPro+")"+"</option>");
	}
	
	rs.close();
	stm.close();

	dbConnCAT.close();

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
