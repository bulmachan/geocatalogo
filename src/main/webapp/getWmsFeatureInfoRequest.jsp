<%@ page 
	language="java" 
	contentType="text/html; charset=iso-8859-1" 
	pageEncoding="ISO8859-1"
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

%><%

	try{

		URL url = new URL(request.getParameter("url"));
		
		//StringBuffer sb = new StringBuffer();

		try{
			
			WebMapServer wms = new WebMapServer(url);
			
			GetMapRequest gmReq = wms.createGetMapRequest();

			WMSCapabilities capabilities = wms.getCapabilities();
			List layersList=capabilities.getLayerList();

			String[] listLayersRichiesti=request.getParameter("LAYERS").split(";");
			
			if(layersList.size() > 0 || listLayersRichiesti.length > 0){
				
				for (int i = 0; i < listLayersRichiesti.length; i++) {
			
					Layer layer=null;
					for (int j = 1; j < layersList.size(); ++j) {
				 
						Layer la=(Layer)layersList.get(j);
						
						if (la.isQueryable())
							if(la.getName().equalsIgnoreCase(listLayersRichiesti[i])){
								layer=la;
								break;
							}
					}
			
					if(layer!=null){
					
						gmReq.addLayer(layer);
						gmReq.setBBox(request.getParameter("BBOX"));
						gmReq.setDimensions(Integer.parseInt(request.getParameter("WIDTH")), Integer.parseInt(request.getParameter("HEIGHT")));
						gmReq.setFormat("image/png");
						gmReq.setSRS(request.getParameter("SRS"));
						gmReq.setVersion("1.1.1");
						gmReq.setTransparent(true);
						
						GetFeatureInfoRequest gfiReq = wms.createGetFeatureInfoRequest(gmReq);
						
						gfiReq.addQueryLayer(layer);
						
						String x = request.getParameter("x");
						String y = request.getParameter("y");
						Double xPoint=Double.valueOf(request.getParameter("X").trim()).doubleValue();
						Double yPoint=Double.valueOf(request.getParameter("Y").trim()).doubleValue();
						
						// java.lang.NumberFormatException: For input string: "10.694269648076"
						// gfiReq.setQueryPoint(Integer.parseInt(request.getParameter("X")), Integer.parseInt(request.getParameter("Y")));
						
						gfiReq.setQueryPoint(xPoint.intValue(), yPoint.intValue());
						
						gfiReq.setProperty("LAYERS", request.getParameter("LAYERS"));
						gfiReq.setProperty("VERSION", "1.1.1");
						gfiReq.setProperty("INFO_FORMAT", "application/vnd.ogc.wms_xml");
						//gfiReq.setProperty("INFO_FORMAT", "application/vnd.esri.wms_featureinfo_xml");
						//gfiReq.setProperty("INFO_FORMAT", "text/xml");


						// Debug
						//out.println(gmReq.getFinalURL().toString()+"<br />");
						//out.println(gfiReq.getFinalURL().toString()+"<br />");

						GetFeatureInfoResponse gfiRep = wms.issueRequest(gfiReq);

						
						String localPath = application.getRealPath(request.getServletPath()).replace(request.getServletPath().replace("/",""),"");

						//String line="";
						//BufferedReader reader = new BufferedReader(new InputStreamReader(gfiRep.getInputStream(), "UTF-8") );
						//sb.append("<h1>").append(layer.getTitle()).append("</h1>");
						//while ((line = reader.readLine()) != null) {
						//	sb.append(line).append("\n");
						//}
						
						out.println("<div class=\"div_balloon\"><b>Attributi di</b> "+layer.getTitle()+"</div>");
						out.println("<div class=\"div_balloon_result\">");
						
						TransformerFactory tFactory = TransformerFactory.newInstance();
						Transformer transformer = tFactory.newTransformer(new StreamSource(localPath+"styles/wms_featureinfo_esri_html.xsl"));
						transformer.transform(new StreamSource(gfiRep.getInputStream()), new StreamResult(out));

						out.println("</div>");
						
					
					} else {
					
						//sb.append("<h1>").append(listLayersRichiesti[i]).append(" NON TROVATO !!!</h1>");					
						out.println("<h1>"+listLayersRichiesti[i]+" NON TROVATO !!!"+"</h1>");

					}			
				
				}
				
				//out.println(sb.toString());
			
			}
			

			
	
		} catch (ServiceException ee) {
			System.out.println("Unable to get WMS " + ": " + ee.getMessage());
		}
	} catch (MalformedURLException e) {
		System.out.println("Invalid URL " + ": " + e.getMessage());
    }


%>