<%
	String nomeXlicenza=request.getParameter("layer");
	
	if(!request.getParameter("header").equals("NO")){
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="it">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<title>Licenza d'uso del LAYER</title>
	<link rel="stylesheet" media="screen"  type="text/css" href="styles/style_page.css" />
</head>

<body>			
	<div id="main">
		<div id="condizioni">
			<h1>Licenza d'uso</h1>

<% }
%>
			<div><h3>Licenza Banca dati "<%=nomeXlicenza%>"</h3></div>
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


			</span>


<%	if(!request.getParameter("header").equals("NO")){
%>

		</div>
	</div>
</body>
</html>

<%	}
%>