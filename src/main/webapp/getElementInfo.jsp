<%@ page
	language="java" 
	contentType="text/html; charset=iso-8859-1"
	pageEncoding="UTF-8"
	import =	"java.io.*,
			org.w3c.dom.*,
			org.apache.xerces.dom.DocumentImpl,
			org.apache.xml.serialize.*,
			java.sql.*,
			java.net.*,
			java.util.*,
			org.geotools.ows.ServiceException,
			org.geotools.data.ResourceInfo,
			org.geotools.data.wms.*,
			org.geotools.data.ows.*,
			org.geotools.data.wms.request.*,
			org.geotools.data.wms.response.*,
			org.opengis.metadata.citation.*,
			java.io.IOException,
			java.net.URL,
			java.text.DecimalFormat,
			java.util.Map,
			java.util.Map.Entry,
			java.io.BufferedReader, 
			java.io.InputStreamReader,
			java.io.FileOutputStream,
			javax.xml.transform.Transformer,
			javax.xml.transform.TransformerFactory,
			javax.xml.transform.stream.StreamResult,
			javax.xml.transform.stream.StreamSource"
	errorPage=""
%><%@ include file="configESRI.jsp"
%><%@ include file="classes/micSpatialEngine.jsp"
%><%
	
	String [] listaLayers=request.getParameter("layer").split("\\<\\|\\>");
	String [] listaLayersDesc=request.getParameter("tabledesc").split("\\<\\|\\>");
	
	String x = request.getParameter("x");
	String y = request.getParameter("y");
	String sT = request.getParameter("searchTol");
	String srs = request.getParameter("srs");
	
	Double xPoint=Double.valueOf(x.trim()).doubleValue();
	Double yPoint=Double.valueOf(y.trim()).doubleValue();
	Double searchTol=Double.valueOf(sT.trim()).doubleValue();
	
	String risultato;
	String owner="";
	String layer="";
	String type="polygon";
	String[] layerParams;
	String tabledesc="";
	String outString="";
	
	for (int i = 0; i < listaLayers.length; i++){
	
		layerParams=listaLayers[i].split("\\.");
		tabledesc=listaLayersDesc[i];

		if(layerParams.length > 0){
			owner=layerParams[0];
			if(layerParams.length > 1)
				layer=layerParams[1];
			if(layerParams.length>2)
				type=layerParams[2];
		}

		out.println(outString + "<div class=\"div_balloon\"><b>Attributi di</b> " + tabledesc + "</div>");
		try{
			String localPath = application.getRealPath(request.getServletPath()).replace(request.getServletPath().replace("/",""),"");
			
			micSpatialEngine mSE = new micSpatialEngine(connUser,connPw,nomeServer,portaSDE);
			mSE.apriConnSDE();

			risultato = mSE.trovaElementoPerPuntoHTML(xPoint, yPoint, owner+"."+layer, searchTol, srs);
			//out.println(mSE.getReport());
			out.println("<div class=\"div_balloon_result\">");
			
			/* Non serve piu' ci pensa direttamente l'xsl a scrivere Nessun oggetto trovato */
			/*
			if(risultato.equals("Nessun oggetto trovato.")){
				out.println(risultato);
			} else {
			*/
				TransformerFactory tFactory = TransformerFactory.newInstance();
				Transformer transformer = tFactory.newTransformer(new StreamSource(localPath+"styles/wms_featureinfo_html.xsl"));
				transformer.transform(new StreamSource(new StringReader(risultato)), new StreamResult(out));
			/*}*/
			out.println("</div>");
			
			
			mSE.chiudiConnSDE();
		} catch(Exception e){
			e.printStackTrace();
			outString=outString + "<div class=\"div_balloon\">Non e' stato possibile ottenere informazioni.</div><br />";
		}
	}	
	


%>
