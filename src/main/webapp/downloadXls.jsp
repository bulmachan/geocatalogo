<%@ page
	language="java" 
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import=	"java.sql.*,
			java.io.*,
			jxl.*,
			jxl.write.*,
			java.util.Date,
			org.apache.log4j.Category,
			java.text.SimpleDateFormat,
			java.math.*"

	errorPage=""
%><%@ include file="configDB.jsp"
%><%@ include file="rsToXls.jsp"
%><%@ include file="zip.jsp"
%><%@ include file="params.jsp"
%><%

	Category log = Category.getInstance("GEOCATALOGO");

	String table=request.getParameter("table");
	String nome=request.getParameter("nome");


	Statement stmc = null;
	ResultSet rPub = null;
	int countPub = 0;
	try	{
		String stmtt_Sql = "";
		stmtt_Sql = "select count(*) as c from CAT_USER.CAT_V_TREE where ord=2 and pubflag=3 and (owner || '.' || sorgente) = '"+table+"'";
		//out.println(stmtt_Sql);
		
		stmc = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		rPub = stmc.executeQuery(stmtt_Sql);
		rPub.next();
		countPub = rPub.getInt("c");
		rPub.close();
		stmc.close();
		
	} catch(Exception eee) {
	
		if(rPub!=null)
			rPub.close();

		if(stmc!=null)
			stmc.close();
				
		out.print(eee.getMessage());
		eee.printStackTrace();
	}
	//out.print(countPub);


	if(countPub>0){

		Statement stm = null;
		ResultSet rs = null;
		ResultSet rCount = null;
		
		try{
			stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

			rCount = stm.executeQuery("SELECT COUNT(*) AS rowcount FROM "+table);
			rCount.next();
			double count = rCount.getDouble("rowcount");
			rCount.close();
			String stmt_Sql = "select * from "+table;
			
			rs = stm.executeQuery(stmt_Sql);
			
			int x = (int)(100000000*Math.random());

			nome=nome.replaceAll(":","_");
			//.replaceAll("à","a").replaceAll("è","e").replaceAll("ì","i").replaceAll("ò","o").replaceAll("ù","u");

			String nomeFile=outputPath+nome+"_"+x;
			boolean saved = rsToXls(nomeFile+".xls", rs, nome, count);

			rs.close();
			stm.close();

			if(saved) {
				File file = new File(nomeFile+".xls");
				long len = file.length();
				Integer fileSize=Integer.valueOf((int)len);
				
				// ZIPPA IL FILE	
					
				if(len>0) {		
					try {
						makeZipFile list = new makeZipFile( );
						list.doZip(outputPath, nome+"_"+x, fileSize, null, null);
					} catch (Exception e) {
						e.printStackTrace();
						log.error("Errore ZIPPAGGIO");
					}
				}
				
				File filezip = new File(nomeFile+".zip");
				long lenzip = filezip.length();
				
				if(debug)	
					log.info("IP: "+request.getRemoteAddr() + "\t" +"DOWNLOAD XLS: "+nomeFile + ".xls: "+ String.valueOf(lenzip));

				out.println(nome+"_"+x+".zip"+"<|>"+String.valueOf(lenzip));
			} else {
				log.error("DOWNLOAD TABLE: ERRORE "+nome+"_"+x+".zip");
			}
		
		} catch(Exception ee) {
			//out.print(ee.getMessage());
			//ee.printStackTrace();
			log.error("Catch DOWNLOAD TABLE: "+ee.getMessage());
		
			if(rs!=null)
				rs.close();
			
			if(rCount!=null)
				rCount.close();

			if(stm!=null)
				stm.close();

		}
	} else {
		out.print("0");
	}

	dbConnCAT.close();		

%>
