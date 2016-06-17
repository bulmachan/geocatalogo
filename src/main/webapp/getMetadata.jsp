<%@ page 
	language="java" 
	contentType="text/html; charset=iso-8859-1" 
	pageEncoding="ISO8859-1"
	import=	"
		java.io.InputStream, 
		java.io.ByteArrayOutputStream, 
		java.net.*, 
		java.io.*, 
		javax.xml.transform.*, 
		javax.xml.transform.stream.StreamSource, 
		javax.xml.transform.stream.StreamResult, 
		javax.xml.transform.TransformerFactory, 
		javax.xml.transform.Transformer
	"

%><%@ include file="params.jsp"
%><%@ include file="configDB.jsp"
%><%

	// SERVE PER ANDARE A PESCARE IL FILE DI STYLI DELL'XML DAL FILE SYSTEM:
	String localPath = application.getRealPath(request.getServletPath()).replace(request.getServletPath().replace("/",""),"");
	ResultSet rs = null;
	Statement stm = null;

try{
	String[] layer=request.getParameter("layer").split("\\.");
	String owner=layer[0];
	String table=layer[1];

	String stmt_Sql = "";

	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

	stmt_Sql = "SELECT xml FROM sde.gdb_usermetadata WHERE UPPER(owner) = UPPER('" + owner + "') AND UPPER(name) = UPPER('" + table + "')";
	
	rs = stm.executeQuery(stmt_Sql);

	if(rs.next()) {

		InputStream is = rs.getBinaryStream("xml");

		/*
		QUESTO SERVE PER CONVERTIRE LO STREAM IN STRING
		ByteArrayOutputStream bos = new ByteArrayOutputStream(); 

		int r; 
		while ((r = is.read()) != -1){ 
			bos.write(r);
		} 

		byte[] data = bos.toByteArray(); 

		String xml = new String(data);

		//xml=xml.replace("<?xml version=\"1.0\"?>","<?xml version=\"1.0\"?><?xml-stylesheet type=\"text/xsl\" href=\"styles/"+request.getParameter("style")+".xsl\" ?>");
		
		response.setContentType("text/xml");  

		out.println(xml);

		*/

		Writer outWriter = new StringWriter();   

		// Creating Transformer with XSLT
		Source sourceXSLT = new StreamSource(new FileInputStream(localPath+"styles/"+request.getParameter("style")+".xsl"));
		TransformerFactory tFactory = TransformerFactory.newInstance();
		Transformer transformer = tFactory.newTransformer(sourceXSLT);
		Source streamSource = new StreamSource(is);
		
		Result streamResult = new StreamResult(outWriter);
		// SALVA IL FILE HTML:
		//Result streamResult = new StreamResult(new FileOutputStream(localPath+"temp/"+request.getParameter("style")+".html"));

		transformer.transform(streamSource, streamResult); // Tran

		out.println(outWriter);
	
	} else {

		out.println("Metadati non disponibili");
	}
	rs.close();
    stm.close();
	dbConnCAT.close();


} catch (Exception e) {
    e.printStackTrace();
	out.println("Errore: "+e.getMessage());

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	dbConnCAT.close();

}



%>
