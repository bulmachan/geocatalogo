<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page errorPage="errorpage.jsp" %>
<%@ include file="setContentType.jsp" %>
<%@ include file="configDB.jsp" %>

<%!
	static String TABELLA_PROVINCE     = "BASE_USER.BASE_PROVINCE";
	static String TABELLA_COMUNI       = "BASE_USER.BASE_V_COM_PRO_REG";
	static String TABELLA_PROV_COM_CTR = "BASE_USER.BASE_V_CTR_COM_PRO";
	static String FILTRO_PROVINCIA = null;    
	static Logger log = Logger.getLogger("carg");
%>
<%
	ResultSet result=null;
	java.sql.Statement statement=null;
	ResultSet resultCod=null;
	java.sql.Statement statementCod=null;

    try {

	String valore=null;
    String sqlstr=null;
	long idToponimo=0;
	String tipoFoglio="Foglio";

	request.setCharacterEncoding(pageCharEncoding);

	String prov = request.getParameter("provincia");
	if (prov != null)
		prov = prov.trim();

	String com=request.getParameter("comune");
	if (com != null)
		com = com.trim();

  statement = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

  statementCod = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
  
  boolean inizio = false;
  String msg = "";
%>
<%--
<?xml version="1.0" encoding="<%=pageCharEncoding%>"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
--%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it-IT" lang="it-IT">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=<%=pageCharEncoding%>"/>
	<title>Il Catalogo dei Dati Geografici, Servizio Geologico Sismico e dei Suoli, Regione Emilia-Romagna - Funzionalità di ricerca e selezione</title>
	<link href="styles/carg_style.css" rel="stylesheet" type="text/css"/>
	<link href="styles/style_pop.css" rel="stylesheet" type="text/css"/>
	<script src="js/funzioniAjax.js" type="text/javascript"></script>
	<script src="js/funzioniRicerca.js" type="text/javascript"></script>
	<script type="text/javascript" >
	/*<![CDATA[*/


	 // MODIFICHE GEOCATALOGO
	 
	function getListaComuni(){
		xmlAjaxRequest('getListaComuni.jsp', null, null, showListaComuni, 'text');
	}

	function showListaComuni(result){
		var iH="<select id=\"selcom\" name=\"selcom\" class=\"listaComuni\" onChange=\"parent.controlAddLayer(null, 'BASE_USER.BASE_VF_COMUNI_POL.polygon.ID_COMUNE='+this.value, 'Limiti comunali', 0, 'SDE_VECTOR', false, 379);parent.window.hs.close();\">";
		iH=iH+"<option value=\"\" selected>Seleziona Comune<\/option>";
		iH=iH+result;
		iH=iH+"<\/select>";
		document.getElementById("divSelCom").innerHTML=iH;
		document.getElementById("divSelCom").title="Seleziona un comune dalla lista";
		document.getElementById("labelX").innerHTML=parent.srsLabelsX[parent.map.projection];
		document.getElementById("labelY").innerHTML=parent.srsLabelsY[parent.map.projection];
		document.getElementById("srs").innerHTML=parent.srsLabels[parent.map.projection]+"<br/> esempio: "+parent.srsLabelsEs[parent.map.projection];
		document.getElementById("bottone_coord").innerHTML=parent.lettere[parent.lettera];
	}	 
	 
	 function lanciaZoom(idTopo){
		parent.controlAddLayer(null, 'BASE_USER.BASE_VF_TOPONIMI_PUN.point.ID_TOPONIMO='+idTopo, 'Toponimi', 0, 'SDE_VECTOR', false,586)
		parent.window.hs.close();
	 }	
	 
	 function setPulisci(){
	 }	
	 
	function ScrollToElement(theElement){

		var selectedPosX = 0;
		var selectedPosY = 0;
				  
		if(theElement != null){
			selectedPosX += theElement.offsetLeft;
			selectedPosY += theElement.offsetTop;
			theElement = theElement.offsetParent;
		}
		selectedPosY = selectedPosY + 1500;
		//alert(selectedPosX + ' ' + selectedPosY);								  
		window.scrollTo(selectedPosX,selectedPosY);

	}
	 
	 function pulisci(){
		var f = document.getElementById("selezioneToponimo");
		f.provincia.value="";
		f.comune.value="";
		f.quadro.value="";
		f.foglio.value="";
		f.categoria.value="";
		f.tipo.value="";
		f.testo.value="";
		f.submit();
		//ScrollToElement(document.getElementById("bottone"));		
	 }
	
	function pulisciRicercaCatalogo(){
		parent.pulisciAlbero();
		parent.document.getElementById("risultatoricerca").innerHTML="&nbsp;<br />&nbsp;";
		parent.window.hs.close();
	}
	
	function isNumber(s) {
		return (s.toString().search(/^\d+(.\d+)?$/) >= 0);
	}

	function posizionaCoordinate(){
		
		var x = document.getElementById("x").value;
		var y = document.getElementById("y").value;

		if (!isNumber(x) || !isNumber(y)) {
			alert("Inserisci coordinate valide");
		}else {

			var lonLat = new parent.OpenLayers.LonLat(x, y);//.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
			var size = new parent.OpenLayers.Size(20,34);
			var offset = new parent.OpenLayers.Pixel(-(size.w/2), -size.h);
			var icon = new parent.OpenLayers.Icon("images/blue_Marker"+parent.lettere[parent.lettera]+".png",size,offset);
			if(parent.lettera<=parent.lettere.length)
				parent.lettera=parent.lettera+1;
			else
				parent.lettera=0;
			
			parent.layerMarkers.addMarker(new parent.OpenLayers.Marker(lonLat,icon));

			parent.map.setCenter (lonLat, parent.map.getScale());
			parent.window.hs.close();
		}

	}
	
	function OnSubmitForm() {
		//el = document.getElementById("ricerca_in_corso")
		//el.display = "block";
		var f= document.getElementById("selezioneToponimo");
		f.action ="searchForms.jsp";
	}
	

	/*]]>*/
	</script>
</head>
<!-- MODIFICA GEOCATALOGO -->
<body onload="getListaComuni()">
<div id="bodycont">
<h1>Strumenti di ricerca e selezione</h1>
	<div class="gif tit_1">
		<h2>Ricerca nel Catalogo dei dati Geografici</h2>
	</div>
	<div class="riquadrocr">
		<form method="post" id="ricerca_albero" action="javascript:iniziaRicerca();">
			<fieldset>
				<legend>Imposta le condizioni per la ricerca per parole chiave nell'albero del catalogo</legend>
				<div class="div_search">
					<label for="q" title="Inserisci parola chiave da ricercare">Parola chiave:</label>
					<input accesskey="c" type="text" name="q" size="18" value="" id="q" onfocus="fuocosulcerca=true" onblur="fuocosulcerca=false"/> 
					<input class="button w_10" type="submit" id="button_cerca" title="Ricerca per parole chiave di strati informativi nell'albero del catalogo" value="Cerca"/>
				</div>
				<div class="div_search_pulisci">
					<input class="button w_16" type="submit" id="button_pulisci_albero" onclick="javascript:pulisciRicercaCatalogo();" onkeypress="if (event.keyCode == 13) {return pulisciRicercaCatalogo();}" title="Pulisci la ricerca sull'albero del catalogo" value="Pulisci il risultato della ricerca"/>
				</div>
				<p class="clear">Gli strati informativi il cui nome o il campo descrittivo corrispondono alla parola chiave ricercata, vengono evidenziati nell'albero del catalogo.</p>
			</fieldset>
			</form>	
	</div>

	<div class="gif tit_1">
		<h2>Seleziona un Comune</h2>
	</div>
	<div class="riquadrocr">
		<form method="post" id="selezione_comune" action="javascript:parent.pulisciLayersSelezione('BASE_USER.BASE_VF_COMUNI_POL.polygon.ID_COMUNE');parent.window.hs.close();">		
		<fieldset>
			<legend>Imposta le condizioni per la ricerca di un Comune sulla mappa</legend>
			<div class="div_search">		
				<div id="divSelCom" class="div_campo w_100p"></div>
			</div>
			<div class="div_search_pulisci">
				<input class="button w_16" type="submit" id="button_pulisci_comuni" title="Rimuovi comuni selezionati sulla mappa" value="Rimuovi i comuni selezionati"/>
			</div>
			<p class="clear">Il comune selezionato viene evidenziato e centrato sulla mappa.</p>
		</fieldset>
		</form>
	</div>

	<div class="gif tit_1">
		<h2>Aggiungi un punto sulla mappa</h2>
	</div>
	<div class="riquadrocr">
		
		<form method="post" id="coord" action="">
		<fieldset>
			<legend>Inserisci le coordinate nel sistema di riferimento <span id="srs"></span></legend>
			<div class="div_search_big">
				<label for="x" id="labelX"></label><input type="text" name="x" value="" size="15" id="x" /> 
				<label for="y" id="labelY"></label><input type="text" name="y" value="" size="15" id="y" /> 
				<input class="button w_9" type="submit" id="button_aggiungi_punto" onclick="javascript:posizionaCoordinate();" onkeypress="if (event.keyCode == 13) {return posizionaCoordinate();}" title="Aggiungi un punto alla mappa alla coordinata indicata" value="Aggiungi punto"/>
			</div>
			<div class="div_search_pulisci_small">
				<input class="button w_10" type="submit" id="button_pulisci_punti" onclick="javascript:parent.pulisciMarkers();parent.window.hs.close();" onkeypress="if (event.keyCode == 13) {parent.pulisciMarkers();parent.window.hs.close();}" value="Rimuovi tutti i punti" title="Rimuovi tutti i punti aggiunti sulla mappa"/>
			</div>
			<p class="clear">Il punto aggiunto e centrato sulla mappa sarà evidenziato dall'etichetta: "<span id="bottone_coord"></span>"</p>
		</fieldset>	
		
		<div class="centrata">
			<input name="button_chiudi" type="button" 
				id="chiudi"
				value="Chiudi" 
				onclick="return parent.window.hs.close();"
				onkeypress="if (event.keyCode == 13) {return parent.window.hs.close();}"
				title="Chiudi la finestra" 
				class="button w_12" />
		</div>		
		</form>
		
	</div>
</div> <!-- chiude bodycont -->
</body>
</html>

<%

}
catch (Throwable t){
	application.log("Eccezione", t);
}
finally {
	application.log("finally");
	try {
		if(result != null)
			result.close();
	}
	catch(Exception x){}
	application.log("result set chiuso ");	
	try {
		if(statement != null)
			statement.close();
	}
	catch(Exception x){}

	application.log("statement chiuso ");
	try {
		if(resultCod != null)	
			resultCod.close();
	}
	catch(Exception x){}

	application.log("result cod chiuso ");	
	try {
		if(statementCod != null)	
			statementCod.close();
	}
	catch(Exception x){}

	application.log("statement cod chiuso ");	

	if(dbConnCAT != null)
		dbConnCAT.close();
}
%>
