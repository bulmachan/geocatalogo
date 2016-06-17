
function getListaComuni(){
	xmlAjaxRequest('getListaComuni.jsp', null, null, showListaComuni, 'text');
}

function showListaComuni(result){
	var iH="<select id=\"selcom\" name=\"selcom\" class=\"listaComuni\" onChange=\"controlAddLayer(null, 'BASE_USER.BASE_VF_COMUNI_POL.polygon.ID_COMUNE='+this.value, 'Limiti comunali', 0, 'SDE_VECTOR', false, 379);\">";
	iH=iH+"<option value=\"\" selected>Seleziona Comune</option>";
	iH=iH+result;
	iH=iH+"</select>";
//alert(iH);
	document.getElementById("divSelCom").innerHTML=iH;
}


function getRemoteIp(){

	xmlAjaxRequest('getRemoteIp.jsp', null, null, showRemoteIp, 'text');

}

function showRemoteIp(result){

	loadMappa(result);

}

function loadBaseLayers(){

	// WMS regionali:
	layerOrto11 = new OpenLayers.Layer.WMS('Ortofoto 2011',
			"http://servizigis.regione.emilia-romagna.it/wms/agea2011_rgb?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'Agea2011_RGB'} );

	layerOrto = new OpenLayers.Layer.WMS('Ortofoto 2008',
			"http://servizigis.regione.emilia-romagna.it/wms/agea2008_rgb?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'Agea2008_RGB'} );
	
	/*layerCTR = new OpenLayers.Layer.WMS('Ctr 5.000',
			"http://servizigis.regione.emilia-romagna.it/arcgis/public/Ctr5/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '0'} );*/
	
	layerDBTR = new OpenLayers.Layer.WMS('DBTR 2008 Ctr 5.000',
			"http://servizigis.regione.emilia-romagna.it/wms/dbtr2008_ctr5?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'DBTR2008_Ctr5'} );

	/*layerCTR25 = new OpenLayers.Layer.WMS('Ctr 25.000',
			"http://servizigis.regione.emilia-romagna.it/arcgis/public/Ctr25/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '0'} );*/
	
	/*layerCTR250 = new OpenLayers.Layer.WMS('Ctr 250.000',
			"http://servizigis.regione.emilia-romagna.it/arcgis/public/Ctr250/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '0'} );*/
			
	layerCTRMultiScala = new OpenLayers.Layer.WMS('Ctr',
			"http://servizigis.regione.emilia-romagna.it/wms/ctrmultiscala?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'Ctr_250000,Ctr_25000,Ctr_5000'} );

	layerRilievo = new OpenLayers.Layer.WMS('Rilievo', 
			"http://servizigis.regione.emilia-romagna.it/wms/sfumo_altimetrico5_bosco?", {'transparent': 'FALSE', 'bgcolor': '0xFFFFFF', 'layers': 'Sfumo_Altimetrico5_Bosco'} ); // settiamo la trasparenza a FALSE per evitare il nero
	
	layerOrto.addOptions({projection: srsGlobal, isBaseLayer: true, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	layerOrto11.addOptions({projection: srsGlobal, isBaseLayer: true, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	//layerCTR.addOptions({projection: srsGlobal, isBaseLayer: false, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	layerDBTR.addOptions({projection: srsGlobal, isBaseLayer: false, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	//layerCTR25.addOptions({projection: srsGlobal, isBaseLayer: false, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	//layerCTR250.addOptions({projection: srsGlobal, isBaseLayer: false, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	layerCTRMultiScala.addOptions({projection: srsGlobal, isBaseLayer: false, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	layerRilievo.addOptions({projection: srsGlobal, isBaseLayer: true, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});

	layerOrto.id="Orto";
	layerOrto.tipo="BASE";
	layerOrto.download=false;
	layerOrto.srs=srsGlobal;
	
	layerOrto11.id="Orto11";
	layerOrto11.tipo="BASE";
	layerOrto11.download=false;
	layerOrto11.srs=srsGlobal;

	/*layerCTR.id="Ctr5.000";
	layerCTR.tipo="BASE";
	layerCTR.download=false;
	layerCTR.srs=srsGlobal;*/

	layerDBTR.id="DBTR_Ctr5.000";
	layerDBTR.tipo="BASE";
	layerDBTR.download=false;
	layerDBTR.srs=srsGlobal;

	/*layerCTR250.id="Ctr250.000";
	layerCTR250.tipo="BASE";
	layerCTR250.download=false;
	layerCTR250.srs=srsGlobal;*/

	/*layerCTR25.id="Ctr25.000";
	layerCTR25.tipo="BASE";
	layerCTR25.download=false;
	layerCTR25.srs=srsGlobal;*/

	layerCTRMultiScala.id="CtrMultiscala";
	layerCTRMultiScala.tipo="BASE";
	layerCTRMultiScala.download=false;
	layerCTRMultiScala.srs=srsGlobal;
	
	layerRilievo.id="Rilievo";
	layerRilievo.tipo="BASE";
	layerRilievo.download=false;
	layerRilievo.srs=srsGlobal;
	

	// SERVIZI ARCGIS SERVER SGSS:
	layerBase = new OpenLayers.Layer.WMS('Nessuno',
			//applicationPath+"getMap.jsp", {'transparent': 'TRUE', 'bgcolor': '0x00FFFF', 'layers': '', 'ServiceName':'geocatalogo_nessuno'}, {singleTile: true, ratio: 1} );
			//"http://servizigis.regione.emilia-romagna.it/arcgis/public_sgss/geocatalogo_nessuno/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '0'} );
			"http://servizigis.regione.emilia-romagna.it/wms/mappa_base?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'box_regione'} );
				
	layerSfondoItalia = new OpenLayers.Layer.WMS('SfondoItalia',
			//applicationPath+"getMap.jsp", {'transparent': 'FALSE', 'bgcolor': '0x00FFFF', 'layers': '', 'ServiceName':'geocatalogo_regioni'}, {singleTile: true, ratio: 1, displayInLayerSwitcher: false} );
			//"http://servizigis.regione.emilia-romagna.it/arcgis/public_sgss/geocatalogo_regioni/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '0'}, {displayInLayerSwitcher: false} );
			"http://servizigis.regione.emilia-romagna.it/wms/mappa_base?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'sfondo_italia,Base_mare'}, {displayInLayerSwitcher: false} );

	layerMappa = new OpenLayers.Layer.WMS('Mappa',
			//applicationPath+"getMap.jsp", {'transparent': 'TRUE', 'bgcolor': '0x00FFFF', 'layers': '', 'ServiceName':'geocatalogo_mappa'}, {singleTile: true, ratio: 1} );
			//"http://servizigis.regione.emilia-romagna.it/arcgis/public_sgss/geocatalogo_mappa/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '2,3,4,6,7,8,10,11,12,15,16,17,19,20,21,23,24'} );
			//"http://servizigis.regione.emilia-romagna.it/arcgis/public_sgss/geocatalogo_mappa1/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '0,1,2,3,4,5,6,7,8,9,10,11'} );
			//"http://servizigis.regione.emilia-romagna.it/wms/mappa_base?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '16,15,14,13,12,11,10,9,8,7,6,5,4'} );
			"http://servizigis.regione.emilia-romagna.it/wms/mappa_base?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'Sfumo_3D_Italia,Elemento ferroviario,Strada,Strade,Reticolo idrografico,Reticolo idrografico2,Alveo,Laghi_SIG,Province,porti,Localita_abitata2,Province2,Comuni,Sfumo_3D_10m,DTM_10m,box_regione'} );

	layerBase.addOptions({projection: srsGlobal, isBaseLayer: true, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	layerSfondoItalia.addOptions({projection: srsGlobal, isBaseLayer: false, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: true});
	layerMappa.addOptions({projection: srsGlobal, isBaseLayer: true, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1, visibility: false});
	
	layerBase.id="Nessuno";
	layerBase.tipo="BASE";
	layerBase.download=false;
	layerBase.srs=srsGlobal;

	layerSfondoItalia.id="SfondoItalia";
	layerSfondoItalia.tipo="BASE";
	layerSfondoItalia.download=false;
	layerSfondoItalia.srs=srsGlobal;

	layerMappa.id="Mappa";
	layerMappa.tipo="BASE";
	layerMappa.download=false;
	layerMappa.srs=srsGlobal;

	
	
	// BASE LAYERS
	map.addLayer(layerBase);
	map.addLayer(layerRilievo);
	map.addLayer(layerMappa);
	map.addLayer(layerOrto);
	map.addLayer(layerOrto11);
	

	// NO BASE LAYERS
	map.addLayer(layerDBTR);
	/*map.addLayer(layerCTR);
	map.addLayer(layerCTR25);
	map.addLayer(layerCTR250);*/
	map.addLayer(layerCTRMultiScala);
	map.addLayer(layerSfondoItalia);


	layerMarkers = new OpenLayers.Layer.Markers("Markers", {displayInLayerSwitcher: false});
	layerMarkers.id="Markers";
	layerMarkers.tipo="BASE";
	map.addLayer(layerMarkers);
	

	map.setBaseLayer(layerMappa); /* Setta il baselayer corrente */

}


function setSRSOptions(){

	switch (srsGlobal){
		
		case "EPSG:202003": 
			unita="m";
			extent=new OpenLayers.Bounds(500000, 840000, 810000, 1005000);
		break;

		case "EPSG:202032": 
			unita="m";
			extent=new OpenLayers.Bounds(500000, 840000, 810000, 1005000);
		break;
		
		case "EPSG:3003": 
			unita="m";
			extent=new OpenLayers.Bounds(1500000, 4840000, 1810000, 5005000);
		break;

		case "EPSG:3004": 
			unita="m";
			extent=new OpenLayers.Bounds(1500000, 4840000, 1810000, 5005000);
		break;

		case "EPSG:23032":
			unita="m";
			extent=new OpenLayers.Bounds(500000, 4840000, 810000, 5005000);
		break;
	
		case "EPSG:32632":
			unita="m";
			extent=new OpenLayers.Bounds(500000, 4840000, 810000, 5005000);
		break;
		
		case "EPSG:3857":
			unita="m";
			extent=new OpenLayers.Bounds(1000000, 5400000, 1500000, 5650000);
		break;

		case "EPSG:25832":
			unita="m";
			extent=new OpenLayers.Bounds(500000, 4840000, 810000, 5005000);
		break;

		case "EPSG:4326":
			unita="dd";
			extent=new OpenLayers.Bounds(9.12, 43.7, 12.84, 45.2);
		break;

		case "EPSG:4258":
			unita="dd";
			extent=new OpenLayers.Bounds(9.12, 43.7, 12.84, 45.2);
		break;
	}

	resolutions= new Array();
	resOverview= new Array();
	switch (unita){
		case "m":
			coordsDigits=2;
			
			scales = [2500000, 2000000, 1750000, 1500000, 1250000, 1000000, 750000, 500000, 400000, 300000, 250000, 200000, 150000, 100000, 75000, 50000, 35000, 25000, 15000, 10000, 7500, 5000, 2500, 2000, 1000];
			//scalesOverview = [7000000, 6000000, 5000000, 4000000, 3000000, 2000000, 1000000, 500000, 250000];
			//scalesOverview = [7000000, 4000000, 2000000];
			scalesOverview = [8000000];
			
			for (var i = 0; i < scales.length; i++) {
				resolutions[i]=scales[i]*(2.54/OpenLayers.DOTS_PER_INCH/100);
			}
			for (var i = 0; i < scalesOverview.length; i++) {
				resOverview[i]=scalesOverview[i]*(2.54/OpenLayers.DOTS_PER_INCH/100);
			}
			//resolutions=[661.4583333, 529.1666667, 463.0208333, 396.875, 330.7291667, 264.5833333, 198.4375, 132.2916667, 105.8333333, 79.375, 66.14583333, 52.91666667, 39.6875, 26.45833333, 19.84375, 13.22916667, 9.260416667, 6.614583333, 3.96875, 2.645833333, 1.984375, 1.322916667, 0.661458333, 0.529166667, 0.264583333];
			//resOverview=[1852.08333, 1587.5, 1322.916667, 1058.333333, 793.75, 529.1666667, 264.5833333, 132.2916667, 66.14583333];
		break;
		
		case "dd":
			coordsDigits=8;
			
			scales = [5000000, 2500000, 2000000, 1750000, 1500000, 1250000, 1000000, 750000, 500000, 400000, 300000, 250000, 200000, 150000, 100000, 75000, 50000, 35000, 25000, 15000, 10000, 7500, 5000, 2500, 2000, 1000];
			//scalesOverview = [8000000, 7000000, 6000000, 5000000, 4000000, 3000000, 2000000, 1000000, 500000, 250000];
			scalesOverview = [9000000];
			
			for (var i = 0; i < scales.length; i++) {
				resolutions[i]=scales[i]*(1/(4374754*OpenLayers.DOTS_PER_INCH));
			}
			for (var i = 0; i < scalesOverview.length; i++) {
				resOverview[i]=scalesOverview[i]*(1/(4374754*OpenLayers.DOTS_PER_INCH));
			}
			
			//resolutions=[0.00595271566507892000, 0.00476217253206314000, 0.00416690096555524000, 0.00357162939904735000, 0.00297635783253946000, 0.00238108626603157000, 0.00178581469952368000, 0.00119054313301578000, 0.00095243450641262700, 0.00071432587980947000, 0.00059527156650789200, 0.00047621725320631400, 0.00035716293990473500, 0.00023810862660315700, 0.00017858146995236800, 0.00011905431330157800, 0.00008333801931110490, 0.00005952715665078920, 0.00003571629399047350, 0.00002381086266031570, 0.00001785814699523680, 0.00001190543133015780, 0.00000595271566507892, 0.00000476217253206314, 0.00000238108626603157];
			//resOverview=[0.016667604, 0.014286518, 0.011905431, 0.009524345, 0.007143259, 0.004762173, 0.002381086, 0.001190543, 0.000595272];
		break;
	}

}


function loadMappa(){
	
	OpenLayers.Lang.setCode('it');
	OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
    OpenLayers.Util.onImageLoadErrorColor = "transparent";

	setSRSOptions();

	var extentBig=new OpenLayers.Bounds();
	extentBig.extend(new OpenLayers.LonLat((extent.toArray(false)[0])-(extent.getWidth()/10), (extent.toArray(false)[1])-(extent.getHeight()/10)));
	extentBig.extend(new OpenLayers.LonLat((extent.toArray(false)[2])+(extent.getWidth()/10), (extent.toArray(false)[3])+(extent.getHeight()/10)));

	var options = {
		projection: new OpenLayers.Projection(srsGlobal),
		displayProjection: new OpenLayers.Projection(srsGlobal),
		units: unita,
		maxResolution: resolutions[0],
		resolutions: resolutions,
		maxExtent: extentBig,
		numZoomLevels: 25,
		scales: scales//,
		//allOverlays: true
	};
	
	map = new OpenLayers.Map('mappa', options);
	
	// CARICA I CONTROLLI:
	loadControls();

	// CARICA I LAYER DI BASE:
	loadBaseLayers();

	// ATTIVA IL CLICK SULLA MAPPA PER L'IDENTIFY:
	var click = new OpenLayers.Control.Click();
	map.addControl(click);
	click.activate();

	// GEOLOG
	map.events.register('moveend', map, function(){
		writeGeoLog('moveend', null);
		});	
    map.events.register('changelayer', map, function(){
		writeGeoLog('changelayer', null);
		});	
    map.events.register('click', map, function(){
		writeGeoLog('click', null);
		});	



	map.zoomToExtent(extent, true);
	//map.setCenter(new OpenLayers.LonLat(654000,935000));
	//alert("current res: " + map.getResolution() + " max res: " + map.getMaxResolution() + " current scale: "+map.getScale() + " max scale: "+map.maxScale + " min scale: "+map.minScale + " unita': "+map.getUnits());

}


function loadControls(){

	//CARICA LA TOC:
	if (map.getControl("laTOC")!=null){
		map.removeControl(map.getControl("laTOC"));
		//alert("tolgo la toc");
	}
	chiusuraTOCauto=true;
	laTOC = new OpenLayers.Control.LayerSwitcher({displayClass: 'toc', ascending:false});
	laTOC.id="laTOC";
	map.addControl(laTOC);
	chiusuraTOCauto=false;

	
	// CARICA IL LOADINGPANEL:
	if (map.getControl("loadingPan")!=null)
		map.removeControl(map.getControl("loadingPan"));
	loadingPan=new OpenLayers.Control.LoadingPanel();
	loadingPan.id="loadingPan";
	map.addControl(loadingPan);

	
	// CARICA LE KEYBOARD DEFAULTS:
	if (map.getControl("keyboardDefaults")!=null)
		map.removeControl(map.getControl("keyboardDefaults"));
	keyboardDefaults=new OpenLayers.Control.KeyboardDefaults();
	keyboardDefaults.id="keyboardDefaults";
	map.addControl(keyboardDefaults);	

	
	// CARICA LE COORDINATE:
	if (map.getControl("coordsControl")!=null)
		map.removeControl(map.getControl("coordsControl"));
	coordsControl=new OpenLayers.Control.MousePosition();
	coordsControl.id="coordsControl";
	coordsControl.div=document.getElementById("coords");
	//coordsControl.prefix=srsGlobal+" x: <b>";
	coordsControl.prefix=srsLabelsX[srsGlobal]+"<b>";
	coordsControl.separator="</b> - "+srsLabelsY[srsGlobal]+"<b>";
	coordsControl.suffix="</b>";
	coordsControl.numDigits=coordsDigits;
	map.addControl(coordsControl);
	
	
	// CARICA LA SCALEBAR:
	if (map.getControl("scaleBar")!=null)
		map.removeControl(map.getControl("scaleBar"));
	scalebar = new OpenLayers.Control.ScaleBar();
	scalebar.id="scaleBar";
	scalebar.abbreviateLabel = true;
	map.addControl(scalebar);
	
	
	// CARICA LA SCALA NUMERICA:
	if (map.getControl("scaleControl")!=null)
		map.removeControl(map.getControl("scaleControl"));
	var scaleControl=new OpenLayers.Control.Scale();
	document.getElementById("scala").innerHTML = ""; /* svuoto il div scala */
	scaleControl.div=document.getElementById("scala");
	scaleControl.id="scaleControl";
	map.addControl(scaleControl);

	// CARICA LA OVERVIEW:
	if (map.getControl("overView")!=null)
		map.removeControl(map.getControl("overView"));
	
	//layerOverView = new OpenLayers.Layer.WMS('Regione',	applicationPath+"getMap.jsp", {'layers': 'BASE_USER.BASE_VF_REGIONE_ER_POL.polygon'}, {singleTile: true, ratio: 1} );
	layerOverView1 = new OpenLayers.Layer.WMS('Overview1', 
		//applicationPath+"getMap.jsp", {'layers': '', 'ServiceName':'geocatalogo_overview'} );
		//"http://servizigis.regione.emilia-romagna.it/arcgis/public_sgss/geocatalogo_regioni/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '0'} );
		"http://servizigis.regione.emilia-romagna.it/wms/mappa_base?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'sfondo_italia'} );

	layerOverView1.addOptions({projection: srsGlobal, isBaseLayer: true, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1} );
	layerOverView1.units=unita;

	layerOverView2 = new OpenLayers.Layer.WMS('Overview2', 
		//applicationPath+"getMap.jsp", {'layers': '', 'ServiceName':'geocatalogo_overview'} );
		//"http://servizigis.regione.emilia-romagna.it/arcgis/public_sgss/geocatalogo_overview/MapServer/WMSServer?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': '1'} );
		"http://servizigis.regione.emilia-romagna.it/wms/mappa_base?", {'transparent': 'TRUE', 'bgcolor': '0xFFFFFF', 'layers': 'Province2'} );

	layerOverView2.addOptions({projection: srsGlobal, isBaseLayer: false, quattroMilioni: (srsGlobal=="EPSG:202003"), singleTile: true, ratio: 1} );
	layerOverView2.units=unita;

	var optionsOverview = {
		projection: new OpenLayers.Projection(srsGlobal),
		displayProjection: new OpenLayers.Projection(srsGlobal),
		units: unita,
		maxResolution: resOverview[0],
		resolutions: resOverview,
		maxExtent: extent,
		numZoomLevels: scalesOverview.length,
		scales: scalesOverview
	};
	
	var controlOptions = {
		mapOptions: optionsOverview,
		layers: [layerOverView1,layerOverView2]
	}			
	var overview = new OpenLayers.Control.OverviewMap(controlOptions);
	overview.id="overView";

	map.addControl(overview);

	//overview.style.display = 'none';


	// ATTIVA LA NAVIGAZIONE CON I TASTI:
	var handKey= new OpenLayers.Handler.Keyboard(this, {"keydown": tasto });
	handKey.activate();
	
	
	// RENDE ACCESSIBILI LE ICONE:
	makeOpenLayerAccessibile();

}

hs.Expander.prototype.onAfterExpand = function () {
   
   if(hs.getExpander().a.href.indexOf("help")>0)
	   helpAperto=true;
  
   if(hs.getExpander().a.href.indexOf("documenti")>0)
	   documentiAperto=true;

   if(hs.getExpander().a.href.indexOf("salva")>0)
	   salvaAperto=true;

   if(hs.getExpander().a.href.indexOf("toponimi")>0)
	   toponimiAperto=true;

}

hs.Expander.prototype.onAfterClose = function () {
   
   if(hs.getExpander().a.href.indexOf("help")>0)
	  helpAperto=false;
  
   if(hs.getExpander().a.href.indexOf("documenti")>0)
	   documentiAperto=false;
  
   if(hs.getExpander().a.href.indexOf("salva")>0)
	   salvaAperto=false;

   if(hs.getExpander().a.href.indexOf("toponimi")>0)
	   toponimiAperto=false;

}
var fuocosulcerca=false;
var helpAperto=false;
var	documentiAperto=false;
var	salvaAperto=false;
var	toponimiAperto=false;
function tasto(evt){
	if(!fuocosulcerca){
		//alert(evt.keyCode);
		switch(evt.keyCode) {
			case 68: //la D per DOCUMENTI
				if(!documentiAperto){
					document.getElementById("documenti").click();
					documentiAperto=true;
				} else {
					documentiAperto=false;
					return hs.close(document.getElementById("documenti"));
				}
			break;
			case 83: //la S per SALVA
				if(!salvaAperto){
					document.getElementById("salva").click();
					salvaAperto=true;
				} else {
					salvaAperto=false;
					return hs.close(document.getElementById("salva"));
				}
			break;
			case 72: //la H per HELP
				if(!helpAperto){
					document.getElementById("help").click();
					helpAperto=true;
				} else {
					helpAperto=false;
					return hs.close(document.getElementById("help"));
				}
			break;
			
			case 84: //la T per TOPONIMI
				if(!toponimiAperto){
					document.getElementById("toponimi").click();
					toponimiAperto=true;
				} else {
					toponimiAperto=false;
					return hs.close(document.getElementById("toponimi"));
				}
			break;
			
			case 79: //la O per OVERVIEW
				if(map.getControl("overView").minimizeDiv.style.display=='none')
					map.getControl("overView").maximizeControl();
				else
					map.getControl("overView").minimizeControl();

			break;

			case 76: //la L per TOC (LEGENDA)
				if(laTOC.minimizeDiv.style.display=='none')
					laTOC.maximizeControl();
				else
					laTOC.minimizeControl();

			break;
		}
	}


}

function pulisciMarkers() {
	lettera=0;
	layerMarkers.clearMarkers();
}

function cambiaSrs(srs) {
	
	if(srs.indexOf("EPSG:")>-1){
		// GEOLOG
		map.events.remove('moveend');


		tocAperta=(laTOC.div.style.width!="0px");
		// QUESTO NON FUNZIONA 30 aprile 2010; ADESSO SI !! (primo luglio 2010)
		//alert("display: "+map.getControl("overView").div.childNodes[1].style.display+"kkkK");
		overviewAperta=(map.getControl("overView").div.childNodes[1].style.display == 'block');
		var sourceProjection = new OpenLayers.Projection(srsGlobal);
		srsGlobal=srs;
		var destProjection = new OpenLayers.Projection(srsGlobal);
		
		/* setto opportumente il selected nel menu' a tendina, questo perch cambiaSrs non viene richiamato solo dall'onchange proprio della voce sulla tendina,
		ma ad esempio anche analizzaParametri se si apre un URL con dei paramtri precedentemente salvati */
		var srsSelectElement = document.getElementById("srsSelect"); 
		for (i = 0; i < srsSelectElement.length; i++) {
			/* toglie selected al valore precedentemente selezionato */
			srsSelectElement[i].selected = false;
			//alert(srsSelectElement[i].value);
			//if (i == srsSelectElement.selectedIndex) {
			if (srsSelectElement[i].value==srs) {
				//alert("cambiato il selected nel menu a tendina!!! ");
				srsSelectElement[i].selected = true;
			}
		}
		
		setSRSOptions();

		var theMaxExtent = map.getMaxExtent();
		theMaxExtent.transform(sourceProjection, destProjection);
		
		
		// QUESTO NON LO FACCIAMO PIU' ALTRIMENTI POI LE COORDINATE DEL BBOX NON VENGONO AGGIORNATE NEL NUOVO SISTEMA DI RIFERIMENTO
		//var maxExtentBig=new OpenLayers.Bounds();
		//maxExtentBig.extend(new OpenLayers.LonLat((theMaxExtent.toArray(false)[0])-(theMaxExtent.getWidth()/10), (theMaxExtent.toArray(false)[1])-(theMaxExtent.getHeight()/10)));
		//maxExtentBig.extend(new OpenLayers.LonLat((theMaxExtent.toArray(false)[2])+(theMaxExtent.getWidth()/10), (theMaxExtent.toArray(false)[3])+(theMaxExtent.getHeight()/10)));
		
		
		/*var theCurrentExtent = map.getExtent();
		console.log(theCurrentExtent);
		theCurrentExtent=theCurrentExtent.transform(sourceProjection, destProjection);
		console.log(theCurrentExtent);*/
		
		var centroMappa=map.getCenter();
		centroMappa.transform(sourceProjection, destProjection);
		//console.log(destProjection.getCode());
		if(destProjection.getCode()=="EPSG:3857")// && sourceProjection.getCode()!="EPSG:4326" && sourceProjection.getCode()!="EPSG:4258")
			centroMappa.lat=centroMappa.lat+30000;
		if(sourceProjection.getCode()=="EPSG:3857")
			if(destProjection.getCode()!="EPSG:4326" && destProjection.getCode()!="EPSG:4258"){
				centroMappa.lat=centroMappa.lat-21370;
				centroMappa.lon=centroMappa.lon-452;
			} else {
				centroMappa.lat=centroMappa.lat-0.182;
				centroMappa.lon=centroMappa.lon+0.0054;
			}

		var scalaMappa=map.getScale();

		var newMapOptions = {
			projection: new OpenLayers.Projection(srsGlobal),
			displayProjection: new OpenLayers.Projection(srsGlobal),
			units: unita,
			maxResolution: resolutions[0],
			resolutions: resolutions,
			maxExtent: theMaxExtent, //maxExtentBig
			numZoomLevels: scales.length,
			scales: scales
		};
		map.setOptions(newMapOptions);
		
		listaLayers= new Array();
		for (var i = 0; i < map.layers.length; i++) {
			if(map.layers[i].id.indexOf("Ctr")>-1 || map.layers[i].id=="Orto" || map.layers[i].id=="Orto11" || map.layers[i].id=="Rilievo" || map.layers[i].id=="Mappa" || map.layers[i].id=="Nessuno"  || map.layers[i].id=="SfondoItalia") // DA CONTROLLARE PER I WMS REGIONALI
				map.layers[i].addOptions({quattroMilioni: (srsGlobal=="EPSG:202003")});
			//else
			//	map.layers[i].addOptions({projection: destProjection});
			if(map.layers[i].tipo=="WMS")
				map.layers[i].addOptions({quattroMilioni: (srsGlobal=="EPSG:202003")});

			map.layers[i].projection=srsGlobal; 
			map.layers[i].units=unita;
			map.layers[i].srs=srsGlobal;
			listaLayers[i]=map.layers[i];
		}

		// RICARICA I LAYERS
		var layerInvisibili = "";

		for (var i = 0; i < listaLayers.length; i++) {
			//alert("prima: "+listaLayers[i].id);
			var listaPunti = new Array();
			if(listaLayers[i] instanceof OpenLayers.Layer.Markers){
				listaPunti=listaLayers[i].markers;
			}

			map.removeLayer(listaLayers[i],false);
			map.addLayer(listaLayers[i]);
			
			if(listaLayers[i] instanceof OpenLayers.Layer.Markers && listaPunti.length>0){
				for (var kk = 0; kk < listaPunti.length; kk++) {
					listaPunti[kk].lonlat.transform(sourceProjection, destProjection);
				}
				listaLayers[i].markers=listaPunti;
				listaLayers[i].redraw();
			}

			/**/
			//alert("dopo: "+listaLayers[i].id);
			
			// PER IL MOMENTO LO SPEGNIAMO (27/01/2012) PERCHE' I GLI SRS DEI WMS NON SONO ALLINEATI TRA BL93 E VM48
			//if (listaLayers[i].tipo == "WMS") {
			//	if (listaLayers[i].srsDisponibili.indexOf(srsGlobal) == -1) {
			//		layerInvisibili = layerInvisibili+" - "+listaLayers[i].nome+"\n";
			//		/* srs non disponibile */
			//		listaLayers[i].setVisibility(false);
			//	}
			//}
		}

		//if (layerInvisibili!= "") {
		//	/* non e' stato possibile caricare alcuni layer*/
		//		alert("Attenzione, con il seguente SRS "+srsGlobal+" non e' stato posssibile visualizzare i seguenti layer WMS: \n"+layerInvisibili+"\n Sono stati dunque resi invisibili");
		//}

		loadControls();

		//map.zoomToExtent(theCurrentExtent, true);
		map.panTo(centroMappa);
		map.zoomToScale(scalaMappa,true);

		if(tocAperta)
			laTOC.maximizeControl();

		if(overviewAperta)
			map.getControl("overView").maximizeControl();
			
		//alert("current res: " + map.getResolution() + " max res: " + map.getMaxResolution() + " current scale: "+map.getScale() + " max scale: "+map.maxScale + " min scale: "+map.minScale + " unita' finale: "+map.getUnits());
		//alert("maxextent option: " + map.getMaxExtent());
		
		//map.removePopup(popup);
		//popup.destroy();

		// GEOLOG
		map.events.register('moveend', map, function(){
			writeGeoLog('moveend', null);
			});	
		/*map.events.register('changelayer', map, function(){
			writeGeoLog('changelayer', null);
			});	
		map.events.register('click', map, function(){
			writeGeoLog('click', null);
			});	
		*/
		writeGeoLog('moveend', null);
	}
}

var globTimer;

function getMousePos(e){

var posx=0; var posy=0;
var ev=(!e)?window.event:e;//Moz:IE

if (ev.pageX){posx=ev.pageX; posy=ev.pageY;}//Mozilla or compatible
else if(ev.clientX){posx=ev.clientX; posy=ev.clientY;}//IE or compatible
//alert(posx+" "+posy);
}

function startTimerPreview(e, layer, description, bbox, id, dwn) {
	document.getElementById(id).childNodes[0].removeAttribute("title");
	var x=0; var y=0;
	var ev=(!e)?window.event:e;//Moz:IE

	if (ev.pageX){
		x=ev.pageX; y=ev.pageY; //Mozilla or compatible
	}
	else if(ev.clientX){x=ev.clientX; y=ev.clientY;}//IE or compatible

	x=x+100;
	globTimer = setTimeout(function(){viewPreview(layer, description, x, y, bbox, dwn)},300);
}

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}

function viewPreview(layer, description, x, y, bbox, dwn) {
	clearTimeout(globTimer);
	var url = "";
	var newImg;
	var width = 200;
	var height = 133;
	var attempt = 0;
	
	document.getElementById("div_thumb").style.top = "-10000px";
	document.getElementById("div_thumb").style.left = "0px";
	document.getElementById("display_thumb").style.display = "block";
	document.getElementById("div_thumb").style.display = "block";
	document.getElementById("div_thumb").childNodes[0].innerHTML="<p>Click per aggiungere nella mappa</p>";
	document.getElementById("div_thumb_head").innerHTML="<p>Click per aggiungere nella mappa</p>";
	/*document.getElementById("display_thumb").src = "";
	document.getElementById("display_thumb").width = "";
	document.getElementById("display_thumb").height = "";
	*/
			
	if(bbox!=null){
		var bboxs = bbox.split(",");
		var dx=parseFloat(bboxs[2])-parseFloat(bboxs[0]);
		var dy=bboxs[3]-bboxs[1];
		var height = Math.round(width / (dx/dy));

		if(layer.indexOf("VERSION=")<=-1)
			layer = layer+"&VERSION=1.1.1";
		else
			layer = layer.replace("VERSION=1.3.0", "VERSION=1.1.1");
			
		url = layer + "&REQUEST=GetMap&SERVICE=WMS&SRS=EPSG:4326&BBOX="+bbox+"&WIDTH="+width+"&HEIGHT="+height+"&STYLES=&FORMAT=image/png&TRANSPARENT=FALSE&BGCOLOR=0xFFFFFF";
	
	} else {
		url="getThumbnail.jsp?layer="+layer+"&w=200&h=133";	
	}
	//console.log(url);
	//prompt("", url);
		
	document.getElementById("display_thumb").src = url;
	document.getElementById("display_thumb").width = width;
	document.getElementById("display_thumb").height = height;

	//document.getElementById("div_thumb").childNodes[2].innerHTML = "Layer: " + description;
	document.getElementById("div_thumb_desc").innerHTML = "<p>"+description+"</p>";		
	
	if(dwn==true)
		document.getElementById("div_thumb_dwn").style.display = "block";
	else
		document.getElementById("div_thumb_dwn").style.display = "none";
	
	/* il top del div è la posizione del cursore, se il contenuto del div viene tagliato il top viene ricalcolato (in modo che il div vada ad "appogiarsi sul fondo della pagina" */
	var div_thumbOffsetHeight = document.getElementById("div_thumb").offsetHeight;
	
	if (window.innerHeight) {
		theHeight=window.innerHeight;
	}
	else if (document.documentElement && document.documentElement.clientHeight) {
		theHeight=document.documentElement.clientHeight;
	}
	else if (document.body) {
		theHeight=document.body.clientHeight;
	}
	
	if (y + div_thumbOffsetHeight > theHeight) {
		y = theHeight - div_thumbOffsetHeight - 20;
	}
	
	document.getElementById("div_thumb").style.top = y+"px";
	document.getElementById("div_thumb").style.left = x+"px";


}


function stopTimerPreview() {
	document.getElementById("display_thumb").style.display = "none";
	document.getElementById("div_thumb").style.display = "none";
	document.getElementById("display_thumb").src="images/ajax-loader2.gif";
	clearTimeout(globTimer);
}


function controlAddLayer(idParent, layer, nome, layerIdx, tipo, scaricabile, catid){
	url = applicationPath+"getMap.jsp?";
	var listaArgomenti=new Array(url, layer, nome, layerIdx, tipo, scaricabile, catid);

	if(idParent!=null){
		document.getElementById(idParent).childNodes[0].className = "selected";
		addLayer(idParent,listaArgomenti);
	} else {
		xmlAjaxRequest('cercaLayer.jsp', 's=' + layer.split(".")[1]+'&output=id', null, addLayer, 'text', listaArgomenti);
		//prompt('','cercaLayer.jsp'+"?"+'s=' + layer.split(".")[1]+'&output=id');
	}
	
	//addLayer(idParent, url, layer, nome, layerIdx, tipo, scaricabile);
	
}

function addLayer(idObj, listaArgomenti){
	// SERVE SOLO A RIPULIRE idObj PERCHE' SE E' PASSATO DA cercaLayer LO SI DEVE "PULIRE"
	idObj=idObj.replace(/^\s+|\s+$/g, '').split("||")[0];

	var url=listaArgomenti[0];
	var layer=listaArgomenti[1];
	var nome=listaArgomenti[2];
	var layerIdx=listaArgomenti[3];
	var tipo=listaArgomenti[4];
	var scaricabile=listaArgomenti[5];
	var catid=listaArgomenti[6];
	var srsDisponibili = "";
	var mapHeight;
	var laTOC_layersDivHeight;
	
	if(listaArgomenti.length>7)
		srsDisponibili=listaArgomenti[7];

	var layerSelection=false;
	
	var id="";
	switch(tipo){
	
		case "WMS":
			id=url+"&LAYER="+layer;

		break;

		case "SDE_VECTOR":
			id=layer;
		break;

		case "SDE_RASTER":
			id=layer;
		break;
	
	}
	
	// CONTROLLO CHE IL LAYER NON CI SIA GIA
	var layerGiaCaricato=false;
	for (var i = map.layers.length-1; i >= 0; i--) {
		if (map.layers[i].tipo !="BASE") {
			if (map.layers[i].id==id){
				layerGiaCaricato=true;
				break;
			}
		}
	}
	if(!layerGiaCaricato){
	
		newLayerWMS[layerIdx] = new OpenLayers.Layer.WMS(nome, url, {'transparent': 'TRUE', 'bgcolor': '0x00FFFF', 'layers': layer}, {projection: srsGlobal, singleTile: true, ratio: 1} );
		newLayerWMS[layerIdx].addOptions({isBaseLayer: false});
		
		if(tipo=="WMS"){
			//newLayerWMS[layerIdx].setOpacity(0.5);
			newLayerWMS[layerIdx].srsDisponibili=srsDisponibili;
			newLayerWMS[layerIdx].quattroMilioni=(srsGlobal=="EPSG:202003");
		}
		newLayerWMS[layerIdx].id=id;
		newLayerWMS[layerIdx].catid=catid;
		newLayerWMS[layerIdx].tipo=tipo;
		newLayerWMS[layerIdx].nome=nome;
		newLayerWMS[layerIdx].srs=srsGlobal;
		newLayerWMS[layerIdx].download=scaricabile;
		newLayerWMS[layerIdx].expression=null;

		// NEL CASO IN CUI UN LAYER CONTENGA UNA SELEZIONE ALLORA CI ZUMMOLIAMO SOPRA:
		goExtent=false;
		if (layer.split(".").length==4) {
			
			newLayerWMS[layerIdx].selection=true;
			newLayerWMS[layerIdx].expression = layer.split(".")[3]; /* expression */
			goExtent=true;
			newLayerWMS[layerIdx].download=false; /* una selezione non e' donwlodabile */
			//newLayerWMS[layerIdx].name=newLayerWMS[layerIdx].name+" (selezione)";
			xmlAjaxRequest('getLayerAttributes.jsp', 'layer=' + layer+'&i='+layerIdx+'&layerSelection=true', null, showLayerAttributes, 'text');
			//prompt('','getLayerAttributes.jsp?layer=' + layer+'&i='+id+'&layerSelection=true');
		}
	
		map.addLayer(newLayerWMS[layerIdx]);
		
		if(goExtent){
			zoomToLayer(layer);
		}

		/*  tree item id for future deselect item when remove */
	
		if (idObj != null)
			newLayerWMS[layerIdx].treeId = idObj;
		
		//alert('addWMSLayer ' + !tocChiusa);
		
		if(!tocChiusa)
			laTOC.maximizeControl();

	} else {

		laTOC.maximizeControl();
	
	}
	// FA IN MODO CHE IL LAYER DEI MARKERS SEMPRE SIA IN ALTO VISIBILE
	map.setLayerIndex(layerMarkers,map.layers.length-1);
	
	//controlToc();	
	
}

function zoomToLayer(layer){
	
	xmlAjaxRequest('getLayerExtent.jsp', 'layer=' + layer, null, showLayerExtent, 'text');
	//prompt('', 'getLayerExtent.jsp?'+'layer=' + layer);
	//xmlAjaxRequest('getWmsLayerExtent.jsp', 'url=' + url + '&layer=' + layer + '&srs=' + srsGlobal, null, showLayerExtent, 'text');

}

//controlToc
var laTocOffset = 100;

function controlToc(action) {
	clearTimeout(setSizesTimer);

	var tocTop = 0;
	var mapHeight = 0;
	var laTOCDivOffsetHeight = 0;
	var laTOCDiv = 0;
	var scroll = 0;
	var dim = 0;

	tocTop = document.getElementById("laTOC").style.top;
	/* Verifico che la posizione top della toc sia in pixel (LayerSwitcher) */
	if (tocTop.indexOf("px", 0) > -1) {
	
		tocTop = parseInt(tocTop.substring(0, tocTop.length-2));
		mapHeight = map.size.h;	
		
		laTOC_layersDivHeight = document.getElementById("laTOC_layersDiv").style.height;
		
		if (action == "remove") {
			laTOCDiv = parseInt(laTOC_layersDivHeight.substring(0, laTOC_layersDivHeight.length-2));
			scroll = laTOCDiv - mapHeight ;
			//console.log("remove laTOCDiv " + laTOCDiv + " mapHeight " + mapHeight + " scroll " + scroll);
			
		} else {
				
			if (laTOC_layersDivHeight.indexOf("%", 0)  > -1) {
				laTOCDiv = document.getElementById("laTOC_layersDiv").offsetHeight;			
				scroll = laTOCDiv - mapHeight + laTocOffset;
				//console.log("% laTOCDiv " + laTOCDiv + " mapHeight " + mapHeight + " scroll " + scroll);	
			} else {
				laTOCDiv = parseInt(laTOC_layersDivHeight.substring(0, laTOC_layersDivHeight.length-2));
				scroll = 1;
				//console.log("numerico laTOCDiv " + laTOCDiv + " mapHeight " + mapHeight + " scroll " + scroll);
			}

		}
		
		if (scroll >= 0) {
			dim =  mapHeight-(25*5);
			
			if ((action == "remove")) {
				dim = dim - 18;
			}
			//console.log("dim (sto mettendo in px)" + dim);
			document.getElementById("laTOC_layersDiv").style.height = dim +"px";
		} else {
			//console.log("rimetto in 100%");
			document.getElementById("laTOC_layersDiv").style.height = "100%";
		}

	} else {
		//alert("Atttenzione calcolo della scrollbar della TOC non corretto ");
	}

}

function controlAddWmsLayer(idParent, url, layer, nome, layerIdx, srsDisponibili, catid){

	// CONTROLLO CHE IL SISTEMA DI RIFERIMENTO CORRENTE SIA NELLA LISTA DI SISTEMI DI RIFERIMENTO DISPONIBILI PER QUEL WMS:
	var srsArray=srsDisponibili.split(",");
	srsDisponibile=false;
	for (var i = 0; i<srsArray.length; i++) {
		if(srsGlobal==srsArray[i]){
			srsDisponibile=true;
			break;
		}
	}

	//if(!srsDisponibile){
	
	//	alert("Attenzione, il layer " + nome + " non e' disponibile nel sistema di riferimento corrente ("+srsGlobal+"). \n\nI sistemi di riferimento disponibili sono: "+srsDisponibili.substring(0, srsDisponibili.length-1)+".\n\n"+"Per caricare il layer correttamente scegliere dalla lista dei Sistemi di Riferimento in alto a destra "+"\n"+"un sistema di riferimento disponibile per questo layer" );
	
	//} else {
 
		document.getElementById(idParent).childNodes[0].className = "selected";
		
		var listaArgomenti=new Array(url, layer, nome, layerIdx, "WMS", false, catid, srsDisponibili);
		
		addLayer(idParent, listaArgomenti);
		

	//}
}


function showLayerAttributes(result) {
	var response = result.split("<|>");
	if(response.length==7){
		i=response[0];
		//newLayerSde[i].setName(response[2].replace(/ /g,"&nbsp;"));
		if(response[4]==3){
			//newLayerSde[i].download=true;
		}
		//newLayerSde[i].nome="Tabella del layer "+response[2];//.replace(/ /g,"&nbsp;");
		
		if(response[5].trim() == "true"){
			//alert(response[6].trim());
			newLayerWMS[i].setName(newLayerWMS[i].name+"&nbsp;["+response[6].trim()+"]");
			/*layerSelection=false;*/
			//newLayerWMS[i].tabella=false;
			//newLayerWMS[i].download=false;
		}
			
		//map.addLayer(newLayerSde[i]);

	}
}

function showLayerExtent(result) {
	var response = result.split(",");
	if(response.length==4){
		var minX=parseFloat(response[0]);
		var minY=parseFloat(response[1]);
		var maxX=parseFloat(response[2]);
		var maxY=parseFloat(response[3]);
		
		// RENDE L'EXTENT PROPORZIONALE AL CAMPO CARTOGRAFICO:
		var deltaX=maxX-minX;
		var deltaY=maxY-minY;
		var ratio=(map.getSize().w)/(map.getSize().h);
		var gapX=((ratio*deltaY)-deltaX)/2;
		var gapY=((ratio*deltaX)-deltaY)/2;
		
		if(deltaX<deltaY){
			minX=minX-gapX;
			maxX=maxX+gapX;
		}else{					
			minY=minY-gapY;
			maxY=maxY+gapY;
		}				
		//alert(deltaX+"---"+deltaY+"-----------"+minX+", "+minY+", "+maxX+", "+maxY);

		var newExtent=new OpenLayers.Bounds(minX, minY, maxX, maxY);

		if(srsDefault!=srsGlobal){
			var sourceProjection = new OpenLayers.Projection(srsDefault);
			var destProjection = new OpenLayers.Projection(srsGlobal);
			newExtent.transform(sourceProjection, destProjection);
		}

		map.zoomToExtent(newExtent, true);
		if(map.getScale() < 2000)
			map.zoomToScale(2500,true);

	}
}
var testoInizialeBalloon="";
var testoCoordinate="";
function getInfo(x, y, ex, ey){
	listaLayers="";
	listaWMSLayers="";
	listaWMSURLLayer="";
	listaLayersDesc="";
	listaLayersPopup="";
	listaWMSLayersPopup="";
	
	var listaWMS_layers = [];
	countWMSlayers=0;
	for (var i = map.layers.length-1; i >= 0; i--) {
		if (map.layers[i].displayInLayerSwitcher && map.layers[i].visibility && map.layers[i].tipo!="BASE" && map.layers[i].tipo!="SDE_RASTER") {
			coordX=x;
			coordY=y;
			strHref=map.layers[i].getFullRequestString(null,null);
			layers=getURLParam(strHref,"LAYERS").toUpperCase().split(".");
			if(map.layers[i].tipo=="WMS"){
				
				//listaWMSLayers=listaWMSLayers + map.layers[i].params.LAYERS + ",";
				//listaWMSURLLayer=listaWMSURLLayer + map.layers[i].url + ",";
				//listaWMSLayersPopup=listaWMSLayersPopup + "&nbsp;&nbsp;-&nbsp;" + map.layers[i].name + "<br />";

				//QUESTA DOVREBBE ESSERE UN ARRAY:
				//listaWMSURLLayer=map.layers[i];
				listaWMS_layers.push(map.layers[i]);
				countWMSlayers++;

			} else {
				
				layer=layers[0]+"."+layers[1];
				listaLayers=listaLayers + layer + "<|>";
				
				listaLayersPopup=listaLayersPopup + "&nbsp;&nbsp;-&nbsp;" + map.layers[i].name + "<br />";
				listaLayersDesc=listaLayersDesc + map.layers[i].name.replace(/&nbsp;/g," ") + "<|>";
			
			}
			
		}
				
	}
	
	testoCoordinate="<div style=\"color:#333333\">Coordinate del punto:<br />X: <strong>"+x.toFixed(coordsDigits)+"</strong> - Y: <strong>"+y.toFixed(coordsDigits)+"</strong><br /><a href=\"javascript:aggiungiPunto("+x+","+y+");\">Aggiungi punto alla mappa</a><br /><br /></div>";

	testoInizialeBalloon="<div style=\"color:#333333\">";

	if(listaWMS_layers.length > 0 || listaLayers!="") { 
			testoInizialeBalloon=testoInizialeBalloon+"<b>Ricerca informazioni in corso...</b><br /><img src=\"images/ajax-loader.gif\" />";
	}
		var anchor = {'size': new OpenLayers.Size(0,0), 'offset': new OpenLayers.Pixel(0,0)};
		
		//testoInizialeBalloon="<div style=\"color:#333333\"><b>Ricerca informazioni in corso...</b><br /><img src=\"images/ajax-loader.gif\" />";
		
		popup = new OpenLayers.Popup.FramedCloud(null,
						   new OpenLayers.LonLat(x,y),
						   new OpenLayers.Size(200,200),"&nbsp;"
						   ,
						   anchor,
						   true,null);
		
		popup.panMapIfOutOfView=true;
		popup.id="id_"+ex+"_"+ey;
		map.addPopup(popup);
				
		//aggiornaPopup(popup.id);
		
		// LAYERS SDE
		if(listaLayers!=""){
		
			//testoInizialeBalloon+=listaLayersDesc+"<br />";
			
			pixelTolerance = 4;

			searchTolerance = map.getScale()*pixelTolerance*0.00026;
			
			urlGetFeatureInfo="getElementInfo.jsp?layer=" + listaLayers + "&tabledesc=" + listaLayersDesc + "&x=" + x + "&y=" + y+"&searchTol="+searchTolerance+"&srs="+srsGlobal;
			//prompt("urlGetFeatureInfo", urlGetFeatureInfo);
			OpenLayers.loadURL(urlGetFeatureInfo, '', this, showGetInfoResults);
			
			//xmlAjaxRequest('getElementInfo.jsp', 'layer=' + listaLayers + '&tabledesc=' + listaLayersDesc + '&x=' + x + '&y=' + y+'&searchTol='+searchTolerance+'&srs='+srsGlobal, null, showInfo, 'text');

		}	

		// LAYERS WMS
		for (var i = 0; i < listaWMS_layers.length; i++) {
			//testoInizialeBalloon+=listaWMS_layers[i].name+"<br />";
			urlGetFeatureInfo="getWmsFeatureInfoRequest.jsp?url="+listaWMS_layers[i].url+"&BBOX="+map.getExtent().toBBOX()+"&WIDTH="+map.size.w+"&HEIGHT="+map.size.h+"&X="+ex+"&Y="+ey+"&SRS="+srsGlobal+"&LAYERS="+listaWMS_layers[i].params.LAYERS;
			//prompt("urlGetFeatureInfo",urlGetFeatureInfo);
			OpenLayers.loadURL(urlGetFeatureInfo, '', this, showGetInfoResults);
			
		}
		testoInizialeBalloon+="</div>";
		//popup.setContentHTML("<div onclick=\"aggiornaPopup('id_"+ex+"_"+ey+"')\">"+testoCoordinate+testoInizialeBalloon+"</div>");
		
		popup.setContentHTML("<div>"+testoCoordinate+testoInizialeBalloon+"</div>");
		newSize=new OpenLayers.Size(popup.size.w+0, popup.size.h-40);
		popup.setSize(newSize);


	//if((listaWMSLayers!="") || (listaLayers!="")) {
	//} else {
	//	alert("Non ci sono livelli interrogabili.");
	//}

}


function aggiungiPunto(x,y){
	var lonLat = new OpenLayers.LonLat(x, y);//.transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
	var size = new OpenLayers.Size(20,34);
	var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
	var icon = new OpenLayers.Icon("images/blue_Marker"+lettere[lettera]+".png",size,offset);
	if(lettera<=lettere.length)
		lettera=lettera+1;
	else
		lettera=0;
	
	layerMarkers.addMarker(new OpenLayers.Marker(lonLat,icon));
}

function showGetInfoResults(response) {
	
	if (response.responseText){
		//popup.setContentHTML("<div onclick=\"aggiornaPopup('id_"+ex+"_"+ey+"')\">"+popup.contentHTML.replace(testoInizialeBalloon,"")+"<div style=\"color:#333333\">"+response.responseText+"</div></div>");
		
		popup.setContentHTML("<div>"+popup.contentHTML.replace(testoInizialeBalloon,"")+"<div style=\"color:#333333\">"+response.responseText+"</div></div>");
		
		newSize=new OpenLayers.Size(popup.size.w, popup.size.h-30);
		popup.panMapIfOutOfView=false;
		popup.keepInMap=true; 
		popup.setSize(newSize);
		//popup.updateSize();
		
		// NON SEMBRA FUNZIONARE:
		popup.div.style.zIndex=20000; 

	}
}

/*function showInfo(result){
	if (result){
		popup.setContentHTML("<div style=\"color:#333333\">"+result+"</div>");
		newSize=new OpenLayers.Size(popup.size.w+10, popup.size.h-30);
		popup.setSize(newSize);
		//popup.updateSize();
	}
}
*/

function getURLParam(strHref,strParamName){
  var strReturn = "";
  if ( strHref.indexOf("?") > -1 ){
	var strQueryString = strHref.substr(strHref.indexOf("?"));
	var aQueryString = strQueryString.split("&");
	for ( var iParam = 0; iParam < aQueryString.length; iParam++ ){
	  if ( 
		aQueryString[iParam].indexOf(strParamName + "=") > -1 ){
		var aParam = aQueryString[iParam].split("=");
		strReturn = aParam[1];
		break;
	  }
	}
  }
  return unescape(strReturn);
}

function controllaCookies(){
	xmlAjaxRequest('getCookiesList.jsp', null , null, controllaCookiesRes, 'text');
}

function controllaCookiesRes(result){
	if (result){
		if (result!=""){
			return hs.htmlExpand(document.getElementById("salva"), {align: 'center', outlineType: 'rounded-white', wrapperClassName: 'draggable-header', objectType: 'iframe'});
		}
	}
}

function pulisciLayersSelezione(layer){
	
	var listaLayers= new Array();
	for (var i = 0; i < map.layers.length; i++) {
		if(map.layers[i].selection){
			if(map.layers[i].id.indexOf(layer)>-1){
				listaLayers.push(map.layers[i]);
			}
		}
	}
	for (var i = 0; i < listaLayers.length; i++) {
		map.removeLayer(listaLayers[i],false);
	}
}

function analizzaParametri(){

	// PARAMETRO SRS
	var srs=getURLParam(document.location.href,"srs").toUpperCase();
	
	if (!(srs == null || srs == "")) {
		if (srsGlobal != srs) {
			cambiaSrs(srs);
		
		}
	}
	
	//PARAMETRO COOKIE
	//var cookie=getURLParam(document.location.href,"cookie");
	//if(cookie !=""){
	
	// PARAMETRO BBOX
	var bbox=getURLParam(document.location.href,"bbox");
	if(bbox !=""){
		if (bbox.split(",").length==4){
			map.zoomToExtent(new OpenLayers.Bounds(parseFloat(bbox.split(",")[0]),parseFloat(bbox.split(",")[1]),parseFloat(bbox.split(",")[2]),parseFloat(bbox.split(",")[3])), true);
		} else {
			alert("Parametro bbox non corretto: "+bbox);
		}
	
	}
	
	// PARAMETRI CENTRO + SCALA
	var centro=getURLParam(document.location.href,"centro");
	var scala=getURLParam(document.location.href,"scala");
	var marker=getURLParam(document.location.href,"marker");
	if(centro != ""){
		if (centro.split(",").length==2){
			if(scala != ""){

				var ss=null;
				if(scala>=scales[0]){
					scala=scales[0];
					ss=0;
				} else {
					if (scala<=scales[scales.length-1]){
						scala=scales[scales.length-1];
						ss=scales.length-1;
					} else {
						for (var s = 0; s < scales.length-1; s++) {
							if (parseFloat(scala)<=scales[s] && parseFloat(scala)>scales[s+1]){
								
								if(scala>=(scales[s]+scales[s+1])/2){
									ss=s;
								} else {
									ss=s+1;
								}
								break;
							}
						}
					}
				}

				if(ss != null){
					var lonLat = new OpenLayers.LonLat(parseFloat(centro.split(",")[0]),parseFloat(centro.split(",")[1]));
					map.setCenter(lonLat, ss);

					if(marker=="1"){
						var size = new OpenLayers.Size(20,34);
						var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
						var icon = new OpenLayers.Icon("images/blue_Marker"+lettere[lettera]+".png",size,offset);
						
						layerMarkers.addMarker(new OpenLayers.Marker(lonLat,icon));
					}

				} else {
					alert("Parametro scala non corretto: "+scala);
				}

			} else {
				alert("Parametro scala non corretto: "+scala);
			}
		} else {
			alert("Il parametro centro "+centro+" deve essere affiancato dal parametro scala");
		}
	
	}
	
	// PARAMETRO LAYERS e SRS
	var livelli=getURLParam(document.location.href,"livelli");
		
	//livelli=BASE_USER.BASE_VF_COMUNI_POL.polygon,BASE_USER.BASE_VF_COMUNI_POL.polygon.OBJECTID@19
	//livelli=LGr1098_Wms3,




	if(livelli != ""){
		if (livelli.split(",").length>0){
			for (var layerIdx = 0; layerIdx < livelli.split(",").length; layerIdx++) {
			
				var treeId=livelli.split(",")[layerIdx].split(".")[0];
				
				//alert(livelli.split(",")[layerIdx]);
				
				if(document.getElementById(treeId)==null) {
					// NON SI TRATTA DI UN TREEID
					if(livelli.split(",")[layerIdx].split(".").length == 4){
						xmlAjaxRequest('cercaLayer.jsp', 's='+livelli.split(",")[layerIdx].split(".")[1]+'&output=id' , null, aggiungiAllaTOC, 'text', livelli.split(",")[layerIdx].split(".")[3].replace("@","="));
					} else {
						xmlAjaxRequest('cercaLayer.jsp', 's='+livelli.split(",")[layerIdx].split(".")[1]+'&output=id' , null, aggiungiAllaTOC, 'text');
					}

				} else {

					// SI TRATTA DI UN TREEID
					if(livelli.split(",")[layerIdx].split(".").length == 2){
						aggiungiAllaTOC(treeId, livelli.split(",")[layerIdx].split(".")[1].replace("@","="));
					} else {
						aggiungiAllaTOC(treeId, null);
					}
				
				}
			}
		}
	}


	
	// PARAMETRO SFONDI
	
	var sfondi=getURLParam(document.location.href,"sfondi");
	for (var layerIdx = 0; layerIdx < sfondi.split(",").length; layerIdx++) {
		for (var i = 0; i < map.layers.length; i++) {
			if(sfondi.split(",")[layerIdx]==map.layers[i].id){
				if(map.layers[i].isBaseLayer)
					map.setBaseLayer(map.layers[i]);
				else 
					map.layers[i].setVisibility(true);
				
			}
		}
	}
	
	var titolo=getURLParam(document.location.href,"titolo");
	if(titolo!=""){
		//alert(titolo);
		document.title="Geocatalogo SGSS- Mappa: "+(titolo);
	}

	var markers=getURLParam(document.location.href,"markers");
	if(markers!="")
		for (var markerIdx = 0; markerIdx < markers.split(":").length; markerIdx++) {
			punto=markers.split(":")[markerIdx].split(",");
			
			if(punto.length==2){
				if(!isNaN(punto[0]) && !isNaN(punto[1])){
					var lonLat = new OpenLayers.LonLat(punto[0], punto[1]);
					var size = new OpenLayers.Size(20,34);
					var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
					var icon = new OpenLayers.Icon("images/blue_Marker"+lettere[lettera]+".png",size,offset);
					if(lettera<=lettere.length)
						lettera=lettera+1;
					else
						lettera=0;
					
					layerMarkers.addMarker(new OpenLayers.Marker(lonLat,icon));
				}
			}
		
		}
	
	/*if(livelli != ""){
		if (livelli.split(",").length>0){
			var strRicerca="";
			for (var layerIdx = 0; layerIdx < livelli.split(",").length; layerIdx++) {

				var livelloCorrente=livelli.split(",")[layerIdx];
				//alert(livelloCorrente);
				//alert(document.getElementById(livelloCorrente).childNodes[0].href.replace("javascript:","").replace(/%20/g," "));
				
				var elemento=document.getElementById(livelloCorrente).childNodes[0];

				eval(elemento.href.replace("javascript:","").replace(/%20/g," "));

				//showsResults("LGr1303_Og939@LGr1099_Wms003");


				//if(livelloCorrente.substring(0,4)=="http"){ // E' UN WMS
				//alert(livelloCorrente.split("?")[0]+" mmmm "+livelloCorrente.split("?")[1]);
				//	controlAddWmsLayer(null, livelloCorrente.split("?")[0],livelloCorrente.split("?")[1],"nome wms",0,'EPSG:4326,EPSG:4258,EPSG:23032,EPSG:32632,EPSG:25832,');

				//} else {
				
				//	if(livelloCorrente.split(".").length>3){ // LAYER SDE CON SELEZIONE
				//		url =applicationPath+"getMap.jsp?";

				//		addLayer(null, url, livelloCorrente.replace("@","="), "nome (sel.)", layerIdx, "SDE_VECTOR", false);
					
				//	} else { // LAYER SDE SENZA SELEZIONE
				//		url =applicationPath+"getMap.jsp?";
					
				//		addLayer(null, url, livelloCorrente, "nome", layerIdx, "SDE_VECTOR", false);
					
						
				//	}
				//	strRicerca+=livelloCorrente.split(".")[1]+"@";
				//}
				
			}
			
			laTOC.maximizeControl();
			iniziaRicerca(strRicerca);
			//setTimeout("document.getElementById('risultatoricerca').style.display='none'", 500);

		}			
	}
*/

}

		
// GEOLOG: evt finisce nel campo DESCRIZIONE dell'evento, layerid e' l'ID_OGGETTO, serve nel caso del download		
var writeGeoLog=function(evt, layerid){

	// Commentato Marica 30/05/2016
	/*

	//if(map.getZoom() > 8){ // SI FILTRA NEL writeGeoLog.jsp
		listaLayersLog = new Array();
		if(layerid==null){
			for (var i = 0; i < map.layers.length; i++) {
				if(map.layers[i].catid != null && map.layers[i].visibility){
					listaLayersLog.push(map.layers[i].catid);
				}
			}
		} else {
			listaLayersLog.push(layerid);
		}
		//alert(evt);

		var estensione = map.getExtent();
		
		if(srsGlobal!=srsDefault)
			estensione.transform(new OpenLayers.Projection(srsGlobal), 	new OpenLayers.Projection(srsDefault));
		
		if(estensione.getWidth()>10 && estensione.getHeight()>10){
			var url= "writeGeoLog.jsp?APP=geocatalogo&LAYERS="+uniqueArr(listaLayersLog).toString()+"&BBOX="+estensione.toBBOX()+"&SCALE="+ map.getZoom()+"&WIDTH="+ map.size.w+"&HEIGHT="+ map.size.h+"&SRS="+map.projection+"&EVENT="+evt;
			//prompt('',"http://10.10.80.193/geologico/geocatalogo/"+url);

			OpenLayers.loadURL(url, '', this, writeGeoLogResp);	
		}
	//}
	*/
}

var writeGeoLogResp = function(response) {
	var res=response.responseText.replace(new RegExp("\n","g"),"");
	if (res.indexOf("OK")<0){
		xmlAjaxRequest('writeLog.jsp', 'tipo=error&testo=ERRORE GEOLOG: '+response.responseText, null, funzioneNulla, 'text');
	}
}

function funzioneNulla(){
}

function uniqueArr(a) {
	temp = new Array();
	for(i=0;i<a.length;i++){
		if(!contains(temp, a[i])){
			temp.length+=1;
			temp[temp.length-1]=a[i];
		}
	}
	return temp;
}
//Will check for the Uniqueness
function contains(a, e) {
	 for(j=0;j<a.length;j++)
		 if(a[j]==e)
			return true;
	 
	 return false;
} 


function aggiungiAllaTOC(id, paramSelect) { 
	
	ids=id.replace(/^\s+|\s+$/g, '').split("||");
	for (var i = 0; i < ids.length; i++) {
		if ((ids[i]) != "") {
			var elemento=document.getElementById((ids[i])).childNodes[0];
			if(paramSelect!=null)
				str=elemento.href.split("','")[0]+"','"+elemento.href.split("','")[1]+"."+paramSelect+"','"+elemento.href.split("','")[2];
			else
				str=elemento.href;

			str=str.replace("javascript:","").replace(/%20/g," ");

			eval(str);

			apriGruppo(ids[i].split("_")[0].replace("LGr",""));
		}
	}
}

OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {                
	defaultHandlerOptions: {
		'single': true,
		'double': false,
		'pixelTolerance': 0,
		'stopSingle': false,
		'stopDouble': false
	},

	initialize: function(options) {
		this.handlerOptions = OpenLayers.Util.extend(
			{}, this.defaultHandlerOptions
		);
		OpenLayers.Control.prototype.initialize.apply(
			this, arguments
		); 
		this.handler = new OpenLayers.Handler.Click(
			this, {
				'click': this.trigger
			}, this.handlerOptions
		);
	}, 

	trigger: function(e) {
		var lonlat = map.getLonLatFromViewPortPx(e.xy);
		getInfo(lonlat.lon, lonlat.lat, e.xy.x, e.xy.y);
	}

});
			

/*
Author: Robert Hashemian
http://www.hashemian.com/

You can use this code in any manner so long as the author's
name, Web address and this disclaimer is kept intact.
********************************************************
Usage Sample:

<script language="JavaScript" src="http://www.hashemian.com/js/NumberFormat.js"></script>
<script language="JavaScript">
document.write(FormatNumberBy3("1234512345.12345", ".", ","));
</script>
*/

// function to format a number with separators. returns formatted number.
// num - the number to be formatted
// decpoint - the decimal point character. if skipped, "." is used
// sep - the separator character. if skipped, "," is used
function FormatNumberBy3(num, decpoint, sep) {
  // check for missing parameters and use defaults if so
  if (arguments.length == 2) {
    sep = ",";
  }
  if (arguments.length == 1) {
    sep = ",";
    decpoint = ".";
  }
  // need a string for operations
  num = num.toString();
  // separate the whole number and the fraction if possible
  a = num.split(decpoint);
  x = a[0]; // decimal
  y = a[1]; // fraction
  z = "";


  if (typeof(x) != "undefined") {
    // reverse the digits. regexp works from left to right.
    for (i=x.length-1;i>=0;i--)
      z += x.charAt(i);
    // add seperators. but undo the trailing one, if there
    z = z.replace(/(\d{3})/g, "$1" + sep);
    if (z.slice(-sep.length) == sep)
      z = z.slice(0, -sep.length);
    x = "";
    // reverse again to get back the number
    for (i=z.length-1;i>=0;i--)
      x += z.charAt(i);
    // add the fraction back in, if it was there
    if (typeof(y) != "undefined" && y.length > 0)
      x += decpoint + y;
  }
  return x;
}

var maxZindex ;

/*function aggiornaPopup(popupid){
	//maxZindex=document.getElementById("laTOC").style.zIndex;
	
	for (var i=0; i < map.popups.length; i++) {
		if(parseInt(map.popups[i].div.style.zIndex) > maxZindex) {
			// così non incrementa se viene cliccato il popup già più in alto
			if (map.popups[i].id != popupid) {
				maxZindex=parseInt(map.popups[i].div.style.zIndex);
			}
		}
	}
	
	for (var i=0; i < map.popups.length; i++) {

		if(map.popups[i].id==popupid){
			//map.popups[i].updateSize();
			map.popups[i].div.style.zIndex=++maxZindex;
			//console.log(maxZindex);
			break;
		}
	}
}*/


function isNumber(s) {
	return (s.toString().search(/^\d+(.\d+)?$/) >= 0);
}

