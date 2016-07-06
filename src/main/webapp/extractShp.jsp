<%@ page 
	language="java" 
	contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"
	import= "java.io.*,
			java.util.Date,
			java.util.ResourceBundle,
			java.text.*,
			com.esri.aims.mtier.io.*,
			java.net.URL,
			org.apache.log4j.Category,
			java.util.zip.*"
	errorPage=""
%><%@ include file="params.jsp"
%><%@ include file="configDB.jsp"
%><%@ include file="configESRI.jsp"
%><% 

response.setHeader("Cache-Control","no-store"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader("Expires", 0); 

Category logextractShp = Category.getInstance("GEOCATALOGO");

String layer = request.getParameter("layer");
String[] layerParams=layer.split("\\.");

if(layerParams.length>2)
	layer=layerParams[0]+"."+layerParams[1];

String bBox = request.getParameter("bbox");
String layerName = "";
String sistcoord = request.getParameter("sistcoord");

// PER TAGLIARE SULL'EXTENT o PER FARE UN SELECT BY THEME (DEFAULT=TRUE)
String clip = request.getParameter("clip");
if(clip.equals(""))
	clip="true";

String pubflag = "";
String topo = "";

String stmt_Sql = "";
ResultSet rs = null;

double minX = 500000.0;
double minY = 840000.0; 
double maxX = 820000.0;
double maxY = 1020000.0;


// DEFINIZIONE DEI GRIGLIATI
String cartellaGrigliato="";
String grigliatoMM_ETRS89="";
String grigliatoED50_ETRS89="";
if(griglia.equals("GK2")){
	cartellaGrigliato="Dataset_it_emirom_GK2";
	grigliatoMM_ETRS89="RER_MM_ETRS89_IGM_K2.gsb";
	grigliatoED50_ETRS89="RER_ED50_ETRS89_IGM_K2.gsb";
} else if(griglia.equals("ADA")){
	cartellaGrigliato="Dataset_it_emirom_ad400_v1";
	grigliatoMM_ETRS89="RER_AD400_MM_ETRS89_V1A.gsb";
	grigliatoED50_ETRS89=""; // NON ESISTE
} else if(griglia.equals("GPS7")){
	cartellaGrigliato="Dataset_it_emirom_gps7_k2";
	grigliatoMM_ETRS89="RER_MM_ETRS89_GPS7_K2.GSB";
	grigliatoED50_ETRS89="RER_ED50_ETRS89_GPS7_K2.GSB";
}

String outputUrl = "";
String datumTransformation="";

String prjUTMRER="PROJCS[&quot;UTMRER&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388,297]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;Degree&quot;,0.0174532925199432955]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;False_Easting&quot;,500053.0],PARAMETER[&quot;False_Northing&quot;,-3999820.0],PARAMETER[&quot;Central_Meridian&quot;,9],PARAMETER[&quot;Scale_Factor&quot;,0.9996],PARAMETER[&quot;Latitude_Of_Origin&quot;,0],UNIT[&quot;Meter&quot;,1]]";

String prjUTMA="PROJCS[&quot;UTMA&quot;,GEOGCS[&quot;GCS_European_1950&quot;,DATUM[&quot;D_European_1950&quot;,SPHEROID[&quot;International_1924&quot;,6378388,297]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;Degree&quot;,0.017453292519943295]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;False_Easting&quot;,500000],PARAMETER[&quot;False_Northing&quot;,-4000000],PARAMETER[&quot;Central_Meridian&quot;,9],PARAMETER[&quot;Scale_Factor&quot;,0.9996],PARAMETER[&quot;Latitude_Of_Origin&quot;,0],UNIT[&quot;Meter&quot;,1]]";


boolean verbose=true;

String nomeFile = "";

try
{

	Statement stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
	stmt_Sql = "SELECT PUB_FLAG, TOPO, decode(TABLE_DESC_TREE, null, TABLE_DESC, TABLE_DESC_TREE) as TABLE_DESC_TREE FROM CAT_USER.cat_v_oggetti WHERE (OWNER || '.' || TABLE_NAME) = '"+layer+"'";
	//and WHERE_IS = 'geo04srv:geo04_sde'"; //PRECHE' LASCIAMO QUESTA OPZIONE ?!?
	//SELECT PUB_FLAG, TOPO, decode(TABLE_DESC_TREE, null, TABLE_DESC, TABLE_DESC_TREE) as TABLE_DESC_TREE FROM CAT_USER.cat_v_oggetti WHERE (OWNER || '.' || TABLE_NAME) = 'PGE_USER.PGE_VF_PAESAGGIO_GEO_POL' and WHERE_IS = 'geo04srv:geo04_sde'
	//SELECT PUB_FLAG, TOPO, decode(TABLE_DESC_TREE, null, TABLE_DESC, TABLE_DESC_TREE) as TABLE_DESC_TREE FROM CAT_USER.cat_v_oggetti WHERE (OWNER || '.' || TABLE_NAME) = 'GEO_USER.GEO_VF_10_GEOLOGIA_LIN' and WHERE_IS = 'geo04srv:geo04_sde'

	
	//out.println(stmt_Sql);


	rs = stm.executeQuery(stmt_Sql);
	rs.next();
	
	pubflag = rs.getString("PUB_FLAG");
	topo = rs.getString("TOPO");
	layerName=rs.getString("TABLE_DESC_TREE");
	rs.close();
	stm.close();
	dbConnCAT.close();

//topo="a";
//pubflag="3";
	if(pubflag.equals("3")){ 	

		String type="";
		if (topo.equals("a")) {
			type="polygon";
		} else if(topo.equals("p")){
			type="point";
		} else if(topo.equals("l")){
			type="line";
		}

		if(!bBox.equals("")){
			minX=Double.parseDouble(bBox.split(",")[0]);
			minY=Double.parseDouble(bBox.split(",")[1]);
			maxX=Double.parseDouble(bBox.split(",")[2]);
			maxY=Double.parseDouble(bBox.split(",")[3]);

		}
		
		ConnectionProxy connection = new ConnectionProxy();
			
		connection.setConnectionType("tcp");
		connection.setHost(nomeServerArcims);
		connection.setPort(5300);
		connection.setService(servizioAIMSextract+"&CustomService=extract");
		
	//SDE EXTRACT
		
		String req = "";
		String coordSys="";

		req += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		req += "<ARCXML version=\"1.1\">";
		req += "<REQUEST>";
		req += "<GET_EXTRACT>";
		req += "<PROPERTIES>";
		req += "<ENVELOPE minx=\"" + minX + "\" miny=\"" + minY + "\" maxx=\"" + maxX + "\" maxy=\"" + maxY + "\" />";
		req += "<MAPUNITS units=\"meters\" />";
		
	// MODIFICA MARUCCI PER INCLUDERE IL FILE PRJ NELLO ZIPPETTINO:

	
		//out.println(sistcoord);
	
		if(sistcoord.equals("EPSG:202032")){
	
			datumTransformation="GEOGTRAN[&quot;CGT_ED50_ETRS89&quot;,GEOGCS[&quot;GCS_European_1950&quot;,DATUM[&quot;D_European_1950&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_ETRS_1989&quot;,DATUM[&quot;D_ETRS_1989&quot;,SPHEROID[&quot;GRS_1980&quot;,6378137.0,298.257222101]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoED50_ETRS89+"&quot;,0.0]]";

			req += "<FILTERCOORDSYS id=\"202032\" />";
			req += "<FEATURECOORDSYS id=\"202032\" datumtransformstring=\"" + datumTransformation + "\" />";
			
			datumTransformation="GEOGTRAN[&quot;CGT_MM_ETRS89&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_ETRS_1989&quot;,DATUM[&quot;D_ETRS_1989&quot;,SPHEROID[&quot;GRS_1980&quot;,6378137.0,298.257222101]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"&quot;,0.0]]";
	
			coordSys = "<COORDSYS string=\"" + prjUTMRER + "\" datumtransformstring=\"" + datumTransformation + "\" />";
		
		}else if(sistcoord.equals("EPSG:23032")){

			datumTransformation="GEOGTRAN[&quot;CGT_ED50_ETRS89&quot;,GEOGCS[&quot;GCS_European_1950&quot;,DATUM[&quot;D_European_1950&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_ETRS_1989&quot;,DATUM[&quot;D_ETRS_1989&quot;,SPHEROID[&quot;GRS_1980&quot;,6378137.0,298.257222101]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoED50_ETRS89+"&quot;,0.0]]";

			req += "<FILTERCOORDSYS id=\"23032\" />";
			req += "<FEATURECOORDSYS id=\"23032\" datumtransformstring=\"" + datumTransformation + "\" />";
			
			datumTransformation="GEOGTRAN[&quot;CGT_MM_ETRS89&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_ETRS_1989&quot;,DATUM[&quot;D_ETRS_1989&quot;,SPHEROID[&quot;GRS_1980&quot;,6378137.0,298.257222101]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"&quot;,0.0]]";
			
			coordSys = "<COORDSYS string=\"" + prjUTMRER + "\" datumtransformstring=\"" + datumTransformation + "\" />";

		}else if(sistcoord.equals("EPSG:25832")){
			
			datumTransformation="GEOGTRAN[&quot;CGT_MM_ETRS89&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_ETRS_1989&quot;,DATUM[&quot;D_ETRS_1989&quot;,SPHEROID[&quot;GRS_1980&quot;,6378137.0,298.257222101]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"&quot;,0.0]]";
			
			req += "<FILTERCOORDSYS id=\"25832\" datumtransformstring=\"" + datumTransformation + "\" />";
			req += "<FEATURECOORDSYS id=\"25832\" />";
			coordSys = "<COORDSYS string=\"" + prjUTMRER + "\" datumtransformstring=\"" + datumTransformation + "\" />";
		
		}else if(sistcoord.equals("EPSG:32632")){
			
			datumTransformation="GEOGTRAN[&quot;CGT_MM_WGS84&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_WGS_1984&quot;,DATUM[&quot;D_WGS_1984&quot;,SPHEROID[&quot;WGS_1984&quot;,6378137.0,298.257223563]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"&quot;,0.0]]";
			
			req += "<FILTERCOORDSYS id=\"32632\" datumtransformstring=\"" + datumTransformation + "\" />";
			req += "<FEATURECOORDSYS id=\"32632\" />";
			coordSys = "<COORDSYS string=\"" + prjUTMRER + "\" datumtransformstring=\"" + datumTransformation + "\" />";

		}else if(sistcoord.equals("EPSG:4326")){
			
			datumTransformation="GEOGTRAN[&quot;CGT_MM_WGS84&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_WGS_1984&quot;,DATUM[&quot;D_WGS_1984&quot;,SPHEROID[&quot;WGS_1984&quot;,6378137.0,298.257223563]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"&quot;,0.0]]";
			
			req += "<FILTERCOORDSYS id=\"4326\" datumtransformstring=\"" + datumTransformation + "\" />";
			req += "<FEATURECOORDSYS id=\"4326\" />";
			coordSys = "<COORDSYS string=\"" + prjUTMRER + "\" datumtransformstring=\"" + datumTransformation + "\" />";
			
		}else if(sistcoord.equals("EPSG:3857")){
			
			datumTransformation="GEOGTRAN[&quot;CGT_MM_WGS84&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_WGS_1984&quot;,DATUM[&quot;D_WGS_1984&quot;,SPHEROID[&quot;WGS_1984&quot;,6378137.0,298.257223563]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"&quot;,0.0]]";
			
			req += "<FILTERCOORDSYS id=\"3857\" datumtransformstring=\"" + datumTransformation + "\" />";
			req += "<FEATURECOORDSYS id=\"3857\" />";
			coordSys = "<COORDSYS string=\"" + prjUTMRER + "\" datumtransformstring=\"" + datumTransformation + "\" />";

		}else if(sistcoord.equals("EPSG:4258")){
			
			datumTransformation="GEOGTRAN[&quot;CGT_MM_ETRS89&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388.0,297.0]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],GEOGCS[&quot;GCS_ETRS_1989&quot;,DATUM[&quot;D_ETRS_1989&quot;,SPHEROID[&quot;GRS_1980&quot;,6378137.0,298.257222101]],PRIMEM[&quot;Greenwich&quot;,0.0],UNIT[&quot;Degree&quot;,0.0174532925199433]],METHOD[&quot;NTv2&quot;],PARAMETER[&quot;"+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"&quot;,0.0]]";
			
			req += "<FILTERCOORDSYS id=\"4258\" datumtransformstring=\"" + datumTransformation + "\" />";
			req += "<FEATURECOORDSYS id=\"4258\" />";
			coordSys = "<COORDSYS string=\"" + prjUTMRER + "\" datumtransformstring=\"" + datumTransformation + "\" />";

		}else if(sistcoord.equals("EPSG:3003")){
			
			req += "<FILTERCOORDSYS id=\"3003\" />";
			req += "<FEATURECOORDSYS id=\"3003\" />";
			coordSys="<COORDSYS string=\"" + prjUTMRER + "\" />";
		
		}else if(sistcoord.equals("EPSG:202003")){
			
			req += "<FEATURECOORDSYS id=\"202003\" />";
			coordSys="<COORDSYS string=\"" + prjUTMRER + "\" />";

		}

	// FINE MODIFICA MARUCCI
		
		req += "<LAYERLIST>";
		req += "<LAYERDEF id=\"0\" visible=\"false\" />";

	// MODIFICA MARUCCI PER ESCLUDERE ANCHE I COMUNI DALLO ZIPPETTINO:
	
		req += "<LAYERDEF id=\"1\" visible=\"false\" />";
	
	// FINE MODIFICA MARUCCI
		req += "</LAYERLIST>";
		req += "</PROPERTIES>";
		req += "<LAYER type=\"featureclass\" name=\"" + layer + "\" visible=\"true\" id=\"" + layerName.replaceAll("\\.","_").replaceAll(":","_").replaceAll(" ","_") + "\">";

		req += "<DATASET name=\"" + layer + "\" type=\"" + type + "\" workspace=\"sde_ws-0\" />";

		//req += "<COORDSYS string=\"" + prjUTMRER + "\" datumtransformstring=\"" + datumTransformation + "\" />";
		req += coordSys;

	// MODIFICA MARUCCI PER TAGLIARE LE ENTITA' SULL'ESTENSIONE DELLA MAPPA:
    
		req += "<EXTENSION type=\"Extract\" >";
        req += "  <EXTRACTPARAMS clip=\"" + clip + "\" />";
        req += "</EXTENSION>";
	
	// FINE MODIFICA MARUCCI
		
		req += "</LAYER>";
		req += "</GET_EXTRACT>";
		req += "</REQUEST>";
		req += "</ARCXML>";
		
		//out.println(req);

		String resp = connection.send(req);
		
		String dQuote = "\"";
		int startpos = 0;
		int endpos = 0;
		int pos = 0;
		startpos = resp.indexOf(" url=");
		if (startpos!=-1) {
			startpos += 6;
			endpos = resp.indexOf(dQuote,startpos);
			outputUrl = resp.substring(startpos,endpos);
		}
		
		//logextractShp.info("EXTRACT SHP: "+layer +"\t "+ minX + "\t " + minY + "\t " + maxX + "\t " + maxY);
		//logextractShp.info(resp);
		
		if (verbose){
			/*SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy ', ' HH:mm:ss");
			
			Long date1 = new Date().getTime();
			Date date2 = new Date(date1);

			long date = new Date().getTime();
			Long longDate = new Long (date);
			String dateString = longDate.toString();*/
			
			logextractShp.info("EXTRACT SHP: "+layer +"\t "+ minX + "\t " + minY + "\t " + maxX + "\t " + maxY);
			
			/*String path = application.getRealPath("/log_extract.txt");
			PrintWriter pw = new PrintWriter(new FileWriter(new File(path), true));
			pw.println(date2+"\t "+ layer +"\t "+ minX + "\t " + minY + "\t " + maxX + "\t " + maxY);
			pw.close();*/
		}
		
		int barraPos=outputUrl.lastIndexOf("/");
		nomeFile=outputUrl.substring(barraPos+1,outputUrl.length());
		
		//out.println(resp);
		
		// read the size of the remote zip file
		URL url = new URL(outputURL+nomeFile);
		InputStream f = url.openStream();
		byte[] buf = new byte[1024];
		int n;
		int fs=0;
		while ((n = f.read(buf, 0, 1024)) > -1)
			fs+=n;
		f.close(); 

		out.println(nomeFile+"<|>"+fs);//+"-----"+layerName.replaceAll("\\.","_").replaceAll(" ","_"));
		log.info(nomeFile+"<|>"+fs);//+"-----"+layerName.replaceAll("\\.","_").replaceAll(" ","_"));
	}	
	

} catch(Exception ee) {
	out.print("ERRORE: "+ee.getMessage()+ " " + stmt_Sql);
	log.error("ExtractShp.jsp - DOWNLOAD SHP: "+ee.getMessage()+ " " + stmt_Sql);
	ee.printStackTrace();

} finally {
	
	dbConnCAT.close();

} 
%>