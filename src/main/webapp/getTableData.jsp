<%@ page
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"

%><%@ include file="configDB.jsp"
%><%

String layer=request.getParameter("table");
String table=layer.split("\\.")[0]+"."+layer.split("\\.")[1];
String nome=request.getParameter("nome");
String sort=request.getParameter("sort");
String dir=request.getParameter("dir");
String layerid = request.getParameter("layerid");

int  startIndex=Integer.valueOf(request.getParameter("startIndex")).intValue();
int  results=Integer.valueOf(request.getParameter("results")).intValue();
int  totCount=Integer.valueOf(request.getParameter("totCount")).intValue();


String outString="";
Statement stm = null;
ResultSet rCount = null;
ResultSet rs = null;

try	{

	
	String stm_Sql="SELECT count(*) as rowcount FROM (SELECT ROWNUM rnum, a.* FROM (SELECT * FROM " + table + " order by " + sort + " " + dir + ") a WHERE ROWNUM <= " + (startIndex+results) + " order by " + sort + " " + dir + " ) WHERE rnum > " + startIndex + " order by " + sort + " " + dir;
	//out.println(stm_Sql);
	
	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

	rCount = stm.executeQuery(stm_Sql);
	rCount.next();
	int count = rCount.getInt("rowcount") ;
	rCount.close() ;
	
	
	outString+= "{\"recordsReturned\":"+results+",";   
	outString+= "\"totalRecords\":"+totCount+",";   
    outString+= "\"startIndex\":"+startIndex+",";   
    outString+= "\"sort\":\""+sort+"\",";
    outString+= "\"dir\":\""+dir+"\",";
    outString+= "\"pageSize\":"+results+",";  
    outString+= "\"records\":[";
	
	
	String stmt_Sql = "SELECT * FROM (SELECT ROWNUM rnum, a.* FROM (SELECT * FROM " + table + " order by " + sort + " " + dir + ") a WHERE ROWNUM <= " + (startIndex+results) + " order by " + sort + " " + dir + " ) WHERE rnum > " + startIndex + " order by " + sort + " " + dir;
	
	//out.println(stmt_Sql);

	String f = "";

	rs = stm.executeQuery(stmt_Sql);
	
	// TUTTI I RECORD TRANNE L'ULTIMO
	for(int i=0; i<count-1; i++){
		rs.next();
		outString+= "{";
		// TUTTE LE COLONNE TRANNE L'ULTIMA
		for(int j=1; j<rs.getMetaData().getColumnCount(); j++){
			
			f = rs.getMetaData().getColumnName(j);
			f = f.substring(0, 1).toUpperCase() + f.substring(1, f.length()).toLowerCase();
		
			if(f.equalsIgnoreCase("SHAPE")){
			
				outString+= "\""+ f +"\":\""+("<a href=\"javascript: parent.controlAddLayer(null,'"+layer+".OBJECTID="+rs.getString("OBJECTID")+"','"+nome+"','0','SDE_VECTOR',false,"+layerid+"); parent.window.hs.close();\" title=\"Centra l'elemento nella mappa (chiude la tabella)\" ><img src=\"images/map.png\" alt=\"Centra l'elemento nella mappa (chiude la tabella)\"></a>").replaceAll("\"", "\\\\\"")+"\",";
				
				//non funziona la chiusura della tabella:
				//outString+= "\""+ f +"\":\""+("<a href=\"javascript: parent.addLayer('"+table+".polygon.OBJECTID="+rs.getString(1)+"', false, true)\" title=\"Visualizza elemento\" onclick=\"return parent.hs.close(this);\"><img src=\"images/map.png\" alt=\"Visualizza elemento\"></a>").replaceAll("\"", "\\\\\"")+"\",";
			} else {
				if(rs.getObject(j)!=null)
					if(rs.getString(j).length()>6)
						if(rs.getString(j).substring(0,7).equalsIgnoreCase("http://"))
							outString+= "\""+ f +"\":\"<a href='"+rs.getString(j).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\",";
						else
							outString+= "\""+ f +"\":\""+rs.getString(j).replaceAll("\"", "\\\\\"")+"\",";
					else if(rs.getString(j).length()>7)
						if(rs.getString(j).substring(0,8).equalsIgnoreCase("https://"))
							outString+= "\""+ f +"\":\"<a href='"+rs.getString(j).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\",";
						else
							outString+= "\""+ f +"\":\""+rs.getString(j).replaceAll("\"", "\\\\\"")+"\",";
					else if(rs.getString(j).length()>8)
						if(rs.getString(j).substring(0,9).equalsIgnoreCase("/gstatico"))
							outString+= "\""+ f +"\":\"<a href='http://geo.regione.emilia-romagna.it"+rs.getString(j).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\",";
						else
							outString+= "\""+ f +"\":\""+rs.getString(j).replaceAll("\"", "\\\\\"")+"\",";
					else
						outString+= "\""+ f +"\":\""+rs.getString(j).replaceAll("\"", "\\\\\"")+"\",";
				else
					outString+= "\""+ f +"\":\""+"\",";
			}
		}
		f = rs.getMetaData().getColumnName(rs.getMetaData().getColumnCount());
		f = f.substring(0, 1).toUpperCase() + f.substring(1, f.length()).toLowerCase();

		// L'ULTIMA COLONNA
		if(f.equalsIgnoreCase("SHAPE")){
				/* ??? */
				outString+= "\""+ f +"\":\""+("<a href=\"javascript: parent.parent.controlAddLayer(null,'"+layer+".OBJECTID="+rs.getString("OBJECTID")+"','"+nome+"','0','SDE_VECTOR',false,"+layerid+"); parent.window.hs.close();\" title=\"Centra l'elemento nella mappa (chiude la tabella)\"><img src=\"images/map.png\" alt=\"Centra l'elemento nella mappa (chiude la tabella)\"></a>").replaceAll("\"", "\\\\\"")+"\"";
		} else {
			if(rs.getObject(rs.getMetaData().getColumnCount())!=null)
					if(rs.getString(rs.getMetaData().getColumnCount()).length()>6)
						if(rs.getString(rs.getMetaData().getColumnCount()).substring(0,7).equalsIgnoreCase("http://"))
							outString+= "\""+ f +"\":\"<a href='"+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\"";
						else 
							outString+= "\""+ f +"\":\""+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"\"";   

					else if(rs.getString(rs.getMetaData().getColumnCount()).length()>7)
						if(rs.getString(rs.getMetaData().getColumnCount()).substring(0,8).equalsIgnoreCase("https://"))
							outString+= "\""+ f +"\":\"<a href='"+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\"";
						else 
							outString+= "\""+ f +"\":\""+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"\"";   

					else if(rs.getString(rs.getMetaData().getColumnCount()).length()>8)
						if(rs.getString(rs.getMetaData().getColumnCount()).substring(0,9).equalsIgnoreCase("/gstatico"))
							outString+= "\""+ f +"\":\"<a href='http://geo.regione.emilia-romagna.it"+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\"";
						else 
							outString+= "\""+ f +"\":\""+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"\"";   

					else
						outString+= "\""+ f +"\":\""+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"\"";   
			else
				outString+= "\""+ f +"\":\""+"\"";   
		}
		outString+= "},";
	}

	// ULTIMO RECORD TUTTE LE COLONNE TRANNE L'ULTIMA
	rs.next();
	outString+= "{";
	for(int j=1; j<rs.getMetaData().getColumnCount(); j++){
		f = rs.getMetaData().getColumnName(j);
		f = f.substring(0, 1).toUpperCase() + f.substring(1, f.length()).toLowerCase();

		if(f.equalsIgnoreCase("SHAPE")){
			/* ??? */
			//outString+= "\""+ f +"\":\""+("<a href=\"javascript: parent.addLayer('"+table+"."+tipo+".OBJECTID="+rs.getString("OBJECTID")+"', false, true)\" title=\"Visualizza elemento\"><img src=\"images/map.png\" alt=\"Visualizza elemento\"></a>").replaceAll("\"", "\\\\\"")+"\",";
					
			outString+= "\""+ f +"\":\""+("<a href=\"javascript: parent.controlAddLayer(null,'"+layer+".OBJECTID="+rs.getString("OBJECTID")+"','"+nome+"','0','SDE_VECTOR',false,"+layerid+"); parent.window.hs.close();\" title=\"Centra l'elemento nella mappa (chiude la tabella)\"><img src=\"images/map.png\" alt=\"Centra l'elemento nella mappa (chiude la tabella)\"></a>").replaceAll("\"", "\\\\\"")+"\",";
		
		} else {
			if(rs.getObject(j)!=null)
				if(rs.getString(j).length()>6)
					if(rs.getString(j).substring(0,7).equalsIgnoreCase("http://"))
						outString+= "\""+ f +"\":\"<a href='"+rs.getString(j).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\",";
					else
						outString+= "\"" + f + "\":\""+rs.getString(j).replaceAll("\"", "\\\\\"")+"\",";   
				else if(rs.getString(j).length()>7)
					if(rs.getString(j).substring(0,8).equalsIgnoreCase("https://"))
						outString+= "\""+ f +"\":\"<a href='"+rs.getString(j).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\",";
					else
						outString+= "\"" + f + "\":\""+rs.getString(j).replaceAll("\"", "\\\\\"")+"\",";   
				else if(rs.getString(j).length()>8)
					if(rs.getString(j).substring(0,9).equalsIgnoreCase("/gstatico"))
						outString+= "\""+ f +"\":\"<a href='http://geo.regione.emilia-romagna.it"+rs.getString(j).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\",";
					else
						outString+= "\"" + f + "\":\""+rs.getString(j).replaceAll("\"", "\\\\\"")+"\",";   
				else
					outString+= "\"" + f + "\":\""+rs.getString(j).replaceAll("\"", "\\\\\"")+"\",";   
			else
				outString+= "\"" + f + "\":\""+"\",";   
		}
	}

	// ULTIMO RECORD ULTIMA COLONNA
	f = rs.getMetaData().getColumnName(rs.getMetaData().getColumnCount());
	f = f.substring(0, 1).toUpperCase() + f.substring(1, f.length()).toLowerCase();
	
	if(f.equalsIgnoreCase("SHAPE")){
		/* ??? */
		outString+= "\""+ f +"\":\""+("<a href=\"javascript: parent.controlAddLayer(null,'"+layer+".OBJECTID="+rs.getString("OBJECTID")+"','"+nome+"','0','SDE_VECTOR',false,"+layerid+"); parent.window.hs.close();\" title=\"Centra l'elemento nella mappa (chiude la tabella)\"><img src=\"images/map.png\" alt=\"Centra l'elemento nella mappa (chiude la tabella)\"></a>").replaceAll("\"", "\\\\\"")+"\"";
	
	} else {

		if(rs.getObject(rs.getMetaData().getColumnCount())!=null)
			if(rs.getString(rs.getMetaData().getColumnCount()).length()>6)
				if(rs.getString(rs.getMetaData().getColumnCount()).substring(0,7).equalsIgnoreCase("http://"))
					outString+= "\""+ f +"\":\"<a href='"+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\"";
				else			
					outString+= "\"" + f + "\":\""+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"\"";  
			else if(rs.getString(rs.getMetaData().getColumnCount()).length()>7)
				if(rs.getString(rs.getMetaData().getColumnCount()).substring(0,8).equalsIgnoreCase("https://"))
					outString+= "\""+ f +"\":\"<a href='"+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\"";
				else			
					outString+= "\"" + f + "\":\""+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"\"";  
			else if(rs.getString(rs.getMetaData().getColumnCount()).length()>8)
				if(rs.getString(rs.getMetaData().getColumnCount()).substring(0,9).equalsIgnoreCase("/gstatico"))
					outString+= "\""+ f +"\":\"<a href='http://geo.regione.emilia-romagna.it"+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"' style='color: #000000;font-weight: bold;' target='_blank'>Apri</a>\"";
				else			
					outString+= "\"" + f + "\":\""+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"\"";  
			else			
				outString+= "\"" + f + "\":\""+rs.getString(rs.getMetaData().getColumnCount()).replaceAll("\"", "\\\\\"")+"\"";  
		else
			outString+= "\"" + f + "\":\""+"\"";  
	}
	
	outString+= "}";
	outString+= "]}";
		
    rs.close();
    stm.close();
	dbConnCAT.close();

	out.print(outString);

	
} catch (Exception e) {
  System.err.println("Exception: "+e.getMessage());
  out.println("Errore: "+e.getMessage());

	if(rCount!=null)
		rCount.close();

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	dbConnCAT.close();

}
	
	
%>