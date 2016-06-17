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
				interesse per qualunque fine, ovvero secondo i termini della Licenza <a href="http://www.opendatacommons.org/licenses/by/summary/" title="Apri il testo della licenza ODC-BY [in inglese]">Open Data
				Commons - ODC-BY 1.0 license</a> (<a href="http://www.opendatacommons.org/licenses/by/1.0/" title="Apri il testo integrale della licenza ODC-BY [in inglese]">testo integrale</a> in inglese).</p>
				<br />
				<div id="licenza_dati">
					<a  href="http://www.opendatacommons.org/licenses/by/summary/" title="Apri la licenza ODC-BY [testo in inglese]">
						<!-- <img src="images/odc-by.png" width="150" border="0" alt="ODC-BY logo" title="Apri la licenza ODC-BY [testo in inglese]"/> -->
						<img src="images/odc-by_share.png" width="40" border="0" alt="ODC-BY_share logo" title="Condividi il dato - Apri il testo della licenza ODC-BY [in inglese]"/>
					</a>
					<a href="http://www.opendatacommons.org/licenses/by/summary/" title="Apri la licenza ODC-BY [testo in inglese]">
						<img src="images/odc-by_create.png" width="40" border="0" alt="ODC-BY_create logo" title="Crea dati derivati - Apri il testo della licenza ODC-BY [in inglese]"/>
					</a>
					<a href="http://www.opendatacommons.org/licenses/by/summary/" title="Apri la licenza ODC-BY [testo in inglese]">
						<img src="images/odc-by_adapt.png" width="40" border="0" alt="ODC-BY_adapt logo" title="Modifica, elabora, trasforma - Apri il testo della licenza ODC-BY [in inglese]"/>
					</a>
					<a href="http://www.opendatacommons.org/licenses/by/summary/" title="Apri la licenza ODC-BY [testo in inglese]">
						<img src="images/odc-by_attribution.png" width="40" border="0" alt="ODC-BY_attribution logo" title="Cita la fonte dei dati - Apri il testo della licenza ODC-BY [in inglese]"/>
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