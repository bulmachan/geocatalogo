<%@ page import="java.sql.*"
%><%

	// LETTURA PARAMETRI PER LA CONNESSIONE AD ORACLE
		Connection dbConnCAT=null;
		try{
			javax.naming.Context initContext = new javax.naming.InitialContext();
			/* OLD */
			/*javax.naming.Context envContext  = (javax.naming.Context)initContext.lookup("java:/comp/env");
			javax.sql.DataSource ds = (javax.sql.DataSource)envContext.lookup("jdbc/sgssprod");*/
			
			javax.sql.DataSource ds = (javax.sql.DataSource) initContext.lookup("java:/sgssprod");
			
			dbConnCAT = ds.getConnection(); // oggetto connessione
		} catch(Exception ee) {
			out.println("Errore durante la connessione al DB: "+ee);
		}
		

	// FINE

	

%>