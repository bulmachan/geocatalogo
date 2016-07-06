<%@ page 
	language="java" 
	contentType="text/html; charset=iso-8859-1" 
	pageEncoding="ISO8859-1"
	import=	"java.io.InputStream, 
		java.io.ByteArrayOutputStream, 
		java.net.*, 
		java.io.*, 
		java.awt.image.*,
		javax.imageio.*,
		org.w3c.dom.*,
		java.awt.Graphics,
		java.awt.*,
		java.awt.Font,
		java.awt.Color,
		org.apache.log4j.Category
		"

%><%@ include file="configDB.jsp"
%><%

Category loggetThumb = Category.getInstance("GEOCATALOGO");

ResultSet rs = null;
Statement stm = null;

String tempVar="";
Integer w=150;
Integer h=100;

tempVar = request.getParameter("w");
if (tempVar != null && !tempVar.equals("")){
	try{
		w=Integer.parseInt(request.getParameter("w"));
		w = Integer.valueOf(tempVar).intValue();
	} catch (Exception e) {
		
	}
}
tempVar = request.getParameter("h");
if (tempVar != null && !tempVar.equals("")){
	try{
		h = Integer.parseInt(request.getParameter("h"));
		//h = Integer.valueOf(tempVar).intValue();
	} catch (Exception e) {
		
	}
}
	
//Integer w=Integer.parseInt(request.getParameter("w"));
//Integer h=Integer.parseInt(request.getParameter("h"));


try{
	String[] layer=request.getParameter("layer").split("\\.");
	String owner=layer[0];
	String table=layer[1];

	String stmt_Sql = "";

	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

	// OLD stmt_Sql = "SELECT xml FROM sde.gdb_usermetadata WHERE UPPER(owner) = UPPER('" + owner + "') AND UPPER(name) = UPPER('" + table + "')";
	
	stmt_Sql ="SELECT sde.sdexmltotext(sde.sde_xml_doc2.xml_doc) AS xml FROM SDE.GDB_ITEMS, SDE.SDE_XML_DOC2 WHERE SDE.SDE_XML_DOC2.SDE_XML_ID = SDE.GDB_ITEMS.DOCUMENTATION AND NAME = '" + owner + "." + table + "'";
	
	rs = stm.executeQuery(stmt_Sql);
	
	if(rs.next()) {
	
		InputStream is = rs.getBinaryStream("xml");

	/*	
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
		org.apache.xerces.parsers.DOMParser parser;
		
		parser = new org.apache.xerces.parsers.DOMParser();
		
		parser.parse(new org.xml.sax.InputSource(is));
		
		org.w3c.dom.Document document;
		
		document = parser.getDocument();
		
		Element node=null;
		Element node_i=null;
		Element node_ii=null;
		
		
		
		// RICERCA DEL TAG: metadata/Binary/Thumbnail/Data
		
		Element root=document.getDocumentElement();

		NodeList binaries = root.getElementsByTagName("Binary");
		
		for (int i = 0; i < binaries.getLength(); ++i) {
		
			node_i = (Element) binaries.item(i);
			NodeList thumbnails = node_i.getElementsByTagName("Thumbnail");
			for (int ii = 0; ii < thumbnails.getLength(); ++ii) {
				node_ii = (Element) thumbnails.item(ii);
				NodeList data = node_ii.getElementsByTagName("Data");
				
				for (int iii = 0; iii < data.getLength(); ++iii) {
					if (((Element) data.item(iii)).getAttribute("EsriPropertyType").equals("PictureX")) {
						node = (Element) data.item(iii);
					}
				}
			}	
		}

		BufferedImage img=null;
		// DECODIFICA LA STRINGA IN BASE64 E GENERA UN PNG
		if(node!=null){
			String encoded=node.getTextContent();
			
			// prova con le librerie sauronsoftware: http://www.sauronsoftware.it/projects/javabase64/index.php
			//byte[] array = encoded.getBytes("ASCII");
			//byte[] decoded = it.sauronsoftware.base64.Base64.decode(array);
			
			byte[] decoded = org.apache.xerces.impl.dv.util.Base64.decode(encoded);

			BufferedImage sourceImage = ImageIO.read(new ByteArrayInputStream(decoded));

			Image thumbnail = sourceImage.getScaledInstance(w, -1, Image.SCALE_SMOOTH);
			
			img = new BufferedImage(thumbnail.getWidth(null),thumbnail.getHeight(null),BufferedImage.TYPE_INT_ARGB);
			
			img.getGraphics().drawImage(thumbnail, 0, 0, null);
			
			
		} else {

			img = new BufferedImage(w,h, BufferedImage.TYPE_INT_ARGB);
			Graphics2D g = img.createGraphics();
			Color transparent = new Color(0, 0, 0, 0);
			g.setColor(transparent);
			g.setComposite(AlphaComposite.Src);
			
			g.fillRoundRect(0,0,w,h,0,0);
			g.setColor(Color.BLACK);
			Font font4 = new Font("SansSerif", Font.PLAIN,  11);
			g.setFont(font4);
			g.drawString("Anteprima non disponibile",5,10);
			
		}
		response.setContentType("image/png");
		OutputStream os = response.getOutputStream();
		ImageIO.write(img, "png", os);
		os.close();
	} else {
		throw new Exception("Anteprima non disponibile");
	}

	rs.close();
	stm.close();
	dbConnCAT.close();

} catch (Exception e) {
    //e.printStackTrace();
	//out.println("Errore: "+e.getMessage());
	loggetThumb.error("Errore getThumbnail.jsp: "+request.getParameter("layer")+" ---> "+e.getMessage());
	BufferedImage img = new BufferedImage(w,h, BufferedImage.TYPE_INT_ARGB);
	Graphics2D g = img.createGraphics();
	Color transparent = new Color(0, 0, 0, 0);
	g.setColor(transparent);
	g.setComposite(AlphaComposite.Src);
	
	g.fillRoundRect(0,0,w,h,0,0);
	g.setColor(Color.BLACK);
	Font font4 = new Font("SansSerif", Font.PLAIN,  11);
	g.setFont(font4);
	g.drawString(e.getMessage(),5,10);
	//g.drawString(ee.getMessage(),52,35);
	
	response.setContentType("image/png");
	OutputStream os = response.getOutputStream();
	ImageIO.write(img, "png", os);
	os.close();

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	if(dbConnCAT!=null)
		dbConnCAT.close();

}

%>