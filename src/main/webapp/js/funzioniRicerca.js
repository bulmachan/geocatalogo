function trim(stringa){
	while (stringa.substring(0,1) == ' '){        
		stringa = stringa.substring(1, stringa.length);
	}
	while (stringa.substring(stringa.length-1, stringa.length) == ' '){
		stringa = stringa.substring(0,stringa.length-1);
	}
	return stringa;
}

var mostraRisultato=true;
function iniziaRicerca(s){
	if (s==null){
		s=trim(document.forms[0].q.value);
		mostraRisultato=true;
	} else {
		mostraRisultato=false;
	}
	if(s!=""){
		xmlAjaxRequest('cercaLayer.jsp', "s="+s, null, showsResults, 'text');
	}
}

function showsResults(result){

	r3=result.split("@")[2];
	r4=result.split("@")[3];
	//mostra i count

	//if (r3!='0')
	//	str=r3+" cartelle; "+r4+" layers.";
	//else
		str=r4+" layers.";

	if(mostraRisultato)
		parent.document.getElementById("risultatoricerca").innerHTML="Risultato della ricerca per <strong>"+document.forms[0].q.value+"</strong>:<br />"+str;
	
	pulisciAlbero();
	if (r3!='0' || r4 !='0'){
		
		
		//chiude l'albero 
		//chiudiAlbero();
		
		//apre l'albero
		r1=result.split("@")[0];
		p1=r1.split("||");
		for (i in p1){
			if(p1[i]!=""){
				apriGruppo(p1[i]);
			}

		}

		//seleziona gli oggetti
		r2=result.split("@")[1];
		p2=r2.split("||");
		for (i in p2){
			if(p2[i]!=""){
				if(parent.document.getElementById("L"+p2[i])) {
					if(mostraRisultato)
						parent.document.getElementById("L"+p2[i]).className="nodeselected";
					else
						parent.fnSelectItem(parent.document.getElementById("L"+p2[i]).childNodes[0],null);
				}
				if(parent.document.getElementById("F"+p2[i])) {
					if(mostraRisultato)
						parent.document.getElementById("F"+p2[i]).className="nodeselected";
					else
						parent.fnSelectItem(parent.document.getElementById("L"+p2[i]).childNodes[0],null);
				}
			}
		}
		parent.resizeTree();
	}
	
	parent.window.hs.close();

}
function apriGruppo(sGroupId){

	var ii=0
	for (ii=0;ii<=(sGroupId.length/2)-1;ii++){
		
		pGroupId=sGroupId.substr(0,2+(ii*2));
		srcElement=parent.document.getElementById(pGroupId);
		targetElement=parent.document.getElementById(pGroupId+"_TR");
		
		if (targetElement){
			targetElement.style.display= '';
			if(srcElement){
				srcElement.title="Chiudi cartella";					
				if(srcElement.className == "LEVEL2")
					srcElement.src = parent.imgFolderPlusOnly.src;
				else
					srcElement.src = parent.imgFolderOpen.src;
			}
		}
	}

}
function chiudiAlbero(){
	
	var e=parent.document.getElementsByTagName("tr");

	var imgFolderClosed = new Image(31,18);
	imgFolderClosed.src ="images/folderclosed.gif";

	var imgFolderPlusOnly = new Image(31,18);
	imgFolderPlusOnly.src ="images/plusonly.gif";

	for(i=0; i<e.length; i++)
	{
		if(e.item(i).className.substr(0,5) == "LEVEL" && e.item(i).className != "LEVEL0" ) {
			if (parent.document.getElementById(e.item(i).id.replace("_TR",""))){
				e.item(i).style.display= 'none';
				parent.document.getElementById(e.item(i).id.replace("_TR","")).title="Apri cartella";					
				
				if(parent.document.getElementById(e.item(i).id.replace("_TR","")).className == "LEVEL2")
					parent.document.getElementById(e.item(i).id.replace("_TR","")).src = imgFolderPlusOnly.src;
				else
					parent.document.getElementById(e.item(i).id.replace("_TR","")).src = imgFolderClosed.src;
			}
		}

	}

}

function pulisciAlbero(){
	var ee=parent.document.getElementsByTagName("SPAN");
	for(i=0; i<ee.length; i++){
		//alert(ee.item(i).className);
		if (ee.item(i).className=="nodeselected")
			ee.item(i).className="metalink";

	}
}

function lanciaZoom(id){
	alert(id);
}