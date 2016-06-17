
function CreaHttp() {

	var richiesta;
	var browser = navigator.appName;

	try {
		richiesta = new XMLHttpRequest();
	} catch(e) {
		var msxml = [
			'MSXML2.XMLHTTP.3.0',
			'MSXML2.XMLHTTP',
			'Microsoft.XMLHTTP'
		];
		for ( var i=0, len = msxml.length; i < len; ++i ) {
			try {
				richiesta = new ActiveXObject(msxml[i]);
				break;
			} catch(e) {}
		}
	}

	return richiesta;
}


/*
function xmlAjaxRequest(urlAjax, get, post, retFunct, retType) {

	if(window.XMLHttpRequest) {
		var http_request = new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		var http_request = new ActiveXObject("Microsoft.XMLHTTP");
	}

	http_request.onreadystatechange = function() {
		if(http_request.readyState == 4) {
			if(http_request.status == 200) {
				//alert(http_request.responseText);
				if(retType == "text") {
					if(retFunct == null) {
						if(http_request.responseText != "1")
							alert("Server error: retry later");
				
					} else {
						retFunct(http_request.responseText);
					}
				
				} else if(retType == "xml") {
					retFunct(http_request.responseXML);
				}
			
			} else {
				var errorStatus = http_request.status + '';
				alert("HTTP Error: " + errorStatus);
			}
		}
	}

	if(post == null) {
		http_request.open("GET", urlAjax + "?" + get, true);
		http_request.send(null);

	} else {
		var pieces = post.split("&");
		var parNum = pieces.length;
		http_request.open("POST", urlAjax + "?" + get, true);
		http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		http_request.setRequestHeader('Content-length',parNum);
		http_request.send(post);
	}
}
*/
function xmlAjaxRequest(urlAjax, get, post, retFunct, retType) {
	xmlAjaxRequest(urlAjax, get, post, retFunct, retType, null);
}

function xmlAjaxRequest(urlAjax, get, post, retFunct, retType, retType2) {

	if(window.XMLHttpRequest) {
		var http_request = new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		var http_request = new ActiveXObject("Microsoft.XMLHTTP");
	}

	http_request.onreadystatechange = function() {
		if(http_request.readyState == 4) {
			if(http_request.status == 200) {
				//alert(http_request.responseText);
				if(retType == "text") {
					if(retFunct == null) {
						if(http_request.responseText != "1")
							alert("Server error: retry later");
				
					} else {
						if(retType2!=null)
							retFunct(http_request.responseText, retType2);
						else
							retFunct(http_request.responseText);
					}
				
				} else if(retType == "xml") {
					if(retType2!=null)
						retFunct(http_request.responseXML, retType2);
					else
						retFunct(http_request.responseXML);

				} else if(retType == "bin") {
					if(retType2!=null)
						retFunct(http_request.response, retType2);
					else
						retFunct(http_request.response);

				}
				
				
			
			} else {
				var errorStatus = http_request.status + '';
				alert("HTTP Error: " + errorStatus);
			}
		}
	}

	if(post == null) {
		http_request.open("GET", urlAjax + "?" + get, true);
		http_request.send(null);

	} else {
		var pieces = post.split("&");
		var parNum = pieces.length;
		http_request.open("POST", urlAjax + "?" + get, true);
		http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		http_request.setRequestHeader('Content-length',parNum);
		http_request.send(post);
	}
}