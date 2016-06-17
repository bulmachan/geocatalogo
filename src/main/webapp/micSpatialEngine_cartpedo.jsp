<%@ page
	import="
		com.esri.sde.sdk.client.*
		, com.esri.*"
%><%
class micSpatialEngine {
	
	public String nomeServer = "";
	public int portaSDE = 0;
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
		
		/*try {
			this.connSDE = new SeConnection(this.nomeServer, this.portaSDE, this.nomeDB, this.connUN, this.connPW);
			this.statusReport =("Connessione aperta<br>");
		} catch (SeException e) {
			try {
				this.connSDE = new SeConnection(this.nomeServer, this.instance, this.nomeDB, this.connUN, this.connPW);
				this.statusReport =("Connessione aperta<br>");
			} catch (SeException ee) {
				ee.printStackTrace();
				this.statusReport =("FALLITA apertura di connessione<br>");
				this.statusReport +=(ee);
				Errore = true;
			} //try
			
		} //try
		*/

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
	
	public Object[] trovaElementoPerPunto (double xPoint, double yPoint, String tabella, String[] colonne) {
		return (trovaElementoPerPunto (xPoint, yPoint, tabella, colonne, "SHAPE"));
	}
	
	public Object[] trovaElementoPerPunto (double xPoint, double yPoint, String tabella, String[] colonne, String spatCol) {
		Object[] risultato=new Object[colonne.length];
		//this.statusReport +=("<b><i>Dimensione Array:</i></b> "+colonne.lenght+"<br>");
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
		//this.statusReport +=("<b><i>Dimensione Array:</i></b> "+colonne.lenght+"<br>");
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
			//long dateIni1 = new java.util.Date().getTime();
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

						ris[nCampo]=this.riga.getString(nCampo);
					
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
		this.statusReport =("");
		boolean verbose=false;
		
		try {
			
			long dateIni1 = new java.util.Date().getTime();
			
			//this.autoConnSDE();

			// genera il puntatore al layer SDE
			SeLayer layerSDE = new SeLayer(connSDE, tabella, spatCol);
				
			if(verbose){
				this.statusReport += layerSDE.getName()+": "+layerSDE.getCoordRef().getCoordSysDescription()+"<br />";
				this.statusReport += "falseX: "+String.valueOf(layerSDE.getCoordRef().getFalseX())+"<br />";
				this.statusReport += "falseY: "+String.valueOf(layerSDE.getCoordRef().getFalseY())+"<br />";
				this.statusReport += "xyUnits: "+String.valueOf(layerSDE.getCoordRef().getXYUnits())+"<br />";
				this.statusReport += "precision: "+String.valueOf(layerSDE.getCoordRef().getPrecision())+"<br />";
				this.statusReport += "srid: "+String.valueOf(layerSDE.getCoordRef().getSrid().longValue())+"<br />";
				this.statusReport += "envelope: "+String.valueOf(layerSDE.getCoordRef().getXYEnvelope())+"<br /><br />";
			}
				
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
			if(verbose){
				this.statusReport +=("<b>..:: Report sui risultati ::..</b><br>");
				this.statusReport +=("<b><i>Colonna spaziale:</i></b> "+layerSDE.getSpatialColumn()+"<br>");
				this.statusReport +=("<b><i>Handle alla SQL:</i></b> "+sqlConstruct+"<br>");
			}
			SeShape shapeTemp=null;				
			this.riga = query.fetch();

			int dataType = 0;
			if(this.riga != null){
				this.defColonne = this.riga.getColumns();
			}
			int kkk=1;
			
			long dateFin1 = new java.util.Date().getTime();
			if(verbose){
				this.statusReport +="query: "+((double)(dateFin1-dateIni1)/1000)+" sec.";				
			}
			
			long dateIni2 = new java.util.Date().getTime();

			while(this.riga != null){
				
				String[] ris=new String[colonne.length];
				
				short nCampo;
				short decimali;
				
				for (nCampo = 0; nCampo < colonne.length; nCampo++) {
					dataType = this.defColonne[nCampo].getType();
					decimali=this.defColonne[nCampo].getScale();

					if (dataType==SeColumnDefinition.TYPE_SHAPE){
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
							this.statusReport +="Errore tagliaElementiPerBox (clip): "+(sext);
							this.statusReport +=sext.getSeError().getErrDesc();
						}
					
					} else if (dataType==SeColumnDefinition.TYPE_INT32) {

						ris[nCampo]=this.riga.getInteger(nCampo).toString();
					
					} else if (dataType==SeColumnDefinition.TYPE_INT64) {

						ris[nCampo]=this.riga.getInteger(nCampo).toString();

					} else if (dataType==SeColumnDefinition.TYPE_STRING) {

						ris[nCampo]=this.riga.getString(nCampo);
					
					} else if (dataType==SeColumnDefinition.TYPE_FLOAT64) {
						
						if (decimali==0)
							ris[nCampo]=Integer.toString(this.riga.getDouble(nCampo).intValue());
						else
							ris[nCampo]=this.riga.getDouble(nCampo).toString();
					
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

				if (!ris[0].equals("POLYGON (( 0.0 0.0, 0.0 0.0, 0.0 0.0, 0.0 0.0))"))
					risultati.add(ris);

				this.riga = query.fetch();
				kkk++;
			} 				
			
			query.close();
			
			long dateFin2 = new java.util.Date().getTime();
			if(verbose){
				this.statusReport +="while: "+((double)(dateFin2-dateIni2)/1000)+" sec.";				
			}

		} catch (SeException e) {
				e.printStackTrace();
				this.statusReport +="Errore tagliaElementiPerBox: "+(e);
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
	
	public String stringaExtentLayer (String tabella, SeConnection connSDE) {
		return (stringaExtentLayer (tabella, connSDE, "SHAPE"));
	}
	
	public String stringaExtentLayer (String tabella, SeConnection connSDE, String spatCol) {
		try {
			this.autoConnSDE();
			SeLayer layerSDE = new SeLayer(connSDE, tabella, spatCol);
			SeExtent extent = layerSDE.getExtent();
			return (extent.getMinX()+","+extent.getMinY()+","+extent.getMaxX()+","+extent.getMaxY());
	    } catch (SeException e) {
	        e.printStackTrace();
			this.statusReport +=(e);
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
			this.statusReport +=("Nessun elemento disponibile<br>");
			return ("");
		} else {
			return (stringaCentroideElemento (this.objShape));
		} //if
	}

	public Object[] trovaElementoPerParametri (String tabella, String clausolaWhere, SeConnection connSDE) {
		String[] colonne = new String[1];
		colonne[0] = "SHAPE";
		return (trovaElementoPerParametri (tabella, clausolaWhere, colonne, connSDE));
	}
	
	public Object[] trovaElementoPerParametri (String tabella, String clausolaWhere, String[] colonne, SeConnection connSDE) {
		return (trovaElementoPerParametri (tabella, clausolaWhere, colonne, "SHAPE", connSDE));
	}
	
	public Object[] trovaElementoPerParametri (String tabella, String clausolaWhere, String[] colonne, String spatCol, SeConnection connSDE) {
		Object[] risultato=new Object[colonne.length];
		this.statusReport +=("");
		//this.autoConnSDE();
		
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
			this.statusReport +=(e.getSeError().getErrDesc());
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
					this.statusReport +=(" |"+this.defColonne[nCampo].getName()+" : "+ this.riga.getString(nCampo)+"|");
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
				if(dataType==SeColumnDefinition.TYPE_SHAPE){
					
					SeShape shapeTemp=null;				
					if(!box.equals(null)){
						SeShape shapeInter=this.riga.getShape(nCampo).clip(box.getExtent());
						shapeTemp=shapeInter;
						//if(fg>0){
							
							//SeShape shapeGen=shapeInter.filterCoordinates(fg);
							
							//if(shapeInter.filterCoordinates(0).isSimpleLine()){
								//shapeTemp=shapeInter;
							//}else{
							//	shapeTemp=shapeInter;
							//}
						//}
						risultato[nCampo]=shapeTemp.asText(1000000000);
					}else
						risultato[nCampo]=this.riga.getShape(nCampo).asText(1000000000);
				
				}else
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
			//this.statusReport +=("<b><i>Dimensione Array:</i></b> "+colonne.lenght+"<br>");
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
	
	
	
}
%>