<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
%><%@ include file="params.jsp"
%><%@ include file="configDB.jsp"
%><%
	
String pubflag = "";
String tableDescTree = "";
String tableDesc = "";
String tableDescLong = "";
String layerName="";
String metalayer="";

String table="";
String owner="";

String tipo = request.getParameter("tipo");

String srs = request.getParameter("srs");
String[] layer=request.getParameter("layer").split("\\.");

String nomeXlicenza="";
owner=layer[0];
table=layer[1];


String stmt_Sql = "";
ResultSet rs = null;
ResultSet rsMeta = null;
Statement stm = null;
try	{

	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

	stmt_Sql = "SELECT OWNER, TABLE_NAME, PUB_FLAG, TABLE_DESC_TREE, TABLE_DESC, TABLE_DESC_LONG, TOPO, ID_METADATO FROM CAT_USER.cat_v_oggetti WHERE upper(OWNER) = upper('" + owner + "') and upper(TABLE_NAME)=upper('"+ table + "') and WHERE_IS = 'geo04srv:geo04_sde'";
	
	rs = stm.executeQuery(stmt_Sql);
	rs.next();
	
	tableDescTree = rs.getString("TABLE_DESC_TREE");
	tableDesc = rs.getString("TABLE_DESC");
	tableDescLong = rs.getString("TABLE_DESC_LONG");
	pubflag = rs.getString("PUB_FLAG");
	nomeXlicenza=tableDescTree;

	if(rs.getObject("ID_METADATO")!=null)
		metalayer = rs.getString("ID_METADATO");

    rs.close();

	//stmt_Sql = "SELECT xml FROM sde.gdb_usermetadata WHERE UPPER(owner) = UPPER('" + owner + "') AND UPPER(name) = UPPER('" + table + "')";
	
	stmt_Sql ="SELECT sde.sdexmltotext(sde.sde_xml_doc2.xml_doc) AS xml FROM SDE.GDB_ITEMS, SDE.SDE_XML_DOC2 WHERE SDE.SDE_XML_DOC2.SDE_XML_ID = SDE.GDB_ITEMS.DOCUMENTATION AND NAME = '" + owner + "." + table + "'";
	
	rsMeta = stm.executeQuery(stmt_Sql);

	boolean metadatiEsri=false;
	if(rsMeta.next())
		metadatiEsri=true;
	
	rs.close();
	rsMeta.close();

    stm.close();
	dbConnCAT.close();

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="it">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
	<title>Proprietà LAYER</title>
	<link rel="stylesheet" media="screen"  type="text/css" href="styles/style_page.css" />
	<script type="text/javascript" src="js/funzioniAjax.js"></script>
	<script type="text/javascript">
	/*<![CDATA[*/
		var http = CreaHttp();
		var http1 = CreaHttp();
		var minX,minY,maxX,maxY;
		function getLayerExtent(layer){
			
				http.open('get', 'getLayerExtent.jsp?layer=' + layer);
				http.onreadystatechange = eval("showLayerExtent"); 
				http.send(null);
		
		
		}

		function showLayerExtent() {
			if (http.readyState == 4) {
				//alert(http1.responseText);
				var response = http.responseText.split(",");
				if(response.length==4){
					minX=parseFloat(response[0]);
					minY=parseFloat(response[1]);
					maxX=parseFloat(response[2]);
					maxY=parseFloat(response[3]);
					
					document.getElementById("extent").innerHTML="<li>Est: "+minX.toFixed(2)+"</li>"+"<li>Sud: "+minY.toFixed(2)+"</li>"+"<li>Ovest: "+maxX.toFixed(2)+"</li>"+"<li>Nord: "+maxY.toFixed(2)+"</li>";

<%
	if (pubflag.equals("3") && "a".equals("b")){ // PER IL MOMENTO LO TOGLIAMO
%>					
					
					document.getElementById("download_total").href+="&bbox="+minX+","+minY+","+maxX+","+maxY;
					
					document.getElementById("download_current").href+="&bbox="+parent.map.getExtent().left+","+parent.map.getExtent().bottom+","+parent.map.getExtent().right+","+parent.map.getExtent().top;
					
<% }
%>
					
				}
			}//if	
			
		}
		
		function getTableFields(layer){
			
				http1.open('get', 'getTableFields.jsp?table=' + layer);
				http1.onreadystatechange = eval("showTableFields"); 
				http1.send(null);
	
		}
		
		function showTableFields() {
			if (http1.readyState == 4) {
				//alert(http1.responseText);
				var response = http1.responseText.split("<|>");
				var output="";
				for(var j=0; j<response.length-1; j++){
					output+="<li>"+response[j]+"</li>";
				}
				document.getElementById("fields").innerHTML=output;
			}
		}
		
		/* OLD ?!? */
		function goToExtent() {
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
	/*]]>*/
	</script>

</head>

<body onload="getLayerExtent('<%=owner+"."+table%>'); getTableFields('<%=owner+"."+table%>')">

<form action="extract.jsp" method="post">
  
	<div id="main">
		<div id="intestazione" class="properties">
			<h1>Proprietà del LAYER</h1>
			<p><img class="thumb_properties" src="getThumbnail.jsp?layer=<%=owner+"."+table%>&w=400" alt="Immagine di anteprima <%=tableDescTree%>" /></p>
			
			
			<p><strong><%=tableDescTree%></strong></p>
			<p><strong><%=tableDesc%></strong></p>
			<p><strong><%=tableDescLong%></strong></p>
			<div class="prop_cont">
			<p>
			<!--Metadati: -->
			
<%
		metadatiEsri=false; // LO SPEGNIAMO PERCHE IL FOGLIO DI STILE FGDC_SGSS non funziona piu
		if(metadatiEsri){
%>
			<strong><a href="getMetadata.jsp?layer=<%=owner+"."+table%>&amp;style=FGDC_SGSS" title="Apri i metadati nel Formato ESRI FGDC">Formato ESRI FGDC</a></strong>
<%
			if(!metalayer.equals("")){
%>
				&nbsp;|&nbsp;
<%			}
%>
<%		}
%>

<%
		if(!metalayer.equals("")){
%>
			<strong><a href="<%=g_UrlSrvMetadati+metalayer%>" title="Apri i metadati dal Repository della Regione Emilia-Romagna">Apri i Metadati</a><br />(Formato Emilia-Romagna)</strong>
<%		}
%>
			</p>
			<div><h3>Estensione territoriale del layer nel sistema riferimento originale:</h3></div>
			<ul id="extent">
			</ul>
			
			<div><h3>Sistema di riferimento delle coordinate visualizzato in mappa:</h3></div>
<% if (!srs.equals("EPSG:202003") && !srs.equals("EPSG:202032")){
%>
			<p><strong><a href="http://spatialreference.org/ref/<%=srs.replaceAll(":","/").toLowerCase()%>/" title="Apri i dettagli del sistema di riferimento in un'altra pagina" rel="external">
<%			out.print(srs.trim());
%>
			</a></strong>

<% } else {
%>

			<p><strong>
<%			out.print(srs.trim());
%>
			</strong>

<% }
%>

<%			if(srs.equals("EPSG:202003") || srs.equals("EPSG:202032"))
				out.println(" [*]");
				
%>			</p>
<%			if(srs.equals("EPSG:202003"))
				out.println("<p>[*] Il sistema di riferimento EPSG:202003 è riconduicibile all'<a href=\"http://spatialreference.org/ref/epsg/3003/\" title=\"Apri i dettagli del sistema di riferimento in un'altra pagina\" rel=\"external\">EPSG:3003</a> ad eccezione di una traslazione di 500053 di metri sulle x e di -3999820 di metri sulle y.</p>");
%>
<%			if(srs.equals("EPSG:202032"))
				out.println("<p>[*] Il sistema di riferimento EPSG:202032 è riconduicibile all'<a href=\"http://spatialreference.org/ref/epsg/23032/\" title=\"Apri i dettagli del sistema di riferimento in un'altra pagina\" rel=\"external\">EPSG:23032</a> ad eccezione di una traslazione di -4000000 di metri sulle y.</p>");
%>
			
			<div><h3>Struttura dei dati alfanumerici:</h3></div>
			<ul id="fields">
			</ul>
<%
	if (pubflag.equals("3") && "a".equals("b")){ // PER IL MOMENTO LO TOGLIAMO
%>
			<p>Download dei dati dell'estensione della mappa corrente in formato Shapefile <a id="download_current" href="downloadShp.jsp?layer=<%=owner+"."+table%>" title="Scarica i dati dell'estensione della mappa corrente in formato Shapefile" onclick="return parent.hs.htmlExpand(this, {align: 'center', outlineType: 'rounded-white', wrapperClassName: 'draggable-header', objectType: 'iframe'})" class="highslide"><img alt="Scarica i dati dell'estensione della mappa corrente in formato Shapefile" src="images/download.png" /></a></p>
			<p>Download dei dati dell'intera estensione in formato Shapefile <a id="download_total" href="downloadShp.jsp?layer=<%=owner+"."+table%>" title="Scarica i dati dell'intera estensione in formato Shapefile " onclick="return parent.hs.htmlExpand(this, {align: 'center', outlineType: 'rounded-white', wrapperClassName: 'draggable-header', objectType: 'iframe'})" class="highslide"><img alt="Scarica i dati dell'intera estensione in formato Shapefile " src="images/download.png"/></a></p>


<% }
%>

<!--<jsp:include page="licenza.jsp">
	<jsp:param name="layer" value="<%=nomeXlicenza%>" />
	<jsp:param name="header" value="no" />
</jsp:include>-->
			<div>
				<h1>Licenza d'uso</h1>
				<h2>Licenza Banca dati "<%=nomeXlicenza%>"</h2>
				<span class="justify">
					
				<p>La titolarità piena ed esclusiva della "Banca dati <%=nomeXlicenza%>" è della
				Regione Emilia-Romagna (ai sensi della L. 633/41 e ss. mm. ii.).</p>
				<p>
				La Regione Emilia-Romagna autorizza la libera e gratuita consultazione, estrazione,
				riproduzione e modifica dei dati in essa contenuti da parte di chiunque vi abbia
				interesse per qualunque fine, ovvero secondo i termini della Licenza <a href="http://creativecommons.org/licenses/by/2.5/it/legalcode" title="Apri il testo della licenza CC-BY 2.5">Creative Commons - CC-BY 2.5</a>.</p>
				<br />
				<div id="licenza_dati">

					<a href="http://creativecommons.org/licenses/by/2.5/it/legalcode" title="Apri il testo della licenza CC-BY 2.5">
						<img alt="Licenza Creative Commons" src="images/88x31.png" />
					</a>
				</div>
			</div>
	

			</div>
		</div>	
	</div>
</form>
</body>
</html>


<%
	} catch (Exception e) {
			System.err.println("Exception: "+e.getMessage());
			out.println("Exception: "+e.getMessage());
			
			if(rsMeta!=null)
				rsMeta.close();
			
			if(rs!=null)
				rs.close();

			if(stm!=null)
				stm.close();
			
			dbConnCAT.close();

}

%>