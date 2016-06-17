var objPreviousLink = null;
					
//The following lines preload the menu images		
var imgPixel = new Image(31,18);
var imgLine = new Image(31,18);
var imgDocJoin = new Image(31,18);
var imgDoc = new Image(31,18);
var imgPlusOnly = new Image(31,18);
var imgMinusOnly = new Image(31,18);
var imgFolderOpen = new Image(31,18);
var imgFldrClosed = new Image(31,18);
var imgFldrClosedJoinempty = new Image(31,18);
var imgFldrClosedempty = new Image(31,18);
var imgWms = new Image(31,18);
var imgPointJoin = new Image(31,18);
var imgPoint = new Image(31,18);
var imgLinesJoin = new Image(31,18);
var imgLines = new Image(31,18);
var imgPolyJoin = new Image(31,18);
var imgPoly = new Image(31,18);
var imgRasJoin = new Image(31,18);
var imgRas = new Image(31,18);
var imgTabJoin = new Image(31,18);
var imgTab = new Image(31,18);
var imgFolderOpen = new Image(31,18);
var imgFolderPlusOnly = new Image(31,18);

imgFolderPlusOnly.src ="images/plusonly.gif";
imgFolderOpen.src ="images/folderopen.gif";
imgPixel.src = "images/pixel.gif";
imgLine.src = "images/line.gif";
//imgDocJoin.src = "images/docjoin.gif";
//imgDoc.src = "images/doc.gif";
imgPlusOnly.src = "images/plusonly.gif";
imgMinusOnly.src = "images/minusonly.gif";
imgFolderOpen.src ="images/folderopen.gif";
imgFldrClosed.src = "images/folderclosed.gif";
imgFldrClosedJoinempty.src = "images/folderclosedjoin-empty.gif";
imgFldrClosedempty.src = "images/folderclosed-empty.gif";
imgWms.src ="images/wms.gif";
imgPointJoin.src = "images/pointjoin.gif";
imgPoint.src = "images/point.gif";
imgLinesJoin.src = "images/linesjoin.gif";
imgLines.src = "images/lines.gif";
imgPolyJoin.src = "images/polyjoin.gif";
imgPoly.src = "images/poly.gif";
imgRasJoin.src = "images/rasterjoin.gif";
imgRas.src = "images/raster.gif";
imgTabJoin.src = "images/tablejoin.gif";
imgTab.src = "images/table.gif";

//This function queries the arClickedElementID[] and arAffectedMenuItemID[] arrays
//to get an object reference to the appropriate menu element to show or hide.
function fnLookupElementRef(sID, arClickedElementID, arAffectedMenuItemID)
{
	
	//modificato da marucci_f 19/11/2007

	//var i;
	//for (i=0;i<arClickedElementID.length;i++)
	//	if (arClickedElementID[i] == sID)
	//		return document.getElementById(arAffectedMenuItemID[i]);

	return document.getElementById(sID+"_TR");


								
	//return null;
}
		
//This function is responsible for showing/hiding the menu items.  It
//also switches the images accordingly
function doChangeTree(e, arClickedElementID, arAffectedMenuItemID) {
	var targetID, srcElement, targetElement;
	srcElement = e;
	
	if (srcElement != null)			
		//Only work with elements that have LEVEL in the classname
		if(srcElement.className.substr(0,5) == "LEVEL") {
			//Using the ID of the item that was clicked, we look up
			//and retrieve an object reference to the menu item that
			//should be shown or hidden
			targetElement = fnLookupElementRef(srcElement.id, arClickedElementID, arAffectedMenuItemID)		
						
			if (targetElement != null){
				fnChangeFolderStatus(srcElement, targetElement);

				//If we have a value in the MODE field, it means we are clicking
				//on a site.  We should submit the menu so we can retrieve the
				//data for that site and rebuild the tree 
				/*if (srcElement.name == 'LoadOnDemand'){
					//We submit the menu only if the tree is being expanded.  
					if (targetElement.style.display == "")
						document.frmMenu.submit();
				}*/
				
			}
		}

	resizeTree();
	
}


function resizeTree(){
	var a = document.getElementById("menu").clientWidth;
	var b = document.getElementById("0_TR").offsetWidth;
	//alert(a);
	if(a - b < 20){ // FORSE QUESTO E' DA MODIFICARE
		document.getElementById("menu").style.width=(b + 50)+"px";
		//document.getElementById("menuTree").clientWidth=(b + 50);
		document.getElementById("mappa").style.width=(document.body.offsetWidth-(b+50))+"px";
	}
	//alert(document.getElementById("menuTree").style.width);
}

//Adds the current element ID to a string stored in hidden HTML field.
//Only adds the ID if it is not already in there
function fnAddItem(objField, sElementID)
{
	var sCurrValue = objField.value;

	if (sCurrValue.indexOf(sElementID) == -1)
		objField.value = objField.value + ',' + sElementID;
}

//Removes a specific element ID from a string stored in hidden HTML field.
function fnRemoveItem(objField, sElementID)
{
	var sCurrValue = objField.value;
	var arValues = sCurrValue.split(',');
	var arNewValues = new Array(0);
	var x=0;
	
	for (i=0;i<arValues.length;i++)
		if (arValues[i] != sElementID)
		{
			arNewValues[x] = arValues[i];
			x++;
		}	
	
	sCurrValue = arNewValues.join(',');
	objField.value = sCurrValue;
}

//Opens a closed folder and closes an open folder.  This function
//is responsible for all aspects of changing the folder status.
//Attributes are as follows:
//-------------------------------
//srcElement : Object reference to the folder that should be expanded/contracted
//targetElement : Object reference to the subfolder that should be displayed/hidden
function fnChangeFolderStatus(srcElement, targetElement)
{//alert(srcElement.id+' ' +targetElement.id);
	if (srcElement != null) 
	{
		//First find out if the current folder is empty
		//We find out based on the name of the image used
		//alert(srcElement.id + " --- " + srcElement.tagName);
		if (srcElement.tagName == 'IMG')
		{
			var sImageSource = srcElement.src;
			if (sImageSource.indexOf("empty") == -1)
			{
				if (targetElement.style.display == "none")
				{
					//Our menu item is currently hidden, so display it
					targetElement.style.display = "";
					//aggiunto da marucci_f 14/11/2007:
					srcElement.title="Chiudi cartella";
					srcElement.alt="Chiudi cartella";
					document.getElementById("Nome_Cartella_"+srcElement.id).title="Chiudi cartella";
					document.getElementById("Nome_Cartella_"+srcElement.id).alt="Chiudi cartella";
					//alert(srcElement.className);
					if (srcElement.className == "LEVEL2"){
						//Set a special open-folder graphic for the root folder
						srcElement.src = imgMinusOnly.src;
						}
					else{						
						// Don't change the special open-folder graphic for WMS folder				
						if (sImageSource == imgWms.src)
							srcElement.src = imgWms.src;  // ... do nothing 						
						else
							//Otherwise, just show the standard icon
							srcElement.src = imgFolderOpen.src;							
						}
					//fnAddItem(document.frmMenu.hdnOpenFolders, srcElement.id);
				}
				else
				{
					//Our menu item is currently visible, so hide it
					targetElement.style.display = "none";
					//aggiunto da marucci_f 14/11/2007:
					srcElement.title="Apri cartella";
					srcElement.alt="Apri cartella";
					document.getElementById("Nome_Cartella_"+srcElement.id).title="Apri cartella";
					document.getElementById("Nome_Cartella_"+srcElement.id).alt="Apri cartella";
										
					if (srcElement.className == "LEVEL2"){
						//Set a special closed-folder graphic for the root folder
						srcElement.src = imgPlusOnly.src;
						}
					else{
						// Don't change the special open-folder graphic for WMS folder
						if (sImageSource == imgWms.src)
							srcElement.src = imgWms.src;  // ... do nothing 
						else		
							//Otherwise, just show the standard icon
							srcElement.src = imgFldrClosed.src;
						}	
					//fnRemoveItem(document.frmMenu.hdnOpenFolders, srcElement.id);
				}
			}
		} 
	}
}
		
//This function highlights the text of a menu item.
//It also deselects the previously
//selected menu item.  It takes three parameters: 1) an
//object reference to the selected link, and 2) an 
//object reference to the previously selected link.  The
//function returns a reference to the currently selected link.
function fnSelectItem(objSelectedLink, objPreviousLink)
{	
	var bFound = false;
				
	//If we have previously selected a menu item, deselect it
	if (objPreviousLink != null)
		fnDeselectItem(objPreviousLink);
	//Find an object reference for our TD tag
	var objTD = objSelectedLink;
	/*while (objTD.tagName!="DIV")
	{
		objTD=objTD.parentElement;
						
		if (objTD.tagName == "DIV")
			bFound = true;
	}*/
					
	//Got the TD tag reference, so now highlight the cell	
			bFound = true;
	if (bFound == true)
	{
		objTD.className = "selected";
	}
					
	//Return reference to our selected item
	//alert(objTD);
	return objSelectedLink;
}

function fnSelectItemImg(objSelectedLink, objPreviousLink)
{	
	//If we have previously selected a menu item, deselect it
	if (objPreviousLink != null)
		fnDeselectItem(objPreviousLink);

	//Find an object reference for our TD tag
	var objTD = document.getElementById('L'+objSelectedLink.id.substr(1));
	objTD.className = "selected";
					
	//Return reference to our selected item
	return objTD;
}
		

//This function removes the highlight from a
//previously selected menu item.  It takes an
//object reference to the item that needs deselecting.
function fnDeselectItem(objPreviousLink)
{
	if (objPreviousLink !=  null)
	{
		//Find an object reference for our TD tag
		var objTD = objPreviousLink;
		while (objTD.tagName!="DIV")
			objTD=objTD.parentElement;
					
		//Change the style class for the TD tag 
		//back to normal
		objTD.className = "metalink";
	}
}

function getMenuTree(){
	xmlAjaxRequest('getMenuTree.jsp', null, null, showMenuTree, 'text');
}

function showMenuTree(result) {
	contenutoHtml=result.split("<|>")[0];
	contenutoArray=result.split("<|>")[1];
	document.getElementById("menuTree").innerHTML=contenutoHtml;
	
	//alert(contenutoArray);
	var res=contenutoArray.split(",");
	for (i=0; i<res.length; i++){
		arClickedElementID.push(res[i]);
		arAffectedMenuItemID.push(res[i]+1);
	}


	if(document.location.href.indexOf("?")>0)
		analizzaParametri();
	else
		controllaCookies();


}
