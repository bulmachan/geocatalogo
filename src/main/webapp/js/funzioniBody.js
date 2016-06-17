var setSizesTimer;
function setSizes() {
	
	var arrInnerSize=getInnerSize();
	
	hs.width = arrInnerSize[0]-50;
	hs.height = arrInnerSize[1]-95-65-10//document.body.offsetHeight-50;
	hs.cacheAjax = false;

	//document.getElementById("mappa").style.height=document.getElementById("menuTree").clientHeight+"px";
	//alert(document.documentElement.clientHeight);
	
	document.getElementById("mappa").style.height=document.getElementById("menu").clientHeight+"px";
	
	//alert(parseInt(document.getElementById("menuTree").style.width));
	if(parseInt(document.getElementById("menu").style.width)){
		//alert("menu modificato: "+(document.body.offsetWidth-parseInt(document.getElementById("menuTree").style.width)));
		
		document.getElementById("mappa").style.width=(arrInnerSize[0]-parseInt(document.getElementById("menu").style.width-16))+"px"; // ok firefox
	}else{
		//alert("menu originale: "+(document.body.offsetWidth-document.getElementById("menuTree").clientWidth));
		
		document.getElementById("mappa").style.width=(arrInnerSize[0]-document.getElementById("menu").clientWidth-16)+"px"; // ok firefox
	}
	
	//alert(document.getElementById("mappa").style.width);
	setSizesTimer = setTimeout("controlToc()", 100);
	
}

function getInnerSize() {
  var myWidth = 0, myHeight = 0;
  if( typeof( window.innerWidth ) == 'number' ) {
    //Non-IE
    myWidth = window.innerWidth;
    myHeight = window.innerHeight;
  } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
    //IE 6+ in 'standards compliant mode'
    myWidth = document.documentElement.clientWidth;
    myHeight = document.documentElement.clientHeight;
  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
    //IE 4 compatible
    myWidth = document.body.clientWidth;
    myHeight = document.body.clientHeight;
  }
  ritorno=new Array();
  ritorno[0]=myWidth;
  ritorno[1]=myHeight;

  return ritorno;
}

function makeOpenLayerAccessibile() {
	var panUp = document.getElementById("OpenLayers.Control.PanZoom_5_panup_innerImage");
	panUp.setAttribute("alt", "Spostati verso l'alto");
	panUp.setAttribute("title", "Spostati verso l'alto");
	var panDown = document.getElementById("OpenLayers.Control.PanZoom_5_pandown_innerImage");
	panDown.setAttribute("alt", "Spostati verso il basso");
	panDown.setAttribute("title", "Spostati verso il basso");
	var panLeft = document.getElementById("OpenLayers.Control.PanZoom_5_panleft_innerImage");
	panLeft.setAttribute("alt", "Spostati verso sinistra");
	panLeft.setAttribute("title", "Spostati verso sinistra");
	var panRight = document.getElementById("OpenLayers.Control.PanZoom_5_panright_innerImage");
	panRight.setAttribute("alt", "Spostati verso destra");
	panRight.setAttribute("title", "Spostati verso destra");
	var zoomIn = document.getElementById("OpenLayers.Control.PanZoom_5_zoomin_innerImage");
	zoomIn.setAttribute("alt", "Zoom avanti");
	zoomIn.setAttribute("title", "Zoom avanti");
	var zoomOut = document.getElementById("OpenLayers.Control.PanZoom_5_zoomout_innerImage");
	zoomOut.setAttribute("alt", "Zoom indietro");
	zoomOut.setAttribute("title", "Zoom indietro");
	var zoomworld = document.getElementById("OpenLayers.Control.PanZoom_5_zoomworld_innerImage");
	zoomworld.setAttribute("alt", "Zoom alla massima estensione");
	zoomworld.setAttribute("title", "Zoom alla massima estensione");
	

}

//funzione che apre i link con rel="external" in una popup javascript
function externalLinks( ) {
 if (!document.getElementsByTagName) return;
 var anchors = document.getElementsByTagName("a");
 for (var i=0; i<anchors.length; i++) {
	var anchor = anchors[i];
	if (anchor.getAttribute("href") && anchor.getAttribute("rel") == "external") {
		if(anchor.title)
			anchor.title = anchor.title+" (il link apre una nuova finestra o scheda)" ;
		else
			anchor.title = "Il link apre una nuova finestra o scheda" ;
		
		anchor.onclick = function( ) { window.open( this.href ); return false; }
		anchor.onkeypress= function(e) { k = (e) ? e.keyCode : window.event.keyCode; if (k==13) window.open(this.href); return false; }
	}
 }
}

