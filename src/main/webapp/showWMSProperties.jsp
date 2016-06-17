<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
	import =	"java.io.*,
				org.w3c.dom.*,
				org.apache.xerces.dom.DocumentImpl,
				org.apache.xml.serialize.*,
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
				java.io.FileOutputStream"

%><%
	
	//String[] layerParams=request.getParameter("layer").split("LAYER=");
	//out.println();
	//out.println("mmmmm"+layerParams[1]+"nnnnn");
	String urlStr=request.getParameter("url");//layerParams[0]+"?";
	String layer=request.getParameter("LAYER");//layerParams[1];
	String requestedSrs=request.getParameter("srs");
	String tipo=request.getParameter("tipo");

	//String service=urlStr.substring(urlStr.lastIndexOf("/")+1,urlStr.length());
	//urlStr=urlStr.substring(0,urlStr.lastIndexOf("/")+1);


	String tableDescTree = "";
	String tableDesc = "";
	String tableDescLong = "";

	String stmt_Sql = "";
	String localPath = application.getRealPath(request.getServletPath()).replace(request.getServletPath().replace("/",""),"");
	
	String versione="";
	String stringaFormatiGetMap="";
	String stringaFormatiGetFeatureInfo="";
	String stringaEccezioni="";

	String srsLayer="";
	String srsZero="";
	String bBoxStr="";
	String bBoxZeroStr="";
	String nomeLayer="";
	String titoloLayer="";
	String abstractLayer="";
	String interrogabile="";
	String limiteScalaMin="";
	String limiteScalaMax="";
	Layer la=null;
	CRSEnvelope bBox=null;	
	String titoloWMS="";
	String abstractWMS="";
	String[] keyWordList=null;
	String keyWords="";
	String contactPerson="";
	String contactOrg="";
	String contactEmail="";
	
	
	/*Statement stm = null;
	ResultSet rs = null;
	
	try{
	
		if (tipo.equals("WMS")){
			stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

			stmt_Sql = "SELECT ETICHETTA_TREE, ETICHETTA, ETICHETTA_DESC FROM CAT_USER.cat_v_tree WHERE OWNER is null and TOPO = 'wms' and WHERE_IS = '"+urlStr+"'";
		
			//out.println(stmt_Sql);

			rs = stm.executeQuery(stmt_Sql);
		
			if(rs.next()){
			
				tableDescTree = rs.getString("ETICHETTA_TREE");
				tableDesc = rs.getString("ETICHETTA");
				tableDescLong = rs.getString("ETICHETTA_DESC");
				
			}
			
			rs.close();
			stm.close();
			dbConnCAT.close();
		}
	
	} catch(Exception ee) {
		out.print(ee.getMessage());
		ee.printStackTrace();

		if(rs!=null)
			rs.close();

		if(stm!=null)
			stm.close();
		
		dbConnCAT.close();

	}*/		
	
	try{
		
		try{
			//out.println(urlStr);
			URL url = new URL(urlStr);
			WebMapServer wms = null;
			try{
			
				wms = new WebMapServer(url);

				WMSCapabilities capabilities = wms.getCapabilities();
				
				versione=capabilities.getVersion();
				Service service = capabilities.getService();
				titoloWMS=service.getTitle();
				abstractWMS=service.get_abstract();
				keyWordList=service.getKeywordList();
				StringBuffer result = new StringBuffer();
				if (keyWordList.length > 0) {
					result.append(keyWordList[0]);
					for (int i=1; i < keyWordList.length; i++) {
						result.append("</li><li>");
						result.append(keyWordList[i]);
					}
				}
				keyWords = result.toString();

				ResponsibleParty resps = service.getContactInformation();
				contactPerson = resps.getIndividualName();
				contactOrg = resps.getOrganisationName().toString();
				contactEmail = resps.getContactInfo().getAddress().getElectronicMailAddresses().toString();

				List listaFormati=null;
				WMSRequest wmsReq = capabilities.getRequest();

				OperationType opType=wmsReq.getGetMap();
				listaFormati = opType.getFormats();
				stringaFormatiGetMap="<ul>";
				for (int j = 0; j < listaFormati.size(); j++) {
					stringaFormatiGetMap+="<li>"+listaFormati.get(j)+"</li>";
				}
				stringaFormatiGetMap+="</ul>";
				

				opType=wmsReq.getGetFeatureInfo();
				if(opType!=null){
					listaFormati = opType.getFormats();
					stringaFormatiGetFeatureInfo="<ul>";
					for (int j = 0; j < listaFormati.size(); j++) {
						stringaFormatiGetFeatureInfo+="<li>"+listaFormati.get(j)+"</li>";
					}
					stringaFormatiGetFeatureInfo+="</ul>";
				}

				String[] eccezioni=capabilities.getExceptions();
				stringaEccezioni="<ul>";
				for (int j = 0; j < eccezioni.length; j++) {
					stringaEccezioni+="<li>"+eccezioni[j]+"</li>";
				}
				stringaEccezioni+="</ul>";
		
				List layersList=capabilities.getLayerList();
				for (int j = 0; j < layersList.size(); j++) {
					Iterator iter = null;
					la=(Layer)layersList.get(j);
					String elemento = "";
					if(j == 0){
						iter = la.getSrs().iterator();
						srsZero="<ul>";
						while (iter.hasNext()) {
							elemento=(String)iter.next();
							srsZero+="<li><a href=\"http://www.spatialreference.org/ref/"+elemento.replace(":","/").toLowerCase()+"\" title=\"Apri i dettagli del sistema di riferimento in un'altra pagina\" rel=\"external\">"+elemento+"</a></li>";
						}
						srsZero+="</ul>";
						
						bBox = la.getLatLonBoundingBox();
						bBoxZeroStr="<ul class=\"indentlessp\">";
						//bBoxZeroStr+="<li><strong>EPSG:4326</strong>: "+bBox.getMinX()+","+bBox.getMinY()+","+bBox.getMaxX()+","+bBox.getMaxY()+"</li>";
						
						// questo con la 2.7.0 non funziona piu':
						/*Map boundingBoxes=la.getBoundingBoxes();
						for (Iterator i = boundingBoxes.entrySet().iterator(); i.hasNext();) { 
							Map.Entry entry = (Entry) i.next(); 
							bBox = (CRSEnvelope) entry.getValue(); 
							bBoxZeroStr+="<li><strong>"+bBox.getEPSGCode()+"</strong>: "+bBox.getMinX()+","+bBox.getMinY()+","+bBox.getMaxX()+","+bBox.getMaxY()+"</li>";
						}*/ 
						
						List boundingBoxes=la.getLayerBoundingBoxes();
						java.util.Iterator itfd=boundingBoxes.iterator();
						boolean epsg4326=false;
						while(itfd.hasNext()){
							bBox = (CRSEnvelope)itfd.next();
							bBoxZeroStr+="<li><strong>"+bBox.getEPSGCode()+"</strong>: "+bBox.getMinX()+", "+bBox.getMinY()+", "+bBox.getMaxX()+", "+bBox.getMaxY()+"</li>";
							if(bBox.getEPSGCode().equalsIgnoreCase("EPSG:4326"))
								epsg4326=true;
						}

						//if(!epsg4326)
						//	bBoxZeroStr+="<li><strong>ssfEPSG:4326</strong>: "+bBox.getMinX()+", "+bBox.getMinY()+", "+bBox.getMaxX()+", "+bBox.getMaxY()+"</li>";
						
						bBoxZeroStr+="</ul>";
					}

					if(la.getName()!=null){
						//if(la.getName().equalsIgnoreCase(layer)){
							//out.println("JJJJ"+layer);
						if(layer.indexOf(la.getName())>-1){

							nomeLayer+=la.getName()+",";
							titoloLayer+=la.getTitle()+", ";
							abstractLayer+=la.get_abstract()+"<br />";


							iter = la.getSrs().iterator();
							srsLayer="<ul>";
							while (iter.hasNext()) {
								elemento=(String)iter.next();
								srsLayer+="<li><a href=\"http://www.spatialreference.org/ref/"+elemento.replace(":","/").toLowerCase() +"\" title=\"Apri i dettagli del sistema di riferimento in un'altra pagina\" rel=\"external\">"+elemento+"</a></li>";
							}
							srsLayer+="</ul>";
							
							//bBox = la.getLatLonBoundingBox();
							bBoxStr="<ul class=\"indentlessp\">";
							//bBoxStr+="<li><strong>EPSG:4326</strong>: "+bBox.getMinX()+","+bBox.getMinY()+","+bBox.getMaxX()+","+bBox.getMaxY()+"</li>";
							
							
							// questo con la 2.7.0 non funziona piu':
							/*Map boundingBoxes=la.getBoundingBoxes();
							for (Iterator i = boundingBoxes.entrySet().iterator(); i.hasNext();) { 
								Map.Entry entry = (Entry) i.next(); 
								bBox = (CRSEnvelope) entry.getValue(); 
								bBoxStr+="<li><strong>"+bBox.getEPSGCode()+"</strong>: "+bBox.getMinX()+","+bBox.getMinY()+","+bBox.getMaxX()+","+bBox.getMaxY()+"</li>";
							}*/
							
							List boundingBoxes=la.getLayerBoundingBoxes();
							java.util.Iterator itfd=boundingBoxes.iterator();
							boolean epsg4326=false;
							while(itfd.hasNext()){
								bBox = (CRSEnvelope)itfd.next();
								bBoxStr+="<li><strong>"+bBox.getEPSGCode()+"</strong>: "+bBox.getMinX()+", "+bBox.getMinY()+", "+bBox.getMaxX()+", "+bBox.getMaxY()+"</li>";
								if(bBox.getEPSGCode().equalsIgnoreCase("EPSG:4326"))
									epsg4326=true;
							}

						//if(!epsg4326)
						//	bBoxStr+="<li><strong>jjjEPSG:4326</strong>: "+bBox.getMinX()+", "+bBox.getMinY()+", "+bBox.getMaxX()+", "+bBox.getMaxY()+"</li>";


							bBoxStr+="</ul>";

							if(la.isQueryable())
								interrogabile="Interrogabile: <strong>SI</strong>";
							else
								interrogabile="Interrogabile: <strong>NO</strong>";
							
							
							if(!((Double)la.getScaleHintMin()).isNaN())
								limiteScalaMin="Limite inferiore di scala: <strong>" + la.getScaleHintMin()+"</strong>";

							if(!((Double)la.getScaleHintMax()).isNaN())
								limiteScalaMax="Limite superiore di scala: <strong>" + la.getScaleHintMax()+"</strong>";

							if(!((Double)la.getScaleDenominatorMin()).isNaN())
								limiteScalaMin="Limite inferiore di scala: <strong>" + la.getScaleDenominatorMin()+"</strong>";

							if(!((Double)la.getScaleDenominatorMax()).isNaN())
								limiteScalaMax="Limite superiore di scala: <strong>" + la.getScaleDenominatorMax()+"</strong>";

							
							// LA GESTIONE DELLO STILE PER PRENDERE LA URL DELLA LEGENDA NON FUNZIONA, COMUNQUE LO STILE E' NULLO ANCHE SE C'E'
							/*if (la.getStyles() != null) {

								List stylesList=la.getStyles();
								for (int jj = 0; jj < stylesList.size(); jj++) {
									List legendURLs = ((StyleImpl)stylesList.get(jj)).getLegendURLs();
									
									out.println("nnnn"+((StyleImpl)stylesList.get(jj)).getName());

									//out.println("gggg"+((StyleImpl)stylesList.get(jj)).getGraphicStyles().size());
									
									if (legendURLs != null){
										for (int jjj = 0; jjj < legendURLs.size(); jjj++) {
											out.println(legendURLs.get(jjj)+"<br />");
										}
									}
								}


							}*/

							//break;

						}
					}

				}
				nomeLayer=nomeLayer.substring(0,nomeLayer.length()-1);
				titoloLayer=titoloLayer.substring(0,titoloLayer.length()-1);
				//abstractLayer=abstractLayer.substring(0,abstractLayer.length()-1);

			} catch (IOException ee) {
				out.println("Unable to get WMS " + ": " + ee.getMessage());
				
			} catch (ServiceException ee) {
				out.println("Unable to get WMS " + ": " + ee.getMessage());
			}				

		} catch (MalformedURLException e) {
			out.println("Invalid URL " + ": " + e.getMessage());
		}


%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8">
	<title>Proprietà del LAYER</title>
	<link rel="stylesheet" media="screen"  type="text/css" href="styles/style_page.css" />

	<script type="text/javascript">
		function goToExtent(minX, minY, maxX, maxY) {
			// RENDE L'EXTENT PROPORZIONALE AL CAMPO CARTOGRAFICO:
			var deltaX=maxX-minX;
			var deltaY=maxY-minY;
			var ratio=(parent.map.getSize().w)/(parent.map.getSize().h);
			var gapX=((ratio*deltaY)-deltaX)/2;
			var gapY=((ratio*deltaX)-deltaY)/2;
			
			if(deltaX<deltaY){
				minX=minX-gapX;
				maxX=maxX+gapX;
			}else{					
				minY=minY-gapY;
				maxY=maxY+gapY;
			}				
			//alert(deltaX+"---"+deltaY+"-----------"+minX+", "+minY+", "+maxX+", "+maxY);
			var newExtent=new parent.OpenLayers.Bounds(minX, minY, maxX, maxY);
			parent.map.zoomToExtent(newExtent, true);
		}
	//-->
	</script>
</head>

<body >
	<div id="main">
		<div id="intestazione" class="properties">
			<h1>Proprietà del WMS</h1>
			<div>
				<p><strong><%=titoloWMS%></strong></p>
				<p><strong><%=abstractWMS%></strong></p>
				<p>&nbsp;</p>
				<p><strong>Parole chiave</strong></p>
				<p class="center"><%=keyWords%></ul></p>
				<p>&nbsp;</p>
				<p><strong>Responsabile</strong></p>
				<p><%=contactPerson%><br />(<%=contactOrg%>)<br /><%=contactEmail%></p>
				<p>&nbsp;</p>
				
				<p><strong>Versione</strong></p>
				<p>WMS&nbsp;<%=versione%></p>
				<p>&nbsp;</p>

				<p><strong>URL di accesso al servizio</strong></p>
				<p><%=urlStr%></p>
				
<%
				String urlRequest="";
				if(urlStr.charAt(urlStr.length()-1)==(("?").charAt(0)))
					urlRequest=urlStr+"VERSION="+versione;
				else if(urlStr.indexOf("?") > -1)
					urlRequest=urlStr;
				else
					urlRequest=urlStr+"?VERSION="+versione;
	
%>
				<p><a href="<%=urlRequest%>&REQUEST=GetCapabilities&SERVICE=WMS" title="Accesso al file XML di Capabilities">XML Capabilities</a></p>
				
				<p>&nbsp;</p>
				<!-- <div class="prop_cont"> -->
					<p><strong>Lista Formati GetMap</strong></p>
					<p><%=stringaFormatiGetMap%></p>
					<p>&nbsp;</p>

<% if(!stringaFormatiGetFeatureInfo.equals("")){
%>
					<p><strong>Lista Formati GetFeatureInfo</strong></p>
					<p><%=stringaFormatiGetFeatureInfo%></p>
					<p>&nbsp;</p>
<%}
%>
					<p><strong>Lista Formati Errori</strong></p>
					<p><%=stringaEccezioni%></p>
					<p>&nbsp;</p>
					
					<p><strong>Lista sistemi di riferimento del servizio WMS</strong></p>
					<p><%=srsZero%></p>
					<p>&nbsp;</p>

					<p><strong>Lista extensioni cartografiche del servizio WMS</strong></p>
					<p><%=bBoxZeroStr%></p>
					<p>&nbsp;</p>
				<!-- </div> -->  <!-- chiude div class="prop_cont" -->
			</div>
			
			<h2>Proprietà del LAYER</h2>
			<div>
				<p><strong><%=(titoloLayer+" (layer: "+nomeLayer+")")%></strong></p>

<% if (!abstractLayer.equals("null<br />")){
%>			
				<p><strong>Descrizione</strong></p>
				<p><%=abstractLayer%></p>

<%}
%>
<%		
				try {
					int w = 200;
					double dx=la.getLatLonBoundingBox().getMaxX()-la.getLatLonBoundingBox().getMinX();
					double dy=la.getLatLonBoundingBox().getMaxY()-la.getLatLonBoundingBox().getMinY();
					long h = Math.round(w / (dx/dy));


				urlRequest="";
				if(urlStr.charAt(urlStr.length()-1)==(("?").charAt(0)))
					urlRequest=urlStr+"VERSION="+versione;
				else if(urlStr.indexOf("?") > -1)
					urlRequest=urlStr;
				else
					urlRequest=urlStr+"?VERSION="+versione;
				
				urlRequest+="&REQUEST=GetMap&SERVICE=WMS&LAYERS="+nomeLayer;
				String bb = "";
				if(versione.equals("1.3.0")){
					urlRequest+="&CRS=EPSG:4326";
					bb = Double.toString(la.getLatLonBoundingBox().getMinY())+","+Double.toString(la.getLatLonBoundingBox().getMinX())+","+Double.toString(la.getLatLonBoundingBox().getMaxY())+","+Double.toString(la.getLatLonBoundingBox().getMaxX());
				} else {
					bb = Double.toString(la.getLatLonBoundingBox().getMinX())+","+Double.toString(la.getLatLonBoundingBox().getMinY())+","+Double.toString(la.getLatLonBoundingBox().getMaxX())+","+Double.toString(la.getLatLonBoundingBox().getMaxY());
					urlRequest+="&SRS=EPSG:4326";
				}

				urlRequest+="&BBOX="+bb+"&WIDTH="+w+"&HEIGHT="+h+"&STYLES=&FORMAT=image/png&TRANSPARENT=FALSE&BGCOLOR=0xFFFFFF";
	

%>
				<p><img class="mappetta" src="<%=urlRequest%>" /></p>



				<p><%=interrogabile%></p>

<% if (!srsLayer.equals(srsZero)){
%>				<p><strong>Lista sistemi di riferimento layer</strong></p>
				<p><%=srsLayer%></p>
				<p>&nbsp;</p>
<% }
%>			
				<p><strong>Lista estensioni cartografiche layer</strong></p>
				<p>
<%
				
				if(bBoxStr.equals("<ul></ul>"))
					out.println("Sono definite al livello di Servizio");
				else
					out.println(bBoxStr);
%>				</p>
				<p>&nbsp;</p>

			
<% 
	if(!limiteScalaMin.equals("")){
		out.println("<p>"+limiteScalaMin+"</p>");
	}
	if(!limiteScalaMax.equals("")){
		out.println("<p>"+limiteScalaMax+"</p>");
	}
		} catch (Exception ee){
		
			out.println("Non e' stato possibile ottenere le proprietà di questo layer.");//+ee.getMessage());

		}

	} catch (Exception ee){
	
		out.println("Non e' stato possibile ottenere le proprietà di questo layer.");//+ee.getMessage());

	//} finally {
	
	//		dbConnCAT.close();

	}

%>
			</div> <!-- chiude div class="prop_cont" -->
		</div>
	</div>
</body>
</html>
