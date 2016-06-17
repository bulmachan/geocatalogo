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

class menuTreeClasses{

	boolean g_UsaRepository = true;

	public menuTreeClasses(){

	}

	
	public void loadXMLData(Document objDoc, StringBuffer report, Connection dbConnCAT){
		
		Element root = objDoc.createElement("root");

		root.setAttribute("name", "<strong>Catalogo</strong>");
		root.setAttribute("id", "0");
		root.setAttribute("rootId", "0");

		objDoc.appendChild(root);


		String stmt_Sql = "select * from CAT_USER.CAT_V_TREE";
		int wmsId=100;
		
		Statement stm = null;
		ResultSet rs = null;
		
		try	{
			stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = stm.executeQuery(stmt_Sql);
			Element objVarNode = null;
			String s="";

			int pos=1;
			while(rs.next()){

				if (rs.getString("ID_PADRE").equals("00")) {

					Element objRootNode = objDoc.createElement("root_cat");

					objRootNode.setAttribute("name", "<strong>"+rs.getString("ETICHETTA_TREE")+"</strong>");
					objRootNode.setAttribute("id", rs.getString("ID"));
					objRootNode.setAttribute("rootId", Integer.toString(pos));
					objRootNode.setAttribute("visible", "true");
				
					root.appendChild(objRootNode);
				
				}else{
				
					if(rs.getString("SORGENTE")==null){
						Element objNode = objDoc.createElement("folder");
						objNode.setAttribute("padre", rs.getString("ID_PADRE"));
						objNode.setAttribute("name", rs.getString("ETICHETTA_TREE"));
						objNode.setAttribute("id", rs.getString("ID"));
						objNode.setAttribute("visible", "true");
						
						if(rs.getString("ID_PADRE").equals("01")){
							
							objVarNode.appendChild(objNode);
						
						}else{
						
							objVarNode=null;
							s=rs.getString("ID_PADRE");
							NodeList sections = objDoc.getElementsByTagName("root_cat");
							for (int i = 0; i < sections.getLength(); ++i) {
								if (((Element) sections.item(i)).getAttribute("id").equals(s)) {
									objVarNode = (Element) sections.item(i);
								}
							}
							if(objVarNode==null){
								sections = objDoc.getElementsByTagName("folder");
								for (int i = 0; i < sections.getLength(); ++i) {
									if (((Element) sections.item(i)).getAttribute("id").equals(s)) {
										objVarNode = (Element) sections.item(i);
									}
								}
							}
							objVarNode.appendChild(objNode);
						
						}


					}else{
						
						String tblDesc="";
						if(rs.getString("ETICHETTA")==null){
							tblDesc=rs.getString("SORGENTE");
						}else{
							tblDesc=rs.getString("ETICHETTA");
						}
						String tblDescTree="";
						if(rs.getString("ETICHETTA_TREE")==null){
							tblDescTree=tblDesc;
						}else{
							tblDescTree=rs.getString("ETICHETTA_TREE");
						}
						String tblDescTreeLong="";
						if(rs.getString("ETICHETTA_DESC")==null){
							tblDescTreeLong=tblDescTree;
						}else{
							tblDescTreeLong=rs.getString("ETICHETTA_DESC");
						}
						String tblTopo = rs.getString("TOPO");
						if (tblTopo==null){
							tblTopo = "";
						}
						String tblOwn = rs.getString("OWNER");
						if (tblOwn==null){
							tblOwn = "";
						}
						String tblPubFlag = rs.getString("PUBFLAG");
						if (tblPubFlag==null){
							tblPubFlag = "4";
						}
						String tblMetaLayer = rs.getString("METALAYER");
						if (tblMetaLayer==null){
							tblMetaLayer = "";
						}
						if(tblTopo.equals("wms")){
							readWMS(objDoc, rs.getString("ID_PADRE"), wmsId, tblDesc, tblDescTreeLong, rs.getString("SORGENTE"), rs.getString("WHERE_IS"), rs.getString("ID"));
							wmsId--;

						}else{
							
							Element objNode = objDoc.createElement("document");
							objNode.setAttribute("tab", rs.getString("SORGENTE"));
							objNode.setAttribute("name", tblDesc);
							objNode.setAttribute("nametree", tblDescTree);
							objNode.setAttribute("desctree", tblDescTreeLong);
							objNode.setAttribute("id", "Gr" + rs.getString("ID_PADRE") + "_Og" + rs.getString("ID"));
							objNode.setAttribute("catid", rs.getString("ID"));
							objNode.setAttribute("topo", tblTopo);
							objNode.setAttribute("owner", tblOwn);
							objNode.setAttribute("pubflag", tblPubFlag);
							objNode.setAttribute("metalayer", tblMetaLayer);
							objNode.setAttribute("visible", "true");

							objVarNode=null;
							s=rs.getString("ID_PADRE");
							NodeList sections = objDoc.getElementsByTagName("root_cat");
							for (int i = 0; i < sections.getLength(); ++i) {
								if (((Element) sections.item(i)).getAttribute("id").equals(s)) {
									objVarNode = (Element) sections.item(i);
								}
							}
							if(objVarNode==null){
								sections = objDoc.getElementsByTagName("folder");
								for (int i = 0; i < sections.getLength(); ++i) {
									if (((Element) sections.item(i)).getAttribute("id").equals(s)) {
										objVarNode = (Element) sections.item(i);
									}
								}
							}
							objVarNode.appendChild(objNode);
						
						}
					
					}

				}

				pos++;
			}



			// TOGLIE I RAMI SECCHI

			NodeList objNodeList = objDoc.getElementsByTagName("document");
		
			for (int j=0; j<objNodeList.getLength(); j++){
				Element objNode = (Element) objNodeList.item(j);
				String objId=objNode.getAttribute("id");

				String sIdValue="9999";
				while(sIdValue.length()>2){
					if(objId.indexOf("_")>-1)
						sIdValue=objId.substring(0, objId.indexOf("_")).replace("Gr","");
					else
						sIdValue=objId.substring(0, objId.length()-2);

					report.append("jj"+sIdValue+"</br>");
					
					objVarNode=null;
					s=sIdValue;
					NodeList sections = objDoc.getElementsByTagName("root_cat");
					for (int i = 0; i < sections.getLength(); ++i) {
						if (((Element) sections.item(i)).getAttribute("id").equals(s)) {
							objVarNode = (Element) sections.item(i);
						}
					}
					if(objVarNode==null){
						sections = objDoc.getElementsByTagName("folder");
						for (int i = 0; i < sections.getLength(); ++i) {
							if (((Element) sections.item(i)).getAttribute("id").equals(s)) {
								objVarNode = (Element) sections.item(i);
							}
						}
					}
					objVarNode.setAttribute("visible", "true");
					objId=objVarNode.getAttribute("id");

				}


			}

			rs.close();
			stm.close();
			
			// SCRIVE L'XML DELL'ALBERO:
			//writeXML(objDoc,"/var/lib/jbossas/server/geologico/./deploy/cartpedo.war/ge/logs/menuTree.xml");

		} catch(Exception ee) {
			
		
			report.append(ee.getMessage());
			ee.printStackTrace();
			
			try	{
				if(rs!=null)
					rs.close();

				if(stm!=null)
					stm.close();
			
			} catch(SQLException sqlee) {
				report.append(sqlee.getMessage());
			}

		}

	}

	/*
	public String pincoPallo() {
		String pollo = null;
		try {
		
				
		URL url = new URL("http://servizigis.regione.emilia-romagna.it/arcgis/public/Ctr250/MapServer/WMSServer?VERSION=1.1.1");
		WebMapServer wms = new WebMapServer(url);
		
		pollo = wms.getSpecification().getVersion();
		
		/*WMSCapabilities capabilities = wms.getCapabilities();				
		
		//List layersList=capabilities.getLayerList();
		
	

			// SIAMO QUI !!!!
			String clientVersion = "1.1.1"; //tempSpecification.getVersion();
			Specification tempSpecification = new WMS1_0_0();
			pollo = tempSpecification.getVersion();
			
			GetCapabilitiesRequest request = tempSpecification.createGetCapabilitiesRequest(url);
			
			AbstractOpenWebService prova = new AbstractOpenWebService(url);
			
			//GetCapabilitiesResponse prova2 = org.geotools.data.ows.AbstractOpenWebService.issueRequest(request);
			
			//tempSpecification.getCapabilities();
			//getCapabilities();
			
		} catch (MalformedURLException e) {
			System.out.println("Invalid URL " + ": " + e.getMessage());
		} finally {
			return(pollo);
		}
	
	}*/

	public void readWMS(Document objDoc, String tblGrId, int wmsId, String tblDesc, String tblDescTree, String tblName, String whereIs, String catid){

		String padre=tblGrId;
		DecimalFormat d = new DecimalFormat("00");
		DecimalFormat dd = new DecimalFormat("000");
		
		//wmsId=PadMyNumber(wmsId-1,2) 'tblOggId
		String sWmsId=d.format(wmsId-1);
		String service=tblName;
		String servicename=tblDescTree;
		String url_base=whereIs;
		Element objVarNode = null;
		String s="";

		try{
			URL url = null;
			if(service.equals("-"))
				url = new URL(url_base);
			else
				url = new URL(url_base + service);

			try{
				WebMapServer wms = new WebMapServer(url);
/*				
		RIGHE NUOVE DELLA 2.7.0:
+        if( serverURL.getQuery() != null ){
+            String[] tokens = serverURL.getQuery().split("&");
+            for (String token : tokens) {
+                String[] param = token.split("=");
+                if( param != null && param.length > 1 && param[0] != null && 
+                        param[0].equalsIgnoreCase("version") ){
+                    if( versions.contains(param[1]) )
+                        test = versions.indexOf(param[1]);
+                }
+            }
+        }
+
*/


/*protected void setupSpecifications() {
	        specs = new Specification[3];
	        specs[0] = new WMS1_0_0();
	        specs[1] = new WMS1_1_0();
	        specs[2] = new WMS1_1_1();
		}
	}
*/
				// SIAMO QUI !!!!
				/*String clientVersion = "1.1.1"; //tempSpecification.getVersion();
	            Specification tempSpecification = new WMS1_0_0();

				GetCapabilitiesRequest request = tempSpecification.createGetCapabilitiesRequest(url);
				
                System.out.println("QUI"+tempSpecification.getVersion());
				
				//tempCapabilities = (WMSCapabilities) issueRequest(request).getCapabilities();
				//GetCapabilitiesResponse  prova = tempSpecification.issueRequest(request);
				//WMSCapabilities capabilities = (WMSCapabilities)prova.getCapabilities();*/
				
				WMSCapabilities capabilities = wms.getCapabilities();				
				List layersList=capabilities.getLayerList();
				//List layersList=null;
				if(layersList.size() > 0){
					
					Layer layerRoot=(Layer)layersList.get(0);

					//Map layerRootBoundingBoxes=layerRoot.getBoundingBoxes();
					List layerRootBoundingBoxes=layerRoot.getLayerBoundingBoxes();
					
					Element objNodeFolder = objDoc.createElement("folder");
					
					objNodeFolder.setAttribute("padre", padre);
					objNodeFolder.setAttribute("name", servicename);
					objNodeFolder.setAttribute("id", padre + sWmsId);
					objNodeFolder.setAttribute("visible", "false");
					
					// aggiunto da landini_m 20/04/2010
					objNodeFolder.setAttribute("topo", "WMS");

					objVarNode=null;
					s=padre;
					NodeList sections = objDoc.getElementsByTagName("root_cat");
					for (int i = 0; i < sections.getLength(); ++i) {
						if (((Element) sections.item(i)).getAttribute("id").equals(s)) {
							objVarNode = (Element) sections.item(i);
						}
					}
					if(objVarNode==null){
						sections = objDoc.getElementsByTagName("folder");
												
						for (int i = 0; i < sections.getLength(); ++i) {
							if (((Element) sections.item(i)).getAttribute("id").equals(s)) {
								objVarNode = (Element) sections.item(i);
							}
						}
					}
					objVarNode.appendChild(objNodeFolder);

					int tblOggWmsId=0;

					for (int j = 0; j < layersList.size(); ++j) {
					
					//for (int j = layersList.size()-1; j >= 0; --j) { // TOLTO 19/08/2011 PER RISPETTARE L'ORDINE NELLE CAPABILITIES
				 
						Layer la=(Layer)layersList.get(j);
						
						//if (la.isQueryable()) {
						if(la.getName()!=null){	
							Element objNode = objDoc.createElement("document");
							tblOggWmsId=tblOggWmsId+1;

							objNode.setAttribute("tab", service + "-" +la.getTitle());
							objNode.setAttribute("name", la.getName());
							objNode.setAttribute("nametree", la.getTitle());
							
							objNode.setAttribute("id", "Gr" + padre + sWmsId + "_Wms" + la.getName());// PER CREARE IL treeId USIAMO IL NOME DEL LAYER, NON PIU': dd.format(tblOggWmsId));
							objNode.setAttribute("catid", catid);
							objNode.setAttribute("topo", "WMS");
							objNode.setAttribute("owner", "");
							objNode.setAttribute("scalemin", "");
							objNode.setAttribute("pubflag", "2");
							objNode.setAttribute("metalayer", "");
							objNode.setAttribute("wmsurl", url_base);
							objNode.setAttribute("service", service);
							
							CRSEnvelope bBox=null;
							//Map boundingBoxes=la.getBoundingBoxes();
							List boundingBoxes=la.getLayerBoundingBoxes();
							
							if (boundingBoxes == null || boundingBoxes.isEmpty()) { 
								boundingBoxes=layerRootBoundingBoxes;
							}
							CRSEnvelope LLbBox=la.getLatLonBoundingBox();

							String srs="";
							Iterator iter = la.getSrs().iterator();
							boolean epsg0=false;
							while (iter.hasNext()) {
								
								String srsLayer=(String)iter.next();
								if(srsLayer.equalsIgnoreCase("EPSG:4326")){
									if (LLbBox != null) { 
										srs+=srsLayer+",";
									}
								}
								
								//for (Iterator i = boundingBoxes.entrySet().iterator(); i.hasNext();) { 
								for (Iterator i = boundingBoxes.iterator(); i.hasNext();) { 
									//Map.Entry entry = (Entry) i.next(); 
									bBox = (CRSEnvelope)i.next();
									
									if(bBox.getEPSGCode().equalsIgnoreCase(srsLayer)){
										srs+=srsLayer+",";
									}
								} 
					
								if(srsLayer.equalsIgnoreCase("EPSG:0"))
									epsg0=true;
							}
							if (epsg0)
								srs+="EPSG:NONE"+",";

							objNode.setAttribute("srs", srs);
							
							String bbox="";
							if(la.getLatLonBoundingBox() != null)
								bbox=la.getLatLonBoundingBox().getMinX()+","+la.getLatLonBoundingBox().getMinY()+","+la.getLatLonBoundingBox().getMaxX()+","+la.getLatLonBoundingBox().getMaxY();

							objNode.setAttribute("bbox", bbox);
							
							objNode.setAttribute("visible", "true");

							objNodeFolder.appendChild(objNode);

						}
						
				
					}

				}
		
			} catch (IOException ee) {
				System.out.println("Unable to get WMS " + ": " + ee.getMessage());
			} catch (ServiceException ee) {
				System.out.println("Unable to get WMS " + ": " + ee.getMessage());
			}
		} catch (MalformedURLException e) {
			System.out.println("Invalid URL " + ": " + e.getMessage());
		} catch (IOException e) {
			// Print out the exception that occurred
			System.out.println("Unable to execute " + ": " + e.getMessage());
		}

	}




	public void writeXML(Document objDoc, String pathXML){

		// WRITE IN A TEXT FILE

		try{
			FileOutputStream fos = new FileOutputStream(new File(pathXML));
			// XERCES 1 or 2 additionnal classes.
			OutputFormat of = new OutputFormat("XML","ISO-8859-1",true);
			of.setIndent(1);
			of.setIndenting(true);
			//of.setDoctype(null,"users.dtd");
			XMLSerializer serializer = new XMLSerializer(fos,of);
			// As a DOM Serializer
			serializer.asDOMSerializer();
			serializer.serialize(objDoc.getDocumentElement());
			fos.close();
		} catch(Exception ee) {
			System.out.println(ee.getMessage());
			ee.printStackTrace();
		}

	}
	public void displayNode(NodeList objNodes, int[] iElement, String sLeftIndent, String sOpenFolders, int stXsl, StringBuffer sb, String g_UrlSrvMetadati){

	short NODE_ELEMENT=1;
	boolean bIsLast = true;
	iElement[0]=iElement[0]+1;
	String sTempLeft="";
	for (int i = 0; i < objNodes.getLength(); ++i) {

		String sHrefMeta="";
		boolean bHasChildren = objNodes.item(i).hasChildNodes();
		
		if(objNodes.item(i).getNextSibling() != null){
			Node oNodeNext = objNodes.item(i).getNextSibling();
			bIsLast = true;
			while(oNodeNext != null){
				if(((Element)oNodeNext).getAttribute("visible").equals("true")){
					bIsLast = false;
					break;
				}
				oNodeNext = oNodeNext.getNextSibling();
			}
		}else{
			bIsLast = true;
		}
		

		if(objNodes.item(i).getNodeType()==NODE_ELEMENT){
			
			Element oNode=(Element)objNodes.item(i);
			
			String sNodeType = oNode.getTagName();

			String sNodeTopo = oNode.getAttribute("topo");

			String sNodeUrl="";
			if (sNodeTopo.equals("WMS"))
			  sNodeUrl=oNode.getAttribute("wmsurl");
			
			String sNodeService="";
			if (sNodeTopo.equals("WMS"))
			  sNodeService=oNode.getAttribute("service");
			
			String sNodeSrs="";
			if (sNodeTopo.equals("WMS"))
			  sNodeSrs=oNode.getAttribute("srs");
			
			String sNodeBbox="";
			if (sNodeTopo.equals("WMS"))
			  sNodeBbox=oNode.getAttribute("bbox");

			String catid = oNode.getAttribute("catid");
			String sAttrValue = oNode.getAttribute("name");
			String sAttrValueTree = oNode.getAttribute("nametree");
			String sAttrValueTreeDesc = oNode.getAttribute("desctree");
			String sNodeTab = oNode.getAttribute("tab");
			String sNodeOwn = oNode.getAttribute("owner");
			String sNodeScaleMin = oNode.getAttribute("scalemin");
			String sNodePub = oNode.getAttribute("pubflag");
			String sMetaLayer = oNode.getAttribute("metalayer");
			String sGroupId = oNode.getAttribute("id");
			String sRootId = oNode.getAttribute("rootId");
			String sVisible = oNode.getAttribute("visible");
			String display = "";

			boolean bIsRoot = false;
			if (sNodeType.equals("root") || sRootId.equals("1")){
				bIsRoot = true;
			}
			
			boolean bShowOpen = false;

			if (sNodeType.equals("document")){
				if (!sNodePub.equals("0")){

					String type="";
					String tipo="";
					if(sNodeTopo.equalsIgnoreCase("p")){
						type="point";
						tipo="SDE_VECTOR";
					} else if(sNodeTopo.equalsIgnoreCase("a")){
						type="polygon";
						tipo="SDE_VECTOR";
					} else if(sNodeTopo.equalsIgnoreCase("l")){
						type="line";
						tipo="SDE_VECTOR";
					} else if(sNodeTopo.equalsIgnoreCase("R")){
						type="raster";
						tipo="SDE_RASTER";
					} else if(sNodeTopo.equalsIgnoreCase("t")){
						type="table";
						tipo="SDE_TABLE";
					} else if(sNodeTopo.equalsIgnoreCase("wms")){
						type="wms";
						tipo="WMS";
					} else {
						type="error";
						tipo="ERROR";
					}
					String scaricabile="false";
					if(sNodePub.equals("3"))
						scaricabile="true";
					
					display="block";
					if (!bShowOpen) {
						display="none";
					}

					sb.append("\t"+"\t"+"<li class=\"LEVEL"+iElement[0]+"\" id=\""+sGroupId+"_TR"+"\" >"+"\r\n");
				
					sb.append("\t"+"\t"+"\t"+sLeftIndent+"\r\n");
					
					sb.append("\t"+"\t"+"\t"+"<span><img height=\"20\" src=\"images/"+fnChooseIcon(bIsLast, bIsRoot, sNodeType, sNodeTopo, bHasChildren, true)+"\" title=\""+fnChooseTitle(bIsRoot, sNodeType, sNodeTopo, bHasChildren)+"\" alt=\"" + fnChooseAlt(bIsRoot, sNodeType, sNodeTopo, bHasChildren) + "\"/></span>"+"\r\n");
					
					sb.append("\t"+"\t"+"\t"+"<span class=\"node\">");
					
					sb.append("<span id=\"L"+sGroupId+"\" class=\"metalink\" >");
					
					if (sNodeTopo.equals("t")){
					
						sb.append("<a title=\"Apri la tabella &quot;" + sAttrValueTreeDesc + "&quot;\"href=\"showTable.jsp?table=" + sNodeOwn + "." + sNodeTab + "&type=tabella" + "&nome=" + sAttrValue + "&layerid=" + catid + "\" onclick=\"return hs.htmlExpand(this, {align: 'center', outlineType: 'rounded-white', wrapperClassName: 'draggable-header', objectType: 'iframe'})\" class=\"highslide\"><strong>" + sAttrValue + "</strong></a>");
					
					} else if(sNodeTopo.equals("WMS")){

						String wmsUrlTot="";
						if(sNodeService.equals("-"))
							wmsUrlTot=sNodeUrl;
						else
							wmsUrlTot=sNodeUrl + sNodeService;
						
						
						// QUI BISOGNEREBBE CONTROLLARE LA QUESTIONE ? / &
						sb.append("<a href=\"javascript: controlAddWmsLayer('L" + sGroupId + "','" + wmsUrlTot +  "','" + sAttrValue + "','" + sAttrValueTree.replaceAll("'", "\\\\'")  + "',0,'"+sNodeSrs+"'"+","+catid+")\" title=\"Aggiunge il layer &quot;" + sAttrValueTree + "&quot; alla mappa\" onMouseover=\"javascript: startTimerPreview(event, '"+wmsUrlTot+"&LAYERS="+sAttrValue+"', '"+sAttrValueTree+"','"+oNode.getAttribute("bbox")+"','L" + sGroupId + "',false);\" onMouseout=\"javascript: stopTimerPreview();\"><strong>" + sAttrValueTree + "</strong></a>");
						
					} else {
						/* puliamo la stringa descrittiva */
						String desc= sAttrValueTreeDesc.replaceAll("\"", "").replaceAll("'", "\\\\'").replaceAll("\r\n", "").replaceAll("\n", "");								
						sb.append("<a href=\"javascript: controlAddLayer('L" + sGroupId + "','"+sNodeOwn + "." + sNodeTab+"."+type+"','"+sAttrValueTree.replaceAll("'", "\\\\'")+"',0,'"+tipo+"',"+scaricabile+","+catid+");\" title=\"Aggiunge il layer &quot;" + sAttrValueTree + "&quot; alla mappa\" onMouseover=\"javascript: startTimerPreview(event, '"+sNodeOwn + "." + sNodeTab+"."+type+"', '"+desc+"',null,'L" + sGroupId + "',"+scaricabile+");\" onMouseout=\"javascript: stopTimerPreview();\"><strong>" + sAttrValueTree + "</strong></a>");
					}
						
					sb.append("</span>"+"\r\n");
					sb.append("</span>"+"\r\n");

					sb.append("\t"+"\t"+"</li>"+"\r\n");
				}
			}

			if (sNodeType.equals("root")){

				bShowOpen = true;
				sOpenFolders = sOpenFolders + "," + iElement[0];
				
				
				sb.append("\t"+"<ul id=\"0_TR\" class=\"menu_table\" >"+"\r\n");
				
				
				displayNode(oNode.getChildNodes(), iElement, sLeftIndent, sOpenFolders, stXsl, sb, g_UrlSrvMetadati);
				
				
				sb.append("\t"+"</ul>"+"\r\n");
			}

			if (sNodeType.equals("root_cat") || sNodeType.equals("folder") ){
				
		        //iElement[0]=iElement[0]+1;
				bShowOpen=false;
				
				if (sVisible.equals("true")){
				 ;
				} else {
					bShowOpen = true;
				}

				if (bHasChildren){
					display="block";
					if (!bShowOpen || sNodeType.equals("folder")) {
						display="none";
					}
				
					sb.append("\t"+"<li class=\"LEVEL"+iElement[0]+"\" >"+"\r\n");
						sb.append("\t"+"<ul>"+"\r\n");
							
							sb.append("\t"+"<li>"+"\r\n");
							
								sb.append("\t"+"\t"+"\t"+sLeftIndent+"\r\n");
										
								sb.append("\t"+"\t"+"\t"+"<span><a href=\"javascript:doChangeTree(document.getElementById('"+sGroupId+"'), arClickedElementID, arAffectedMenuItemID);\"><img height=\"20\" class=\"LEVEL"+iElement[0]+"\" src=\"images/"+fnChooseIcon(bIsLast, bIsRoot, sNodeType, sNodeTopo, bHasChildren, bShowOpen)+"\" title=\""+fnChooseTitle(bIsRoot, sNodeType, sNodeTopo, bHasChildren)+"\" alt=\""+fnChooseAlt(bIsRoot, sNodeType, sNodeTopo, bHasChildren)+"\" id=\""+sGroupId+"\"/></a></span>"+"\r\n");
								sb.append("\t"+"\t"+"\t"+"<span class=\"node\" ><span id=\"F"+sGroupId+"\" class=\"metalink\" ><a href=\"javascript:doChangeTree(document.getElementById('"+sGroupId+"'), arClickedElementID, arAffectedMenuItemID);\" title=\""+fnChooseTitle(bIsRoot, sNodeType, sNodeTopo, bHasChildren)+"\" id=\"Nome_Cartella_"+sGroupId+"\">"+sAttrValue+"</a></span></span>"+"\r\n");
							
							sb.append("\t"+"</li>"+"\r\n");

							
							sTempLeft = sLeftIndent;

							if (iElement[0] > 1){
								sLeftIndent = fnBuildLeftIndent(oNode, bIsLast, sLeftIndent);
							}
						
							
							sb.append("\t"+"<li id=\""+sGroupId+"_TR"+"\" style=\"display:"+display+"\">"+"\r\n");
							sb.append("\t"+"<ul>"+"\r\n");
							displayNode(oNode.getChildNodes(), iElement, sLeftIndent, sOpenFolders, stXsl, sb, g_UrlSrvMetadati);
							sb.append("\t"+"</ul>"+"\r\n");
							sb.append("\t"+"</li>"+"\r\n");

							sLeftIndent = sTempLeft;

						sb.append("\t"+"</ul>"+"\r\n");

					sb.append("\t"+"</li>"+"\r\n");
				}
			}

		} // end IF ==NODE_ELEMENT
		
	} // end FOR

} // end VOID displayNode



	public String fnBuildLeftIndent(Element oNode, boolean bIsLast, String sLeftIndent){
		if (!bIsLast)
			sLeftIndent = sLeftIndent + "								<span><img src=\"images/line.gif\" height=\"20\" alt=\"\" /></span>";
	else
			sLeftIndent = sLeftIndent + "								<span><img src=\"images/pixel.gif\" width=\"20\" height=\"1\" alt=\"\" /></span>";

		return sLeftIndent;
	
	}
	
	public String fnChooseIcon(boolean bIsLast, boolean bIsRoot, String sNodeType, String sNodeTopo, boolean bHasChildren, boolean bShowOpen){
	
		String sIcon = "";
		
		if (sNodeType.equals("document"))
			if (sNodeTopo.equals("a") || sNodeTopo.equals("a+"))
			   if (!bIsLast)
				   sIcon = "polyjoin.gif";
			   else
				   sIcon = "poly.gif";
			else if (sNodeTopo.equals("p") || sNodeTopo.equals("p+"))
			   if (!bIsLast)
				   sIcon = "pointjoin.gif";
			   else
				   sIcon = "point.gif";
			else if (sNodeTopo.equals("l") || sNodeTopo.equals("l+"))
			   if (!bIsLast)
				   sIcon = "linesjoin.gif";
			   else
				   sIcon = "lines.gif";
			else if (sNodeTopo.equals("R") || sNodeTopo.equals("cat"))
			   if (!bIsLast)
				   sIcon = "rasterjoin.gif";
			   else
				   sIcon = "raster.gif";
			else if (sNodeTopo.equals("t"))
			   if (!bIsLast)
				   sIcon = "tablejoin.gif";
			   else
				   sIcon = "table.gif";
			else if (sNodeTopo.equals("0"))
			   if (!bIsLast)
				   sIcon = "tablejoin.gif";
			   else
				   sIcon = "table.gif";
			else if (sNodeTopo.equals("WMS"))
			   if (!bIsLast)
				   sIcon = "wmsjoin.gif";
			   else
				   sIcon = "wms.gif";
			else		   
			   if (!bIsLast)
				   sIcon = "tablejoin.gif";
			   else
				   sIcon = "table.gif";
			
		else 
			if (bIsRoot) {
				if (bShowOpen)
					sIcon = "minusonly.gif";
				else
					sIcon = "plusonly.gif";
			} else if (bHasChildren) {
				// aggiunto da landini_m 20/04/2010
					if (bShowOpen)
						sIcon = "folderopen.gif";
					else
						sIcon = "folderclosed.gif";
			} /*else if (bHasChildren) {
				if (!bIsLast)
					sIcon = "folderclosedjoin-empty.gif";
				else
					sIcon = "folderclosed-empty.gif";
			}*/
		

		return sIcon;
	
	}
	
	public String fnChooseTitle(boolean bIsRoot, String sNodeType, String sNodeTopo, boolean bHasChildren){
	
		String sTitle = "";
		
		if (sNodeType.equals("document"))  
			if (sNodeTopo.equals("a") || sNodeTopo.equals("a+"))
				   sTitle = "Topologia poligonale";
			else if (sNodeTopo.equals("p") || sNodeTopo.equals("p+"))
				   sTitle = "Topologia puntuale";
			else if (sNodeTopo.equals("l") || sNodeTopo.equals("l+"))
				   sTitle = "Topologia lineare";
			else if (sNodeTopo.equals("R") || sNodeTopo.equals("cat"))
				   sTitle = "Immagine raster";
			else if (sNodeTopo.equals("t"))
				   sTitle = "Tabella";
			else if (sNodeTopo.equals("0"))
				   sTitle = "Cartella";
			else if (sNodeTopo.equals("WMS"))
				   sTitle = "Servizio WMS";
			else		   
				   sTitle = "Cartella";
		else 
			if (bIsRoot)
					sTitle = "Apri cartella";
			else if  (bHasChildren)
					sTitle = "Apri cartella";
			else if (!bHasChildren)
					sTitle = "Cartella vuota";
		
		return sTitle;
	
	}

	public String fnChooseAlt(boolean bIsRoot, String sNodeType, String sNodeTopo, boolean bHasChildren){
	
		String sAlt = "";
		
		if (sNodeType.equals("document"))
			if (sNodeTopo.equals("a") || sNodeTopo.equals("a+"))
				   sAlt = "Topologia poligonale";
			else if (sNodeTopo.equals("p") || sNodeTopo.equals("p+"))
				   sAlt = "Topologia puntuale";
			else if (sNodeTopo.equals("l") || sNodeTopo.equals("l+"))
				   sAlt = "Topologia lineare";
			else if (sNodeTopo.equals("R") || sNodeTopo.equals("cat"))
				   sAlt = "Immagine raster";
			else if (sNodeTopo.equals("t"))
				   sAlt = "Tabella";
			else if (sNodeTopo.equals("0"))
				   sAlt = "Cartella"; 
			else if (sNodeTopo.equals("WMS"))
				   sAlt = "Servizio WMS";  
			else		   
				   sAlt = "Cartella";
		else 
			if (bIsRoot)
					sAlt = "Apri cartella";
			else if  (bHasChildren)
					sAlt = "Apri cartella";
			else if (!bHasChildren)
					sAlt = "Cartella vuota";
		
		return sAlt;
	
	}

	public String fnMap(String sNodeOwn, String sNodeTab, String sNodeType, String sNodeTopo, String sNodeScaleMin, String sAttrValue, String sNodePub, String sGroupId, String sWmsUrl, String sWmsService, String sSrs, String sBbox, String sAttrValueTree){
		//dim mReturn, mapHref, mapScala, idOggetto
		
		String idOggetto=sGroupId.substring(sGroupId.indexOf("_Og")+3,sGroupId.length());
		String mReturn = "";
		String mapHref = "";
		String type="";
		if(sNodeTopo.equalsIgnoreCase("p"))
			type="point";
		else if(sNodeTopo.equalsIgnoreCase("a"))
			type="polygon";
		else if(sNodeTopo.equalsIgnoreCase("l"))
			type="line";
		else if(sNodeTopo.equalsIgnoreCase("R"))
			type="raster";
		else if(sNodeTopo.equalsIgnoreCase("t"))
			type="table";
		else if(sNodeTopo.equalsIgnoreCase("wms"))
			type="wms";
		else
			type="error";

		if (sNodeTopo.equals("t")){
			//mapHref = "<a title=\"Visualizza la tabella: " + sAttrValue + "\" href=\"showTable.jsp?id=" + idOggetto + "&table=" + sNodeOwn + "." + sNodeTab; 
			mapHref = "<a title=\"Apri la tabella: " + sAttrValue + "\" href=\"showTable.jsp?table=" + sNodeOwn + "." + sNodeTab; 
		} else if (sNodeTopo.equals("WMS")){

			//String[] sSrsAr=sSrs.split(",");
			mapHref = "";
			//for (int iSrs=0; iSrs<sSrsAr.length; iSrs++){
				mapHref = mapHref + "<a title=\"Crea una nuova mappa con il layer WMS &quot;" + sAttrValueTree + "&quot; nel sistema di riferimento &quot;" + "&quot;\" href=\"javascript: addWmsLayer('" + sWmsUrl + sWmsService +  "','" + sAttrValue + "','" + sAttrValueTree  + "', true)\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/></a>&nbsp;";
				
				mapHref = mapHref + "&nbsp;<a title=\"Aggiungi il layer &quot;" + sAttrValueTree + "&quot; nel sistema di riferimento &quot;" + "&quot; alla mappa\" href=\"javascript: addWmsLayer('" + sWmsUrl + sWmsService +  "','" + sAttrValue + "','" + sAttrValueTree  + "', false)\" ><img src=\"images/mActionAddLayer.png\" id=\"I" + sGroupId + "_2\"/></a>";
			//}

		} else {
		
			mapHref = "<a title=\"Crea una nuova mappa con il layer &quot;" + sAttrValue + "&quot;\" onclick=\"javascript: controlAddLayer(this,event,'"+sNodeOwn + "." + sNodeTab+"."+type+"',true,0)\" href=\"#\"";// + "&layer=" + sNodeOwn + "." + sNodeTab;
			
		}

		String mapScala = "3500000";

		if (sNodeType.equals("document") && !sNodePub.equals("0") && !sNodePub.equals("1")){
		
			if (sNodeTopo.equals("a") || sNodeTopo.equals("a+")){
				if (!sNodeScaleMin.equals("0") && !sNodeScaleMin.equals("2000000"))
					mapHref = mapHref + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/>";
				else
					mapHref = mapHref + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/>";
				
				//if (sNodePub.equals("3"))
				//	mapHref = mapHref + "<img src=\"images/zip.gif\"/>";

				mapHref = mapHref + "</a>";
				
				mapHref = mapHref + "&nbsp;<a href=\"javascript: addLayer('"+sNodeOwn + "." + sNodeTab+".polygon', false, false, 0)\" title=\"Aggiunge il layer &quot;" + sAttrValue + "&quot; alla mappa\"><img src=\"images/mActionAddLayer.png\"/></a>";

				
				mReturn = mapHref;
				
			}else if (sNodeTopo.equals("p") || sNodeTopo.equals("p+")){
				
				if (!sNodeScaleMin.equals("0") && !sNodeScaleMin.equals("2000000"))
					mapHref = mapHref + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/>";
				else	
					mapHref = mapHref + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/>";
				
				//if (sNodePub.equals("3"))
				//	mapHref = mapHref + "<img src=\"images/zip.gif\"/>";

				mapHref = mapHref + "</a>";
							
				mapHref = mapHref + "&nbsp;<a href=\"javascript: addLayer('"+sNodeOwn + "." + sNodeTab+".point', false, false, 0)\" title=\"Aggiunge il layer  &quot;" + sAttrValue + "&quot; alla mappa\"><img src=\"images/mActionAddLayer.png\"/></a>";
				
				mReturn = mapHref;

			}else if (sNodeTopo.equals("l") || sNodeTopo.equals("l+")){

				if (!sNodeScaleMin.equals("0") && !sNodeScaleMin.equals("2000000"))
					mapHref = mapHref + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/>";
				else	
					mapHref = mapHref + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/>";

				//if (sNodePub.equals("3"))
				//	mapHref = mapHref + "<img src=\"images/zip.gif\"/>";

				mapHref = mapHref + "</a>";
				mapHref = mapHref + "&nbsp;<a href=\"javascript: addLayer('"+sNodeOwn + "." + sNodeTab+".line', false, false, 0)\" title=\"Aggiunge il layer  &quot;" + sAttrValue + "&quot; alla mappa\"><img src=\"images/mActionAddLayer.png\"/></a>";

				mReturn = mapHref;	
			
			}else if (sNodeTopo.equals("R")){
				
				if (!sNodeScaleMin.equals("0") && !sNodeScaleMin.equals("2000000"))
					mapHref = mapHref + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId +"\"/>";
				else	
					mapHref = mapHref + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/>";

				//if (sNodePub.equals("3"))
				//	mapHref = mapHref + "<img src=\"images/zip.gif\"/>";

				mapHref = mapHref + "</a>";
				mapHref = mapHref + "&nbsp;<a href=\"javascript: addLayer('"+sNodeOwn + "." + sNodeTab+".raster', false, false, 0)\" title=\"Aggiunge il layer &quot;" + sAttrValue + "&quot; alla mappa\"><img src=\"images/mActionAddLayer.png\"/></a>";
				
				mReturn = mapHref;
					
			}else if (sNodeTopo.equals("t")){
				
				mapHref = mapHref + "&type=tabella" + "&nome=" + sAttrValue + "\" onclick=\"return hs.htmlExpand(this, {align: 'center', outlineType: 'rounded-white', wrapperClassName: 'draggable-header', objectType: 'iframe'})\" class=\"highslide\"><img src=\"images/mActionOpenTable.png\" id=\"I" + sGroupId + "\"/>";
				
				//if (sNodePub.equals("3"))
				//	mapHref = mapHref + "<img src=\"images/zip.gif\"/>";
				
				mapHref = mapHref + "</a>";
				
				mReturn = mapHref;

			}else if (sNodeTopo.equals("WMS")){
				
				//mapHref = mapHref + "&type=wms" + "&nome=" + sAttrValue + "\" ><img src=\"images/mActionFileNew.png\" id=\"I" + sGroupId + "\"/>";
				//mapHref = mapHref + "</a>";
				mReturn = mapHref;
			
			}
		
		}
		
		return mReturn;
	
	}


} // end CLASS menuTreeClasses
%>