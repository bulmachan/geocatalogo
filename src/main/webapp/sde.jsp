<%@ page 
	language="java" 
	contentType="text/html; charset=iso-8859-1" 
	pageEncoding="ISO8859-1"
	import =	"java.io.*,
				org.w3c.dom.*,
				org.apache.xerces.dom.DocumentImpl,
				org.apache.xml.serialize.*,
				java.sql.*,
				java.net.*,
				java.util.*,
				org.geotools.ows.ServiceException,
				org.geotools.data.ResourceInfo,
				org.geotools.data.wms.*,
				org.geotools.data.ows.*,
				org.geotools.arcsde.*,
				org.geotools.arcsde.session.ArcSDEConnectionPool.*,

				org.opengis.metadata.citation.*,
				java.io.IOException,
				java.net.URL,
				java.text.DecimalFormat,
				java.util.Map,
				java.util.Map.Entry,
		com.esri.sde.sdk.client.*
		, com.esri.*
		, java.text.SimpleDateFormat
		, java.io.*
		, java.util.*
		, java.sql.*
		, org.geotools.data.*
		, org.opengis.feature.*
		, org.opengis.geometry.*
		, org.geotools.data.DataStore
		, org.geotools.data.DataStoreFinder
		, org.geotools.data.DataStoreFactorySpi
		, org.apache.commons.pool.*
		, org.geotools.feature.* 

		"
				
%><%@ include file="configESRI.jsp"
%><%

	String tabella="BASE_USER.BASE_F_COMUNI_POL";
	String[] colonne=new String[2];
	colonne[0]="SHAPE"; 		// CAMPO SHAPE
	colonne[1]="GISID"; 		// CAMPO ID
	//colonne[2]="NOME"; 		// CAMPO ID
out.println("pollO");



	Map<String, Object> params = new HashMap<String, Object>();
	params.put("dbtype", "arcsde");
	params.put("server", nomeServer);
	params.put("port", portaSDE);
	params.put("database", "");  // this was OK as blank in my example
	params.put("user", connUser);
	params.put("password", connPw);


	DataStore dataStore = DataStoreFinder.getDataStore(params);



            org.geotools.arcsde.session.ArcSDEConnectionPool pool = dataStore.getConnectionPool();
            int initialAvailableCount = pool.getAvailableCount();
            int initialPoolSize = pool.getPoolSize();

			out.print(initialAvailableCount+ " --- "+initialPoolSize);
 







	String[] typeNames = dataStore.getTypeNames();
	String typeName = typeNames[0];

	out.println("Reading content " + typeName);


/*
	FeatureSource featureSource = dataStore.getFeatureSource(typeName);
	FeatureCollection collection = featureSource.getFeatures();
	FeatureIterator iterator = collection.features();
	int length = 0;
	try {
			while (iterator.hasNext()) {
					Feature feature = iterator.next();
					Geometry geometry = feature.getDefaultGeometry();
					length += geometry.getLength();
			}
	} finally {
			iterator.close();
	}
	out.println("Total length " + length);

*/




	/*SeConnection connSDE=new SeConnection(nomeServer, portaSDE, null, connUser, connPw);

	SeLayer layerSDE = new SeLayer(connSDE, typeName, "SHAPE");
	out.println(layerSDE.getQualifiedName());





	SeSqlConstruct sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName(), "1=1");
	SeQuery query = new SeQuery( connSDE, colonne, sqlConstruct );
	query.prepareQuery();
	query.execute();


	SeRow riga = query.fetch();

	int kkk=0;
	String temp="";
	while(riga != null){
				
		short nCampo;
		for (nCampo = 0; nCampo < 2; nCampo++) {

			temp=riga.getObject(nCampo).toString();
			out.println(temp+"<br />");
		}
			
		riga = query.fetch();
		kkk++;
	} 				

	query.close();

	connSDE.close();*/

%>