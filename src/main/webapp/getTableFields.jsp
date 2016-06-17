<%@ page
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
	errorPage=""
%><%@ include file="configDB.jsp"
%>
<%
String table=request.getParameter("table");
Statement stm = null;
ResultSet rs = null;

try	{

	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
	String stmt_Sql = "select * from "+table;

	rs = stm.executeQuery(stmt_Sql);

	
	
	String descrizione="";
	String outString="";
	for(int j=1; j<rs.getMetaData().getColumnCount()+1; j++){
		
		
		if(rs.getMetaData().getColumnName(j).equalsIgnoreCase("SHAPE")){
		
			descrizione="Geometry";

		} else {

			switch (rs.getMetaData().getColumnType(j)){

				case 12: //VARCHAR
					descrizione="Varchar"+" ["+rs.getMetaData().getColumnDisplaySize(j)+"]";
				break;
				
				case 2: //NUMBER
					switch (rs.getMetaData().getScale(j)){
						case 0: // INTEGER
							descrizione="Number" + " ["+rs.getMetaData().getPrecision(j)+",0]";
						break; //FLOAT
						default:
							descrizione="Float";
							//descrizione=rs.getMetaData().getColumnTypeName(j)+" ["+rs.getMetaData().getPrecision(j)+","+rs.getMetaData().getScale(j)+"]";
					}
				break;
				
				case 91: //DATA
					descrizione="Data";
				break;
			
				default:
					descrizione = rs.getMetaData().getColumnType(j)+" - "+rs.getMetaData().getColumnTypeName(j)+" [dispsize:"+rs.getMetaData().getColumnDisplaySize(j)+",precision: "+rs.getMetaData().getPrecision(j)+",scale: "+rs.getMetaData().getScale(j)+"]";

			}
		
		}
		outString=outString+rs.getMetaData().getColumnName(j)+" - "+"<strong>"+descrizione+"</strong>"+"<|>";
	}
	
	out.print(outString);
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