<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page language="java" pageEncoding="UTF-8" %>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="org.apache.log4j.Category" %>

<%@page errorPage="errorpage.jsp" %>

<%@include file="setContentType.jsp" %>

<%!
	static Category log = Category.getInstance("carg");

  	Connection oraConn=null;
	ResultSet result=null;
	java.sql.Statement statement=null;
	ResultSet resultCod=null;
	java.sql.Statement statementCod=null;

	String sqlstr=null;
	String tipoArea = null;
	String key = null;
	String [] tipoDoc = null;
	String descrArea = null;
	String descrTestoArea = null;

	ResourceBundle bundle = ResourceBundle.getBundle("carg");
	String driver1 = bundle.getString("driver1");
	String driver2 = bundle.getString("driver2");
	String driver3 = bundle.getString("driver3");
	String driver4 = bundle.getString("driver4");
	String server = bundle.getString("server");
	String user = bundle.getString("user");
	String password = bundle.getString("password");
	String docUser = bundle.getString("docUser");
	String docPwd = bundle.getString("docPwd");

	ResourceBundle bundle2 = ResourceBundle.getBundle("carg");
	String docBasePath = bundle2.getString("docBasePath");
	String docServer = bundle2.getString("docServer");
	String docProtocol = bundle2.getString("docProtocol");
%>
<%
	try {
		Class.forName(driver1+"."+driver2+"."+driver3+"."+driver4);
		oraConn = DriverManager.getConnection(server,docUser,docPwd);
		statement = oraConn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		statementCod = oraConn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	} catch (ClassNotFoundException e) {
			log.error("ClassNotFoundException",e);
	} catch (SQLException e) {
			log.error("SQLException",e);
	}

	if(request.getParameter("tipoArea") != null){
		tipoArea = request.getParameter("tipoArea");
	} else {tipoArea = "";}

	if(request.getParameter("key") != null){
		key = request.getParameter("key");
	} else {key = "";}

	tipoDoc = request.getParameterValues("tipoDoc");

	if(request.getParameter("descrizioneArea") != null){
		descrArea = request.getParameter("descrizioneArea");
	} else {descrArea = "";}

	if(request.getParameter("descrizioneTestoArea") != null){
		descrTestoArea = request.getParameter("descrizioneTestoArea");
	} else {descrTestoArea = "";}

	log.debug("tipoArea= "+tipoArea);
	log.debug("key= "+key);
	log.debug("descrArea= "+descrArea);
	log.debug("descrTestoArea= "+descrTestoArea);
	log.debug("docProtocol= "+docProtocol);
	log.debug("docServer= "+docServer);	
	log.debug("docBasePath= "+docBasePath);
%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it-IT" lang="it-IT">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=<%=pageCharEncoding%>" />
	<title>Il Catalogo dei Dati Geografici, Servizio Geologico Sismico e dei Suoli, Regione Emilia-Romagna - Documenti trovati</title>
	<link href="styles/carg_style.css" rel="stylesheet" type="text/css" />
	<link href="styles/style_pop.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript">
	/*<![CDATA[*/
	function apriDoc(url){
		window.open(url,"","menubar=no,location=no,toolbar=yes,status=no,scrollbars=yes,resizable=yes");
	}
	/*]]>*/
	</script>
</head>
<body>
<div>

      <div class="gif tit_1">
        <h1>DOCUMENTI TROVATI PER L'AREA: <%=descrArea%>
        <%if(!descrTestoArea.equals("")){%>
        	 - <%=descrTestoArea%>
        <%} %>
        </h1>
      </div>
      <div>
        <h2>Clicca sul nome del documento per aprirlo</h2>
      </div>
      
      <%if (tipoArea.equals("")){%>
		<div class="centrata"><h2>Nessun criterio di selezione impostato</h2></div>
		
      <%}else{
      
      	try {

			// cilco su tutti i tipi di doc
			result = statement.executeQuery("select id_tipo, descrizione from doc_t_documenti order by id_tipo asc");

			while (result.next()){

				// solo se è tra quellli passati
				// NB: mi baso sul fatto che l'ordinamento è lo stesso dei dati passati nel form
				if (chkTipoDoc(result.getString("id_tipo"))) {
					
					sqlstr = "select doc_documenti.id_documento, doc_documenti.nome ";
					sqlstr += ", doc_documenti.descrizione, doc_documenti.path ";
					sqlstr += " from doc_documenti, doc_documenti_aree ";
					sqlstr += " where doc_documenti_aree.id_area_interesse = " + tipoArea;			
					sqlstr += " and doc_documenti.id_tipo = " + result.getString("id_tipo");
					sqlstr += " and doc_documenti.id_documento = doc_documenti_aree.id_documento ";
					if (!key.equals("")) {
						// area con combo
						sqlstr += " and (";
							sqlstr += " doc_documenti_aree.key = '" + key + "'";
							// prendo anche tutti i documenti associati a tutta l'area
							// (e non ad un valore specifico della key)
							sqlstr += " or doc_documenti_aree.key is null";
						sqlstr += " )";
					}

					try{
					
						log.debug("Query DocTrovati "+sqlstr);
						resultCod = statementCod.executeQuery(sqlstr);

						%>
						<div>
						<fieldset>
							<legend><%=result.getString("descrizione")%></legend>
							<ul><%
						
							while (resultCod.next()){
	
								// costruisco l'url al file
								// i path sono tutti relativi al docBasePath e NON comprendono il nome del file
								docBasePath = docBasePath.replaceAll("\"","");
								
								String path = resultCod.getString("path");
								// giro le barre
								if(path!=null){
									if(!path.equals("")){
										path = path.replaceAll("\\\\","\\/");
										// se contiene docBasePath lo tolgo
										if(path.indexOf(docBasePath) != -1){
											path = path.replace(docBasePath,"");
										}
										if (path.startsWith("//"))
											path = path.substring(2);
										if (path.startsWith("/"))
											path = path.substring(1);
										if (!path.endsWith("/"))
											path += "/";
									}
								} else path = "";
								
								
								if (!docBasePath.startsWith("/"))
									docBasePath = "/" + docBasePath;
								if (!docBasePath.endsWith("/"))
									docBasePath += "/";

								docServer = docServer.replaceAll("\"","");
								
								/* NON FUNZIONA in quanto internamente è tutto in http
								if(docServer.equals("")){
									docServer = request.getServerName();
								}
								//String url = "http://" + docServer + docBasePath + path + resultCod.getString("nome");
								String scheme = request.getScheme().toLowerCase();
								int port = request.getServerPort();
								if(port == 443 || (port % 1000) == 443){
									scheme = "https";
								}
								String url = scheme + "://" + docServer;
								url += (port == 80 ? "" : ":"+port);
								url += docBasePath + path + resultCod.getString("nome");
								*/
								String url = "";
								if(path.substring(0, 4).equalsIgnoreCase("http")){
									url=path + resultCod.getString("nome");
								} else {

									if(docServer.equals("")){
										// devo usare un path relativo
										url = docBasePath + path + resultCod.getString("nome");
									} else {
										if(docProtocol == null || docProtocol.equals("") || !docProtocol.equalsIgnoreCase("https")){
											docProtocol = "http";
										}
										url = docProtocol + "://" + docServer + docBasePath + path + resultCod.getString("nome");
									}
								}
								%><li>
										<a href="#" onclick="apriDoc('<%=url%>'); return false;"
											title="Apri il documento (nuova finestra)"><%=resultCod.getString("descrizione")%></a>
									</li>
								<%
							} // while

						%>
							</ul>
						</fieldset>
						</div>
						<%
						
					
					} catch	(SQLException sqle){
						log.error("SQLException",sqle);
					}

				}

			} // while

		} catch (SQLException e) {
				log.error("SQLException",e);
		}
      
      
      }%>
        
	<div class="centrata">
		<input type="button" 
			value="Indietro" 
			title="Torna alla pagina di ricerca" 
			onclick="history.back()" 
			onkeypress="if (event.keyCode == 13) {history.back()}"
			class="button w_10" />
			
		<input type="button" 
			value="Chiudi" 
			title="Chiude la finestra" 
			onclick="return parent.window.hs.close();" 
			onkeypress="if (event.keyCode == 13) {return parent.window.hs.close();}"
			class="button w_10" />
	</div>

</div>
</body>
</html>

<%
	try{
		if(result != null)
			result.close();
		if(statement != null)
			statement.close();
		if(resultCod != null)
			resultCod.close();
		if(statementCod != null)
			statementCod.close();
		if(oraConn != null)
			oraConn.close();
	} catch(SQLException e){
		log.error("SQLException",e);
	}
%>

<%! 
// verifica se il tipo documento è tra quelli passati in input dal form
boolean chkTipoDoc(String tipo) {
	for (int i=0; i<tipoDoc.length; i++){
		if (tipoDoc[i].equals(tipo)){
			return true;
		}
	}
	return false;
}
%>
