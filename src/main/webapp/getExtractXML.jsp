<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
	import= "java.io.*,
			java.util.Date,
			java.text.*,
			java.net.URL,
			java.sql.*"
	errorPage=""
%><%

response.setHeader("Cache-Control","no-store"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader("Expires", 0); 


Connection Conn = null;
Statement stm = null;
ResultSet rs = null;
String stmt_Sql="";

try {
	try{
		javax.naming.Context initContext = new javax.naming.InitialContext();
		/* OLD */
		/*javax.naming.Context envContext  = (javax.naming.Context)initContext.lookup("java:/comp/env");
		javax.sql.DataSource ds = (javax.sql.DataSource)envContext.lookup("jdbc/sgssmeta");*/
		
		javax.sql.DataSource ds = (javax.sql.DataSource) initContext.lookup("java:/sgssmeta");
		
		Conn = ds.getConnection(); // oggetto connessione
	} catch(Exception ee) {
		out.println("Errore durante la connessione al DB: "+ee);
	}
	

	String metaLayer=request.getParameter("metalayer");

	stm = Conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
	//String stmt_Sql = "select export_xml from rm_meta_export x, rm_metadato m where x.id_metadato= m.id_metadato and m.titolo='Archi ferroviari - 1:10.000 (Digitale)'";

	//String stmt_Sql = "select export_xml from rm_meta_export x, rm_metadato m, rm_entity e where x.id_metadato= m.id_metadato and x.id_metadato= e.id_metadato and e.nome='"+metaLayer.replaceAll("'","''")+"' and data_fine is null";

	stmt_Sql = "select x.export_xml from rm_meta_export x, rm_entity_eg e, rx_tema t where x.id_metadato= e.id_metadato and e.id_eg = t.id_tabella and t.nome='"+metaLayer.replaceAll("'","''")+"' and x.data_fine is null";
	
	rs = stm.executeQuery(stmt_Sql);
	
	if(rs.next()){
		Clob xml=rs.getClob("export_xml");
		
		StringBuffer strOut = new StringBuffer();
		String aux;

		BufferedReader br = new BufferedReader(xml.getCharacterStream());
		while ((aux=br.readLine())!=null)
			strOut.append(aux);

		// CAMBIA L'ENCODING DELL'INTESTAZIONE DELL'XML PERCHE' L'ENCODING DEL FILE E' ANSI [non e' piu' necessario]
		//byte[] theByteArray = strOut.toString().getBytes();//.replace("UTF-8","ISO-8859-1").getBytes();
		byte[] theByteArray = strOut.toString().replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>","<?xml version=\"1.0\" encoding=\"UTF-8\"?><?xml-stylesheet type=\"text/xsl\" href=\"iso_19139.xsl\" ?>").getBytes();
		outZip.putNextEntry(new ZipEntry(shpName+".xml"));
		
		outZip.write(theByteArray, 0, theByteArray.length);
		
		outZip.closeEntry();
	}
	rs.close();
	stm.close();
	Conn.close();

} catch(Exception ee) {
	//out.print("Errore pagina: "+ee.getMessage());
	//ee.printStackTrace();
	log.error("getExtractXML.jsp - DOWNLOAD SHP: query - " + stmt_Sql + " - " + ee.getMessage());

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	if(Conn!=null)
		Conn.close();
}

%>