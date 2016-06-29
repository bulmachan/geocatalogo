<%@ include file="classes/DesEncrypterPhrase.jsp"
%><%
	
	// LETTURA PARAMETRI PER LA CONNESSIONE AD ARCIMS E ARCSDE:
	String nomeServer = "";
        String frase = "";
        String connUser = "";
        String connPw= "";
        String istanzaSDE = "";
        String nomeServerArcims = "";
        String servizioAIMS = ""; 
        String servizioAIMSextract = "";
        int portaSDE = 0;
        Category log = Category.getInstance("GEOCATALOGO");

        try {
                ResourceBundle applicationProperties = ResourceBundle.getBundle("application");
                String connectionSDEfileName=applicationProperties.getString("connectionSDEfileName.properties");
                String connectionAIMSfileName=applicationProperties.getString("connectionAIMSfileName.properties");
                
		ResourceBundle connectionSDEConfig = ResourceBundle.getBundle(connectionSDEfileName);
		nomeServer=connectionSDEConfig.getString("server");
                frase=connectionSDEConfig.getString("frase");
		DesEncrypter encrypter = new DesEncrypter(frase);
		connUser=connectionSDEConfig.getString("username");
		connPw=encrypter.decrypt(connectionSDEConfig.getString("password"));
		istanzaSDE=connectionSDEConfig.getString("istanzaSDE");
		portaSDE = Integer.parseInt(connectionSDEConfig.getString("porta")); // QUESTA SERVE PER L'ARCIMS

                
                ResourceBundle connectionAIMSConfig = ResourceBundle.getBundle(connectionAIMSfileName);
		nomeServerArcims=connectionAIMSConfig.getString("serverArcims");
		servizioAIMS=connectionAIMSConfig.getString("servizioAIMS");
		servizioAIMSextract=connectionAIMSConfig.getString("servizioAIMSextract");
                
                //log.info("connectionSDEfileName: " + connectionSDEfileName + " - nomeServer: " + nomeServer + ", connUser: " + connUser + ", istanzaSDE: " + istanzaSDE + ", portaSDE: "+portaSDE);
                //log.info("connectionAIMSfileName: " + connectionAIMSfileName + " - nomeServerArcims: " + nomeServerArcims + ", servizioAIMS: " + servizioAIMS + ", servizioAIMSextract: " + servizioAIMSextract);
                
        } catch(Exception ee) {
            log.error("configESRI.jsp - ResourceBundle: "+ee.getMessage());
            //ee.printStackTrace();
        }	
	// FINE

%>