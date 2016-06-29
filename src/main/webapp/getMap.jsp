<%@ page
    buffer="500kb"
	language="java" 
	contentType="text/html; charset=iso-8859-1"
	pageEncoding="ISO8859-1"
	import="com.esri.aims.mtier.io.*,
			com.esri.aims.mtier.model.workspace.SDEWorkspace,
			com.esri.aims.mtier.model.workspace.ImageWorkspace,
			com.esri.aims.mtier.model.workspace.Dataset,
			com.esri.aims.mtier.model.map.Map,
			com.esri.aims.mtier.model.map.layer.renderer.SimpleRenderer, 
			com.esri.aims.mtier.model.map.layer.renderer.symbol.SimpleLineSymbol, 
			com.esri.aims.mtier.model.map.layer.renderer.symbol.SimplePolygonSymbol, 
			com.esri.aims.mtier.model.map.layer.renderer.symbol.SimpleMarkerSymbol, 
			com.esri.aims.mtier.model.map.layer.renderer.symbol.RasterMarkerSymbol,
			com.esri.aims.mtier.model.map.layer.renderer.symbol.TrueTypeMarkerSymbol,
			com.esri.aims.mtier.model.map.layer.FeatureLayer, 
			com.esri.aims.mtier.model.map.layer.ImageLayer, 
			com.esri.aims.mtier.model.envelope.Envelope, 
			com.esri.aims.mtier.model.map.layer.raster.Raster,
			com.esri.aims.mtier.model.wmsmap.*,
			com.esri.aims.mtier.model.acetate.Acetate,
			com.esri.aims.mtier.model.acetate.Polygon,
			com.esri.aims.mtier.model.acetate.Point,
			com.esri.aims.mtier.model.acetate.Points,
			com.esri.aims.mtier.model.acetate.Ring,
			com.esri.aims.mtier.model.map.layer.AcetateLayer,
			java.awt.image.*,
			javax.imageio.*,
			java.io.*,
			java.net.URL,
			java.text.SimpleDateFormat,
			java.util.Calendar,
			java.awt.Graphics,
			java.awt.*,
			java.awt.Font,
			java.awt.Color,
			java.util.ResourceBundle,
			org.apache.log4j.Category,
			com.esri.aims.mtier.model.map.projection.*"
	errorPage=""
%><%@ include file="configESRI.jsp"
%><%@ include file="configDB.jsp"
%><%@ include file="params.jsp"
%><%

	//LAYERS=158_UTMA_ORTOAGEA2008
	//BBOX=660348.575846471,937771.28770505,660983.088417322,938188.006666195&WIDTH=1177&HEIGHT=773
	
	//?layers=BASE_USER.BASE_VF_REGIONE_ER_POL&bbox=660348.575846471,937771.28770505,660983.088417322,938188.006666195&WIDTH=800&HEIGHT=600

	//Category log = Category.getInstance("GEOCATALOGO"); //Duplicate local variable log (modev to configESRI.jsp)
	
	String width="";
	String height="";
	
	if (request.getParameter("width") != null){
		width=request.getParameter("width");
	} else {
		if (request.getParameter("WIDTH") != null){
			width=request.getParameter("WIDTH");
		} else {
			width="300";
		}
	}	

	if (request.getParameter("height") != null){
		height=request.getParameter("height");
	} else {
		if (request.getParameter("HEIGHT") != null){
			height=request.getParameter("HEIGHT");
		} else {
			height="200";
		}
	}


String layerParam="";

ResultSet rs = null;
Statement stm = null;
String layerName="";
try {

	if (request.getParameter("layers") != null){
		layerParam=request.getParameter("layers");
	} else {
		if (request.getParameter("LAYERS") != null){
			layerParam=request.getParameter("LAYERS");
		} else {
			throw new Exception("Parametro LAYERS non corretto");
		}
	}

	String bBox="";
	if (request.getParameter("bbox") != null){
		bBox=request.getParameter("bbox");
	} else {
		if (request.getParameter("BBOX") != null){
			bBox=request.getParameter("BBOX");
		} else {
			throw new Exception("Parametro BBOX non corretto");
		}
	}

	if (request.getParameter("width") != null){
		width=request.getParameter("width");
	} else {
		if (request.getParameter("WIDTH") != null){
			width=request.getParameter("WIDTH");
		} else {
			throw new Exception("Parametro WIDTH non corretto");
		}
	}	

	if (request.getParameter("height") != null){
		height=request.getParameter("height");
	} else {
		if (request.getParameter("HEIGHT") != null){
			height=request.getParameter("HEIGHT");
		} else {
			throw new Exception("Parametro HEIGHT non corretto");
		}
	}
	String sistcoord="";
	
	if (request.getParameter("srs") != null){
		sistcoord=request.getParameter("srs");
	} else {
		if (request.getParameter("SRS") != null){
			sistcoord=request.getParameter("SRS");
		} else {
			sistcoord="0";
		}
	}


	if(sistcoord.indexOf("NONE")>-1)
		sistcoord="0";
	else
		if(sistcoord.indexOf("EPSG:")>-1)
			sistcoord=sistcoord.replace("EPSG:","");
		else
			sistcoord="0";

	String serviceName="";
	if (request.getParameter("SERVICENAME") != null){
		serviceName=request.getParameter("SERVICENAME");
	}

	
	String extractBbox="";
	if (request.getParameter("EXTRACTBBOX") != null){
		extractBbox=request.getParameter("EXTRACTBBOX");
	} 

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

	String textLog="";

	//Calendar cal = Calendar.getInstance();
	//String DATE_FORMAT_NOW = "MMMMMyyyy";
	//SimpleDateFormat sdfNow = new SimpleDateFormat(DATE_FORMAT_NOW);
	//String now=sdfNow.format(cal.getTime());
	//String pathLog = application.getRealPath(request.getServletPath().toString().replace("/getMap.jsp","/")+"/logs/log"+now+".txt");
	
	//BASE_USER.BASE_VF_COMUNI_POL.polygon.ID_COMUNE=36037
	String owner="";
	String layer="";
	String type="polygon";
	String expression="";
	
	String[] layerParams=layerParam.split("\\.");
	String layerNoUser="";

	if(layerParams.length > 0){
	
		//type=layer.substring(layer.lastIndexOf(".")+1, layer.length());
		//layer=layer.substring(0,layer.lastIndexOf("."));
		
		///*String[] layers=layer.split("\\.");
		owner=layerParams[0];
		if(layerParams.length > 1)
			layer=layerParams[1];
		if(layerParams.length>2)
			type=layerParams[2];		
		if(layerParams.length>3)
			expression=layerParams[3];
		
		layerName=layer;
		
		if(!owner.equals(""))
			layer=owner+"."+layer;
		
	}else{
		layerName=layer;
		layer=layerParam;
		if(layer.lastIndexOf("POLYGON") > -1){
			type="polygon";
		} else if(layer.lastIndexOf("POLYLINE") > -1){
			type="line";
		} else if(layer.lastIndexOf("POINT") > -1){
			type="point";
		} else {
			if(layer.lastIndexOf("_") > -1){
				if(layer.substring(layer.lastIndexOf("_")+1, layer.length()).equalsIgnoreCase("POL")){
					type="polygon";
				} else if(layer.substring(layer.lastIndexOf("_")+1, layer.length()).equalsIgnoreCase("LIN")){
					type="line";
				}else if(layer.substring(layer.lastIndexOf("_")+1, layer.length()).equalsIgnoreCase("PUN")){
					type="point";
				} else {
					type="raster";
				}
			}
		}
	}



	//String bBox = "660348.575846471,937771.28770505,660983.088417322,938188.006666195";
	
	String[] arrBBox = bBox.split(",");

	Double xMin = null;
	Double yMin = null;
	Double xMax = null;
	Double yMax = null;
	
	if (arrBBox.length >= 1) {
		xMin = Double.valueOf(arrBBox[0]);
	}
	if (arrBBox.length >= 2) {
		yMin = Double.valueOf(arrBBox[1]);
	}
	if (arrBBox.length >= 3) {
		xMax = Double.valueOf(arrBBox[2]);
	}
	if (arrBBox.length >= 4) {
		yMax = Double.valueOf(arrBBox[3]);
	}

	if(serviceName.equals("")){

		try{
			stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

			String stmt_Sql = "SELECT OWNER, TABLE_NAME, PUB_FLAG, TABLE_DESC_TREE FROM CAT_USER.cat_v_oggetti WHERE upper(OWNER) = upper('" + owner + "') and upper(TABLE_NAME)=upper('"+ layerName + "') and WHERE_IS = 'geo04srv:geo04_sde'";
			rs = stm.executeQuery(stmt_Sql);
			if(rs.next()){
			
				layerName = rs.getString("TABLE_DESC_TREE");
				
				if(Integer.parseInt(rs.getString("PUB_FLAG").trim())<2){
					
					throw new Exception("Il layer "+layerName+" non e' pubblico");
				}
			} else {
				
				throw new Exception("Il layer "+layer+" non esiste");
				//+ "WHERE upper(OWNER) = upper('" + owner + "') and upper(TABLE_NAME)=upper('"+ layer + "') and WHERE_IS = 'geo04srv:geo04_sde'");
			
			}
			rs.close();
			stm.close();

		} catch (Exception eDb) {
			
			throw new Exception("Errore DB: " +eDb.getMessage());

		}

	}
	
	dbConnCAT.close();

	long dateIni15 = new java.util.Date().getTime();

	
	try{
	
		ConnectionProxy connection = new ConnectionProxy();
		Map map = new Map();
		connection.setConnectionType("tcp");
		
		//nomeServerArcims="vm81srv";
		
		connection.setHost(nomeServerArcims);
		connection.setPort(5300);
		if(serviceName.equals(""))
			connection.setService(servizioAIMS);
		else
			connection.setService(serviceName);


		map.initMap(connection, 0, false, false, true, false);	

		map.getEnvelope().setMinX(xMin);
		map.getEnvelope().setMinY(yMin);
		map.getEnvelope().setMaxX(xMax);
		map.getEnvelope().setMaxY(yMax);

		map.getLegend().setDisplay(false);

		map.setWidth(Long.valueOf(width));
		map.setHeight(Long.valueOf(height));

		map.setBackground("255,255,255");		
		map.setTransColor("255,255,255");

		String datumTransformation="";

		String prjUTMA="PROJCS[\"UTMA\",GEOGCS[\"GCS_European_1950\",DATUM[\"D_European_1950\",SPHEROID[\"International_1924\",6378388,297]],PRIMEM[\"Greenwich\",0],UNIT[\"Degree\",0.017453292519943295]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"False_Easting\",500000],PARAMETER[\"False_Northing\",-4000000],PARAMETER[\"Central_Meridian\",9],PARAMETER[\"Scale_Factor\",0.9996],PARAMETER[\"Latitude_Of_Origin\",0],UNIT[\"Meter\",1]]";

		// DOPO CAMBIO DATI DA UTMA A UTMRER (in TEST GENNAIO 2013)
		String prjUTMRER="PROJCS[\"UTMRER\",GEOGCS[\"GCS_Monte_Mario\",DATUM[\"D_Monte_Mario\",SPHEROID[\"International_1924\",6378388,297]],PRIMEM[\"Greenwich\",0],UNIT[\"Degree\",0.0174532925199432955]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"False_Easting\",500053.0],PARAMETER[\"False_Northing\",-3999820.0],PARAMETER[\"Central_Meridian\",9],PARAMETER[\"Scale_Factor\",0.9996],PARAMETER[\"Latitude_Of_Origin\",0],UNIT[\"Meter\",1]]";
		
		//prjUTMRER="PROJCS[&quot;UTMRER&quot;,GEOGCS[&quot;GCS_Monte_Mario&quot;,DATUM[&quot;D_Monte_Mario&quot;,SPHEROID[&quot;International_1924&quot;,6378388,297]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;Degree&quot;,0.0174532925199432955]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;False_Easting&quot;,500053.0],PARAMETER[&quot;False_Northing&quot;,-3999820.0],PARAMETER[&quot;Central_Meridian&quot;,9],PARAMETER[&quot;Scale_Factor&quot;,0.9996],PARAMETER[&quot;Latitude_Of_Origin&quot;,0],UNIT[&quot;Meter&quot;,1]]";

		Long epsg=(long)202003;
		
		CoordSys coordsys = new CoordSys();
		FeatureCoordSys featureCoordSys = new FeatureCoordSys();
		FilterCoordSys filterCoordSys = new FilterCoordSys();
		
		//coordsys.setString(prjUTMA);
		coordsys.setString(prjUTMRER);

		//filterCoordSys.setString(prjUTMA);
		
		if(sistcoord.equals("202003")){

			//featureCoordSys.setString(prjUTMA);
			//filterCoordSys.setString(prjUTMA);
			
			epsg=(long)202003;
			featureCoordSys.setString(prjUTMRER);
			filterCoordSys.setString(prjUTMRER);

		
		}else if(sistcoord.equals("202032")){
			
			coordsys.setString(prjUTMA);
			epsg=(long)202032;
			featureCoordSys.setID(epsg);
			filterCoordSys.setID(epsg);

		}else if(sistcoord.equals("23032")){
		
			coordsys.setString(prjUTMA);
			epsg=(long)23032;
			featureCoordSys.setID(epsg);
			filterCoordSys.setID(epsg);

		}else if(sistcoord.equals("25832")){
			
			epsg=(long)25832;
			featureCoordSys.setID(epsg);
			filterCoordSys.setID(epsg);

			datumTransformation="GEOGTRAN[\"CGT_MM_ETRS89\",GEOGCS[\"GCS_Monte_Mario\",DATUM[\"D_Monte_Mario\",SPHEROID[\"International_1924\",6378388.0,297.0]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],GEOGCS[\"GCS_ETRS_1989\",DATUM[\"D_ETRS_1989\",SPHEROID[\"GRS_1980\",6378137.0,298.257222101]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],METHOD[\"NTv2\"],PARAMETER[\""+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"\",0.0]]";

		}else if(sistcoord.equals("32632")){
			epsg=(long)32632;
			featureCoordSys.setID(epsg);
			filterCoordSys.setID(epsg);

			datumTransformation="GEOGTRAN[\"CGT_MM_WGS84\",GEOGCS[\"GCS_Monte_Mario\",DATUM[\"D_Monte_Mario\",SPHEROID[\"International_1924\",6378388.0,297.0]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],GEOGCS[\"GCS_WGS_1984\",DATUM[\"D_WGS_1984\",SPHEROID[\"WGS_1984\",6378137.0,298.257223563]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],METHOD[\"NTv2\"],PARAMETER[\""+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"\",0.0]]";

		}else if(sistcoord.equals("4326")){

			epsg=(long)4326;
			featureCoordSys.setID(epsg);
			filterCoordSys.setID(epsg);
			
			datumTransformation="GEOGTRAN[\"CGT_MM_WGS84\",GEOGCS[\"GCS_Monte_Mario\",DATUM[\"D_Monte_Mario\",SPHEROID[\"International_1924\",6378388.0,297.0]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],GEOGCS[\"GCS_WGS_1984\",DATUM[\"D_WGS_1984\",SPHEROID[\"WGS_1984\",6378137.0,298.257223563]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],METHOD[\"NTv2\"],PARAMETER[\""+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"\",0.0]]";
		
		}else if(sistcoord.equals("4258")){

			epsg=(long)4258;
			featureCoordSys.setID(epsg);
			filterCoordSys.setID(epsg);

			datumTransformation="GEOGTRAN[\"CGT_MM_ETRS89\",GEOGCS[\"GCS_Monte_Mario\",DATUM[\"D_Monte_Mario\",SPHEROID[\"International_1924\",6378388.0,297.0]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],GEOGCS[\"GCS_ETRS_1989\",DATUM[\"D_ETRS_1989\",SPHEROID[\"GRS_1980\",6378137.0,298.257222101]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],METHOD[\"NTv2\"],PARAMETER[\""+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"\",0.0]]";
		
		}else if(sistcoord.equals("3003")){

			epsg=(long)3003;
			featureCoordSys.setID(epsg);
			filterCoordSys.setID(epsg);

		}else if(sistcoord.equals("3857")){

			epsg=(long)3857;
			featureCoordSys.setID(epsg);
			filterCoordSys.setID(epsg);
			datumTransformation="GEOGTRAN[\"CGT_MM_WGS84\",GEOGCS[\"GCS_Monte_Mario\",DATUM[\"D_Monte_Mario\",SPHEROID[\"International_1924\",6378388.0,297.0]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],GEOGCS[\"GCS_WGS_1984\",DATUM[\"D_WGS_1984\",SPHEROID[\"WGS_1984\",6378137.0,298.257223563]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],METHOD[\"NTv2\"],PARAMETER[\""+cartellaGrigliato+"/"+grigliatoMM_ETRS89+"\",0.0]]";

		}

		featureCoordSys.setDatumTransformString(datumTransformation);
		coordsys.setDatumTransformString(datumTransformation);
		
		map.setFeatureCoordSys(featureCoordSys);
		map.setFilterCoordSys(filterCoordSys);


		AcetateLayer nostroAcetate = new AcetateLayer("2","1:1000", "1:2000000");
		
		if(!extractBbox.equals("")){

			String[] arrBBoxExtract = extractBbox.split(",");

			Double xMinExtract = null;
			Double yMinExtract = null;
			Double xMaxExtract = null;
			Double yMaxExtract = null;
			
			if (arrBBoxExtract.length >= 1) {
				xMinExtract = Double.valueOf(arrBBoxExtract[0]);
			}
			if (arrBBoxExtract.length >= 2) {
				yMinExtract = Double.valueOf(arrBBoxExtract[1]);
			}
			if (arrBBoxExtract.length >= 3) {
				xMaxExtract = Double.valueOf(arrBBoxExtract[2]);
			}
			if (arrBBoxExtract.length >= 4) {
				yMaxExtract = Double.valueOf(arrBBoxExtract[3]);
			}

			Acetate acetate = new Acetate();
			com.esri.aims.mtier.model.acetate.Polygon extractBox = new com.esri.aims.mtier.model.acetate.Polygon();
			Ring ring = new Ring();
			
			
			Points points = new Points();
			
			com.esri.aims.mtier.model.acetate.Point pnt1 = new com.esri.aims.mtier.model.acetate.Point();
			pnt1.setX(xMinExtract);
			pnt1.setY(yMinExtract);
			points.addPointObject(pnt1);

			com.esri.aims.mtier.model.acetate.Point pnt2 = new com.esri.aims.mtier.model.acetate.Point();
			pnt2.setX(xMinExtract);
			pnt2.setY(yMaxExtract);
			points.addPointObject(pnt2);

			com.esri.aims.mtier.model.acetate.Point pnt3 = new com.esri.aims.mtier.model.acetate.Point();
			pnt3.setX(xMaxExtract);
			pnt3.setY(yMaxExtract);
			points.addPointObject(pnt3);

			com.esri.aims.mtier.model.acetate.Point pnt4 = new com.esri.aims.mtier.model.acetate.Point();
			pnt4.setX(xMaxExtract);
			pnt4.setY(yMinExtract);
			points.addPointObject(pnt4);

			ring.setPoints(points);
			extractBox.addRing(ring);

			SimplePolygonSymbol simplePolygon = new SimplePolygonSymbol();
			simplePolygon.setFillTransparency(0.0);
			simplePolygon.setBoundaryColor("255,60,60");
			simplePolygon.setBoundaryWidth(2);
			extractBox.setSymbol(simplePolygon);
			
			acetate.setAcetateElement(extractBox);
			
			//nostroAcetate.setCoordSys(coordsys);

			nostroAcetate.addAcetate(acetate);

		}		
		
		
		if(serviceName.equals("")){

			SDEWorkspace sdeWSP = new SDEWorkspace();
			sdeWSP.setName("workspace3");
			sdeWSP.setInstance("port:"+portaSDE);
			
			sdeWSP.setServer(nomeServer);
			sdeWSP.setUser(connUser);
			sdeWSP.setPassword(connPw);
			
			map.addWorkspace(sdeWSP);
			
			Dataset data = new Dataset();
			
			if (type.equals("line")){ 
				data.setName(layer);
				data.setWorkspaceName(sdeWSP.getName());	
				FeatureLayer fl = new FeatureLayer(String.valueOf(map.getLayers().getCount()), null, null);
				data.setType("line");
				fl.setDataset(data);
				fl.setName("sdeLINE");
				fl.setVisible(true);
				SimpleRenderer sr = new SimpleRenderer(); 
				SimpleLineSymbol sls = new SimpleLineSymbol();
				
				if(!expression.equals("")){

					com.esri.aims.mtier.model.map.layer.query.Filter filter = new com.esri.aims.mtier.model.map.layer.query.Filter();
					String subField=expression.split("=")[0];
					filter.addSubField(subField);
					//filter.setWhereExpression(expression);
					filter.setWhereExpression("upper("+expression.split("=")[0]+")"+"="+"upper('"+expression.split("=")[1]+"')");
					fl.setFilterObject(filter);	
					
					sls.setColor("255,255,0");
					sls.setLineType(sls.SOLID);
					sls.setWidth(2);
				
				} else {
				
					sls.setColor("0,102,153");
					sls.setLineType(sls.SOLID);
					sls.setWidth(2);

				}
				sr.setSymbol(sls);
				fl.setRenderer(sr);
				
				fl.setCoordSys(coordsys);
				
				map.getLayers().add(fl);
			}
			else if  (type.equals("polygon")){
				data.setName(layer);
				data.setWorkspaceName(sdeWSP.getName());	
				FeatureLayer fl = new FeatureLayer(String.valueOf(map.getLayers().getCount()), null, null);
				data.setType("polygon");
				fl.setDataset(data);
				fl.setName("sdePOLYGON");
				fl.setVisible(true);
				
				SimpleRenderer sr = new SimpleRenderer(); 
				SimplePolygonSymbol sps = new SimplePolygonSymbol();
				
				if(!expression.equals("")){
					com.esri.aims.mtier.model.map.layer.query.Filter filter = new com.esri.aims.mtier.model.map.layer.query.Filter();
					String subField=expression.split("=")[0];
					filter.addSubField(subField);
					//filter.setWhereExpression(expression);
					filter.setWhereExpression("upper("+expression.split("=")[0]+")"+"="+"upper('"+expression.split("=")[1]+"')");
					fl.setFilterObject(filter);	
					
					log.info("MARUCCI"+filter.getWhereExpression());
					
					sps.setFillType(sps.SOLID);
					sps.setFillTransparency(0);
					sps.setBoundaryColor("255,255,0");
					sps.setBoundaryWidth(3);
				
				} else {
				
					sps.setFillColor("123,123,123");
					sps.setBoundaryColor("0,0,153");
					sps.setBoundaryWidth(2);
					sps.setFillType(sps.FDIAGONAL);
					sps.setFillInterval(8);
					sps.setFillTransparency(1.0);
				
				}
				
				sr.setSymbol(sps);
				fl.setRenderer(sr);
				
				fl.setCoordSys(coordsys);

				map.getLayers().add(fl);

			
			}
			else if  (type.equals("point")){
				data.setName(layer);
				data.setWorkspaceName(sdeWSP.getName());	
				FeatureLayer fl = new FeatureLayer(String.valueOf(map.getLayers().getCount()), null, null);
				data.setType("point");
				fl.setDataset(data);
				fl.setName("sdePOINT");
				fl.setVisible(true);
				SimpleRenderer sr = new SimpleRenderer(); 
				SimpleMarkerSymbol sms = new SimpleMarkerSymbol();
				
				if(!expression.equals("")){

					com.esri.aims.mtier.model.map.layer.query.Filter filter = new com.esri.aims.mtier.model.map.layer.query.Filter();
					String subField=expression.split("=")[0];
					filter.addSubField(subField);
					//filter.setWhereExpression(expression);
					filter.setWhereExpression("upper("+expression.split("=")[0]+")"+"="+"upper('"+expression.split("=")[1]+"')");
					fl.setFilterObject(filter);	
					log.info(layer+"upper("+expression.split("=")[0]+")"+"="+"upper('"+expression.split("=")[1]+"')");
					sms.setColor("255,255,0");
					sms.setMarkerType("CIRCLE");
					sms.setWidth(10);		
					sms.setTransparency(1.0);
				
				} else {

					sms.setColor("0,153,0");
					sms.setMarkerType("circle");
					sms.setWidth(10);		
					sms.setTransparency(1.0);
				
				}
				sr.setSymbol(sms);
				fl.setRenderer(sr);

				fl.setCoordSys(coordsys);
				
				map.getLayers().add(fl);
			}
			// modifica marucci_f 27/11/2007
			else if  (type.equals("raster")){
				
				data.setName(layer+".RASTER");
				data.setWorkspaceName(sdeWSP.getName());	
				
				data.setType("image");

				ImageLayer imgLayer = new ImageLayer(String.valueOf(map.getLayers().getCount()), null, null);
				imgLayer.setDataset(data);

				imgLayer.setName("sdeIMAGE");

				imgLayer.setVisible(true);
				
				imgLayer.setCoordSys(coordsys);
				
				map.getLayers().add(imgLayer);

			}
			/* 
			TENTATIVO (FALLITO) DI INSERIRE IL RADEX QUI DENTRO con le API dell'aims (21/08/2009) con geotools si riesce (25/08):

			WmsMap wms=new WmsMap();
			wms.initMap("http://10.10.64.223/?VERSION=1.1.1&SERVICE=WMS&");
			
			WmsLayers wmsLayers=new WmsLayers();
			
			WmsLayer wmsLayer=new WmsLayer();
			wmsLayer.setName("158_UTMA_ORTOAGEA2008");
			wmsLayer.setSRS("EPSG%3ANONE");
			
			com.esri.aims.mtier.model.wmsmap.Envelope wmsenvel = new com.esri.aims.mtier.model.wmsmap.Envelope();

			wmsenvel.setMinX(xMin);
			wmsenvel.setMinY(yMin);
			wmsenvel.setMaxX(xMax);
			wmsenvel.setMinY(yMax);
			
			wmsLayers.add(wmsLayer);
			
			wms.setLayers(wmsLayers);

			wms.setHeight(Long.valueOf(height));
			wms.setWidth(Long.valueOf(width));
			
			wms.doZoomToExtent(wmsenvel);
			
			map.getLayers().add(wms);
			*/
		
		} else {
			if(!expression.equals("")){
				
				
				
				
				// FILTRA TUTTI I LAYER con EXPRESSION
				FeatureLayer layerFiltrato = null;
				for (int i=0;i<map.getLayers().getCount();i++) {
					if (map.getLayers().item(i).getName().equalsIgnoreCase(layer)){
						layerFiltrato = (FeatureLayer) map.getLayers().item(i);
						
						FeatureLayer pointsLayer = (FeatureLayer)layerFiltrato;
						com.esri.aims.mtier.model.map.layer.query.Filter filter = new com.esri.aims.mtier.model.map.layer.query.Filter();						
						filter.setWhereExpression("upper("+expression.split("=")[0].toUpperCase()+")"+"="+"upper('"+expression.split("=")[1]+"')");
						pointsLayer.setFilterObject(filter);
						map.refresh();
						
						//break;
					}
				}
				
				/*
				if(layerFiltrato!=null){
					FeatureLayer pointsLayer = layerFiltrato;
					com.esri.aims.mtier.model.map.layer.query.Filter filter = new com.esri.aims.mtier.model.map.layer.query.Filter();
					
					log.info("MARUCCI"+"upper("+expression.split("=")[0]+")"+"="+"upper('"+expression.split("=")[1]+"')");

					//filter.setWhereExpression("gisid=5200");
					
					filter.setWhereExpression("upper("+expression.split("=")[0]+")"+"="+"upper('"+expression.split("=")[1]+"')");
					pointsLayer.setFilterObject(filter);
					

				}	*/				
				

			}
		}




		/*
		
		// SCALEBAR
		AcetateLayer scalebarLayerAcetate = new AcetateLayer("3","1:1000", "1:2000000");

		Acetate scalebarAcetate = new Acetate();
		scalebarAcetate.setUnits("acetate.PIXEL");

		com.esri.aims.mtier.model.acetate.ScaleBar scalebar= new com.esri.aims.mtier.model.acetate.ScaleBar();
		scalebar.setID("ScaleBar-1");
		//scalebar.setType(scalebar.METERS);

		scalebar.setBarColor("200,200,200");
		scalebar.setX(50.0);
		scalebar.setY(50.0);
		scalebar.setBarWidth(15);

		//scalebar.setBarTransparency(0.5);
		//scalebar.setTextTransparency(0.5);
		scalebar.setAntialiasing(true);
		scalebar.setFont("Arial");
		scalebar.setFontSize(15);
		scalebar.setFontColor("200,0,0");
		scalebar.setFontStyle(scalebar.BOLD);

		scalebar.setDistance(100.0);
		scalebar.setScreenLength(304);
		scalebar.setPrecision(20);
		scalebar.setMapUnits(scalebar.METERS);
		scalebar.setScaleUnits(scalebar.METERS);
		//scalebar.setRound(25.0);
		scalebar.setMode(scalebar.CARTESIAN);
		scalebar.setOverlap(false);
		scalebar.setOutline("200,0,0");

		scalebarAcetate.setAcetateElement(scalebar);
		scalebarLayerAcetate.addAcetate(scalebarAcetate);
		
		map.getLayers().add(scalebarLayerAcetate);
		// SCALEBAR

		// BACKGORUND
		AcetateLayer bgScalebarLayerAcetate = new AcetateLayer("4","1:1000", "1:2000000");

		Acetate bgScalebarAcetate = new Acetate();
		bgScalebarAcetate.setUnits("acetate.PIXEL");

		com.esri.aims.mtier.model.acetate.Polygon bgScalebar = new com.esri.aims.mtier.model.acetate.Polygon();
		Ring ring1 = new Ring();
		
		Points points1 = new Points();
		
		com.esri.aims.mtier.model.acetate.Point pnt1 = new com.esri.aims.mtier.model.acetate.Point();
		pnt1.setX(50.0);
		pnt1.setY(50.0);
		points1.addPointObject(pnt1);

		com.esri.aims.mtier.model.acetate.Point pnt2 = new com.esri.aims.mtier.model.acetate.Point();
		pnt2.setX(50.0);
		pnt2.setY(100.0);
		points1.addPointObject(pnt2);

		com.esri.aims.mtier.model.acetate.Point pnt3 = new com.esri.aims.mtier.model.acetate.Point();
		pnt3.setX(100.0);
		pnt3.setY(100.0);
		points1.addPointObject(pnt3);

		com.esri.aims.mtier.model.acetate.Point pnt4 = new com.esri.aims.mtier.model.acetate.Point();
		pnt4.setX(100.0);
		pnt4.setY(50.0);
		points1.addPointObject(pnt4);

		ring1.setPoints(points1);
		bgScalebar.addRing(ring1);

		SimplePolygonSymbol simplePolygon = new SimplePolygonSymbol();
		simplePolygon.setFillTransparency(1.0);
		simplePolygon.setBoundaryTransparency(0.0);
		simplePolygon.setFillColor("255,255,255");
		simplePolygon.setBoundaryWidth(0);
		bgScalebar.setSymbol(simplePolygon);
		
		bgScalebarAcetate.setAcetateElement(bgScalebar);
		bgScalebarLayerAcetate.addAcetate(bgScalebarAcetate);
		
		map.getLayers().add(bgScalebarLayerAcetate);
		// BACKGORUND
*/
		
		if(!extractBbox.equals(""))
			map.getLayers().add(nostroAcetate);

					map.sendImageRequest();
		map.refresh();

		BufferedImage img = null;
		try {
			URL url = new URL(map.getMapOutput().getURL());
			img = ImageIO.read(url);
		} catch (IOException e) {
			throw new Exception(e.getMessage());
		}
		
		//URL url1 = new URL("http://geo.regione.emilia-romagna.it/catalogo_web_new/images/logo_sgss.gif");
		//Image imgLogo = ImageIO.read(url1);

		//Graphics g=img.getGraphics();
		//g.drawImage(imgLogo,150,Integer.parseInt(height)-35, null);
		//g.drawString("Servizio Geologico, Sismico e dei Suoli",185,Integer.parseInt(height)-5);
		//g.dispose();

		//URL url1 = new URL("http://10.10.80.37/geologico/geocatalogo/images/icon.png");
		//Image imgLogo = ImageIO.read(url1);

		//Graphics g=img.getGraphics();
		//g.drawImage(imgLogo,150,Integer.parseInt(height)-35, null);
		//g.drawString("Servizio Geologico, Sismico e dei Suoli",185,Integer.parseInt(height)-5);
		//g.dispose();		
		
		
		try {
			response.setContentType("image/png");
			OutputStream os = response.getOutputStream();
			ImageIO.write(img, "png", os);
			os.close();
			img=null;
			
			long dateFin15 = new java.util.Date().getTime();
			textLog+="getMap: "+((double)(dateFin15-dateIni15)/1000)+" sec."+"\t";

			if(debug)	
				log.info("IP: "+request.getRemoteAddr() + "\t" + "Layer: " + layerParam + "\t" + textLog);
			
			
			/*SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy (HH:mm:ss.S)");
			
			PrintWriter pw = new PrintWriter(new FileWriter(new File(pathLog), true));
			pw.println(sdf.format(new java.util.Date())+ "\t" + "IP: "+request.getRemoteAddr() + "\t" + "Layer: " + layerParam + "\t" + textLog);
			pw.close();
			*/
		} catch (Exception eimage) {
			throw new Exception(eimage.getMessage());
		}


/*
out.println(coordsys.getString());
*/	} catch (Exception e) {
		String strEr = "è troppo complesso per questo livello di scala, avvicinare la mappa (zoom in)";
		if (e.getMessage()!=null)
			strEr+=": "+e.getMessage()+".";

		throw new Exception(strEr);
		
	}
	
} catch(Exception ee) {

	BufferedImage img = new BufferedImage(Integer.parseInt(width),Integer.parseInt(height), BufferedImage.TYPE_INT_ARGB);
	Graphics2D g = img.createGraphics();
	Color transparent = new Color(0, 0, 0, 0);
	g.setColor(transparent);
	g.setComposite(AlphaComposite.Src);
	
	g.fillRoundRect(0,0,Integer.parseInt(width),Integer.parseInt(height),0,0);
	g.setColor(Color.BLACK);
	Font font4 = new Font("SansSerif", Font.PLAIN,  11);
	g.setFont(font4);
	g.drawString("Livello cartografico \""+layerName+"\" momentaneamente non disponibile:",50,10);
	if(ee.getMessage()!=null)
		g.drawString(ee.getMessage(),55,25);
	
	response.setContentType("image/png");
	OutputStream os = response.getOutputStream();
	ImageIO.write(img, "png", os);
	os.close();
	
	log.error("Errore getMap.jsp: "+ layerName +" ---> "+ee.getMessage());

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	if(dbConnCAT!=null)
		dbConnCAT.close();

}%>