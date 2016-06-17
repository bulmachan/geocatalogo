<%

	// SERVE PER SCRIVERE NEL LOG DI JBOSS: SETTARE A TRUE PER TEST E SVILUPPO MA A FALSE PER PROD
	String ip = request.getLocalAddr().toString();
	boolean debug=(ip.equals("10.10.80.193") || ip.equals("10.10.80.125"));

	String appPath = "nnN";
	if(request.getLocalAddr().equals(request.getRemoteAddr()))
		appPath = request.getScheme() + "://" + request.getRemoteAddr() + request.getContextPath() + "/";
	else
		appPath = request.getScheme() + "://"+request.getRemoteAddr()+"/geologico"+ request.getContextPath() + "/";
	
	// URL DEL SERVER DI RADEX (NON DOVREBBE SERVIRE PIU' QUANDO SI USI IL WMS DELL'IMAGESERVER:
	String urlRadex="http://10.10.64.223/?";
	
	
	// URL DEL SERVER DEL REPOSITORY DEI METADATI REGIONALI:
	//String g_UrlSrvMetadati = "http://servizigis.regione.emilia-romagna.it/ctwmetadati/MetadatiEdiz.ejb?ente=1&org=01&nome_tema=";
	String g_UrlSrvMetadati = "http://servizigis.regione.emilia-romagna.it/ctwmetadatiRER/metadatoISO.ejb?stato_IdMetadato=iOrg01iEnP1idMetadato";
	
	// URL di output di ARCIMS: serve per recuperare i files ZIP dell'EXTRACT di ARCIMS:
	//String outputURL="http://bl88srv/Output/";
	String outputURL="http://mappegis.regione.emilia-romagna.it/output/";
	
	// PATH cartella di temporanea (per files XLS)
	String outputPath="/mnt/vm346srv/arcims/Output/"; 
	//String outputPath="/mnt/bl88srv/"; 
	
	// lista delle estensioni (senza punto) delle legende da allegare negli zippettini di download:
	String[] legendExtensions=null; 
	legendExtensions=new String[2];
	legendExtensions[0]="avl";
	legendExtensions[1]="lyr";
	
	// cartella contenente i files di legende (lyr e/o avl) e file da allegare allo zip el download: 
	//String attachmentsPath="/mnt/gstatico/documenti/geocatalogo/attachments/"; // COSI' FUNZIONA SOLO IN SVILUPPO
	String attachmentsPath="/mnt/vm178srv/website_jboss/documenti/geocatalogo/attachments/"; // COSI' FUNZIONA IN TEST E ANCHE IN SVILUPPO

	
	// LISTA DI FILES DA ALLEGARE AGLI ZIPPETTINI DEL DOWNLOAD (AD ES. METADATI, LICENZE, ETC...)
	String[] dwnAttachments=null;
	dwnAttachments=new String[2];
	dwnAttachments[0]="license_cc_by_2_5.pdf";//"odc_by_1_0_public_text.txt";//"licenza_uso_dati.txt";
	dwnAttachments[1]="iso_19139.xsl";
	
	
	// CONFIGURAZIONE DELLA GRIGLIA, VALORI ACCETTATI: "GK2" (griglie igm k2) | "ADA" (griglie adattative) | "GPS7" (grigliati regionali gps7)
	String griglia="GK2"; //"ADA" //"GPS7";



%>