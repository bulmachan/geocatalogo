<%@ page 
	language="java" 
	contentType="text/html; charset=iso-8859-1" 
	pageEncoding="ISO8859-1"
	import =	"java.io.*,
				java.io.IOException,
				java.io.InputStream,
				java.io.OutputStream,
				java.net.*,
				java.util.*,
				java.text.SimpleDateFormat"	
%>
<%@ include file="configDB.jsp"
%>
<%

if ((request.getParameter("layer") != null) && (request.getParameter("layer") != "")) {

	out.println("DOWNLOAD DI: "+request.getParameter("layer"));

	String scheme = request.getScheme();             // http
	String serverName = request.getServerName();     // hostname.com
	String contextPath = request.getContextPath();   // /mywebapp
	String servletPath = request.getServletPath();   // /servlet/MyServlet
	String layer = request.getParameter("layer");
	
	Hashtable<String, String> sist = new Hashtable();
	sist.put("EPSG:202003", "500000.00,840000.00,810000.00,1005000.00");
	sist.put("EPSG:3003", "1500000.00,4840000.00,1810000.00,5005000.00");
	sist.put("EPSG:202032", "500000.00,840000.00,810000.00,1005000.00");
	sist.put("EPSG:23032", "500000.00,4840000.00,810000.00,5005000.00");
	sist.put("EPSG:25832", "500000.00,4840000.00,810000.00,5005000.00");
	sist.put("EPSG:4258", "9.12000000,43.70000000,12.84000000,45.20000000");
	sist.put("EPSG:32632", "500000.00,4840000.00,810000.00,5005000.00");
	sist.put("EPSG:4326", "9.12000000,43.70000000,12.84000000,45.20000000");
	sist.put("EPSG:3857", "1003755.07,5400000.00,1434827.23,5650000.00");
	
	String sistcoord = "EPSG:202003";
	String bbox = "";
	
	String path = "";
	/*scheme+"://"+serverName+"/geologico"+contextPath+"/";*/
	String app = "unknown";
	String clip = "true";
	
	if ((request.getParameter("app") != null) && (request.getParameter("app") != "")) {
		app = request.getParameter("app");
	}
	if ((request.getParameter("clip") != null) && (request.getParameter("clip") != "")) {
		clip = request.getParameter("clip");
	}
	
	/* parametrizzzato srs */
	if ((request.getParameter("srs") != null) && (request.getParameter("srs") != "")) {
		sistcoord = request.getParameter("srs");
	}
	
	/* parametrizzzato bbox */
	if ((request.getParameter("bbox") != null) && (request.getParameter("bbox") != "")) {
		bbox = request.getParameter("bbox");
	}	else {
		bbox = sist.get(sistcoord);
	} 	
	
	//String ip = request.getLocalAddr().toString();
	String ip = request.getServerName().toString();
	
	if (ip.equals("10.10.80.37")){// || ip.equals("geotest.ente.regione.emr.it")){
		// TEST E SVILUPPO:
		path = request.getScheme() + "://"+request.getServerName()+"/geologico"+ request.getRequestURI().substring(0, request.getRequestURI().lastIndexOf('/')+1);
	} else {
		// PROD VERA:
		path = request.getScheme() + "://"+request.getServerName()+ request.getRequestURI().substring(0, request.getRequestURI().lastIndexOf('/')+1);
	}
	
	
	
	Statement stmCAT = null;
	ResultSet rsCAT = null;
	
	String[] resLayer = layer.split("\\.");
	String ownerLayer = resLayer[0];
	String nameLayer = resLayer[1];

	stmCAT = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
	//out.println("CONNESSIONE AL DB: "+dbConnCAT.getMetaData().getURL() );
	
	String stmtCAT_Sql = "select TABLE_DESC_TREE, METALAYER, ID_OGGETTO from CAT_USER.CAT_V_OGGETTI where PUB_FLAG = 3 and OWNER = '"+ownerLayer+"' and TABLE_NAME = '"+nameLayer+"'";
	rsCAT = stmCAT.executeQuery(stmtCAT_Sql);
	String nome = "";
	String metalayer = "";
	String idOggetto = "";
	//out.println(stmtCAT_Sql);
	if (rsCAT.next()) {
		nome = rsCAT.getString("TABLE_DESC_TREE");
		idOggetto = rsCAT.getString("ID_OGGETTO");
		if (rsCAT.getString("METALAYER") != null) {
			metalayer = rsCAT.getString("METALAYER");
		}
	}
	
	rsCAT.close();
	stmCAT.close();
	dbConnCAT.close();

	if (nome != "") {
	
		String url = path+"extractShp.jsp?layer="+layer+"&bbox="+bbox+"&sistcoord="+sistcoord+"&clip="+clip;
		//out.println(url);
		
		try {
			URL urlPage = new URL(url);
			HttpURLConnection conn = (HttpURLConnection)urlPage.openConnection();
			conn.connect();
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String result = "";
			String resultExtractShp = "";
			String[] res;
			while ((result = br.readLine()) != null) { 
				resultExtractShp += result;
			}
		
			res = resultExtractShp.split("<|>");
			String nomeFileZip = res[0];

			String files = "license_cc_by_2_5.pdf,iso_19139.xsl"; /* definito */ 
			String size = "";
			if(res.length==3){
				double dwnTotSize = Double.parseDouble(res[2]);
				if(Math.round(dwnTotSize/1024)<1000)
					size=Math.round(dwnTotSize/1024)+"%20Kb";
				else
					size=(Math.round(dwnTotSize/1024)/1000)+"%20Mb";
			}			
			
			try {
			
				/*url = path+"writeGeoLog.jsp?APP="+app+"&LAYERS="+idOggetto+"&BBOX="+bbox+"&SRS="+sistcoord+"&EVENT=download shape";
				urlPage = new URL(url);
				conn = (HttpURLConnection)urlPage.openConnection();
				conn.connect();*/
				url = path+"createZip.jsp?zip="+nomeFileZip+"&files=license_cc_by_2_5.pdf,iso_19139.xsl&srs="+sistcoord+"&nome="+nome.replace(" ","%20")+"&size="+size+"&metalayer="+metalayer.replace(" ","%20")+"&app="+app;		
				response.sendRedirect(url);
							
			} catch (IOException e) {
				out.print("pippo");
				//e.printStackTrace();
			} catch(IllegalStateException e) {
				out.print("pippo");
				//e.printStackTrace();
			}
        } catch (MalformedURLException e) {
            e.printStackTrace();			
	    } catch (IOException e) {
	       e.printStackTrace();
		   out.print("ERRORE URL: "+e.getMessage());
	    } catch(IllegalStateException e) {
			//e.printStackTrace();
		}
    } else {
	out.print("Lo strato "+layer+" non è scaribile");
    }

%>

<%


}
	
%>
