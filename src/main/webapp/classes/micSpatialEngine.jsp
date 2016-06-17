<%@ page
	import="
		com.esri.sde.sdk.client.*
		, com.esri.*
		, java.text.SimpleDateFormat
		, java.io.*
		, java.util.*
		, java.sql.*
		"
%><%
class micSpatialEngine {
	
	public String nomeServer = "";
	public int portaSDE = 5151;
	public String nomeDB = "";
	public String connUN = "";
	public String connPW = "";
	public String instance = "";
	
	private SeConnection connSDE = null; // connessione SDE
	private String statusReport = ""; // report
	private SeRow riga; // riga recuperata
	private SeShape objShape; // shape (feature) recuperata
	private SeColumnDefinition[] defColonne; // definizione delle colonne
	private short numeroColonne; // numero delle colonne recuperate
	private String extent;
	
	// constants
	public double MajorAxis = 6378137.0;
	public double MinorAxis = 6356752.3;
	public double Ecc = (MajorAxis * MajorAxis - MinorAxis * MinorAxis) / (MajorAxis * MajorAxis);
	public double Ecc2 = Ecc / (1.0 - Ecc);
	public double K0 = 0.9996;
	public double E4 = Ecc * Ecc;
	public double E6 = Ecc * E4;
	public double degrees2radians = Math.PI / 180.0;
	
	public SeRow getRiga() {
		return(this.riga);
	}
	
	public SeColumnDefinition[] getDefColonne() {
		return(this.defColonne);
	}
	
	public short getNumeroColonne() {
		return(this.numeroColonne);
	}
	
	public SeConnection getConnSDE() {
		return(this.connSDE);
	}
	
	public String getReport() {
		return(this.statusReport);
	}
	
	public boolean apriConnSDE () {
		boolean Errore = false;
		
		try {
			this.connSDE = new SeConnection(this.nomeServer, this.portaSDE, this.nomeDB, this.connUN, this.connPW);
			this.statusReport =("Connessione aperta<br>");
			this.statusReport = this.nomeServer+" . "+this.portaSDE+" . "+this.nomeDB+" . "+this.connUN+" . "+this.connPW;
		} catch (SeException e) {
			try {
				this.connSDE = new SeConnection(this.nomeServer, this.instance, this.nomeDB, this.connUN, this.connPW);
				this.statusReport =("Connessione aperta<br>");
			} catch (Exception ee) {
				ee.printStackTrace();
				this.statusReport =("FALLITA apertura di connessione<br>");
				this.statusReport +=(ee);
				Errore = true;
			} //try
			
		} //try
		

		return (!Errore);
	}
	
	public boolean chiudiConnSDE () {
		boolean Errore = false;
		
		try {
			if (this.connSDE != null) {
				connSDE.close();
			}
			this.connSDE = null;
			this.statusReport =("Connessione chiusa<br>");
		} catch (SeException e) {
			e.printStackTrace();
			this.statusReport =("FALLITA chiusura di connessione<br>");
			this.statusReport +=(e);
			Errore = true;
		} //try
		
		return (!Errore);
	}
	
	public micSpatialEngine (String connUN, String connPW, String nomeServer, int portaSDE, String nomeDB) {
		this.connUN = connUN;
		this.connPW = connPW;
		this.nomeServer = nomeServer;
		this.portaSDE = portaSDE;
		this.nomeDB = nomeDB;
	}
	
	public micSpatialEngine (String connUN, String connPW, String nomeServer, int portaSDE) {
		this.connUN = connUN;
		this.connPW = connPW;
		this.nomeServer = nomeServer;
		this.portaSDE = portaSDE;
	}
	
	public micSpatialEngine (String connUN, String connPW, String nomeServer, String instance) {
		this.connUN = connUN;
		this.connPW = connPW;
		this.nomeServer = nomeServer;
		this.instance = instance;
	}

	public micSpatialEngine (String connUN, String connPW, String nomeServer) {
		this.connUN = connUN;
		this.connPW = connPW;
		this.nomeServer = nomeServer;
	}
	
	

	
	// NUOVA FUNZIONE 31/08/2009
	public String trovaElementoPerPuntoHTML (double xPoint, double yPoint, String tabella, double searchTol, String srs) {
        
      try{
		
		SeLayer layer = new SeLayer(this.connSDE, tabella, "SHAPE");
		
		SeTable table = new SeTable(this.connSDE, layer.getQualifiedName()); 
		SeColumnDefinition[] tableDef = table.describe();

		String[] cols = new String[tableDef.length];
		for( int i =0 ; i < tableDef.length ; i++ )
			cols[i] = tableDef[i].getName();            
		
		return (trovaElementoPerPuntoHTML (xPoint, yPoint, tabella, searchTol, srs, cols));
      
	  } catch (SeException ce) {
          SeError err = ce.getSeError();
          return (err.getErrDesc()+ " - "+ err.getSdeErrMsg());
      }    

	}
	
	public String trovaElementoPerPuntoHTML (double xPoint, double yPoint, String tabella, double searchTol, String srs, String[] colonne) {
		return (trovaElementoPerPuntoHTML (xPoint, yPoint, tabella, searchTol, srs, colonne, "SHAPE"));
	}
	
	public String trovaElementoPerPuntoHTML (double xPoint, double yPoint, String tabella, double searchTol, String srs, String[] colonne, String spatCol) {
		String result="";
		//this.statusReport +=("<b><i>Dimensione Array:</i></b> "+colonne.array.lenght+"<br>");
		this.statusReport =("");
		this.autoConnSDE();
		
		try {
		// genera il puntatore al layer SDE
			SeLayer layerSDE = new SeLayer(this.connSDE, tabella, spatCol);

			double[] coordArray=new double[2];
			coordArray[0]=xPoint;
			coordArray[1]=yPoint;

		// trasforma il punto
			if(srs.equals("EPSG:4326") || srs.equals("EPSG:4258")){
				coordArray=trasformaPunto(xPoint,yPoint, "WGS84LL-ED50A");
			}
			if(srs.equals("EPSG:32632") || srs.equals("EPSG:25832")){
				coordArray=trasformaPunto(xPoint,yPoint, "WGS84-ED50A");
			}
			if(srs.equals("EPSG:23032")){
				coordArray[1]=yPoint-4000000;
			}

		// genera un punto
			int nPunti = 1;
			SDEPoint[] ptArray = new SDEPoint[nPunti];
			ptArray[0] = new SDEPoint(coordArray[0],coordArray[1]);

			SeShape Punto = new SeShape(layerSDE.getCoordRef());
			Punto.generatePoint(nPunti, ptArray); 
            SeShape bufferPunto = Punto.generateBuffer(searchTol,1000);                              
			
		// genera un filtro tra punto e layer SDE
			SeShapeFilter Filtri[] = new SeShapeFilter[1];
			SeShapeFilter Filtro = new SeShapeFilter(tabella, layerSDE.getSpatialColumn(), bufferPunto, SeFilter.METHOD_II_OR_ET);
			Filtri[0] = Filtro;
			
		// genera la query che applica il filtro
			SeSqlConstruct sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName() );
			SeQuery query = new SeQuery( connSDE, colonne, sqlConstruct );
			
		// applica la query
			query.prepareQuery();
			// ottimizza il filtro sulla colonna spaziale
			query.setSpatialConstraints(SeQuery.SE_OPTIMIZE, false,	Filtri);
			query.execute();
			
		// --------------[ genera REPORT ]---------------
			this.statusReport +=("<b>..:: Report sui risultati ::..</b><br>");
		    this.statusReport +=("<b><i>Colonna spaziale:</i></b> "+layerSDE.getSpatialColumn()+"<br>");
		    this.statusReport +=("<b><i>Handle alla SQL:</i></b> "+sqlConstruct+"<br>");
			
			SeRow row = query.fetch();
			SeColumnDefinition colDef = new SeColumnDefinition();
			int numCols = 0;
			try {
				numCols = row.getNumColumns();
			} catch ( NullPointerException ne ) {                                
				query.close();
					result += "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
					result += "<FeatureInfoResponse>";
					result += "</FeatureInfoResponse>";
				return result;
			}

			
			result += "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
			result += "<FeatureInfoResponse>";
			result += "<FIELDS ";

			for( int i = 0 ; i < numCols ; i++ ) {

				colDef = row.getColumnDef(i);
				int type = colDef.getType();
				if(!colDef.getName().equalsIgnoreCase("SHAPE") && !colDef.getName().equalsIgnoreCase("OBJECTID") ) 

					switch( type ) {
						case SeColumnDefinition.TYPE_SMALLINT:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>" + row.getShort(i)+"<br />";
						result += colDef.getName() + "=\"" + row.getShort(i) + "\" ";
						break;                       

						case SeColumnDefinition.TYPE_DATE:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>" + row.getDate(i)+"<br />";
						result += colDef.getName() + "=\"" + row.getDate(i) + "\" ";
						break;                            

						case SeColumnDefinition.TYPE_INTEGER:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>" + row.getInteger(i)+"<br />";
						result += colDef.getName() + "=\"" + row.getInteger(i) + "\" ";
						break;                           

						case SeColumnDefinition.TYPE_FLOAT:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>" + row.getFloat(i)+"<br />";
						result += colDef.getName() + "=\"" + row.getFloat(i) + "\" ";
						break;

						case SeColumnDefinition.TYPE_DOUBLE:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>" + row.getDouble(i)+"<br />";
						result += colDef.getName() + "=\"" + row.getDouble(i) + "\" ";
						break;

						case SeColumnDefinition.TYPE_STRING:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>" + row.getString(i)+"<br />";
						result += colDef.getName() + "=\"" + row.getString(i).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll("<", "&gt;") + "\" "; // ALTRIMENTI NON SI RIESCE A PARSARE l'XML
						break;

						case SeColumnDefinition.TYPE_NSTRING:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>" + row.getString(i)+"<br />";
						result += colDef.getName() + "=\"" + row.getString(i).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll("<", "&gt;") + "\" "; // ALTRIMENTI NON SI RIESCE A PARSARE l'XML
						break;

						case SeColumnDefinition.TYPE_SHAPE:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>"+"<br />";
						result += colDef.getName() + "=\"" + "\" ";
						SeShape spVal = (SeShape)row.getShape(i);
						break;                           
						
						/*case SeColumnDefinition.TYPE_NCLOB:

							try{
								java.io.ByteArrayInputStream bbb = (ByteArrayInputStream)row.getClob(i);
								
								Reader r = new InputStreamReader(bbb);   
								StringWriter sw = new StringWriter();   
								char[] buffer = new char[1024];   
								for (int n; (n = r.read(buffer)) != -1; )   
									sw.write(buffer, 0, n);   
							
								result += colDef.getName() + "=\"" + sw.toString() + "\" ";							
							
							}catch(Exception ex){
								result += colDef.getName() + "=\"" + ex.getMessage() + "\" ";	
								this.statusReport +=colDef.getName() + " errore: "+ex.getMessage();
							}
						break;*/

						default:
						//result += "&nbsp;&nbsp;<b>" + colDef.getName() + ": </b>" + "Unknown Type"+"<br />";
						result += colDef.getName() + "=\"" + "Unknown Type" + "\" ";
						break;

					} // End switch(type)

			} // End for 

			result += "/>";
			result += "</FeatureInfoResponse>";	
	
		} catch (SeException e) {
	        e.printStackTrace();
			this.statusReport +=(e);
			this.statusReport +=(e.getSeError().getErrDesc());
	    } //try
	    
	    return (result);
	}



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public Object[] trovaElementoPerPunto (double xPoint, double yPoint, String tabella, String[] colonne) {
		return (trovaElementoPerPunto (xPoint, yPoint, tabella, colonne, "SHAPE"));
	}
	
	public Object[] trovaElementoPerPunto (double xPoint, double yPoint, String tabella, String[] colonne, String spatCol) {
		Object[] risultato=new Object[colonne.length];
		//this.statusReport +=("<b><i>Dimensione Array:</i></b> "+colonne.array.lenght+"<br>");
		this.statusReport =("");
		this.autoConnSDE();
		
		try {
		// genera il puntatore al layer SDE
			SeLayer layerSDE = new SeLayer(this.connSDE, tabella, spatCol);
		
		// genera un punto
			int nPunti = 1;
			SDEPoint[] ptArray = new SDEPoint[nPunti];
			ptArray[0] = new SDEPoint(xPoint,yPoint);
			SeShape Punto = new SeShape(layerSDE.getCoordRef());
			Punto.generatePoint(nPunti, ptArray); 
			
		// genera un filtro tra punto e layer SDE
			SeShapeFilter Filtri[] = new SeShapeFilter[1];
			SeShapeFilter Filtro = new SeShapeFilter(tabella, layerSDE.getSpatialColumn(), Punto, SeFilter.METHOD_II_OR_ET);
			Filtri[0] = Filtro;
			
		// genera la query che applica il filtro
			SeSqlConstruct sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName() );
			SeQuery query = new SeQuery( connSDE, colonne, sqlConstruct );
			
		// applica la query
			query.prepareQuery();
			// ottimizza il filtro sulla colonna spaziale
			query.setSpatialConstraints(SeQuery.SE_OPTIMIZE, false,	Filtri);
			query.execute();
			
		// --------------[ genera REPORT ]---------------
			this.statusReport +=("<b>..:: Report sui risultati ::..</b><br>");
		    this.statusReport +=("<b><i>Colonna spaziale:</i></b> "+layerSDE.getSpatialColumn()+"<br>");
		    this.statusReport +=("<b><i>Handle alla SQL:</i></b> "+sqlConstruct+"<br>");
			
		// lettura del primo record recuperato
			if ((this.riga = query.fetch()) != null) {
				risultato = this.LeggiRiga(null);
			} //if
			query.close();
	    } catch (SeException e) {
	        e.printStackTrace();
			this.statusReport +=(e);
			this.statusReport +=(e.getSeError().getErrDesc());
	    } //try
	    
	    return (risultato);
	}
	

	public ArrayList trovaElementiPerShape (String tabella, String[] colonne) {
		return (trovaElementiPerShape (tabella, colonne, "SHAPE"));
	}
	
	public ArrayList trovaElementiPerShape (String tabella, String[] colonne, String spatCol) {
		Object[] risultato=new Object[colonne.length];
		ArrayList risultati=new ArrayList();
		//this.statusReport +=("<b><i>Dimensione Array:</i></b> "+colonne.array.lenght+"<br>");
		this.statusReport =("");
		this.autoConnSDE();
		
		if (this.objShape == null) {
			this.statusReport =("Nessun elemento disponibile<br>");
			return (null);
		} else {
			try {
				// genera il puntatore al layer SDE
					SeLayer layerSDE = new SeLayer(this.connSDE, tabella, spatCol);
					
					this.statusReport += layerSDE.getName()+": "+layerSDE.getCoordRef().getCoordSysDescription()+"<br />";
					this.statusReport += "falseX: "+String.valueOf(layerSDE.getCoordRef().getFalseX())+"<br />";
					this.statusReport += "falseY: "+String.valueOf(layerSDE.getCoordRef().getFalseY())+"<br />";
					this.statusReport += "xyUnits: "+String.valueOf(layerSDE.getCoordRef().getXYUnits())+"<br />";
					this.statusReport += "precision: "+String.valueOf(layerSDE.getCoordRef().getPrecision())+"<br />";
					this.statusReport += "srid: "+String.valueOf(layerSDE.getCoordRef().getSrid().longValue())+"<br />";
					this.statusReport += "envelope: "+String.valueOf(layerSDE.getCoordRef().getXYEnvelope())+"<br /><br />";
					
					
					//SeShape theShape=this.objShape;
					SeShape theShape=this.objShape.changeCoordRef(layerSDE.getCoordRef(),null);
					
					//SeCoordinateReference nCR=new SeCoordinateReference();
					//SeObjectId oSrid= new SeObjectId(23032);
					//nCR.setCoordSysByID(oSrid);
					//nCR.setCoordSysByDescription(layerSDE.getCoordRef().getCoordSysDescription());
					//nCR.setXY(layerSDE.getCoordRef().getFalseX(),layerSDE.getCoordRef().getFalseY(),layerSDE.getCoordRef().getXYUnits());
					//theShape.setCoordRef(nCR);
					
					//SeCoordRef nCR=new SeCoordRef();
					//nCR.setSrid(206);
					//theShape.changeCoordRef(nCR,null);
					
					this.statusReport += "SHAPE: "+theShape.getCoordRef().getCoordSysDescription()+"<br />";
					this.statusReport += "falseX: "+String.valueOf(theShape.getCoordRef().getFalseX())+"<br />";
					this.statusReport += "falseY: "+String.valueOf(theShape.getCoordRef().getFalseY())+"<br />";
					this.statusReport += "xyUnits: "+String.valueOf(theShape.getCoordRef().getXYUnits())+"<br />";
					this.statusReport += "precision: "+String.valueOf(theShape.getCoordRef().getPrecision())+"<br />";
					this.statusReport += "srid: "+String.valueOf(theShape.getCoordRef().getSrid().longValue())+"<br />";
					this.statusReport += "envelope: "+String.valueOf(theShape.getCoordRef().getXYEnvelope())+"<br /><br />";
				
				// genera un filtro tra punto e layer SDE
					SeShapeFilter Filtri[] = new SeShapeFilter[1];
					SeShapeFilter Filtro = new SeShapeFilter(tabella, layerSDE.getSpatialColumn(), theShape, SeFilter.METHOD_II_OR_ET);
					Filtri[0] = Filtro;
					
				// genera la query che applica il filtro
					SeSqlConstruct sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName() );
					SeQuery query = new SeQuery( connSDE, colonne, sqlConstruct );
					
				// applica la query
					query.prepareQuery();

					// ottimizza il filtro sulla colonna spaziale
					query.setSpatialConstraints(SeQuery.SE_SPATIAL_FIRST, false, Filtri);

					query.execute();
					
				// --------------[ genera REPORT ]---------------
					this.statusReport +=("<b>..:: Report sui risultati ::..</b><br>");
					this.statusReport +=("<b><i>Colonna spaziale:</i></b> "+layerSDE.getSpatialColumn()+"<br>");
					this.statusReport +=("<b><i>Handle alla SQL:</i></b> "+sqlConstruct+"<br>");
					
				// lettura del primo record recuperato
					//if ((this.riga = query.fetch()) != null) {
					//	risultato = this.LeggiRiga();
					//} //if
				
				// lettura tutti records
					this.riga = query.fetch();
					int i=0;
					while(this.riga != null){

						risultato=this.LeggiRiga(null);
						String[] ris=new String[colonne.length];
						for(int j=0; j<colonne.length; j++){
							ris[j]=(risultato[j].toString());
							//this.statusReport +="jj"+risultato[j].toString()+"kk";
						}
						risultati.add(ris);

						this.riga = query.fetch();
						i++;
					}
					
					query.close();
				} catch (SeException e) {
					e.printStackTrace();
					this.statusReport +="Errore: "+(e);
					this.statusReport +=(e.getSeError().getErrDesc());
				} //try
				
				return (risultati);
			}
	}	


	public int contaElementiPerBox (String tabella, double xMin, double yMin, double xMax, double yMax, SeConnection connSDE) {
		return (contaElementiPerBox (tabella, "SHAPE", xMin, yMin, xMax, yMax, connSDE));
	}

	public int contaElementiPerBox (String tabella, String spatCol, double xMin, double yMin, double xMax, double yMax, SeConnection connSDE) {
		this.statusReport =("");
		//this.autoConnSDE();
		int i=0;

		try {
			SeLayer layerSDE = new SeLayer(connSDE, tabella, spatCol);
		
		
			SeExtent seExt=new SeExtent(xMin, yMin, xMax, yMax);
			SeShape box = new SeShape(layerSDE.getCoordRef());
			box.generateRectangle(seExt); 
		
			// genera un filtro tra punto e layer SDE
			SeShapeFilter Filtri[] = new SeShapeFilter[1];
			SeShapeFilter Filtro = new SeShapeFilter(tabella, layerSDE.getSpatialColumn(), box, SeFilter.METHOD_II_OR_ET);
			Filtri[0] = Filtro;
			String[] colonne={"SHAPE"};
			
		// genera la query che applica il filtro
			SeSqlConstruct sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName() );
			SeQuery query = new SeQuery( connSDE, colonne, sqlConstruct );
			
		// applica la query
			query.prepareQuery();

		// ottimizza il filtro sulla colonna spaziale
			query.setSpatialConstraints(SeQuery.SE_SPATIAL_FIRST, false, Filtri);

			query.execute();

			this.riga = query.fetch();
			while(this.riga != null){
				i++;
				this.riga = query.fetch();
			}

			query.close();
			
		} catch (SeException e) {
			e.printStackTrace();
			this.statusReport +="Errore: "+(e);
			this.statusReport +=(e.getSeError().getErrDesc());
		} //try
		
		return (i);
	
	}
	public ArrayList getElementi (String tabella, String[] colonne, SeConnection connSDE) {
		return (getElementi (tabella, colonne, "SHAPE", connSDE));
	}
	
	public ArrayList getElementi (String tabella, String[] colonne, String spatCol, SeConnection connSDE) {
		Object[] risultato=new Object[colonne.length];
		ArrayList risultati=new ArrayList();
		try {
			SeLayer layerSDE = new SeLayer(connSDE, tabella, spatCol);
			
			// genera la query che applica il filtro
			SeSqlConstruct sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName(), "1=1");
			SeQuery query = new SeQuery( connSDE, colonne, sqlConstruct );

			// applica la query
			query.prepareQuery();
			query.execute();
			
			
			this.riga = query.fetch();

			int dataType = 0;
			if(this.riga != null){
				this.defColonne = this.riga.getColumns();
			}
			int kkk=1;
			//Long dateIni1 = new java.util.Date().getTime();
			while(this.riga != null){
				
				String[] ris=new String[colonne.length];
				
				short nCampo;
				short decimali;
				for (nCampo = 0; nCampo < colonne.length; nCampo++) {
					dataType = this.defColonne[nCampo].getType();
					decimali=this.defColonne[nCampo].getScale();

					if (dataType==SeColumnDefinition.TYPE_SHAPE){
						SeShape shape=this.riga.getShape(0);
						ris[0]=(shape.asText(1000000000));
					
					} else if (dataType==SeColumnDefinition.TYPE_INT32) {

						ris[nCampo]=this.riga.getInteger(nCampo).toString();
					
					} else if (dataType==SeColumnDefinition.TYPE_INT64) {

						ris[nCampo]=this.riga.getInteger(nCampo).toString();

					} else if (dataType==SeColumnDefinition.TYPE_STRING) {

						ris[nCampo]=this.riga.getString(nCampo).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll("<", "&gt;");
					
					} else if (dataType==SeColumnDefinition.TYPE_FLOAT64) {
						
						if (decimali==0)
							ris[nCampo]=Integer.toString(this.riga.getDouble(nCampo).intValue());
						else
							ris[nCampo]=this.riga.getDouble(nCampo).toString();
						
					} else {

						ris[nCampo]=this.riga.getObject(nCampo).toString();
					
					}
					
				}						
				risultati.add(ris);
				//System.out.println(kkk+" "+dataType);

				this.riga = query.fetch();
				kkk++;
			}
			query.close();
			
		} catch (SeException e) {
			e.printStackTrace();
			this.statusReport +="Errore: "+(e);
			this.statusReport +=(e.getSeError().getErrDesc());
		} //try
		
		return (risultati);
	}
	
	public ArrayList tagliaElementiPerBox (String tabella, String[] colonne, double xMin, double yMin, double xMax, double yMax, SeConnection connSDE) {
		return (tagliaElementiPerBox (tabella, colonne, "SHAPE", xMin, yMin, xMax, yMax, connSDE));
	}
	
	public ArrayList tagliaElementiPerBox (String tabella, String[] colonne, String spatCol, double xMin, double yMin, double xMax, double yMax, SeConnection connSDE) {
		Object[] risultato=new Object[colonne.length];
		ArrayList risultati=new ArrayList();
		//this.statusReport +=("<b><i>Dimensione Array:</i></b> "+colonne.array.lenght+"<br>");
		this.statusReport =("");
		try {
			
			//Long dateIni1 = new java.util.Date().getTime();
			//this.autoConnSDE();
		



			// genera il puntatore al layer SDE
				
			SeLayer layerSDE = new SeLayer(connSDE, tabella, spatCol);
				
				this.statusReport += layerSDE.getName()+": "+layerSDE.getCoordRef().getCoordSysDescription()+"<br />";
				this.statusReport += "falseX: "+String.valueOf(layerSDE.getCoordRef().getFalseX())+"<br />";
				this.statusReport += "falseY: "+String.valueOf(layerSDE.getCoordRef().getFalseY())+"<br />";
				this.statusReport += "xyUnits: "+String.valueOf(layerSDE.getCoordRef().getXYUnits())+"<br />";
				this.statusReport += "precision: "+String.valueOf(layerSDE.getCoordRef().getPrecision())+"<br />";
				this.statusReport += "srid: "+String.valueOf(layerSDE.getCoordRef().getSrid().longValue())+"<br />";
				this.statusReport += "envelope: "+String.valueOf(layerSDE.getCoordRef().getXYEnvelope())+"<br /><br />";
				
				SeExtent seExt=new SeExtent(xMin, yMin, xMax, yMax);
				SeShape box = new SeShape(layerSDE.getCoordRef());
				box.generateRectangle(seExt); 
			
			// genera un filtro tra punto e layer SDE
				SeShapeFilter Filtri[] = new SeShapeFilter[1];
				SeShapeFilter Filtro = new SeShapeFilter(tabella, layerSDE.getSpatialColumn(), box, SeFilter.METHOD_II_OR_ET);
				Filtri[0] = Filtro;
				
			// genera la query che applica il filtro
				SeSqlConstruct sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName() );
				SeQuery query = new SeQuery( connSDE, colonne, sqlConstruct );
				
			// applica la query
				query.prepareQuery();

				// ottimizza il filtro sulla colonna spaziale
				query.setSpatialConstraints(SeQuery.SE_SPATIAL_FIRST, false, Filtri);

				query.execute();
				
			// --------------[ genera REPORT ]---------------
				this.statusReport +=("<b>..:: Report sui risultati ::..</b><br>");
				this.statusReport +=("<b><i>Colonna spaziale:</i></b> "+layerSDE.getSpatialColumn()+"<br>");
				this.statusReport +=("<b><i>Handle alla SQL:</i></b> "+sqlConstruct+"<br>");
				
				SeShape shapeTemp=null;				
				this.riga = query.fetch();

				int dataType = 0;
				if(this.riga != null){
					this.defColonne = this.riga.getColumns();
				}
				int kkk=1;
				//Long dateIni1 = new java.util.Date().getTime();

				while(this.riga != null){
					
					String[] ris=new String[colonne.length];
					
					short nCampo;
					short decimali;
					//System.out.println(box.getExtent().toString());
					for (nCampo = 0; nCampo < colonne.length; nCampo++) {
						dataType = this.defColonne[nCampo].getType();
						decimali=this.defColonne[nCampo].getScale();

						if (dataType==SeColumnDefinition.TYPE_SHAPE){
							//System.out.println(this.riga.getShape(0).toString());
							SeShape shapeInter=null;
							ris[0]="POLYGON (( 0.0 0.0, 0.0 0.0, 0.0 0.0, 0.0 0.0))";
							try {
								SeShape poly=this.riga.getShape(0);
								if(!poly.isNil()){
									shapeInter=poly.clip(box.getExtent());
									if(shapeInter.getNumOfPoints()>0){
										shapeTemp=shapeInter;
										ris[0]=(shapeTemp.asText(1000000000));
									}
								}
							} catch(SeException sext){
								System.out.println("Errore clip: "+sext.getSeError().getErrDesc());
								//sext.printStackTrace();
								//System.out.println(sext.getLocalizedMessage());
							}
						
						} else if (dataType==SeColumnDefinition.TYPE_INT32) {

							ris[nCampo]=this.riga.getInteger(nCampo).toString();
						
						} else if (dataType==SeColumnDefinition.TYPE_INT64) {

							ris[nCampo]=this.riga.getInteger(nCampo).toString();

						} else if (dataType==SeColumnDefinition.TYPE_STRING) {

							ris[nCampo]=this.riga.getString(nCampo).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll("<", "&gt;");
						
						} else if (dataType==SeColumnDefinition.TYPE_FLOAT64) {
							
							if (decimali==0)
								ris[nCampo]=Integer.toString(this.riga.getDouble(nCampo).intValue());
							else
								ris[nCampo]=this.riga.getDouble(nCampo).toString();
								//System.out.println(ris[nCampo]);
						
						} else {

							ris[nCampo]=this.riga.getObject(nCampo).toString();
						
						}
						
					}						
					/*	
						SeShape shapeInter=this.riga.getShape(0).clip(box.getExtent());
						shapeTemp=shapeInter;
						ris[0]=(shapeTemp.asText(1000000000));

						ris[1]=this.riga.getShort(1).toString();
						
						ris[2]=this.riga.getString(2);
					*/

						risultati.add(ris);
						//System.out.println(kkk+" "+dataType);

					this.riga = query.fetch();
					kkk++;
				} 				
				//Long dateFin1 = new java.util.Date().getTime();
				//System.out.println("while: "+((double)(dateFin1-dateIni1)/1000)+" sec.");				
				
				
		

				
				
				
				// lettura del primo record recuperato
				//if ((this.riga = query.fetch()) != null) {
				//	risultato = this.LeggiRiga();
				//} //if
			
			// lettura tutti records
			//	this.riga = query.fetch();
			//	int i=0;
			//	while(this.riga != null){

			//		risultato=this.LeggiRiga(box);
			//		String[] ris=new String[colonne.length];
					
			//		for(int j=0; j<colonne.length; j++){
			//			ris[j]=(risultato[j].toString());
						//ris[j]=this.riga.getString(j);
						//this.statusReport +="jj"+risultato[j].toString()+"kk";
			//		}
					
			//		risultati.add(ris);

			//		this.riga = query.fetch();
			//		i++;
			//	}
				//this.statusReport +=("<b><i>Count SQL:</i></b> "+String.valueOf(i)+"<br>");				
				query.close();
				
				//Long dateFin1 = new java.util.Date().getTime();
				//System.out.println("while: "+((double)(dateFin1-dateIni1)/1000)+" sec.");				
			
		} catch (SeException e) {
			System.out.println("pollo");
				e.printStackTrace();
				this.statusReport +="Errore: "+(e);
				this.statusReport +=(e.getSeError().getErrDesc());
		} //try
			
			return (risultati);
	}	

	
	protected boolean autoConnSDE () {
		boolean Errore = true;
		if (connSDE == null) {
			if (apriConnSDE()) {
				this.statusReport =("Connessione aperta automaticamente<br>");
				Errore = false;
			} else {
				this.statusReport =("Fallito tentativo di aprire una connessione automaticamente<br>");
			} //if
		} //if
		
		return (!Errore);
	}
	
	public String stringaExtentLayer (String tabella) {
		return (stringaExtentLayer (tabella, "SHAPE"));
	}
	
	public String stringaExtentLayer (String tabella, String spatCol) {
		try {
			this.autoConnSDE();
			SeLayer layerSDE = new SeLayer(this.connSDE, tabella, spatCol);
			SeExtent extent = layerSDE.getExtent();
			return (extent.getMinX()+","+extent.getMinY()+","+extent.getMaxX()+","+extent.getMaxY());
	    } catch (SeException e) {
	        e.printStackTrace();
			this.statusReport +=("lll"+e);
			return ("");
	    } //try
	}
	
	public String stringaExtentElemento (SeShape objShape) {
		try {
			SeExtent extent = objShape.getExtent();
			return (extent.getMinX()+","+extent.getMinY()+","+extent.getMaxX()+","+extent.getMaxY());
	    } catch (SeException e) {
	        e.printStackTrace();
			this.statusReport +=(e);
			return ("");
	    } //try
	}
	
	public String stringaExtentElemento () {
		if (this.objShape == null) {
			this.statusReport =("Nessun elemento disponibile<br>");
			return ("");
		} else {
			return (stringaExtentElemento (this.objShape));
		} //if
	}

	public String stringaCentroideElemento (SeShape objShape) {
		try {
			SeShape centroide = objShape.asPoint();
			SeExtent extent = centroide.getExtent();
			return (extent.getMinX()+","+extent.getMinY());
	    } catch (SeException e) {
	        e.printStackTrace();
			this.statusReport +=(e);
			return ("");
	    } //try
	}

	public String stringaCentroideElemento () {
		if (this.objShape == null) {
			this.statusReport =("Nessun elemento disponibile<br>");
			return ("");
		} else {
			return (stringaCentroideElemento (this.objShape));
		} //if
	}

	public Object[] trovaElementoPerParametri (String tabella, String clausolaWhere) {
		String[] colonne = new String[1];
		colonne[0] = "SHAPE";
		return (trovaElementoPerParametri (tabella, clausolaWhere, colonne));
	}
	
	public Object[] trovaElementoPerParametri (String tabella, String clausolaWhere, String[] colonne) {
		return (trovaElementoPerParametri (tabella, clausolaWhere, colonne, "SHAPE"));
	}
	
	public Object[] trovaElementoPerParametri (String tabella, String clausolaWhere, String[] colonne, String spatCol) {
		Object[] risultato=new Object[colonne.length];
		this.statusReport =("");
		this.autoConnSDE();
		
		try {
		// genera il puntatore al layer SDE
			SeLayer layerSDE = new SeLayer(this.connSDE, tabella, spatCol);
			//colonne[0] = layerSDE.getSpatialColumn();
		
		// genera la query che applica il filtro
			SeSqlConstruct sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName(), clausolaWhere);
			SeQuery query = new SeQuery( connSDE, colonne, sqlConstruct );
		// applica la query
			query.prepareQuery();
			query.execute();
		    
		// --------------[ genera REPORT ]---------------
			this.statusReport +=("<b>..:: Report sui risultati ::..</b><br>");
		    this.statusReport +=("<b><i>Colonna spaziale:</i></b> "+layerSDE.getSpatialColumn()+"<br>");
		    this.statusReport +=("<b><i>Handle alla SQL:</i></b> "+sqlConstruct+"<br>");
			
		// lettura del primo record recuperato
			if ((this.riga = query.fetch()) != null) {
				risultato = this.LeggiRiga(null);
			} //if
			query.close();
	    } catch (SeException e) {
	        e.printStackTrace();
	        
			this.statusReport +=(e);
			this.statusReport +=(e.getSeError().getErrDesc()+"<br>");
			this.statusReport +=tabella+"."+clausolaWhere+"."+spatCol;
	    } //try
	    
	    return (risultato);
	}
	
	protected Object[] LeggiRiga (SeShape box) {
		try {
		// Recupera la definizione di tutte le colonne restituite
			this.defColonne = this.riga.getColumns();
			this.numeroColonne = this.riga.getNumColumns();
			Object[] risultato=new Object[this.numeroColonne];
		// --------------[ genera REPORT ]---------------
			this.statusReport +=("<b><i>Handle della riga:</i></b> "+this.riga+"<br>");
			this.statusReport +=("<b><i>Numero delle colonne:</i></b> "+this.numeroColonne+"<br>");
			
		// cicla sul record per recuperare i valori
			short nCampo;
			for (nCampo = 0; nCampo < this.numeroColonne; nCampo++) {
				int dataType = this.defColonne[nCampo].getType();
				this.statusReport +=("<b><i>DATA TYPE</i></b> = ["+dataType+"]<br>");
				
				switch( dataType ) {
				case SeColumnDefinition.TYPE_SHAPE:
					this.objShape = this.riga.getShape(nCampo);
					this.statusReport +=(" |"+this.defColonne[nCampo].getName()+" : "+this.riga.getShape(nCampo).toString()+"|");
					//risultato[nCampo]=this.riga.getShape(nCampo);
					break;
				case SeColumnDefinition.TYPE_STRING:
					this.statusReport +=(" |"+this.defColonne[nCampo].getName()+" : "+ this.riga.getString(nCampo).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll("<", "&gt;")+"|");
					//risultato[nCampo]=this.riga.getString(nCampo);
					break;
				case SeColumnDefinition.TYPE_FLOAT64:
					Double valore = this.riga.getDouble(nCampo);
					long longValore = valore.longValue();
					this.statusReport +=(" |"+this.defColonne[nCampo].getName()+" : "+ this.riga.getDouble(nCampo).longValue()+"|");
					//risultato[nCampo]= new Long(this.riga.getDouble(nCampo).longValue());
					//risultato[nCampo]=this.riga.getDouble(nCampo);
					break;
				default:
					//risultato[nCampo]=this.riga.getObject(nCampo);
					break;
				}
				risultato[nCampo]=this.riga.getObject(nCampo);
				this.statusReport +=("<br>");
			} //for
		    return (risultato);
				
	    } catch (SeException e) {
	        e.printStackTrace();
			this.statusReport +=(e);
			this.statusReport +=(e.getSeError().getErrDesc());
		    return (null);
	    } //try
	    
	}
// trovaElVicinoPerPunto --------------------------------
/* Nota importante:
	Mettere sempre il campo shape come campo 0.
	Questo permette di leggere l'oggetto shape.
	Altrimenti non funziona.
*/
	public Object[] trovaElVicinoPerPunto (double xPoint, double yPoint, String tabella) {
		try {
			String[] colonne = new String[1];
			colonne[0] = "SHAPE";
			return (trovaElVicinoPerPunto (xPoint, yPoint, tabella, colonne, "", "SHAPE"));
	    } catch (Exception e) {
			this.statusReport +=(e);
		    return (null);
	    } //try
	}
	
	
	public Object[] trovaElVicinoPerPunto (double xPoint, double yPoint, String tabella, String[] colonne, String clausolaWhere) {
		try {
			return (trovaElVicinoPerPunto (xPoint, yPoint, tabella, colonne, clausolaWhere, "SHAPE"));
	    } catch (Exception e) {
			this.statusReport +=(e);
		    return (null);
	    } //try
	}
	
	public Object[] trovaElVicinoPerPunto (double xPoint, double yPoint, String tabella, String[] colonne, String clausolaWhere, String spatCol) {
		try {
			Object[] risultato=new Object[colonne.length];
			//this.statusReport +=("<b><i>Dimensione Array:</i></b> "+colonne.array.lenght+"<br>");
			this.statusReport =("");
			this.autoConnSDE();
			double dimBuffer = 100;
			double distanza = dimBuffer+10;

		// genera il puntatore al layer SDE
			SeLayer layerSDE = new SeLayer(this.connSDE, tabella, spatCol);
		// genera un punto
			int nPunti = 1;
			SDEPoint[] ptArray = new SDEPoint[nPunti];
			ptArray[0] = new SDEPoint(xPoint,yPoint);
			SeShape Punto = new SeShape(layerSDE.getCoordRef());
			Punto.generatePoint(nPunti, ptArray);
			SeShape buffer;
			SeSqlConstruct sqlConstruct;
			SeQuery query;
			long contaRecord = 0;
			double tempDistanza = 0;
			boolean trovatoToponimo = false;
		// cicla finchè non trova un toponimo
			while (!trovatoToponimo) {
			// genera il buffer sul punto
				buffer = Punto.generateBuffer(dimBuffer,200);

			// genera un filtro tra punto e layer SDE
				SeShapeFilter Filtri[] = new SeShapeFilter[1];
				SeShapeFilter Filtro = new SeShapeFilter(tabella, layerSDE.getSpatialColumn(), buffer, SeFilter.METHOD_II_OR_ET);
				Filtri[0] = Filtro;

			// genera la query che applica il filtro
				sqlConstruct = new SeSqlConstruct( layerSDE.getQualifiedName(), clausolaWhere);
				query = new SeQuery( connSDE, colonne, sqlConstruct );
					
			// applica la query
				query.prepareQuery();
				// ottimizza il filtro sulla colonna spaziale
				query.setSpatialConstraints(SeQuery.SE_OPTIMIZE, false,	Filtri);
				query.execute();
			// --------------[ genera REPORT ]---------------
				this.statusReport +=("<b>..:: Report sui risultati ::..</b><br>");
			    this.statusReport +=("<b><i>Colonna spaziale:</i></b> "+layerSDE.getSpatialColumn()+"<br>");
			    this.statusReport +=("<b><i>Handle alla SQL:</i></b> "+sqlConstruct+"<br>");
				contaRecord = 0;
				//tempDistanza = new Double(0);
			// ciclo di lettura di tutti i record recuperati
				while ((this.riga = query.fetch()) != null) {
					trovatoToponimo = true;
					contaRecord ++;
				// se la distanza è minore della precedente legge il record recuperato
//this.statusReport +=("<br>OK"+(String.valueOf(Punto.calculateDistance((SeShape)this.riga.getShape(0),false)))+"<br>");
					tempDistanza = Punto.calculateDistance((SeShape)this.riga.getShape(0),false);

					//this.statusReport +=("<b><i>Testo:</i></b> "+contaRecord+"<br>");
					//if (tempDistanza!=null) {
						if (tempDistanza < distanza) {
							distanza = tempDistanza;
						// lettura del record recuperato
							risultato = this.LeggiRiga(null);
						}

					//}
				// --------------[ genera REPORT ]---------------
					this.statusReport +=("<b><i>Numero della riga:</i></b> "+contaRecord+"<br>");
					
				} //while
				query.close();
				if (!trovatoToponimo) {
					dimBuffer = dimBuffer*10;
					distanza = dimBuffer+10;
				}
			} //while
		    return (risultato);
	    } catch (SeException e) {
	        e.printStackTrace();
			this.statusReport +=(e);
			this.statusReport +=(e.getSeError().getErrDesc());
	    	return (null);
	    } //try
	}

	public double[] trasformaPunto(double x, double y, String verso){
		
		String[] xy = new String[2];
		double[] orig = new double[2];
		orig[0]=x;
		orig[1]=y;
		double[] dest = new double[2];
		double[] dest1 = new double[2];

		if(verso.equals("ED50A-WGS84LL")){
			
			dest1 = ed50a2wgs84(32, orig);
			dest = UTMToGeographic(32, dest1);

		} else if (verso.equals("ED50A-WGS84")){

			dest = ed50a2wgs84(32, orig);
			
		} else if (verso.equals("WGS84LL-ED50A")){
			dest1 = geographicToUTM(32, orig);
			
			dest = wgs842ed50a(32, dest1);

this.statusReport +=orig[0]+", "+orig[1]+"<br />"+dest1[0]+", "+dest1[1]+"<br />....:"+dest[0]+", "+dest[1]+"<br />";

		} else if (verso.equals("WGS84-ED50A")){

			dest = wgs842ed50a(32, orig);

		}
		return dest;
	}
	
	// Computes the meridian distance for the GRS-80 Spheroid.
	// See equation 3-22, USGS Professional Paper 1395.
	public double meridianDist(double lat) {
	  double c1 = MajorAxis * (1 - Ecc / 4 - 3 * E4 / 64 - 5 * E6 / 256);
	  double c2 = -MajorAxis * (3 * Ecc / 8 + 3 * E4 / 32 + 45 * E6 / 1024);
	  double c3 = MajorAxis * (15 * E4 / 256 + 45 * E6 / 1024);
	  double c4 = -MajorAxis * 35 * E6 / 3072;

	  return(c1 * lat + c2 * Math.sin(lat * 2) + c3 * Math.sin(lat * 4) + c4 * Math.sin(lat * 6));
	}


	// Convert lat/lon (given in decimal degrees) to UTM, given a particular UTM zone.
	public double[] geographicToUTM(int zone, double[] latlon) {
	  double[] utm = new double[2];

	  double centeralMeridian = -((30 - zone) * 6 + 3) * degrees2radians;

	  double lat = latlon[1] * degrees2radians;
	  double lon = latlon[0] * degrees2radians;

	  double latSin = Math.sin(lat);
	  double latCos = Math.cos(lat);
	  double latTan = latSin / latCos;
	  double latTan2 = latTan * latTan;
	  double latTan4 = latTan2 * latTan2;

	  double N = MajorAxis / Math.sqrt(1 - Ecc * (latSin*latSin));
	  double c = Ecc2 * latCos*latCos;
	  double a = latCos * (lon - centeralMeridian);
	  double m = meridianDist(lat);

	  double temp5 = 1.0 - latTan2 + c;
	  double temp6 = 5.0 - 18.0 * latTan2 + latTan4 + 72.0 * c - 58.0 * Ecc2;
	  double temp11 = Math.pow(a, 5);

	  utm[0] = K0 * N * (a + (temp5 * Math.pow(a, 3)) / 6.0 + temp6 * temp11 / 120.0) + 500000;

	  double temp7 = (5.0 - latTan2 + 9.0 * c + 4.0 * (c*c)) * Math.pow(a,4) / 24.0;
	  double temp8 = 61.0 - 58.0 * latTan2 + latTan4 + 600.0 * c - 330.0 * Ecc2;
	  double temp9 = temp11 * a / 720.0;

	  utm[1] = K0 * (m + N * latTan * ((a * a) / 2.0 + temp7 + temp8 * temp9));

	  return(utm);
	}
	public double CSq(double value) {
	  return value*value;
	}	

	// Convert UTM coordinates (given in meters) to Lat/Lon (in decimal degrees), given a particular UTM zone.
	public double[] UTMToGeographic(int zone, double[] utm) {
	  double latlon[] = new double[2];

	  double centeralMeridian = -((30 - zone) * 6 + 3) * degrees2radians;

	  double temp1 = Math.sqrt(1.0 - Ecc);
	  double ecc1 = (1.0 - temp1) / (1.0 + temp1);
	  double ecc12 = ecc1 * ecc1;
	  double ecc13 = ecc1 * ecc12;
	  double ecc14 = ecc12 * ecc12;

	  utm[0] = utm[0] - 500000.0;

	  double m = utm[1] / K0;
	  double um = m / (MajorAxis * (1.0 - (Ecc / 4.0) - 3.0 * (E4 / 64.0) - 5.0 * (E6 / 256.0)));

	  double temp8 = (1.5 * ecc1) - (27.0 / 32.0) * ecc13;
	  double temp9 = ((21.0 / 16.0) * ecc12) - ((55.0 / 32.0) * ecc14);

	  double latrad1 = um + temp8 * Math.sin(2 * um) + temp9 * Math.sin(4 * um) + (151.0 * ecc13 / 96.0) * Math.sin(6.0 * um);

	  double latsin1 = Math.sin(latrad1);
	  double latcos1 = Math.cos(latrad1);
	  double lattan1 = latsin1 / latcos1;
	  double n1 = MajorAxis / Math.sqrt(1.0 - Ecc * CSq(latsin1));
	  double t2 = CSq(lattan1);
	  double c1 = Ecc2 * CSq(latcos1);

	  double temp20 = (1.0 - Ecc * CSq(latsin1));
	  double r1 = MajorAxis * (1.0 - Ecc) / Math.sqrt(CSq(temp20) * temp20);

	  double d1 = utm[0] / (n1*K0);
	  double d2 = CSq(d1);
	  double d3 = d1 * d2;
	  double d4 = CSq(d2);
	  double d5 = d1 * d4;
	  double d6 = CSq(d3);

	  double t12 = CSq(t2);
	  double c12 = CSq(c1);

	  temp1 = n1 * lattan1 / r1;
	  double temp2 = 5.0 + 3.0 * t2 + 10.0 * c1 - 4.0 * c12 - 9.0 * Ecc2;
	  double temp4 = 61.0 + 90.0 * t2 + 298.0 * c1 + 45.0 * t12 - 252.0 * Ecc2 - 3.0 * c12;
	  double temp5 = (1.0 + 2.0 * t2 + c1) * d3 / 6.0;
	  double temp6 = 5.0 - 2.0 * c1 + 28.0 * t2 - 3.0 * c12 + 8.0 * Ecc2 + 24.0 * t12;

	  latlon[0] = (latrad1 - temp1 * (d2 / 2.0 - temp2 * (d4 / 24.0) + temp4 * d6 / 720.0)) * 180 / Math.PI;
	  latlon[1] = (centeralMeridian + (d1 - temp5 + temp6 * d5 / 120.0) / latcos1) * 180 / Math.PI;
	  utm[0] = utm[0] + 500000.0;

	  return(latlon);
	}

	// funzione per convertire da utm32* in ed50 a utm32 in wgs84 (olivucci)
	// l'utm viene prima convertito in Gauss-Boaga con il metodo CTR
	public double[] ed50a2wgs84(int zone, double[] ed50){
		double[] wgs84 = new double[2];	
			
		double gb_x = ed50[0] +(-53+1000000);
		// per convertire da utm non * sottraggo solo 180
		double gb_y = ed50[1] +(-180+4000000);
			
		// Costanti per il passaggio da GBovest a wgs84 fuso32	
		//costanti per la trasformazione (nord Y )
		double Mn = 0.999980296577487;
		double Bn = 78.4886438645733;
		//costanti per la trasformazione (est X )
		double Me = 0.999976577415925;
		double Be = -999991.102517111;
		
			
		wgs84[0] =((gb_x * Me)+ Be);
		wgs84[1] =((gb_y * Mn)+ Bn);
		
		return (wgs84);
		
	}	
	
	// funzione per convertire da utm32* in ed50 a utm32 in wgs84 (olivucci)
	// l'utm viene prima convertito in Gauss-Boaga con il metodo CTR
	public double[] wgs842ed50a(int zone, double[] wgs84){
		double[] ed50 = new double[2];	
			
			
		// Costanti per il passaggio da GBovest a wgs84 fuso32	
		//costanti per la trasformazione (nord Y )
		double Mn = 0.999980296577487;
		double Bn = 78.4886438645733;
		//costanti per la trasformazione (est X )
		double Me = 0.999976577415925;
		double Be = -999991.102517111;
		
		double gb_x = wgs84[0] +(-53+1000000);
		// per convertire da utm non * sottraggo solo 180
		double gb_y = wgs84[1] +(-180+4000000);
			
		
		
		ed50[0] = ((wgs84[0]-Be)/Me) - (-53+1000000);     //((gb_x * Me)+ Be);
		ed50[1] = ((wgs84[1]-Bn)/Mn) - (-180+4000000);    //((gb_y * Mn)+ Bn);
		
		return (ed50);
		
	}	
	
}
%>