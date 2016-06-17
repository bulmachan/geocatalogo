<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
%><%

String app = "unknown";
if ((request.getParameter("app") != null) && (request.getParameter("app") != "")) {
	app = request.getParameter("app");
}


	String layer = request.getParameter("layer");
	String srs = request.getParameter("srs");
	/*.replace(":NONE",":202032");*/
	String nome = request.getParameter("nome");
	String layerid = request.getParameter("layerid");
	String nomeXlicenza=nome;


	String bBox="";
	if ((request.getParameter("bbox") != null) && (request.getParameter("bbox") != "")){
		bBox=request.getParameter("bbox");
	} else {
		if ((request.getParameter("BBOX") != null) && (request.getParameter("BBOX") != "")){
			bBox=request.getParameter("BBOX");
		} else {
			bBox="";
		}
	}

	/*String bBox = request.getParameter("bbox");
	
	double minX = 500000.0;
	double minY = 840000.0; 
	double maxX = 820000.0;
	double maxY = 1020000.0;

	if(!bBox.equals("")){
		minX=Double.parseDouble(bBox.split(",")[0]);
		minY=Double.parseDouble(bBox.split(",")[1]);
		maxX=Double.parseDouble(bBox.split(",")[2]);
		maxY=Double.parseDouble(bBox.split(",")[3]);
	}*/


	String sistcoord="";
	
	if (request.getParameter("srs") != null){
		sistcoord=request.getParameter("srs");
	} else {
		if (request.getParameter("SRS") != null){
			sistcoord=request.getParameter("SRS");
		} else {
			sistcoord="";
		}
	}

	/*if(sistcoord.indexOf("NONE")>-1)
		sistcoord="0";
	else
		if(sistcoord.indexOf("EPSG:")>-1)
			sistcoord=sistcoord.replace("EPSG:","");
		else
			sistcoord="";
	*/

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="it">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<title>Download in formato Shapefile</title>
	<link rel="stylesheet" media="screen"  type="text/css" href="styles/style_page.css" />

	<script type="text/javascript" src="js/funzioniAjax.js"></script>
	<script type="text/javascript">
	/*<![CDATA[*/
		http = CreaHttp();
		
		function getCheckedValue(radioObj) {
			if(!radioObj)
				return "";
			var radioLength = radioObj.length;
			if(radioLength == undefined)
				if(radioObj.checked)
					return radioObj.value;
			else
				return "";
			for(var i = 0; i < radioLength; i++) {
				if(radioObj[i].checked) {
					return radioObj[i].value;
				}
			}
			return "";
		}

		function accetta(){

			if(parent.window.loadingPan){
				if(parent.window.loadingPan.maximized){

					alert ("Attendere il caricamento del layer nella mappa e cliccare nuovamente su Continua.");
					return null;
				}
			}
			//} else {

				document.getElementById("bottoni").style.display="none";
				document.getElementById("attendere").style.display="block";

				if (http!=null){
					if(extentBBox){
						//var sistcoord = getCheckedValue(document.forms['extract'].elements['sistcoord']);

						//var sistcoord = parent.srsGlobal;//"<%=srs%>";
						var clip="false";
						if (document.getElementById("clipTrue").checked){
							clip="true";
						}
						xmlAjaxRequest('extractShp.jsp', 'layer=<%=layer%>&bbox='+extentBBox+'&sistcoord='+sistcoord+'&clip='+clip, null, showsResults1, 'text');
						//prompt("",'extractShp.jsp?'+'layer=<%=layer%>&bbox='+parent.map.getExtent().toBBOX()+'&sistcoord='+sistcoord);

					} else {
						alert("Estrazione al momento non disponibile");
					}
				}
			//}
		}
		
		
		var dwnZipFileName;
		var dwnTotSize;
		function showsResults1(result){
	
			//alert(result);
	
			if(result.indexOf("ERRORE")>-1){

				document.getElementById("risultato").innerHTML="ATTENZIONE<br />L'estrazione dei dati ha prodotto un errore: si consiglia di scegliere una porzione di territorio piu' piccola e riprovare.";
				document.getElementById("risultato").style.display="block";
				document.getElementById("attendere").style.display="none";
			
			
			} else {
			
				if(result.split("<|>")[0]==""){
					//alert(result);
					document.getElementById("risultato").innerHTML="<strong><br />ATTENZIONE<br /><br />L'estrazione dei dati ha prodotto un errore: si consiglia di riprovare.<\/strong>"+"<br /><br /><input type=\"button\" id=\"nuova_estrazione\" value=\"nuova estrazione\" onclick=\"window.location.href=window.location.href\" \/>&nbsp;&nbsp;<input type=\"button\" id=\"chiudi_estrazione\" value=\"chiudi\" onclick=\"return parent.hs.close(this.elemento);\" \/><br /><br />";
					document.getElementById("risultato").style.display="block";
					document.getElementById("attendere").style.display="none";
				
				} else {
					dwnZipFileName=result.split("<|>")[0];
					dwnTotSize=parseInt(result.split("<|>")[1]);
					//prompt('','getAttachmentsList.jsp?layer=<%=layer%>');
					xmlAjaxRequest('getAttachmentsList.jsp', 'layer=<%=layer%>', null, showsResults2, 'text');

					// costruire string degli URL dei files da aggiungere separati da una , controllare prima che il file esistano
				}
			}

		}
		function showsResults2(result){
			
			dwnAttachmentsList=result.split("<|>")[0];
			dwnTotSize+=parseInt(result.split("<|>")[1]);
			metaLayer=result.split("<|>")[2];

			if(Math.round(dwnTotSize/1024)<1000)
				size=Math.round(dwnTotSize/1024)+" Kb";
			else
				size=(Math.round(dwnTotSize/1024)/1000).toFixed(1)+" Mb";
			
			document.getElementById("risultato").innerHTML="<br /><p>File generato e pronto per il <a href=\"createZip.jsp?zip="+dwnZipFileName+"&files="+dwnAttachmentsList+"&srs=<%=srs%>"+"&nome=<%=nome%>"+"&size="+size+"&metalayer="+metaLayer+"&app=<%=app%>\" title=\"Scarica il file richiesto\">download<\/a> ("+size+")<\/p><br /><br /><input type=\"button\" id=\"nuova_estrazione\" value=\"nuova estrazione\" onclick=\"window.location.href=window.location.href\" onkeypress=\"if (event.keyCode == 13) {window.location.href=window.location.href}\" title=\"Lancia una nuova estrazione\" class=\"button\"\/> &nbsp; <input type=\"button\" id=\"chiudi_estrazione\" value=\"chiudi\" onclick=\"return parent.hs.close(this.elemento);\" onkeypress=\"if (event.keyCode == 13) {return parent.hs.close(this.elemento);}\" title=\"Chiudi la finestra\" class=\"button\" \/><br /><br />";
			
			document.getElementById("risultato").style.display="block";
			document.getElementById("attendere").style.display="none";

			document.getElementById("clipTrue").disabled = true;
			document.getElementById("clipFalse").disabled = true;

			// SCRIVE NEL GEOLOG:
			if('<%=layerid%>'!='')
				parent.writeGeoLog('download shape','<%=layerid%>');
		}

	
		/* OLD !?! */
		function setCheckedValue(radioObj, newValue) {
			if(!radioObj)
				return;
			var radioLength = radioObj.length;
			if(radioLength == undefined) {
				radioObj.checked = (radioObj.value == newValue.toString());
				return;
			}
			for(var i = 0; i < radioLength; i++) {
				radioObj[i].checked = false;
				if(radioObj[i].value == newValue.toString()) {
					radioObj[i].checked = true;
				}
			}
		}
		
		var extentBBox;
		var sistcoord;

		function init(){

			var bBox="<%=bBox%>";

			if(bBox==""){
				if(parent.extent.containsBounds(parent.map.getExtent(),false,false)){
					extentBBox=parent.map.getExtent(); // EXTENT PER CLIPPARE
				} else {
					extentBBox=parent.extent.clone(); // EXTENT DI DEFAULT
					extentBBox.intersect(parent.map.getExtent()); // EXTENT INTERSEZIONE TRA IL DEFAULT E IL CLIP
				}
				var extentRER=parent.extent.toBBOX();

				extentBBox=extentBBox.toBBOX();

				var coordsDigits=parent.coordsDigits;

			} else {
				
				extentBBox=bBox;
				var extentRER="500000,840000,810000,1005000";
				var coordsDigits=2;

			}
			sistcoord="<%=sistcoord%>";
			if(sistcoord==""){
				var srsGlobal=parent.srsGlobal;
			} else {
				var srsGlobal=sistcoord;
			}
			var x1=parseFloat(extentBBox.split(",")[0]);
			var y1=parseFloat(extentBBox.split(",")[1]);
			var x2=parseFloat(extentBBox.split(",")[2]);
			var y2=parseFloat(extentBBox.split(",")[3]);

			var srcImage="getMap.jsp?LAYERS=BASE_USER.BASE_VF_REGIONE_ER_POL.polygon&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&FORMAT=image%2Fjpeg&SRS="+srsGlobal+"&WIDTH=220&HEIGHT=130&BBOX="+extentRER+"&EXTRACTBBOX="+extentBBox;
			
			tmp_img = new Image();
			tmp_img.onload=function() {
				document.getElementById("imgMappa").width = this.width;
				document.getElementById("imgMappa").height = this.height;
				document.getElementById("imgMappa").src = srcImage;
			}
			tmp_img.src = srcImage;

			var testoSRS="";


			switch(srsGlobal){
				case "EPSG:202003": 
					//testoSRS="ED50 / UTMA (RER) ["+parent.srsGlobal+"]";
					testoSRS="UTMRER [Roma40] (EPSG:202003/5659)";
				break;
				case "EPSG:202032": 
					//testoSRS="ED50 / UTMA (RER) ["+parent.srsGlobal+"]";
					testoSRS="UTMA [ED50] (EPSG:202032)";
				break;

				case "EPSG:23032": 
					testoSRS="UTM 32N [ED50] (EPSG:23032)";
				break;

				case "EPSG:3003": 
					testoSRS="Gauss-Boaga Ovest [Roma40] (EPSG:3003)";
				break;
				
				case "EPSG:25832": 
					testoSRS="UTM 32N [ETRS89] (EPSG:25832)";
				break;
				
				case "EPSG:4258": 
					testoSRS="Geografiche [ETRS89] (EPSG:4258)";
				break;
				
				case "EPSG:32632": 
					testoSRS="UTM 32N [WGS84] (EPSG:32632)";
				break;
				
				case "EPSG:4326": 
					testoSRS="Gradi decimali [WGS84] (EPSG:4326)";
				break;
			
				case "EPSG:3857": 
					testoSRS="Pseudo Mercator [WGS84] (EPSG:3857)";
				break;

			
			}
			document.getElementById("testoSRS").innerHTML=testoSRS;

			str="Est: "+x1.toFixed(coordsDigits)+" - ";
			str+="Sud: "+y1.toFixed(coordsDigits)+" - ";
			str+="Ovest: "+x2.toFixed(coordsDigits)+" - ";
			str+="Nord: "+y2.toFixed(coordsDigits);
			
			document.getElementById("testoBBOX").innerHTML=str;

		}

	/*]]>*/
	</script>

</head>

<body>

<form id="extract" action="extract.jsp" method="post">
  
	<div id="main">
		<div id="intestazione" class="download">

			<h1>Estrazione dati in formato ESRI Shapefile</h1>
			<p>Nome: <strong><%=nome%></strong></p>
			<p>Layer: <strong><%=layer%></strong></p>

			<div id="divMappa">
				<div id="mappaImmagine">
					<img id="imgMappa" src="images/ajax-loader.gif" width="56" height="21" alt="Riquadro di estrazione" title="Riquadro di estrazione" />
				</div>
			</div>
			
			<div id="condizioni">
				<div><h3>Sistema di riferimento delle coordinate di output:</h3></div>
				<p><span id="testoSRS"></span></p>
			</div>
			<div id="condizioni">
				<div><h3>Estensione territoriale richiesta per l'estrazione:</h3></div>
				<span id="testoBBOX"></span><br /><br />
				<input type="radio" id="clipTrue" name="clip" checked="checked" value="true" />&nbsp;Taglia le entità sull'estensione della mappa<br />
				<input type="radio" id="clipFalse" name="clip" value="false" />&nbsp;Esporta le entità che ricadono nell'estensione della mappa
			</div>

		</div>
		
		
		<div id="condizioni">

<jsp:include page="licenza.jsp">
	<jsp:param name="layer" value="<%=nomeXlicenza%>" />
	<jsp:param name="header" value="no" />
</jsp:include>

		</div>
		
		<div id="bottoni">
				
			<input name="back" type="button" 
				id="chiudi"
				value="Annulla" 
				onclick="return parent.hs.close(this.elemento);"
				onkeypress="if (event.keyCode == 13) {return parent.hs.close(this.elemento);}"
				title="Chiudi la finestra" 
				class="button" />
			
			<input name="submit" type="button" 
				value="Continua" 
				onclick="javascript:accetta();" 
				onkeypress="if (event.keyCode == 13) { javascript:accetta();}"
				title="Avvia download" 
				class="button" />

		</div>

		
		<div id="attendere" class="display_none">
			<h3>Attendere l'estrazione dei dati</h3>
			<img src="images/ajax-loader.gif" alt="Caricamento..." />
		</div>
		<div id="risultato" class="display_none">
		</div>
	</div>
</form>
<script type="text/javascript">
	/*<![CDATA[*/
	//setCheckedValue(document.forms["extract"].elements["sistcoord"],parent.srsGlobal);
	init();
	/*]]>*/
</script>
</body>
</html>
