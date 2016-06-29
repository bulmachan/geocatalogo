<%@ page import="java.sql.*, java.util.ResourceBundle, org.apache.log4j.Category"
%><%

	// LETTURA PARAMETRI PER LA CONNESSIONE AD ORACLE
		Connection dbConnCAT=null;
                Category logdb = Category.getInstance("GEOCATALOGO");
		try{
			javax.naming.Context initContext = new javax.naming.InitialContext();	
                        ResourceBundle applicationdataSourceProperties = ResourceBundle.getBundle("application");
                        String dataSource=applicationdataSourceProperties.getString("dataSource");
                        javax.sql.DataSource ds = (javax.sql.DataSource) initContext.lookup(dataSource);
			log.info("dataSource: " + dataSource + 
			dbConnCAT = ds.getConnection(); // oggetto connessione
		} catch(Exception ee) {
			logdb.error("configDB.jps - Errore durante la connessione al DB: "+ee);
		}
		

	// FINE

	

%>