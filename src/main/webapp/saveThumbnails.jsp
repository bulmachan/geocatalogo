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

Category logsaveThumb = Category.getInstance("GEOCATALOGO");

ResultSet rs = null;
Statement stm = null;

String tempVar="";
Integer w=150;
Integer h=100;



		org.apache.xerces.parsers.DOMParser parser;
		
		parser = new org.apache.xerces.parsers.DOMParser();

		
        
		parser.setFeature("http://xml.org/sax/features/validation", true);
        parser.setFeature("http://xml.org/sax/features/namespaces", false);



File folder = new File("/mnt/condivisa/maru/");
File[] listOfFiles = folder.listFiles();

for (File file : listOfFiles) {
    if (file.isFile()) {
		if(file.getName().contains(".xml")){
			out.println("/mnt/condivisa/maru/"+file.getName());




		String uri="/mnt/condivisa/maru/"+file.getName();
		parser.parse(uri);
		
		
		
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
					if (((Element) data.item(iii)).getAttribute("EsriPropertyType").equals("Picture")) {
						node = (Element) data.item(iii);
						break;
					}
					if (((Element) data.item(iii)).getAttribute("EsriPropertyType").equals("PictureX")) {
						node = (Element) data.item(iii);
						break;
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

			img = ImageIO.read(new ByteArrayInputStream(decoded));

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

		ImageIO.write(img, "jpg",new File("/mnt/condivisa/maru/img/"+file.getName().replace(".xml",".jpg")));
		out.print("immagine "+file.getName().replace(".xml",".jpg")+" salvata <br />");



	
		}
    }
}
	
	


%>










