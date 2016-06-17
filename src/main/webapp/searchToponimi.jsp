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
	 function lanciaZoom(idTopo){
		parent.controlAddLayer(null, 'BASE_USER.BASE_VF_TOPONIMI_PUN.point.ID_TOPONIMO='+idTopo, 'Toponimi', 0, 'SDE_VECTOR', false)
		parent.window.hs.close();
	 }	


	 
	 function setPulisci(){
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
	 	 
	 function setProvincia(){
		var f = document.getElementById("selezioneToponimo");
		f.comune.value="";
		f.foglio.value="";
		f.action = "searchToponimi.jsp?focus=provincia";
		f.submit();
		//ScrollToElement(document.getElementById("chiudi"));
	 }
	 
	function setFoglio(focusElement){
		var f = document.getElementById("selezioneToponimo");
		f.foglio.value="";
		f.action = "searchToponimi.jsp?focus="+focusElement;
		f.submit();
		//ScrollToElement(document.getElementById("chiudi"));
	}	
	
	function setTipo(){
		var f = document.getElementById("selezioneToponimo");
		f.tipo.value="";
		f.action = "searchToponimi.jsp?focus=categoria";
		f.submit();
		//ScrollToElement(document.getElementById("chiudi"));
	}
	
	function cercaToponimo() {
		var f = document.getElementById("selezioneToponimo");
		f.action = "searchToponimi.jsp?focus=id_first_row";
		f.submit();
	}

	/*
	function help(){
		var par = "resizable=yes,menubar=no,location=no,toolbar=no,status=no,scrollbars=yes";
		var nw = window.open("../data/HelpLocator/HelpLocator.htm","",par);
	}
	*/


	
	function OnSubmitForm() {
		//el = document.getElementById("ricerca_in_corso")
		//el.display = "block";
		var f= document.getElementById("selezioneToponimo");
		f.action ="searchToponimi.jsp";
	}
	

	/*]]>*/
	</script>
</head>
<!-- MODIFICA GEOCATALOGO -->
<body>
<!--<div id="cont_wait" style="display:none; position:absolute; top:50%; left:40%;"><img alt="Ricerca toponimi in corso" title="Ricerca toponimi in corso" id="wait" src="images/barra-loader.gif"/></div>-->
<div id="bodycont">
	<h1>Ricerca toponimi</h1>
	<div class="gif tit_1">
		<h2>Ricerca e posizione su Toponimi</h2>
	</div>
	<form id="selezioneToponimo" class="modulo" action="searchToponimi.jsp" method="post">

	<fieldset>
		<legend>Imposta le condizioni per la selezione dei Toponimi</legend>
	<div class="div_riga">
	
		<div class="div_label w_9p">
			<label for="provincia" title="Scegli la provincia">Provincia:</label>
		</div>

		<%
		try{
			//application.log("Inizio pagina");
			String query = "select NOME from " + TABELLA_PROVINCE + " where ID_REGIONE=8 ";
			if (FILTRO_PROVINCIA != null){
				query += " AND " + FILTRO_PROVINCIA;
			}
			query += " order by NOME";
			//application.log(query);
			result = statement.executeQuery(query);
			//application.log("query ok");
		} catch	(SQLException sqle){
			application.log("TopoLocator - ComboBox Provincia: ",sqle);
		}						
		if(prov != null && !"".equals(prov)){
			valore=prov;
		} else {
			valore="";
		}
		%>
		
		<div class="div_campo w_26p">
			<select id="provincia"
				name="provincia" 
				onchange="setProvincia();"
				class="controllo">
				
				<%--
				<% if (FILTRO_PROVINCIA == null) { %>
					<option selected="selected"><%=valore%></option>
					<option></option>					  
				<% }%>
				 --%>
				<option></option>	
				 
				<% while ( result.next()){
					if(result.getString("NOME").equals(valore)){
				%>
						<option selected="selected"><%= result.getString("NOME")%></option>
					<%} else {%>
						<option><%= result.getString("NOME")%></option>
					<%}%>
				<%}%>
			</select>
		</div>
		
		<div class="div_label w_9p">
			<label for="comune" title="Scegli il comune">Comune:</label>
		</div>
		
		<%
		try{						 	  													
			if((prov==null || "".equals(prov)) && FILTRO_PROVINCIA == null) {
				sqlstr = "select NOME_COM from " + TABELLA_COMUNI + " where ID_REGIONE=8 order by NOME_COM";
			} else {
				if(prov != null && prov.indexOf("'",0)>0){
					prov= prov.replaceAll("'","''");
				}
				sqlstr = "select NOME_COM from " + TABELLA_COMUNI + " where ";
				if (prov != null &&  !"".equals(prov.trim())) {
					sqlstr += " NOME_PRO='" + prov + "'";
				} else {
					sqlstr += " 1=1 ";		
				}
				if (FILTRO_PROVINCIA != null) {
					sqlstr += " AND " + FILTRO_PROVINCIA;
				}
				sqlstr += " order by NOME_COM";
			}
			//application.log("query comuni:" + sqlstr);
			
			if(result != null)
				result.close();
		
			result = statement.executeQuery(sqlstr);	
			//application.log("query ok");
		} catch	(SQLException sqle){
			application.log("TopoLocator - ComboBox Comune: ",sqle);
		}
		if(com!=null && com.length() > 0){
			valore=com;
		} else {
			valore="";
		}	
		%>
			 
		<div class="div_campo w_40p">
			<select id="comune"
				name="comune" 
				onchange="setFoglio(this.id);"
				class="controllo">
				
				<%--
				<option selected="selected"><%=valore%></option>
				<option></option>
				 --%>
				 <option></option>
				<% while (result.next()){
					if(result.getString("NOME_COM").equals(valore)){
				%>
						<option selected="selected"><%= result.getString("NOME_COM")%></option>
					<%} else {%>
						<option><%= result.getString("NOME_COM")%></option>
					<%}%>
				<%}%>	
			</select>
		</div>
		
	</div>
	
	<div class="div_riga">
	
		<div class="div_label w_9p">
			<label for="quadro" title="Scegli quadro d'unione">Quadro Unione:</label>
		</div>
		
		<div class="div_campo w_26p">
			<select id="quadro" 
				name="quadro" 
				onchange="setFoglio(this.id);"
				class="controllo">
				
				<%--
				<option selected="selected"><%=valore%></option>
				<option></option>
				 --%>
				 <option></option>
				 
		<%
		if(request.getParameter("quadro")!=null){
			valore=request.getParameter("quadro");
		} else {
			valore="";
		}
		tipoFoglio="Elemento:";		
		if(valore.equals("5.000")) {
			%><option selected="selected">5.000</option><%
		} else {
			%><option>5.000</option><%
		}
		if(valore.equals("10.000")) {
			tipoFoglio="Sezione";
			%><option selected="selected">10.000</option><%
		} else {
			%><option>10.000</option><%
		}
		if(valore.equals("25.000")) {
			tipoFoglio="Tavola";
			%><option selected="selected">25.000</option><%
		} else {
			%><option>25.000</option><%
		}
		if(valore.equals("50.000")) {
			tipoFoglio="Foglio";
			%><option selected="selected">50.000</option><%
		} else {
			%><option>50.000</option><%
		}
		%>
		
			</select>
		</div>

		<div class="div_label w_9p">
			<label for="foglio" title=""><%=tipoFoglio%></label>
		</div>
		<div class="div_campo w_26p">
			<select id="foglio" 
				name="foglio" 
				class="controllo">

			<%
			String quadroSel=null;
			quadroSel=request.getParameter("quadro");
			//application.log("Prov: -" + prov + "-");
			if (quadroSel!=null && !("".equals(quadroSel))){
				Vector condizioni=new Vector();
				int k=0;
				//application.log("Prov: -" + prov + "-");
				if(prov!=null && !("".equals(prov))){
					sqlstr="select ID_PROVINCIA from " + TABELLA_PROVINCE + " where NOME='" + prov + "'";
					try {
						if(resultCod != null)
							resultCod.close();
						resultCod = statementCod.executeQuery(sqlstr);
						resultCod.first();
					} catch	(SQLException sqle){
						application.log("TopoLocator - ComboBox N° Foglio: ",sqle);
					}
					Integer codpro=new Integer(resultCod.getInt("ID_PROVINCIA"));								
					condizioni.add(k,"ID_PROVINCIA="+codpro.toString());								
					k++;
				}
				
				if(com!=null && !("".equals(com))){																
					int pos=com.indexOf("'",0);
					if (pos>0){
						com=com.replaceAll("'","''");							
					}
					sqlstr="select * from " + TABELLA_COMUNI + " where NOME_COM='" + com + "'";
					try{
						if(resultCod != null)
							resultCod.close();
						resultCod = statementCod.executeQuery(sqlstr);
						resultCod.first();
					} catch	(SQLException sqle){
						application.log("TopoLocator - ComboBox N° Foglio: ",sqle);
					}
					Integer codcom=new Integer(resultCod.getInt("ID_COMUNE"));
					condizioni.add(k,"ID_COMUNE="+codcom.toString());
					k++;
				}
				
				String strWhereFoglio=null;
				if (condizioni.size()>0){								
					strWhereFoglio =" WHERE "+(String)condizioni.get(0);
					for (int jj=1;jj==condizioni.size()-1;jj++) {
						strWhereFoglio=strWhereFoglio + " AND " + condizioni.get(jj);
					}
				} else {
					strWhereFoglio="";
				}
				if(quadroSel.equals("5.000")){								
					sqlstr="select ELEMENTO as CTR from " + TABELLA_PROV_COM_CTR + strWhereFoglio+" order by ELEMENTO";
				}
				if(quadroSel.equals("10.000")){
					sqlstr="select SEZIONE as CTR from " + TABELLA_PROV_COM_CTR + strWhereFoglio+" order by SEZIONE";
				}
				if(quadroSel.equals("25.000")){
					sqlstr="select TAVOLA as CTR from " + TABELLA_PROV_COM_CTR + strWhereFoglio+" order by TAVOLA";
				}
				if(quadroSel.equals("50.000")){
					sqlstr="select FOGLIO as CTR from " + TABELLA_PROV_COM_CTR + strWhereFoglio+" order by FOGLIO";
				}
				
				//application.log(sqlstr);
				Vector fogli = new Vector();
				try {						 					
					if(result != null)
						result.close();
					result = statement.executeQuery(sqlstr);
					while (result.next()) {
						String foglio = result.getString("CTR");
						if (!fogli.contains(foglio)){
							fogli.add(foglio);
						}	
					}
				} catch	(SQLException sqle){
					application.log("TopoLocator - ComboBox N° Foglio: ",sqle);
				}
				
				if(request.getParameter("foglio")!=null){
					valore=request.getParameter("foglio");
				} else {
					valore="";
				}%>
				
				<%--
				<option selected="selected"><%=valore%></option>
				<option></option>
				 --%>
				<option></option>
				<%
				Iterator it = fogli.iterator();
				while (it.hasNext()){
					String val = (String)it.next();
					if(val.equals(valore)){
						%><option selected="selected"><%=val%></option><%
					} else {
						%><option><%=val%></option><%
					}
				}
				
			}else{
				if(request.getParameter("foglio")!=null){
					valore=request.getParameter("foglio");
				} else {
					valore="";
				}%>
				<option selected="selected"><%=valore%></option>
				<option></option>
			<%}%>
			</select>
			
		</div>
		
	</div>
	
	<div class="div_riga">
	
		<div class="div_label w_9p">
			<label for="categoria" title="Scegli la categoria del toponimo">Categoria toponimo:</label>
		</div>
		
		<%
		try{					
			if(result != null)
				result.close();
			result = statement.executeQuery("select NOME from BASE_USER.BASE_T_TOPONIMI_CATEG order by NOME");
		} catch	(SQLException sqle){
			application.log("TopoLocator - ComboBox Categoria toponimo: ",sqle);
		}	
		if(request.getParameter("categoria")!=null){
			valore=request.getParameter("categoria");
		}else{
			valore="";
		}
		%>
				
		<div class="div_campo w_26p">
			<select id="categoria"
				name="categoria" 
				onchange="setTipo();"
				class="controllo">
				
				<%--
				<option selected="selected"><%=valore%></option> 
				<option></option>
				 --%> 
				<option></option>
				<% while (result.next()){
					if(result.getString("NOME").equals(valore)){
						%><option selected="selected"><%= result.getString("NOME")%></option><%
					} else {
						%><option><%= result.getString("NOME")%></option>
					<%}%>
				<%}%>
			</select>
		</div>
		
		<div class="div_label w_9p">
			<label for="tipo" title="Scegli la tipologia del toponimo">Tipologia toponimo:</label>
		</div>
		
		<%
		String cat=null;
		int idCat=0;
		cat=request.getParameter("categoria");			
		if(request.getParameter("tipo")!=null){
			valore=request.getParameter("tipo");
		}else{
			valore="";
		}		
		%>
		
		<div class="div_campo w_26p">
			<select id="tipo" 
				name="tipo" 
				class="controllo"
				>
				
				<%--
				<option selected="selected"><%=valore%></option>
				<option></option>
				 --%>
				 
				<option></option>
				
				<%   
				if(cat!=null && !("".equals(cat))){
					try {		
						if (cat.indexOf("'",0)>0){
							cat=cat.replaceAll("'","''");
						}
						if(result != null)
							result.close();
						result = statement.executeQuery("select ID_CATEG from BASE_USER.BASE_T_TOPONIMI_CATEG where NOME='"+cat+"'");
						result.first();
						idCat=result.getInt("ID_CATEG");
					} catch	(SQLException sqle){
						application.log("TopoLocator - ComboBox Tipologia toponimo: ",sqle);
					}
					try {
						if(result != null)
							result.close();
						result = statement.executeQuery("select DESCRIZIONE from BASE_USER.BASE_T_TOPONIMI where ID_CATEG="+idCat+" order by DESCRIZIONE");
						//application.log("select DESCRIZIONE from BASE_USER.BASE_T_TOPONIMI where ID_CATEG="+idCat+" order by DESCRIZIONE");
					} catch	(SQLException sqle){
						application.log("TopoLocator - ComboBox Tipologia toponimo: ",sqle);
					}
					
					while (result.next()){
						if(result.getString("DESCRIZIONE").equals(valore)){
							%><option selected="selected"><%= result.getString("DESCRIZIONE")%></option><%
						} else {
							%><option><%= result.getString("DESCRIZIONE")%></option>
						<%}%>
					<%}
				}
				%>
			</select>
						
		</div>

	</div>
	
	<div class="div_riga">
	
		<div class="div_label w_9p">
			<label for="testo" title="Inserisci il testo del toponimo (o parte di esso)">Testo toponimo:</label>
		</div>
		
		<%
		if(request.getParameter("testo")!=null){
			valore=request.getParameter("testo");
		}else{
			valore="";
		}
		%>
			   
		<div class="div_campo w_26p">
			<input type="text" 
				id="testo" 
				name="testo" 
				class="controllo"
				value="<%=valore%>"/>
		</div>
		
		<div class="div_label w_9">
			<input type="submit" 
				id="bottone" 
				name="bottone" 
				class="button_s w_10" 
				value="Cerca toponimo" 
				title="Avvia la ricerca del toponimo"
				onclick="javascript:cercaToponimo();" onkeypress="if (event.keyCode == 13) {return cercaToponimo();}"/>
		</div>
		
	</div>
	
	</fieldset>
		
	<!-- TOPONIMI TROVATI -->	
	<div class="riquadro_toponimi">
		<%
		msg = "";
		//application.log("bottone: " + request.getParameter("bottone"));
		if(request.getParameter("bottone")!=null){
			Vector listaCondizioni=new Vector();
			int i=0;
			//application.log("prov: " + prov);
			if(prov!=null){
				String provincia=prov;
				String whereProvincia=null;
				if (provincia.equals("")){
					whereProvincia="";
				} else {
					//if(provincia.indexOf("'",0)>0){
					//	provincia=provincia.replaceAll("'","''");
					//}	
					whereProvincia="NOME_PRO='" + provincia + "'";
					listaCondizioni.add(i,whereProvincia);
					i=i+1;
				}		
				String comune=com;
				String whereComune=null;
				if (comune.equals("")){
					whereComune="";
				} else {
					if(comune.indexOf("'",0)>0){
						comune=comune.replaceAll("'","''");
					}	
					whereComune="NOME_COM='" + comune + "'";
					listaCondizioni.add(i,whereComune);
					i=i+1;
				}
				String quadro=request.getParameter("quadro");
				String foglio=request.getParameter("foglio");
				String whereQuadro=null;
				if (!(foglio.equals(""))){
					if (quadro.equals("")&& foglio.equals("")){
						whereQuadro="";
					} else {
						if("5.000".equals(quadro)){
							whereQuadro="ELEMENTO=" + foglio;	
						}
						if("10.000".equals(quadro)){
							whereQuadro="SEZIONE='" + foglio + "'";	
						}
						if("25.000".equals(quadro)){
							whereQuadro="TAVOLA='" + foglio + "'";	
						}
						if("50.000".equals(quadro)){
							whereQuadro="FOGLIO='" + foglio + "'";	
						}
						listaCondizioni.add(i,whereQuadro);
						i=i+1;
					}
				}
				String categoria=request.getParameter("categoria");
				String whereCategoria=null;
				if (categoria.equals("")){
					whereCategoria="";
				}else{
					if(categoria.indexOf("'",0)>0){
						categoria=categoria.replaceAll("'","''");
					}	
					whereCategoria="CATEGORIA='" + categoria + "'";
					listaCondizioni.add(i,whereCategoria);
					i=i+1;
				}
				String tipo=request.getParameter("tipo");
				String whereTipo=null;
				if (tipo.equals("")){
					whereTipo="";
				}else{
					if(tipo.indexOf("'",0)>0){
						tipo=tipo.replaceAll("'","''");
					}	
					whereTipo="TIPO='" + tipo + "'";
					listaCondizioni.add(i,whereTipo);
					i=i+1;
				}
				String testo=request.getParameter("testo");
				String whereTesto=null;
				if (testo.equals("")){
					whereTesto="";
				}else{
					if(testo.indexOf("'",0)>0){
						testo=testo.replaceAll("'","''");
					}	
					whereTesto="UPPER (TOPONIMO) LIKE '%" + testo.toUpperCase() + "%'";
					listaCondizioni.add(i,whereTesto);
					i=i+1;
				}
					
				if(provincia.equals("") && comune.equals("") && quadro.equals("") 
						&& foglio.equals("") && categoria.equals("") 
						&& tipo.equals("") && testo.equals("")){
					//application.log("qui mancano param");
					msg = "Inserire almeno un parametro di ricerca.";
				} else {
				
				
				
					//application.log("qui query");
					String strWhere=null;
					strWhere =(String)listaCondizioni.get(0);
					for (int j=1;j<=listaCondizioni.size()-1;j++){
						strWhere=strWhere + " AND " + listaCondizioni.get(j);
					}
					//application.log("select ID_TOPONIMO,TOPONIMO,ELEMENTO, NOME_COM, CATEGORIA from BASE_USER.BASE_V_TOPO_CTR_AMM where "+ strWhere +"  order by TOPONIMO");														
					if(result != null)
						result.close();
					result = statement.executeQuery("select ID_TOPONIMO, TOPONIMO, ELEMENTO, NOME_COM, CATEGORIA from BASE_USER.BASE_V_TOPO_CTR_AMM where "+ strWhere +"  order by TOPONIMO");	
				}
			}
		} else {
			//application.log("request.getParameter(\"bottone\")");
			if(result != null)
				result.close();
			result = null;
			inizio = true;
		}
		%>
				
		<%
		//application.log("anche qui" + result);
		
		if(result != null && result.next()){ 
			idToponimo=result.getLong("ID_TOPONIMO");%>
						
			<div class="container_toponimi">
				<div class="div_toponimi">
					<table class="toponimi" 
						summary="Elenco dei toponimi trovati"
						cellpadding="0" cellspacing="0">
						<caption>
							Elenco dei toponimi trovati
						</caption>
					<tr>
						<th id="th_topo" scope="col" abbr="Toponimo">Toponimo</th>
						<th id="th_ctr5" scope="col" abbr="Carta Tecnica Regionele in cui si trova il toponimo">CTR5</th>
						<th id="th_comune" scope="col" abbr="Comune in cui si trova il toponimo">Comune</th>
						<th id="th_categoria" scope="col" abbr="Categoria del toponimo">Categoria</th>
					</tr>
					<tr>
						<td class="dati" headers="th_topo">
							<a id="id_first_row" href="javascript:lanciaZoom(<%=idToponimo%>);"  
								title="Cliccare sul toponimo per posizionarsi"><%=result.getString("TOPONIMO")%>
							</a>
						</td>
						<td class="dati" headers="th_ctr5"><%=result.getString("ELEMENTO")%></td>						
						<td class="dati" headers="th_comune"><%=result.getString("NOME_COM")%></td>
						<td class="dati" headers="th_categoria"><%=result.getString("CATEGORIA")%></td>
					</tr>
					
					<%
					while (result != null && result.next()){
						idToponimo=result.getLong("ID_TOPONIMO");%>
						<tr>
							<td class="dati" headers="th_topo">
								<a href="javascript:lanciaZoom(<%=idToponimo%>);" 
									title="Cliccare sul toponimo per posizionarsi"><%=result.getString("TOPONIMO")%>
								</a>
							</td>
							<td class="dati" headers="th_ctr5"><%=result.getString("ELEMENTO")%></td>						
							<td class="dati" headers="th_comune"><%=result.getString("NOME_COM")%></td>
							<td class="dati" headers="th_categoria"><%=result.getString("CATEGORIA")%></td>
						</tr>
						<%
						
					}%>
					</table>
				</div> <!-- div_toponimi -->

			</div> <!-- chiude container_toponimi -->

		
		<%} else if(!inizio) {%>
		
			<div class="errore centrata">
			<% if(msg.equals("")) {
				msg = "Nessun toponimo trovato";
			}
			%>
			<p><%=msg%></p>
			</div>
		<%}%>
		
			<div class="centrata">
				<input name="button_pulisci" type="button" 
					value="Pulisci" 
					onclick="pulisci();" 
					onkeypress="if (event.keyCode == 13) { pulisci();}"
					title="Azzera i parametri di ricerca" 
					class="button w_12" />
				<input name="button_chiudi" type="button" 
					id="chiudi"
					value="Chiudi" 
					onclick="return parent.window.hs.close();"
					onkeypress="if (event.keyCode == 13) {return parent.window.hs.close();}"
					title="Chiudi la finestra" 
					class="button w_12" />
			</div>


	</div>	<!-- chiude riquadro toponimi -->
	</form>

</div> <!-- chiude bodycont -->
	<%
		if (request.getParameter("recall") != null) {
			out.println("<script type=\"text/javascript\" >	/*<![CDATA[*/ /*document.getElementById(\"bodycont\").className=\"opacityOn\";*/ document.getElementById(\"wait\").style.opacity=1; document.getElementById(\"cont_wait\").style.display=\"block\";/*]]>*/</script>");
		}
		
		if (request.getParameter("focus") != null) {
			if(msg.equals("")) {		
				out.println("<script type=\"text/javascript\" >	/*<![CDATA[*/ document.getElementById(\""+request.getParameter("focus")+"\").focus(); /*]]>*/</script>");
			}
		} 
		
	%>

</body>
</html>

<%

}
catch (Throwable t){
	application.log("Eccezione", t);
}
finally {
	//application.log("finally");
	try {
		if(result != null)
			result.close();
		//application.log("result set chiuso ");	
	} catch(Exception x){
	
		application.log("ERRORE 0: "+x.getMessage());

	}
	
	try {
		if(statement != null)
			statement.close();
		//application.log("statement chiuso ");
	}
	catch(Exception x){
	
		application.log("ERRORE 1: "+x.getMessage());
	}

	try {
		if(resultCod != null)	
			resultCod.close();
		//application.log("result cod chiuso ");	
	}
	catch(Exception x){
		application.log("ERRORE 2: "+x.getMessage());
	}

	try {
		if(statementCod != null)	
			statementCod.close();
		//application.log("statement cod chiuso ");	
	}
	catch(Exception x){
			application.log("ERRORE 3: "+x.getMessage());
	}


	try {
		if(dbConnCAT != null)
			dbConnCAT.close();
	} catch(Exception x){
			//application.log("ERRORE 4: "+x.getMessage());
	}
}
%>
