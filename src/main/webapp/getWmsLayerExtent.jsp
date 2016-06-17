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
				org.opengis.metadata.citation.*,
				java.io.IOException,
				java.net.URL,
				java.text.DecimalFormat,
				java.util.Map,
				java.util.Map.Entry"
%><%
	String layer=request.getParameter("layer");
	String requestedSrs=request.getParameter("srs");


	try{
		//URL url = new URL(url_base + service);
		//URL url = new URL("http://geo.regione.emilia-romagna.it/wmsconnector/com.esri.wms.Esrimap/ewater_it");
		URL url = new URL(request.getParameter("url"));
		try{
			WebMapServer wms = new WebMapServer(url);
			WMSCapabilities capabilities = wms.getCapabilities();
			List layersList=capabilities.getLayerList();
			
			if(layersList.size() > 0){
				
				Layer layerRoot=(Layer)layersList.get(0);
				
				CRSEnvelope LLbBoxRoot=layerRoot.getLatLonBoundingBox();
				
				Map layerRootBoundingBoxes=layerRoot.getBoundingBoxes();
				
				for (int j = 1; j < layersList.size(); ++j) {
			 
					Layer la=(Layer)layersList.get(j);
					
					if (la.isQueryable()) {
						if(la.getName().equalsIgnoreCase(layer)){
							//String srs="";
							//Iterator iter = la.getSrs().iterator();
							//while (iter.hasNext()) {
							//	srs+=(String)iter.next()+",";
							//}
							
							String bBoxStr="";
							CRSEnvelope bBox=null;
							if(requestedSrs.equalsIgnoreCase("EPSG:4326")){
								
								bBox=la.getLatLonBoundingBox();

							} else {
							
								Map boundingBoxes=la.getBoundingBoxes();

								if (boundingBoxes == null || boundingBoxes.isEmpty()) { 
									boundingBoxes=layerRootBoundingBoxes;
								}
								
								for (Iterator i = boundingBoxes.entrySet().iterator(); i.hasNext();) { 
									Map.Entry entry = (Entry) i.next(); 
									
									if(((String) entry.getKey()).equalsIgnoreCase(requestedSrs)){
										//String layerSrs = (String) entry.getKey(); 
										bBox = (CRSEnvelope) entry.getValue(); 
									}
								} 
							}							
							
							if(bBox != null)
								bBoxStr=bBox.getMinX()+","+bBox.getMinY()+","+bBox.getMaxX()+","+bBox.getMaxY();

							//out.println(la.getName()+": "+srs+"<br />");
							//out.println(la.getName()+": "+bbox4326.getMinX()+", "+bbox4326.getMinY()+", "+bbox4326.getMaxX()+", "+bbox4326.getMaxY()+"<br />");
							
							out.println(bBoxStr);
							
							break;
						}
					}
			
				}

			}
	
		} catch (ServiceException ee) {
			System.out.println("Unable to get WMS " + ": " + ee.getMessage());
		}
	} catch (MalformedURLException e) {
		System.out.println("Invalid URL " + ": " + e.getMessage());
    }


%>