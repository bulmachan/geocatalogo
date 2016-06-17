<%@ include file="classes/DesEncrypterPhrase.jsp"
%><%
	
	// LETTURA PARAMETRI PER LA CONNESSIONE AD ARCIMS E ARCSDE:
		
		ResourceBundle connectionConfig = ResourceBundle.getBundle("connectionESRI");
		String nomeServer=connectionConfig.getString("server");
		String nomeServerArcims=connectionConfig.getString("serverArcims");
		String servizioAIMS=connectionConfig.getString("servizioAIMS");
		String servizioAIMSextract=connectionConfig.getString("servizioAIMSextract");
		String frase=connectionConfig.getString("frase");
		DesEncrypter encrypter = new DesEncrypter(frase);
		String connUser=connectionConfig.getString("username");
		String connPw=encrypter.decrypt(connectionConfig.getString("password"));
		String istanzaSDE=connectionConfig.getString("istanzaSDE");
		int portaSDE = Integer.parseInt(connectionConfig.getString("porta")); // QUESTA SERVE PER L'ARCIMS

	// FINE

%>