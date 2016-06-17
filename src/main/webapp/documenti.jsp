<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.apache.log4j.Category" %>
<%@ page import="it.semenda.carg.Documenti" %>
<%@ page import="it.semenda.carg.CargUtil"%>

<%@ page errorPage="errorpage.jsp" %>
<%@ include file="setContentType.jsp" %>

<%! static Category log = Category.getInstance("carg"); %>
<%
	Documenti doc = new Documenti();

	Connection oraConn = null;
	ResultSet result = null;
	Statement statement = null;
	ResultSet resultCod = null;
	Statement statementCod = null;

	String sqlstr=null;
	String tipoArea = null;
	String key = null;
	String descrArea = null;
	String descrTestoArea = null;
	String provincia = null;
	String comune = null;
	
	
	if(request.getParameter("tipoArea") != null)
		tipoArea = request.getParameter("tipoArea");
	else tipoArea = "";

	if(request.getParameter("key") != null)
		key = request.getParameter("key");
	else key = "";

	// caso particolare: combo provincia e comune sono legati
	if(request.getParameter("provincia") != null)
		provincia = request.getParameter("provincia");
	else provincia = "";
	
	if(request.getParameter("comune") != null)
		comune = request.getParameter("comune");
	else comune = "";

	if(request.getParameter("descrizioneArea") != null)
		descrArea = request.getParameter("descrizioneArea");
	else descrArea = "";

	if(request.getParameter("descrizioneTestoArea") != null)
		descrTestoArea = request.getParameter("descrizioneTestoArea");
	else descrTestoArea = "";
	
	log.debug("tipoArea= "+tipoArea);
	log.debug("key= "+key);
	log.debug("provincia= "+provincia);
	log.debug("comune= "+comune);
	log.debug("descrArea= "+descrArea);
	log.debug("descrTestoArea= "+descrTestoArea);
%>
<%-- <?xml version="1.0" encoding="<%=pageCharEncoding%>"?> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
--%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it-IT" lang="it-IT">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=<%=pageCharEncoding%>" />
	<title>Il Catalogo dei Dati Geografici, Servizio Geologico Sismico e dei Suoli, Regione Emilia-Romagna - Ricerca documenti</title>
	
	<link href="styles/carg_style.css" rel="stylesheet" type="text/css" />
	<link href="styles/style_pop.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript">
	/*<![CDATA[*/
	function switchSel(tipo){
		var f = document.getElementById("frmDocRicerca");
		f.provincia.value = getProvincia();
		f.comune.value = getComune();
		f.key.value = "";
		f.action = "documenti.jsp?focus=tipoArea";
		f.target = "";
		f.submit();
	}

	var provinciaTmp = "<%=provincia%>";
	
	function go(el){
		var f = document.getElementById("frmDocRicerca");
		if(getProvincia()!="" && getProvincia()!=provinciaTmp){
			//è cambiata la provincia, azzero il comune
			f.comune.value = "";
		} else {
			f.comune.value = getComune();
		}
		f.provincia.value = getProvincia();
		
		if(!el.value == ""){
			f.key.value = el.value;
		} else {
			if(f.comune.value != ""){
				f.key.value = f.comune.value;
			} else if(f.provincia.value != ""){
				f.key.value = f.provincia.value;
			} else {
				f.key.value = "";
			}
		}
		f.action = "documenti.jsp?focus="+el.id;	
		f.target = "";
		f.submit();
	}

	// ritorna il valore della provincia (se impostata)
	function getProvincia(){
		var s = document.getElementById("s_4");
		if (s && s.selectedIndex != 0)
			return s.value;
		else
			return "";
	}
	// ritorna il valore del comune (se impostato)
	function getComune(){
		var s = document.getElementById("s_5");
		if (s && s.selectedIndex != 0)
			return s.value;
		else
			return "";
	}

	// esegue la query
	function apriDoc(){
		// controllo che sia stato selezionato almeno un tipo documento
		if (!okTipoDoc()){
			alert("Selezionare almeno un tipo di documento");
			return false;
		}

		// nome casuale per la window (così posso aprirne varie in //)
		/*
		var wname = Math.random();
		wname = Math.round(wname * 100000);
		wname = "docTrovati" + wname;
		var nw = window.open("",wname,"width=600, height=350, menubar=no,location=no,toolbar=no,status=no,scrollbars=yes,resizable=yes");
		*/
		var f = document.getElementById("frmDocRicerca");
		var s = document.getElementById("tipoArea");
		var sVal;
		if(s.value=="4"){
			//provincia o comune
			var sCom = document.getElementById("s_5");
			if(sCom && sCom.value!=""){
				f.descrizioneArea.value = "Comune";
				f.descrizioneTestoArea.value = sCom[sCom.selectedIndex].text;
			} else {
				f.descrizioneArea.value = "Provincia";
				sVal = document.getElementById("s_"+s.value);
				f.descrizioneTestoArea.value = sVal[sVal.selectedIndex].text;
			}
		} else {
			f.descrizioneArea.value = s[s.selectedIndex].text;
			sVal = document.getElementById("s_"+s.value);
			if(sVal){
				if(sVal.value != ""){
					f.descrizioneTestoArea.value = sVal[sVal.selectedIndex].text;
				} else {
					f.descrizioneTestoArea.value = "";
				}			
			} else {
				f.descrizioneTestoArea.value = "";
			}
		}
		
		f.action = "documentiTrovati.jsp";
		//f.target = wname;
		f.method = "post";		
		//nw = null;
		f.submit();
	}
	function okTipoDoc(){
		var listTipo = document.getElementsByName("tipoDoc");
		for (var i=0; i<listTipo.length; i++) {
			if(listTipo[i].checked){
				return true;
			}
		}
		return false;
	}
	/*]]>*/
	</script>
</head>
<body>

<div>

	<div class="gif tit_1">
	  <h1>RICERCA DOCUMENTI</h1>
	</div>
	
	<div>
	  <h2>Imposta le condizioni di ricerca dei documenti
	  - I campi contrassegnati con * sono obbligatori</h2>
	</div>
	
	<form id="frmDocRicerca" method="post" action="">
	
	<fieldset>
		<legend>Area di interesse</legend>
		
		<div class="div_riga">
			<input type="hidden" name="key" value="<%=key%>" />
			<input type="hidden" name="descrizioneArea" value="<%=descrArea%>"></input>
			<input type="hidden" name="descrizioneTestoArea" value="<%=descrTestoArea%>"></input>
			<input type="hidden" name="provincia" value="<%=provincia%>"></input>
			<input type="hidden" name="comune" value="<%=comune%>"></input>
			
			<div class="div_label w_7_5 obbligatorio">
				<label for="tipoArea"
					title="Scegli l'area di interesse">*Area di interesse</label>
			</div>
			
			<div class="div_campo w_12">
			<select id="tipoArea" 
				name="tipoArea" 
				onchange="switchSel(this.value);">
				
				<%=doc.getSelectTipoArea(tipoArea)%>
			
			</select>
			</div>
		</div>
		
		<div class="div_riga">
		<%
		if(!tipoArea.equals("")){
			
			String sel = "";
			
			if(tipoArea.equals("4")){
				sel = doc.getSelectArea(tipoArea,provincia,"");	
			} else {
				sel = doc.getSelectArea(tipoArea,key,"");
			}
			String wDiv = "w_18";
			String wSel = "w_23";
			if(tipoArea.equals("4")){
				wDiv = "w_10";
				wSel = "w_12";
			}
				
			if(!sel.equals("")){
				
				if(comune.equalsIgnoreCase("")){%>
					<div class="div_label w_7_5 obbligatorio">
						<%=doc.getLabelArea(tipoArea,true)%>
					</div>
			
					<div class="div_campo <%=wDiv%>">
					<select id="s_<%=tipoArea%>"
						name="valoriArea" 
						onfocus="" 
						onchange="go(this)" 
						class="<%=wSel%>">
						
						<%=sel%>
					</select>
					</div>
				
				<%}else{%>
					<div class="div_label w_7_5">
						<%=doc.getLabelArea(tipoArea,false)%>
					</div>
			
					<div class="div_campo <%=wDiv%>">
					<select id="s_<%=tipoArea%>"
						name="valoriArea" 
						onfocus="" 
						onchange="go(this)" 
						class="<%=wSel%>">
						
						<%=sel%>
					</select>
					</div>
				<%}%>

			<%}%>
			
			<% if(tipoArea.equals("4")){%>
				<%-- provincia e comune, mostro il combo comune (id_area = 5) --%>
				<%
				sel = doc.getSelectArea("5",key,provincia); 
				if(!sel.equals("")){
					
					if(provincia.equalsIgnoreCase("") || !comune.equalsIgnoreCase("")){%>
						<div class="div_label w_5 obbligatorio">
							<%=doc.getLabelArea("5",true)%>
						</div>
				
						<div class="div_campo w_15">
						<select id="s_5"
							name="valoriArea" 
							onfocus="" 
							onchange="go(this)" 
							class="w_18">
							
							<%=sel%>
						</select>
						</div>
						
					<%}else{%>
						<div class="div_label w_6">
							<%=doc.getLabelArea("5",false)%>
						</div>
				
						<div class="div_campo w_15">
						<select id="s_5"
							name="valoriArea" 
							onfocus="" 
							onchange="go(this)" 
							class="w_18">
							
							<%=sel%>
						</select>
						</div>
					
					<%}%>
					
	
				<%}%>
			<%}%>
			
		<%}%>
		
		</div>
	</fieldset>
	

	<fieldset>
		<legend>Tipo documento</legend>
		
		<%=doc.getTipoDocumento(tipoArea,key)%>
		
	</fieldset>
	
	<div class="centrata">
		<input type="button" 
			value="Chiudi" 
			title="Chiude la finestra"
			onkeypress="if (event.keyCode == 13) {return parent.window.hs.close();}"
			onclick="return parent.window.hs.close();" 
			class="button w_12" />

		<% if(tipoArea.equals("1") || !key.equals("")){%>
			<input type="button"
				id="btnApri"
				name="btnApri"
				value="Visualizza documenti"
				title="Visualizza l'elenco dei documento individuati" 
				onkeypress="if (event.keyCode == 13) {apriDoc();}"
				onclick="apriDoc()" 
				class="button w_12" />
		<%} %>
				
	</div>
			
	</form>

</div>
<%
if (request.getParameter("focus") != null) {
	out.println("<script type=\"text/javascript\" >	/*<![CDATA[*/ document.getElementById(\""+request.getParameter("focus")+"\").focus(); /*]]>*/</script>");
} 
%>
</body>
</html>
<% doc.chiudi(); %>
