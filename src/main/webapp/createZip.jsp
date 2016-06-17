<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
	import= "java.io.*,
			java.util.*,
			java.util.zip.*,
			java.net.URL,
			org.apache.log4j.Category,
			java.text.SimpleDateFormat"
	errorPage=""
%><%@ include file="params.jsp"
%><%

Category log = Category.getInstance("GEOCATALOGO");
String app = "unknown";
if ((request.getParameter("app") != null) && (request.getParameter("app") != "")) {
	app = request.getParameter("app");
}

try {
		
	String[] filesToAdd=null;
	String nomeZipInput=outputURL+request.getParameter("zip");
	if (request.getParameter("files")!="")
		filesToAdd=request.getParameter("files").split(",");
	
	String srs = request.getParameter("srs");
	String nome = request.getParameter("nome");

	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

	URL url = new URL(nomeZipInput);
		
    byte[] buf = new byte[1024];
    int n;
		
    ZipInputStream zis = new ZipInputStream(url.openStream());
	ZipEntry zipentry;
		
	ZipOutputStream outZip = new ZipOutputStream(response.getOutputStream());
	response.setContentType("application/octet-stream");
	response.setHeader ("Content-Disposition", "attachment;filename=\""+nome+"_"+srs+"_"+sdf.format(new java.util.Date())+".zip\"");
	String entryName="";
	String shpName="";
	while ((zipentry = zis.getNextEntry()) != null) { 
	    //for each entry to be extracted
		
		entryName = zipentry.getName();
               
        if(entryName.indexOf(".shp")>-1)
			shpName=entryName;

		
		// Add ZIP entry to output stream
		outZip.putNextEntry(new ZipEntry(entryName));
				
		// Transfer bytes from the input ZIP file to the ZIPOutputStream
        while ((n = zis.read(buf, 0, 1024)) > -1)
            outZip.write(buf, 0, n);
					
        zis.closeEntry();
    
        // Complete the entry
        outZip.closeEntry();

    } // while
	
	// Close ZipInputStream
    zis.close();
			
	// Add extra files from the list of files passed via URL
	int fs=0;
	if (filesToAdd != null) {
		for (int i = 0; i < filesToAdd.length; i++) {

		
			//FileInputStream fisFileToAdd = new FileInputStream(application.getRealPath(filesToAdd[i]));
			FileInputStream fisFileToAdd = new FileInputStream(attachmentsPath+filesToAdd[i]);

			// Add ZIP entry to output stream
			outZip.putNextEntry(new ZipEntry(filesToAdd[i]));
			
			// Transfer bytes from the file to the ZIP file
			while ((n = fisFileToAdd.read(buf, 0, 1024)) > -1)
				outZip.write(buf, 0, n);
					
			// Complete the entry
			outZip.closeEntry();
				
			// Close ZipInputStream
			fisFileToAdd.close();


		}
	}

%><%@ include file="getExtractXML.jsp"
%><%
	
	if(debug)	
		log.info("createZip.jsp IP: "+request.getRemoteAddr() + "\t" +"DOWNLOAD SHP: "+shpName + ": "+ request.getParameter("size") + " app: "+ app);
	
	// Close ZipOutputStream
	outZip.close();
	
} catch(Exception ee) {

	log.error("createZip.jsp - DOWNLOAD SHP: "+ee.getMessage());
	//ee.printStackTrace();
}

%>