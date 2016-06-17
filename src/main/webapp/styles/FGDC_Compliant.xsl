<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
FGDC Compliant.xsl (version 1.2)

An XSLT stylesheet based on the "FGDC Classic" metadata stylesheet included with ArcGIS
software that shows metadata elements in the Content Standard for Digital Geospatial Metadata,
FGDC-STD-001-1998 defined as "mandatory", "mandatory if applicable", and "optional" 
in DIFFERENT COLORS. Also includes metadata element definitions and domain values.
This metadata stylesheet is intended to be used to as a tool for reviewing metadata
for compliance with FGDC standards.

This stylesheet can be used to transform metadata XML documents in both ArcGIS and in
a Web browser. Supports W3C DOM compatible browsers such as IE6, Netscape 7, and Mozilla
Firefox. See related ArcScripts download, Metadata Stylesheets for the Web, for example
techiques for using XSLT stylesheets to transform metadata XML documents into HTML for
display in a Web browser. Download Metadata Stylesheets for the Web at
http://arcscripts.esri.com/details.asp?dbid=14673

NOTE: Please report any errors or bugs with "FGDC Compliant.xsl" to howies@snet.net

Installation Instructions:

1.  Copy "FGDC Compliant.xsl" to where other ArcGIS metadata stylesheets are installed
    on PC such as in C:\Program Files\ArcGIS\Metadata\Stylesheets.

Key Features:

1. Looks like the familiar "FGDC Classic" stylesheet
2. "Mandatory" metadata elements shown in RED.
3. "Mandatory if applicable" elements shown in GREEN.
4. "Optional" metadata elements shown in PURPLE.
5. Globally Hide/Show "Optional" metadata elements
6. Globally Hide/Show metadata element DEFINITIONS.
7. Globally Hide/Show metadata element DOMAINS.

Revision History:

	"FGDC Classic.xsl" -
	Copyright (c) 1999-2005, Environmental Systems Research Institute, Inc. All rights reserved
	Created 6/7/99 avienneau
	Updated 3/7/00 avienneau
	
	"FGDC Classic for Web.xsl" -		
	Modified 7/04/06 from "FGDC Classic.xsl" by Howie Sternberg:
	Supports W3C DOM compatible browsers such as IE6, Netscape 7, and Mozilla Firefox using
	Javascript for parsing text to respect line breaks in metadata when page loads:
	1.  Added window.onload function, which calls fixvalue() Javascript function.
	2.  Replaced fix() with fixvalue() and addtext() Javascript functions.
	3.  Replaced <xsl:value-of/> with <span class="normal"><xsl:value-of select="."/></span>.
	4.  Replaced XSL code for building Distribution_Information links, using position() and last().
	5.  Replaced <xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl" TYPE="text/javascript">
	    with <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	6.  Replaced <SCRIPT><xsl:comment><![CDATA[
	    with <script type="text/javascript" language="JavaScript1.3"><![CDATA[
	7.  Replaced <PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE><SCRIPT>fix(original)</SCRIPT>
	    with <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>, removing enclosing DIV elements if present.
	8.  Lowercased all HTML element and attribute names.

	"FGDC Compliant.xsl" -
	Modified 10/28/06 from "FGDC Classic for Web.xsl" by Howie Sternberg at howies@snet.net
	Highlights mandatory, mandatory if applicable, and optional FGDC metadata elements
	as defined in Content Standard for Digital Geospatial Metadata, FGDC-STD-001-1998.
	1. Removed all <i> HTML elements and used the following CSS classes to differentiate
	   metadata element by color - "mandatory", "mandatoryif", and "optional".
	2. Added <dt> special elements for displaying the metadata element definition 
	   and domains specified in Content Standard for Digital Geospatial Metadata.
	3. Added Javascript functions to hide/show the definitions and domains.
	4. Added Javascript function to hide/show optional metadata elements.
	5. Added Javascript functions to open/close certain metadata sections.
	6. Added named templates to label elements if not present in metadata such as...
		<xsl:if test="count(metadata/idinfo) = 0">
			<xsl:call-template name="no_idinfo_element"/>
		</xsl:if>
	Modified 11/23/06 (version 1.2) - Howie Sternberg at howies@snet.net
	1. Fixed bugs with Vertical_Position_Accuracy_Assessment, Vertical_Position_Accuracy_Explanation
	   and Entity_and_Attribute_Detail_Citation metadata elememnts. Also added some "- or -" and
	   "- and/or "operators between elements that were missed.

-->

<xsl:template match="/">
<html>
<head>
<style>
#definition		{font-style: italic; color: #A9A9A9; margin-top: 1px; margin-bottom: 0px; display: none;}
#domain			{font-style: italic; color: #BDb76B; margin-top: 0px; margin-bottom: 1px; display: none;}
#optional		{font-style: italic; color: #BA55D3; display: block;}
.mandatory		{font-style: italic; color: #FF0000;}
.mandatoryif	{font-style: italic; color: #7CDE7C;}
.optional		{font-style: italic; color: #BA55D3;}
.italic			{font-style: italic;}
.normal			{font-style: normal; color: #000000;}
.def			{font-style: italic; color: #A9A9A9;}
.dom			{font-style: italic; color: #BDb76B;}
.show			{cursor: pointer; color: #0000FF; text-decoration: underline;}
.showover 		{cursor: pointer; color: #0000FF; text-decoration: none;}
.open			{cursor: pointer; color: #0000FF; text-decoration: underline;}
.openover		{cursor: pointer; color: #0000FF; text-decoration: none;}
.opentarget		{background-color: #F9F9F9; display: none;}
a:link			{font-style: normal; color: #0000FF; text-decoration: underline;}
a:active		{font-style: normal; color: #0000FF; text-decoration: none;}
a:visited		{font-style: normal; color: #0000FF; text-decoration: underline;}
a:hover			{font-style: normal; color: #0000FF; text-decoration: none;}
</style>
<script type="text/javascript" language="JavaScript1.3"><![CDATA[
/* Onload - Find each <pre> element with an Id="fixvalue" and
call fixvalue() function to parse text to respect line breaks,
replace <pre> element with <div> elememt, and convert URL address
strings in text to <a href> element. */

window.onload = function() {
	elem = document.getElementById("fixvalue");
	while (Boolean(elem != null)) {
		fixvalue(elem);
		elem = document.getElementById("fixvalue");
	}
	elem = document.getElementById("clickdefinition");
	elem.onclick = showdefinition
	elem.onmouseover = overshow
	elem.onmouseout = overshow
	elem = document.getElementById("clickdomain");
	elem.onclick = showdomain
	elem.onmouseover = overshow
	elem.onmouseout = overshow
	elem = document.getElementById("clickoptional");
	elem.onclick = showoptional
	elem.onmouseover = overshow
	elem.onmouseout = overshow
	elem = document.getElementById("open");
	while (Boolean(elem != null)) {
		elem.id = "";
		elem.onclick = openclose
		elem.onmouseover = overopenclose
		elem.onmouseout = overopenclose
		elem = document.getElementById("open");
	}
	window.focus()
}
	
/* Fix value - Parse text in <pre> element to respect line breaks introduced in ArcCatalog
by the metadata author who intentionally introduced single line breaks to start new lines
or even more than one consecutive line break to further separate text to form paragraphs.
Note, fixvalue() calls the addtext() function, which adds text to DIV elements, which are
sequentially added to a parent DIV element to form separate lines and paragraphs of text. */

function fixvalue(elem) {
	elem.id = "";
	var n
	var val = String("");
	var pos = Number(0);
	// Make a newline character to use for basis for splitting string into 
	// an array of strings that are processed and turned into separate div
	// elements with either new line or paragraphic-like style.
	var newline = String.fromCharCode(10);
	var par = elem.parentNode;
	if (elem.innerText) {
		// Position of first newline character in IE
		n = elem;
		val = n.innerText;
		pos = val.indexOf(newline);
	} else {
		// Position of first newline character in NS, Firefox
		n = elem.childNodes[0];
		val = n.nodeValue;
		pos = val.indexOf(newline);
	}
	if (pos > 0) {
		// Text string contains at least one white space character
		var sValue = new String ("");
		// Split entire text string value on newline character
		// in order to create an array of string values to process	
		var aValues = val.split(newline);
		var padBottom = Number(0);
		var add = Boolean("false");
		// Loop thru each potential new line or paragraph and append <DIV>
		// element and set its className accordingly.				
		for (var i = 0; i <= aValues.length - 1; i++) {
			var div = document.createElement("DIV");
			sValue = aValues[i];
			add = false;
			for (var j = 0; j < sValue.length; j++) {
				if (sValue.charCodeAt(j) > 32) {
					add = true;
					// window.alert("CHARACTER AT " + sValue.charAt(j) + " CHARCODE " + sValue.charCodeAt(j))
					break;
				}
			}
			if (add) {
				if (i == 0) {
					// Must clone and append label property (e.g. <b>Abstract</b>) to first <DIV>
					// element, and then remove it from parent if at first element in aValues array.
					prev = elem.previousSibling;
					if (Boolean(prev != null)) {
						var label = prev.cloneNode(true)
						div.appendChild(label);
						par.removeChild(prev);
					}
				}
				// Now test to see whether to set style.paddingBottom to 0 or 4 for newline or 
				// paragraph, respectively.  Look ahead and if all characters in the next element 
				// in the aValues array (the next DIV element to make) are not white space then set
				// style.paddingBottom = 0. Otherwise, set style.paddingBottom = 4 to separate the 
				// the current <DIV> from the next <DIV> element. 			
				padBottom = Number(0);
				if (i < aValues.length - 1) {
					// Assume paragraph-like separation between DIV elements
					padBottom = Number(4);
					// Look for non-white space characters in content for next DIV
					var nextValue = aValues[i+1];
					for (var k = 0; k < nextValue.length; k++) {
						if (nextValue.charCodeAt(k) > 32) {
							// Found a non-white space character
							padBottom = Number(0);
							// window.alert("CHARACTER AT " + nextval.charAt(k) + " CHARCODE " + nextval.charCodeAt(k))
							break;
						}
					}
				}
				// Pad element
				div.style.paddingLeft = 0;
				div.style.paddingRight = 0;
				div.style.paddingTop = 0;
				div.style.paddingBottom = padBottom;
				// Scan text for URL strings before adding text to div element
				addtext(div,sValue);
				// Add new div element to parent div element
				par.appendChild(div);
			}
		}
		par.removeChild(elem);
	} else {
		// No white space charaters in text string so can be added directly to parent DIV element.
		par.removeChild(elem);
		// Scan text for URL strings before adding text to div element
		addtext(par,val);
	}		
}

/* Add text - This function adds text to (inside) DIV element, but before doing so 
searches for strings in the text that resemble URLs and converts them to hypertext
elements and adds them to the div element as well. Searches for strings that begin 
with "://" or "www." and converts them to <a href> elements. Add text function is 
called by fixvalue function */ 
 
function addtext(elem,txt) {
	// Scan entire text value and test for presense of URL strings, 
	// convert URL strings to Hypertext Elements, convert text strings
	// between URL strings to Text Nodes and append all Hypertext
	// Elements and Text Nodes to DIV element.
	var start = new Number (0);
	var end = new Number (0);
	var url = new String("");
	var urlpattern = /(\w+):\/\/([\w.]+)((\S)*)|www\.([\w.]+)((\S)*)/g;
	var punctuation = /[\.\,\;\:\?\!\[\]\(\)\{\}\'\"]/;
	var result
	var text
	while((result = urlpattern.exec(txt)) != null) {
		var fullurl = result[0];
		var protocol = result[1];
		url = fullurl;
		end = result.index;
		if (start < end){
			// Append Text Node to parent
			text = document.createTextNode(txt.substring(start, end));
			elem.appendChild(text);
		}
		var lastchar = fullurl.charAt(fullurl.length - 1);
		// Test to remove last character from url if character is punctuation mark;
		if (lastchar.match(punctuation) != null) {
			url = fullurl.substring(0,fullurl.length - 1);		
		}
		start = (result.index + url.length)
		// Test to concatinate 'http://' to url if not already begininng with 'http://"
		if (protocol == "") {
			url = "http://" + url;
		}
		// Append Hypertext (anchor) Element to parent
		text = document.createTextNode(url);
		var elemAnchor = document.createElement("A");
		elemAnchor.setAttribute("href", url);
		elemAnchor.setAttribute("target", "viewer");
		elemAnchor.appendChild(text);
		elem.appendChild(elemAnchor);				
	}
	end = txt.length;
	if (start < end) {
		// Append Text Node that follows last Hypertext Element
		text = document.createTextNode(txt.substring(start, end));
		elem.appendChild(text);
	}
}

// "show" class onmouseover and onmouseout function
function overshow(evt)  {
	// Get reference to W3C or IE event object
	evt = (evt) ? evt : ((window.event) ? event : null);
	if (evt) {
		// Get reference to element from which event object was created. W3C calls this element target. IE calls it srcElement.
		var elem = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
		if (elem.nodeType == 3) {
			// If W3C and element is text node (nodeType = 3), then get reference to container (parent) to equalize with IE event model.
			elem = elem.parentNode;
		}
		if (elem) {
			// Work with element.
			if (elem.className == "show") {
				elem.className = "showover";
			} else if (elem.className == "showover") {
				elem.className = "show";
			}
		}
		// Prevent event from bubbling past this event handler.
		evt.cancelBubble = true;
	}
}

// "open" class onmouseover and onmouseout function
function overopenclose(evt)  {
	// Get reference to W3C or IE event object
	evt = (evt) ? evt : ((window.event) ? event : null);
	if (evt) {
		// Get reference to element from which event object was created. W3C calls this element target. IE calls it srcElement.
		var elem = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
		if (elem.nodeType == 3) {
			// If W3C and element is text node (nodeType = 3), then get reference to container (parent) to equalize with IE event model.
			elem = elem.parentNode;
		}
		if (elem) {
			// Work with element.
			if (elem.className == "open") {
				elem.className = "openover";
			} else if (elem.className == "openover") {
				elem.className = "open";
			}
		}
		// Prevent event from bubbling past this event handler.
		evt.cancelBubble = true;
	}
}

// Hides and shows metadata element definitions, which are <dd id="definition" name="definition"> elements
function showdefinition(evt) {
	evt = (evt) ? evt : ((window.event) ? event : null);
	if (evt) {
		// Get reference to element from which event object was created. W3C calls this element target. IE calls it srcElement.
		var elem = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
		if (elem.nodeType == 3) {
			// If W3C and element is text node (nodeType = 3), then get reference to container (parent) to equalize with IE event model.
			elem = elem.parentNode;
		}
		if (elem) {
			// Work with element.
			var e
			var eps
			var epsps
			var aElem
			var text 
			var elemDefinition
			var elemOptional
			var styleDisplay
			var styleDisplayOptional
			elemDefinition = document.getElementById("clickdefinition");
			text = "show";
			styleDisplay = "none";
			if (elemDefinition.innerHTML == "show") {
				text = "hide";
				styleDisplay = "block";
			}
			elemOptional = document.getElementById("clickoptional");
			styleDisplayOptional = "block";
			if (elemOptional.innerHTML == "show") {
				styleDisplayOptional = "none";
			}
			aElem = document.getElementsByName("definition")
			for (var i = 0; i < aElem.length; i++) {
				e = aElem[i]				
				e.style.display = styleDisplay;
				eps = e.previousSibling;
				if (styleDisplay == "block" & eps.id == "optional") {
					e.style.display = styleDisplayOptional;
				}
				if (e.previousSibling.previousSibling) {
				    epsps = e.previousSibling.previousSibling
					if (styleDisplay == "block" & epsps.id == "optional") {
						e.style.display = styleDisplayOptional;
					}
				}
			}
			elem.innerHTML = text;
		}
	}
}

// Hides and shows metadata element domains, which are <dd id="domain" name="domain"> elements
function showdomain(evt) {
	evt = (evt) ? evt : ((window.event) ? event : null);
	if (evt) {
		// Get reference to element from which event object was created. W3C calls this element target. IE calls it srcElement.
		var elem = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
		if (elem.nodeType == 3) {
			// If W3C and element is text node (nodeType = 3), then get reference to container (parent) to equalize with IE event model.
			elem = elem.parentNode;
		}
		if (elem) {
			// Work with element.
			var e
			var epsps
			var epspsps
			var aElem
			var text 
			var elemDefinition
			var elemOptional
			var styleDisplay
			var styleDisplayOptional
			elemDefinition = document.getElementById("clickdomain");
			text = "show";
			styleDisplay = "none";
			if (elemDefinition.innerHTML == "show") {
				text = "hide";
				styleDisplay = "block";
			}
			elemOptional = document.getElementById("clickoptional");
			styleDisplayOptional = "block";
			if (elemOptional.innerHTML == "show") {
				styleDisplayOptional = "none";
			}
			aElem = document.getElementsByName("domain")
			for (var i = 0; i < aElem.length; i++) {
				e = aElem[i]				
				e.style.display = styleDisplay;
				epsps = e.previousSibling.previousSibling;
				if (styleDisplay == "block" & epsps.id == "optional") {
					e.style.display = styleDisplayOptional;
				}
				if (e.previousSibling.previousSibling.previousSibling) {
				    epspsps = e.previousSibling.previousSibling.previousSibling
					if (styleDisplay == "block" & epspsps.id == "optional") {
						e.style.display = styleDisplayOptional;
					}
				}				
			}
			elem.innerHTML = text;
		}
	}
}

// Hides and shows optional metadata elements: <div id="optional" name="optional">
function showoptional(evt) {
	evt = (evt) ? evt : ((window.event) ? event : null);
	if (evt) {
		// Get reference to element from which event object was created. W3C calls this element target. IE calls it srcElement.
		var elem = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
		if (elem.nodeType == 3) {
			// If W3C and element is text node (nodeType = 3), then get reference to container (parent) to equalize with IE event model.
			elem = elem.parentNode;
		}
		if (elem) {
			// Work with element.
			var e
			var ens
			var ensns
			var ensnsns
			var aElem
			var text
			var styleDisplay
			var styleDisplayDefinition
			var styleDisplayDomain
			text = "hide";
			styleDisplay = "block"
			if (elem.innerHTML == "hide") {
				text = "show"
				styleDisplay = "none"
			}
			elemDefinition = document.getElementById("clickdefinition");
			styleDisplayDefinition = "none";
			if (styleDisplay == "block" & elemDefinition.innerHTML == "hide") {
				styleDisplayDefinition = "block";
			}
			elemDom = document.getElementById("clickdomain");
			styleDisplayDomain = "none";
			if (styleDisplay == "block" & elemDom.innerHTML == "hide") {
				styleDisplayDomain = "block";
			}
			aElem = document.getElementsByName("optional")
			for (var i = 0; i < aElem.length; i++) {
				e = aElem[i]
				e.style.display = styleDisplay;
				ens = e.nextSibling;
				ensns = e.nextSibling.nextSibling;
				if (ens.className == "optional") {
					ens.style.display = styleDisplay;
				}
				if (ensns.className == "optional") {
					ensns.style.display = styleDisplay;
				}
				if (ens.id == "definition") {
					ens.style.display = styleDisplayDefinition;
				}
				if (ensns.id == "definition") {
					ensns.style.display = styleDisplayDefinition;
				}
				if (ensns.id == "domain") {
					ensns.style.display = styleDisplayDomain;
				}
				if (e.nextSibling.nextSibling.nextSibling) {
				    ensnsns = e.nextSibling.nextSibling.nextSibling
					if (ensnsns.id == "domain") {
						ensnsns.style.display = styleDisplayDomain;
					}
				}
			}
			elem.innerHTML = text;
		}
	}
}

// Opens and closes selected metadata compound elements: <dd class="opentarget">
function openclose(evt) {
	evt = (evt) ? evt : ((window.event) ? event : null);
	if (evt) {
		// Get reference to element from which event object was created. W3C calls this element target. IE calls it srcElement.
		var elem = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
		if (elem.nodeType == 3) {
			// If W3C and element is text node (nodeType = 3), then get reference to container (parent) to equalize with IE event model.
			elem = elem.parentNode;
		}
		if (elem) {
			var aElem
			var text 
			var e
			text = "close";
			nextElem = elem.parentNode.nextSibling.nextSibling
			if (getcomputeddisplay(nextElem) == "none") {
				nextElem.style.display = "block";
			} else {
				nextElem.style.display = "none";
				text = "open"
			}
		 	elem.innerHTML = text;
		}
	}
}

// Returns element style.display property as a text string. Returns "none" or "block".
function getcomputeddisplay(elem) {
	var dis
	if (window.getComputedStyle) {
		// W3C		
		dis = window.getComputedStyle(elem, null).display;
	} else if (elem.currentStyle) {
		// IE
		dis = elem.currentStyle.display;
	}
	return dis;
}
  ]]></script>
  </head>

  <body>

    <a name="Top"/>
    <h1><xsl:value-of select="metadata/idinfo/citation/citeinfo/title"/></h1>
    <h2>Metadata:</h2>
	
    <ul>
      <li><a href="#Identification_Information">Identification_Information</a></li>
      <li><a href="#Data_Quality_Information">Data_Quality_Information</a></li>
      <li><a href="#Spatial_Data_Organization_Information">Spatial_Data_Organization_Information</a></li>
      <li><a href="#Spatial_Reference_Information">Spatial_Reference_Information</a></li>
      <li><a href="#Entity_and_Attribute_Information">Entity_and_Attribute_Information</a></li>
      <xsl:for-each select="metadata/distinfo">
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:choose>
            <xsl:when test="position() = last()">
              <li><a><xsl:attribute name="href"><xsl:text>#Distributor</xsl:text><xsl:value-of select="position()"/></xsl:attribute>Distribution_Information</a></li>
            </xsl:when>
            <xsl:otherwise>		
              <li>Distribution_Information</li>
              <li STYLE="margin-left:0.3in">
                <a><xsl:attribute name="href"><xsl:text>#Distributor</xsl:text><xsl:value-of select="position()"/></xsl:attribute>Distributor <xsl:value-of select="position()"/></a>
              </li>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <li STYLE="margin-left:0.3in">
              <a><xsl:attribute name="href"><xsl:text>#Distributor</xsl:text><xsl:value-of select="position()"/></xsl:attribute>Distributor <xsl:value-of select="position()"/></a>
            </li>
          </xsl:otherwise>
       </xsl:choose>
      </xsl:for-each>
    <xsl:if test="count(metadata/distinfo) = 0">
      <li><a><xsl:attribute name="href"><xsl:text>#Distributor1</xsl:text></xsl:attribute>Distribution_Information</a></li>
    </xsl:if>
      <li><a href="#Metadata_Reference_Information">Metadata_Reference_Information</a></li>
    </ul>

    <h2>Metadata Elements:</h2>
    <ul>
      <li><span class="mandatory">Mandatory</span><span class="italic"> - elements must be provided.</span></li>
      <li><span class="mandatoryif">Mandatory-if-applicable</span><span class="italic"> - elements must be provided if the data set exibits the defined characteristic.</span></li>
      <li><span class="optional">Optional</span><span class="italic"> - elements are provided at the discretion of the metadata producer. <span id="clickoptional" class="show">hide</span></span></li>
    </ul>

    <ul>
      <li class="def">Definitions - <span id="clickdefinition" class="show">show</span></li>
      <li class="dom">Domains - <span id="clickdomain" class="show">show</span></li>
    </ul>

    <xsl:apply-templates select="metadata/idinfo"/>
    <xsl:if test="count(metadata/idinfo) = 0">
       <xsl:call-template name="no_idinfo_element"/>
    </xsl:if>
    <xsl:apply-templates select="metadata/dataqual"/>
    <xsl:if test="count(metadata/dataqual) = 0">
       <xsl:call-template name="no_dataqual_element"/>
    </xsl:if>
    <xsl:apply-templates select="metadata/spdoinfo"/>
    <xsl:if test="count(metadata/spdoinfo) = 0">
       <xsl:call-template name="no_spdoinfo_element"/>
    </xsl:if>
    <xsl:apply-templates select="metadata/spref"/>
    <xsl:if test="count(metadata/spref) = 0">
       <xsl:call-template name="no_spref_element"/>
    </xsl:if>
    <xsl:apply-templates select="metadata/eainfo"/>
    <xsl:if test="count(metadata/eainfo) = 0">
       <xsl:call-template name="no_eainfo_element"/>
    </xsl:if>
    <xsl:apply-templates select="metadata/distinfo"/>
    <xsl:if test="count(metadata/distinfo) = 0">
       <xsl:call-template name="no_distinfo_element"/>
    </xsl:if>
    <xsl:apply-templates select="metadata/metainfo"/>
    <xsl:if test="count(metadata/metainfo) = 0">
      <xsl:call-template name="no_metadata_element"/>
    </xsl:if>

  </body>
  </html>
</xsl:template>

<!-- Identification -->
<xsl:template match="idinfo">
  <a name="Identification_Information"><hr/></a>
  <dl>
    <dt class="mandatory">Identification_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Basic information about the data set.</dd>
    <dd>
    <dl>

      <dt class="mandatory">Citation</dt>
      <dd id="definition" name="definition">Information to be used to reference the data set.</dd>
      <xsl:if test="count(citation) = 0">
        <dd>
        <dl>
          <xsl:call-template name="no_citeinfo_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="citation">
        <dd>
        <dl>
          <xsl:if test="count(citeinfo) = 0">
             <xsl:call-template name="no_citeinfo_element"/>
          </xsl:if>
          <xsl:apply-templates select="citeinfo"/>
        </dl>
        </dd>
      </xsl:for-each>

        <dt class="mandatory">Description</dt>
        <dd id="definition" name="definition">A characterization of the data set, including its intended use and limitations.</dd>
        <xsl:if test="count(descript) = 0">
        <dd>
        <dl>
          <xsl:call-template name="no_descript_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="descript">
        <dd>
        <dl>
          <dt class="mandatory">Abstract: </dt>
          <xsl:for-each select="abstract">
            <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: A brief narrative summary of the data set.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
          <dt class="mandatory">Purpose: </dt>
          <xsl:for-each select="purpose">
            <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: A summary of the intentions with which the data set was developed.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
          <dt id="optional" name="optional">Supplemental_Information: </dt>
          <xsl:for-each select="supplinf">
            <dd class="optional"><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: Other descriptive information about the data set.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatory">Time_Period_of_Content</dt>
      <dd id="definition" name="definition">Time periods(s) for which the data set corresponds to the currentness reference.</dd>
      <xsl:if test="count(timeperd) = 0">
        <dd>
        <dl>
          <xsl:call-template name="no_timeinfo_element"/>
          <dt class="mandatory">Currentness_Reference: </dt>
          <dd id="definition" name="definition">Definition: The basis on which the time period of content information is determined.</dd>
          <dd id="domain" name="domain">Domain: "ground condition", "publication date", free text</dd>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="timeperd">
        <dd>
        <dl>
          <xsl:if test="count(timeinfo) = 0">
            <xsl:call-template name="no_timeinfo_element"/>
          </xsl:if>
          <xsl:apply-templates select="timeinfo"/>
          <dt class="mandatory">Currentness_Reference: </dt>
          <xsl:for-each select="current">
            <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: The basis on which the time period of content information is determined.</dd>
          <dd id="domain" name="domain">Domain: "ground condition", "publication date", free text</dd>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatory">Status</dt>
      <dd id="definition" name="definition">The state of and maintenance information for the data set.</dd>
      <xsl:if test="count(status) = 0">
        <dd>
        <dl>
          <xsl:call-template name="no_status_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="status">
        <dd>
        <dl>
          <dt class="mandatory">Progress:
          <xsl:for-each select="progress">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: The state of the data set.</dd>
          <dd id="domain" name="domain">Domain: "Complete", "In work", "Planned"</dd>
          <dt class="mandatory">Maintenance_and_Update_Frequency: 
          <xsl:for-each select="update">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: The frequency with which changes and additions are made to the data set after the initial data set is completed.</dd>
          <dd id="domain" name="domain">Domain: "Continually", "Daily", "Weekly", "Monthly", "Annually", "Unknown", "As needed", "Irregular", "None planned", free text</dd>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatory">Spatial_Domain</dt>
      <dd id="definition" name="definition">The geographic areal domain of the data set.</dd>
      <xsl:if test="count(spdom) = 0">
        <dd>
        <dl>
          <xsl:call-template name="no_spdom_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="spdom">
        <dd>
        <dl>
          <dt class="mandatory">Bounding_Coordinates</dt>
          <dd id="definition" name="definition">The limits of coverage of a data set expresed by latitude and longitude values in the order western-most, eastern-most, northern-most, and southern-most. For data sets that include a complete band of latitude and longitude around the earth, the West Bounding Coordinates shall be assigned the value -180.0, and the East Bounding Coordinate shall be assigned the value 180.0</dd>
          <xsl:if test="count(bounding) = 0">
            <xsl:call-template name="no_bounding_element"/>
          </xsl:if>
          <xsl:for-each select="bounding">
            <dd>
            <dl>
              <dt class="mandatory">West_Bounding_Coordinate: <span class="normal"><xsl:value-of select="westbc"/></span></dt>
              <dd id="definition" name="definition">Western-most coordinate of the limit of coverages expressed in longitude.</dd>
              <dd id="domain" name="domain">Domain: -180.0 &lt;= West Bonding Coordinate &lt;= 180.0</dd>
              <dt class="mandatory">East_Bounding_Coordinate: <span class="normal"><xsl:value-of select="eastbc"/></span></dt>
              <dd id="definition" name="definition">Eastern-most coordinate of the limit of coverages expressed in longitude.</dd>
              <dd id="domain" name="domain">Domain: -180.0 &lt;= East Bonding Coordinate &lt;= 180.0</dd>
              <dt class="mandatory">North_Bounding_Coordinate: <span class="normal"><xsl:value-of select="northbc"/></span></dt>
              <dd id="definition" name="definition">Northern-most coordinate of the limit of coverages expressed in latitude.</dd>
              <dd id="domain" name="domain">Domain: -90.0 &lt;= North Bonding Coordinate &lt;= 90.0; North Bounding Coordinate &gt;= South Bounding Coordinate</dd>
              <dt class="mandatory">South_Bounding_Coordinate: <span class="normal"><xsl:value-of select="southbc"/></span></dt>
              <dd id="definition" name="definition">Southern-most coordinate of the limit of coverages expressed in latitude.</dd>
              <dd id="domain" name="domain">Domain: -90.0 &lt;= South Bonding Coordinate &lt;= 90.0; South Bounding Coordinate &lt;= North Bounding Coordinate</dd>
            </dl>
            </dd>
          </xsl:for-each>
          <xsl:if test="count(dsgpoly) = 0">
            <dt id="optional" name="optional">Data_Set_G-Polygon</dt>
            <dd id="definition" name="definition">Coordinates defining the outline of an area covered by a data set.</dd>
            <dd class="optional">
            <dl>
              <dt class="mandatory">Data_Set_G-Polygon_Outer_G-Ring</dt>
              <dd id="definition" name="definition">The closed non-intersecting boundary of an interior area.</dd>
                <dd>
                <dl>
                    <xsl:call-template name="no_grngpoin_element"/>
                    <dt class="normal">- or -</dt>
                    <xsl:call-template name="no_gring_element"/>
                </dl>
                </dd>
              <dt class="mandatoryif">Data_Set_G-Polygon_Exclusion_G-Ring</dt>
              <dd id="definition" name="definition">The closed non-intersecting boundary of a void area (or "hole" in an interior area).</dd>
                <dd>
                <dl>
                    <xsl:call-template name="no_grngpoin_element"/>
                    <dt class="normal">- or -</dt>
                    <xsl:call-template name="no_gring_element"/>
                </dl>
                </dd>
            </dl>
            </dd>
          </xsl:if>
          <xsl:for-each select="dsgpoly">
            <dt id="optional" name="optional">Data_Set_G-Polygon</dt>
            <dd id="definition" name="definition">Coordinates defining the outline of an area covered by a data set.</dd>
            <dd class="optional">
            <dl>
              <xsl:if test="count(dsgpolyo) = 0">
                <dt class="mandatory">Data_Set_G-Polygon_Outer_G-Ring: </dt>
                <dd id="definition" name="definition">The closed non-intersecting boundary of an interior area.</dd>
                <dd>
                <dl>
                    <xsl:call-template name="no_grngpoin_element"/>
                    <dt class="normal">- or -</dt>
                    <xsl:call-template name="no_gring_element"/>
                </dl>
                </dd>
              </xsl:if>
              <xsl:for-each select="dsgpolyo">
                <dt class="mandatory">Data_Set_G-Polygon_Outer_G-Ring</dt>
                <dd id="definition" name="definition">The closed non-intersecting boundary of an interior area.</dd>
                <dd>
                <dl>
                  <xsl:if test="count(grngpoin) = 0">
                    <xsl:call-template name="no_grngpoin_element"/>
                  </xsl:if>
                  <xsl:apply-templates select="grngpoin"/>
                  <dt class="normal">- or -</dt>
                  <xsl:if test="count(gring) = 0">
                    <xsl:call-template name="no_gring_element"/>
                  </xsl:if>
                  <xsl:apply-templates select="gring"/>
                </dl>
                </dd>
              </xsl:for-each>
              <xsl:if test="count(dsgpolyx) = 0">
                <dt class="mandatoryif">Data_Set_G-Polygon_Exclusion_G-Ring</dt>
                <dd id="definition" name="definition">The closed non-intersecting boundary of a void area (or "hole" in an interior area).</dd>
                <dd>
                <dl>
                    <xsl:call-template name="no_grngpoin_element"/>
                    <dt class="normal">- or -</dt>
                    <xsl:call-template name="no_gring_element"/>
                </dl>
                </dd>
              </xsl:if>
              <xsl:for-each select="dsgpolyx">
                <dt class="mandatoryif">Data_Set_G-Polygon_Exclusion_G-Ring</dt>
                <dd id="definition" name="definition">The closed non-intersecting boundary of a void area (or "hole" in an interior area).</dd>
                <dd>
                <dl>
                  <xsl:if test="count(grngpoin) = 0">
                    <xsl:call-template name="no_grngpoin_element"/>
                  </xsl:if>
                  <xsl:apply-templates select="grngpoin"/>
                  <dt class="normal">- or -</dt>
                  <xsl:if test="count(gring) = 0">
                    <xsl:call-template name="no_gring_element"/>
                  </xsl:if>
                  <xsl:apply-templates select="gring"/>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatory">Keywords</dt>
      <dd id="definition" name="definition">Words or phrases summarizing an aspect of the data set.</dd>
      <xsl:if test="count(keywords) = 0">
         <xsl:call-template name="no_keywords_element"/>
      </xsl:if>
      <xsl:for-each select="keywords">
        <dd>
        <dl>
          <xsl:if test="count(theme) = 0">
             <xsl:call-template name="no_theme_element"/>
          </xsl:if>
          <xsl:for-each select="theme">
          <dt class="mandatory">Theme</dt>
          <dd id="definition" name="definition">Subjects covered by the data set (for a list of some commonly-used thesauri, see Part IV: Subject/index terms in Network Development and MARK Standards Office, 1988, USMARC code list for relators, sources, and description conventions: Washington Library of Congress).</dd>
            <dd>
            <dl>
              <xsl:if test="count(themekt) = 0">
                <dt class="mandatory">Theme_Keyword_Thesaurus: </dt>
              </xsl:if>
              <xsl:for-each select="themekt">
                <dt class="mandatory">Theme_Keyword_Thesaurus: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: Reference to a formally registered thesaurus or a similar authoritative source of theme keywords.</dd>
              <dd id="domain" name="domain">Domain: "None", free text</dd>
              <xsl:if test="count(themekey) = 0">
                <dt class="mandatory">Theme_Keyword: </dt>
              </xsl:if>
              <xsl:for-each select="themekey">
                <dt class="mandatory">Theme_Keyword: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: Common-use word or phrase used to describe the subject of the data set.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
            </dl>
            </dd>
          </xsl:for-each>
          <xsl:if test="count(place) = 0">
             <xsl:call-template name="no_place_element"/>
          </xsl:if>
          <xsl:for-each select="place">
          <dt class="mandatoryif">Place</dt>
          <dd id="definition" name="definition">Geographic locations characterized by the data set.</dd>
            <dd>
            <dl>
              <xsl:if test="count(placekt) = 0">
                <dt class="mandatory">Place_Keyword_Thesaurus: </dt>
              </xsl:if>
              <xsl:for-each select="placekt">
                <dt class="mandatory">Place_Keyword_Thesaurus: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: Reference to a formally registered thesaurus or a similar authoritative source of place keywords.</dd>
              <dd id="domain" name="domain">Domain: "None", free text</dd>
              <xsl:if test="count(placekey) = 0">
                <dt class="mandatory">Place_Keyword: </dt>
              </xsl:if>
              <xsl:for-each select="placekey">
                <dt class="mandatory">Place_Keyword: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Defition: The geographic name of a location covered by a data set.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
            </dl>
            </dd>
          </xsl:for-each>
          <xsl:if test="count(stratum) = 0">
             <xsl:call-template name="no_stratum_element"/>
          </xsl:if>
          <xsl:for-each select="stratum">
          <dt class="mandatoryif">Stratum</dt>
          <dd id="definition" name="definition">Layered, vertical locations characterized by the data set.</dd>
            <dd>
            <dl>
              <xsl:if test="count(stratkt) = 0">
                <dt class="mandatory">Stratum_Keyword_Thesaurus: </dt>
              </xsl:if>
              <xsl:for-each select="stratkt">
                <dt class="mandatory">Stratum_Keyword_Thesaurus: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: Reference to a formally registered thesaurus or a similar authoritative source of stratum keywords.</dd>
              <dd id="domain" name="domain">Domain: "None", free text</dd>
              <xsl:if test="count(stratkey) = 0">
                <dt class="mandatory">Stratum_Keyword: </dt>
              </xsl:if>
              <xsl:for-each select="stratkey">
                <dt class="mandatory">Stratum_Keyword: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The name of a vertical location used to describe the locations covered by a data set.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
            </dl>
            </dd>
          </xsl:for-each>
          <xsl:if test="count(temporal) = 0">
             <xsl:call-template name="no_temporal_element"/>
          </xsl:if>
          <xsl:for-each select="temporal">
          <dt class="mandatoryif">Temporal</dt>
          <dd id="definition" name="definition">Time period(s) covered by the data set.</dd>
            <dd>
            <dl>
              <xsl:if test="count(tempkt) = 0">
                <dt class="mandatory">Temporal_Keyword_Thesaurus: </dt>
              </xsl:if>
              <xsl:for-each select="tempkt">
                <dt class="mandatory">Temporal_Keyword_Thesaurus: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: Reference to a formally registered thesaurus or a similar authoritative source of temporal keywords.</dd>
              <dd id="domain" name="domain">Domain: "None", free text</dd>
              <xsl:if test="count(tempkey) = 0">
                <dt class="mandatory">Temporal_Keyword: </dt>
              </xsl:if>
              <xsl:for-each select="tempkey">
                <dt class="mandatory">Temporal_Keyword: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The name of a time period covered by a data set.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatory">Access_Constraints: 
      <xsl:for-each select="accconst">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
        <dd id="definition" name="definition">Definition: Restrictions and legal prerequisites for accessing the data set. These include any access constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations on obtaining the data set.</dd>
        <dd id="domain" name="domain">Domain: "None", free text</dd>
      <dt class="mandatory">Use_Constraints: </dt>
      <xsl:for-each select="useconst">
        <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
      </xsl:for-each>
        <dd id="definition" name="definition">Definition: Restrictions and legal prerequisites for using the data set after access is granted. These include any use constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations on using the data set.</dd>
        <dd id="domain" name="domain">Domain: "None", free text</dd>

      <xsl:if test="count(ptcontac) = 0">
        <dt id="optional" name="optional">Point_of_Contact</dt>
        <dd id="definition" name="definition">Definition: Contact information for an individual or organization that is knowledgeable about the data set.</dd>
        <dd class="optional">
        <dl>
          <xsl:call-template name="no_cntinfo_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="ptcontac">
        <dt id="optional" name="optional">Point_of_Contact</dt>
        <dd id="definition" name="definition">Definition: Contact information for an individual or organization that is knowledgeable about the data set.</dd>
        <dd class="optional">
        <dl>
        <xsl:if test="count(cntinfo) = 0">
          <xsl:call-template name="no_cntinfo_element"/>
        </xsl:if>
          <xsl:apply-templates select="cntinfo"/>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:if test="count(browse) = 0">
         <xsl:call-template name="no_browse_element"/>
      </xsl:if>
      <xsl:for-each select="browse">
      <dt id="optional" name="optional">Browse_Graphic</dt>
      <dd id="definition" name="definition">A graphic that provides an illustration of the data set. The graphic should include a legend for interpreting the graphic.</dd>
        <dd class="optional">
        <dl>
          <dt class="mandatory">Browse_Graphic_File_Name: 
          <xsl:for-each select="browsen">
            <a target="viewer">
              <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a>
          </xsl:for-each>
          </dt>
            <dd id="definition" name="definition">Definition: Name of the related graphic file that provides an illustration of the data set.</dd>
            <dd id="domain" name="domain">Domain: free text</dd>
          <dt class="mandatory">Browse_Graphic_File_Description: </dt>
          <xsl:for-each select="browsed">
            <dd><span class="normal"><xsl:value-of select="."/></span></dd>
          </xsl:for-each>
            <dd id="definition" name="definition">Definition: A text description of the illustration.</dd>
            <dd id="domain" name="domain">Domain: free text</dd>
          <dt class="mandatory">Browse_Graphic_File_Type:  
          <xsl:for-each select="browset">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
           <dd id="definition" name="definition">Definition: Graphic file type of a related graphic file.</dd>
           <dd id="domain" name="domain">Domain: '"CGM", "EPS", "EMF", "GIF", "JPEG", "PBM", "PS", "TIFF", WMF", "XWD", free text</dd>
        </dl>
        </dd>
      </xsl:for-each>

      <dt id="optional" name="optional">Data_Set_Credit: </dt>
      <xsl:for-each select="datacred">
        <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: Recognition of those who contributed to the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <xsl:if test="count(secinfo) = 0">
         <xsl:call-template name="no_secinfo_element"/>
      </xsl:if>
      <xsl:for-each select="secinfo">
      <dt id="optional" name="optional">Security_Information</dt>
      <dd id="definition" name="definition">Definition: Handling restrictions imposed on the data set because of national security, privacy or other concerns.</dd>
        <dd class="optional">
        <dl>
          <dt class="mandatory">Security_Classification_System: 
          <xsl:for-each select="secsys">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
            <dd id="definition" name="definition">Definition: Name of the classification system.</dd>
            <dd id="domain" name="domain">Domain: free text</dd>
          <dt class="mandatory">Security_Classification: 
          <xsl:for-each select="secclass">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
            <dd id="definition" name="definition">Definition: Name of the handling restrictions on the data set.</dd>
            <dd id="domain" name="domain">Domain: "Top secret", "Secret", "Confidential", "Restricted", "Unclassified", "Sensitive", free text</dd>
          <dt class="mandatory">Security_Handling_Description: 
          <xsl:for-each select="sechandl">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
            <dd id="definition" name="definition">Definition: Additional information about the restrictions on handling the data set.</dd>
            <dd id="domain" name="domain">Domain: free text</dd>
        </dl>
        </dd>
      </xsl:for-each>

      <dt id="optional" name="optional">Native_Data_Set_Environment: </dt>
      <xsl:for-each select="native">
        <dd class="optional"><span class="normal"><xsl:value-of select="."/></span></dd>
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: A description of the data set in the producer's processing environment, including items such as the name of the software, (including version), the computer operating system, filename (including host-, path-, and filenames), and the data set size.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <xsl:if test="count(crossref) = 0">
        <xsl:call-template name="no_crossref_element"/>
      </xsl:if>
      <xsl:for-each select="crossref">
      <dt id="optional" name="optional">Cross_Reference: </dt>
      <dd id="definition" name="definition">Information about other, related data sets that are likely to be of interest.</dd>
        <dd>
        <dl class="optional">
          <xsl:apply-templates select="citeinfo"/>
        </dl>
        </dd>
      </xsl:for-each>

    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- Data Quality -->
<xsl:template match="dataqual">
  <a name="Data_Quality_Information"><hr/></a>
  <dl>
    <dt class="mandatoryif">Data_Quality_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">A general assessment of the quality of the data set. (Recommendations on information to be reported and test to be performed are found in "Spatial Data Quality," which is chapter 3 of part 1 in Department of Commerce, 1992, Spatial Data Transfer Standard (SDTS) (Federal Information Processing Standard 173): Washington, Department of Commerce, National Institute of Standards and Technology.)</dd>
    <dd>
    <dl>
      <xsl:if test="count(attracc) = 0">
        <xsl:call-template name="no_attracc_element"/>
      </xsl:if>
      <xsl:for-each select="attracc">
        <dt class="mandatoryif">Attribute_Accuracy</dt>
        <dd id="definition" name="definition">An assessment of the accuracy of the identification of entities and the assignment of attribute values in the data set.</dd>
        <dd>
        <dl>
          <dt class="mandatory">Attribute_Accuracy_Report: </dt>
          <xsl:for-each select="attraccr">
            <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: An explanation of the accuracy of the identification of the entities and assignments of values in the data set and a description of the tests used.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
          <xsl:if test="count(qattracc) = 0">
            <xsl:call-template name="no_qattracc_element"/>
          </xsl:if>
          <xsl:for-each select="qattracc">
            <dt id="optional" name="optional">Quantitative_Attribute_Accuracy_Assessment</dt>
            <dd id="definition" name="definition">A value assigned to summarize the accuracy of the identification of the entities and the assignment of values in the data set and the identification of the test that yielded the value.</dd>
            <dd class="optional">
            <dl>
              <dt class="mandatory">Attribute_Accuracy_Value: 
              <xsl:for-each select="attraccv">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: An estimate of the accuracy of the identification of the entities and assignments of attributes in the data set.</dd>
              <dd id="domain" name="domain">Domain: "Unknown", free text</dd>
              <dt class="mandatory">Attribute_Accuracy_Explanation: </dt>
              <xsl:for-each select="attracce">
                <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The identification of the test that yielded the Attribute Accuracy Value.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatory">Logical_Consistency_Report: </dt>
      <xsl:for-each select="logic">
        <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>     
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: An explanation of the fidelity of relationships in the data set and tests used.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <dt class="mandatory">Completeness_Report: </dt>
      <xsl:for-each select="complete">
        <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>     
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: Information about omissions, selection criteria, generalization, definitions used, and other rules used to derive the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <xsl:if test="count(posacc) = 0">
        <dt class="mandatoryif">Positional_Accuracy</dt>
        <dd id="definition" name="definition">An assessment of the accuracy of the positions of spatial objects.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_horizpa_element"/>
          <xsl:call-template name="no_vertacc_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="posacc">
        <dt class="mandatoryif">Positional_Accuracy</dt>
        <dd id="definition" name="definition">An assessment of the accuracy of the positions of spatial objects.</dd>

        <dd>
        <dl>
          <xsl:if test="count(horizpa) = 0">
            <xsl:call-template name="no_horizpa_element"/>
          </xsl:if>
          <xsl:for-each select="horizpa">
            <dt class="mandatoryif">Horizontal_Positional_Accuracy</dt>
            <dd id="definition" name="definition">An estimate of accuracy of the horizontal positions of the spatial objects.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Horizontal_Positional_Accuracy_Report: </dt>
              <xsl:for-each select="horizpar">
                <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: An explanation of the accuracy of the horizontal coordinate measurements and a description of the tests used.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <xsl:if test="count(qhorizpa) = 0">
                <xsl:call-template name="no_qhorizpa_element"/>
              </xsl:if>
              <xsl:for-each select="qhorizpa">
                <dt id="optional" name="optional">Quantitative_Horizontal_Positional_Accuracy_Assessment</dt>
                <dd id="definition" name="definition">Numeric value assigned to summarize the accuracy of the horizontal coordinate measurements and the identification of the test that yielded the value.</dd>
                <dd class="optional">
                <dl>
                  <dt class="mandatory">Horizontal_Positional_Accuracy_Value: 
                  <xsl:for-each select="horizpav">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: An estimate of the accuracy of the horizontal coordinate measurements in the data set expressed in (ground) meters.</dd>
                  <dd id="domain" name="domain">Domain: free real</dd>
                  <dt class="mandatory">Horizontal_Positional_Accuracy_Explanation: </dt>
                  <xsl:for-each select="horizpae">
                    <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: The identification of the test that yielded the Horizontal Positional Accuracy Value.</dd>
                  <dd id="domain" name="domain">Domain: free text</dd>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
          <xsl:if test="count(vertacc) = 0">
            <xsl:call-template name="no_vertacc_element"/>
          </xsl:if>
          <xsl:for-each select="vertacc">
            <dt class="mandatoryif">Vertical_Positional_Accuracy</dt>
            <dd id="definition" name="definition">An estimate of accuracy of the vertical positions in the data set.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Vertical_Positional_Accuracy_Report: </dt>
              <xsl:for-each select="vertaccr">
                <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: An estimation of the accuracy of the vertical coordinate measurements and a description of the tests used.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <xsl:if test="count(qvertpa) = 0">
                <xsl:call-template name="no_qvertpa_element"/>
              </xsl:if>
              <xsl:for-each select="qvertpa">
                <dt id="optional" name="optional">Quantitative_Vertical_Positional_Accuracy_Assessment</dt>
                <dd id="definition" name="definition">Numeric value assigned to summarize the accuracy of vertical coordinate measurements and the identification of the test that yielded the value.</dd>
                <dd class="optional">
                <dl>
                  <xsl:for-each select="vertaccv">
                    <dt class="mandatory">Vertical_Positional_Accuracy_Value: <span class="normal"><xsl:value-of select="."/></span></dt>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: An estimate of the accuracy of the vertical coordinate measurements in the data set expressed in (ground) meters.</dd>
                  <dd id="domain" name="domain">Domain: free real</dd>
                  <dt class="mandatory">Vertical_Positional_Accuracy_Explanation: </dt>
                  <xsl:for-each select="vertacce">
                    <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: The identification of the test that yielded the Vertical Postional Accuracy Value.</dd>
                  <dd id="domain" name="domain">Domain: free text</dd>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:if test="count(lineage) = 0">
        <dt class="mandatory">Lineage</dt>
        <dd id="definition" name="definition">Information about the events, parameters, and source data which constructed the data set, and information about the responsible parties.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_srcinfo_element"/>
          <xsl:call-template name="no_procstep_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="lineage">
        <dt class="mandatory">Lineage</dt>
        <dd id="definition" name="definition">Information about the events, parameters, and source data which constructed the data set, and information about the responsible parties.</dd>
        <dd>
        <dl>

          <xsl:if test="count(srcinfo) = 0">
            <xsl:call-template name="no_srcinfo_element"/>
          </xsl:if>
          <xsl:for-each select="srcinfo">
            <dt class="mandatoryif">Source_Information</dt>
            <dd id="definition" name="definition">List of sources and a short discussion of the information contributed by each.</dd>
            <dd>
            <dl>
              <xsl:if test="count(srccite) = 0">
                <dt class="mandatory">Source_Citation <span id="open" class="open">open</span></dt>
                <dd id="definition" name="definition">Reference for a source data set.</dd>
                <dd class="opentarget">
                <dl>
                  <xsl:call-template name="no_citeinfo_element"/>
                </dl>
                </dd>
              </xsl:if>
              <xsl:for-each select="srccite">
                <dt class="mandatory">Source_Citation</dt>
                <dd id="definition" name="definition">Reference for a source data set.</dd>
                <dd>
                <dl>
                  <xsl:apply-templates select="citeinfo"/>
                </dl>
                </dd>
              </xsl:for-each>
              <dt class="mandatoryif">Source_Scale_Denominator:  
              <xsl:for-each select="srcscale">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The denominator of the representative fraction on a map (for example, on a 1:24,000-scale map, the Source Scale Denominator is 24000).</dd>
              <dd id="domain" name="domain">Domain: Source Scale Denominator &gt; 1</dd>
              <dt class="mandatory">Type_of_Source_Media:  
               <xsl:for-each select="typesrc">
               <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The medium of the source data set.</dd>
              <dd id="domain" name="domain">Domain: "paper", "stable-based material", "microfiche", "microfilm", "audiocassette", "chart", "filmstrip", "transparency", "videocassette", "videodisc", "videotape", "physical model", "computer program", "disc", "cartridge tape" "magnetic tape", "online", "CD-ROM", "electronic bulletin board", "electronic mail system", free text</dd>

              <xsl:if test="count(srctime) = 0">
                <dt class="mandatory">Source_Time_Period_of_Content</dt>
                <dd id="definition" name="definition">Time period(s) for which the source data set corresponds to the ground.</dd>
                <dd>
                <dl>
                  <xsl:call-template name="no_timeinfo_element"/>
                  <dt class="mandatory">Source_Currentness_Reference: </dt>
                  <dd id="definition" name="definition">Definition: The basis on which the source time period of content information of the source data set is determined.</dd>
                  <dd id="domain" name="domain">Domain: "ground condition", "publication date", free text</dd>
                </dl>
                </dd>
              </xsl:if>
              <xsl:for-each select="srctime">
                <dt class="mandatory">Source_Time_Period_of_Content</dt>
                <dd id="definition" name="definition">Time period(s) for which the source data set corresponds to the ground.</dd>
                <dd>
                <dl>
                  <xsl:if test="count(timeinfo) = 0">
                    <xsl:call-template name="no_timeinfo_element"/>
                  </xsl:if>
                  <xsl:apply-templates select="timeinfo"/>
                  <dt class="mandatory">Source_Currentness_Reference: </dt>
                  <xsl:for-each select="srccurr">
                    <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: The basis on which the source time period of content information of the source data set is determined.</dd>
                  <dd id="domain" name="domain">Domain: "ground condition", "publication date", free text</dd>
                </dl>
                </dd>
              </xsl:for-each>
              <dt class="mandatory">Source_Citation_Abbreviation: </dt>
              <xsl:for-each select="srccitea">
                <dd><span class="normal"><xsl:value-of select="."/></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: Short form alias for the source citation.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <dt class="mandatory">Source_Contribution: </dt>
              <xsl:for-each select="srccontr">
                <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: Brief statement identifying the information contributed by the source to the data set.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
            </dl>
            </dd>
          </xsl:for-each>

          <xsl:if test="count(procstep) = 0">
            <xsl:call-template name="no_procstep_element"/>
          </xsl:if>
          <xsl:for-each select="procstep">
            <dt class="mandatory">Process_Step</dt>
            <dd id="definition" name="definition">Information about a single event.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Process_Description: </dt>
              <xsl:for-each select="procdesc">
                <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>   
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: An explanation of the event and related parameters or tolerances.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <xsl:if test="count(srcused) = 0">
                <dt class="mandatoryif">Source_Used_Citation_Abbreviation: </dt>
              </xsl:if>
              <xsl:for-each select="srcused">
                <dt class="mandatoryif">Source_Used_Citation_Abbreviation: </dt>
                <dd><span class="normal"><xsl:value-of select="."/></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The Source Citation Abbreviation of a data set used in the processing step.</dd>
              <dd id="domain" name="domain">Domain: Source Citation Abbreviations from the Source Information entries for the data set.</dd>
              <dt class="mandatory">Process_Date: 
              <xsl:for-each select="procdate">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The date when the event was completed.</dd>
              <dd id="domain" name="domain">Domain: "Unknown", "Not complete", free date</dd>
              <dt id="optional" name="optional">Process_Time: 
              <xsl:for-each select="proctime">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The time when the event was completed.</dd>
              <dd id="domain" name="domain">Domain: free time</dd>
              <xsl:if test="count(srcprod) = 0">
                <dt class="mandatoryif">Source_Produced_Citation_Abbreviation: </dt>
              </xsl:if>
              <xsl:for-each select="srcprod">
                <dt class="mandatoryif">Source_Produced_Citation_Abbreviation: </dt>
                <dd><span class="normal"><xsl:value-of select="."/></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The Source Citation Abbreviation of an intermediate data set that (1) is significant in the opinion of the data producer, (2) is generated in the processing step, and (3) is used in later processing steps.</dd>
              <dd id="domain" name="domain">Domain: Source Citation Abbreviations from the Source Information entries for the data set.</dd>
             <xsl:if test="count(proccont) = 0">
               <dt id="optional" name="optional">Process_Contact</dt>
               <dd id="definition" name="definition">The party responsible for the processing step information.</dd>
               <dd class="optional">
               <dl>
                 <xsl:call-template name="no_cntinfo_element"/>
               </dl>
               </dd>
             </xsl:if>
             <xsl:for-each select="proccont">
               <dt id="optional" name="optional">Process_Contact</dt>
               <dd id="definition" name="definition">The party responsible for the processing step information.</dd>
               <dd class="optional">
               <dl>
               <xsl:if test="count(cntinfo) = 0">
                <xsl:call-template name="no_cntinfo_element"/>
              </xsl:if>
                <xsl:apply-templates select="cntinfo"/>
              </dl>
              </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <dt id="optional" name="optional">Cloud_Cover: 
      <xsl:for-each select="cloud">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: Area of a data set obstructed by clouds, expressed as a percentage of the spatial extent.</dd>
      <dd id="domain" name="domain">Domain: 0&lt;= Cloud Cover &lt;= 100, "Unknown"</dd>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- Spatial Data Organization -->
<xsl:template match="spdoinfo">
  <a name="Spatial_Data_Organization_Information"><hr/></a>
  <dl>
    <dt class="mandatoryif">Spatial_Data_Organization_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">The mechanism used to represent spatial information in the data set.</dd>
    <dd>
    <dl>
      <dt class="mandatoryif">Indirect_Spatial_Reference_Method: </dt>
      <xsl:for-each select="indspref">
        <dd><span class="normal"><xsl:value-of select="."/></span></dd>
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: Name of types of geographic features, addressing schemes, or other means through which locations are referenced in the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <dt class="mandatory">Direct_Spatial_Reference_Method: 
      <xsl:for-each select="direct">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: The system of objects used to represent space in the data set.</dd>
      <dd id="domain" name="domain">Domain: "Point", "Vector", "Raster"</dd>

      <xsl:if test="count(ptvctinf) = 0">
        <dt class="mandatory">Point_and_Vector_Object_Information</dt>
        <dd id="definition" name="definition">The types and numbers of vector or nongridded point spatial objects in the data set.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_sdtsterm_element"/>
          <dt class="normal">- or -</dt>
          <xsl:call-template name="no_vpfterm_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="ptvctinf">
        <dt class="mandatory">Point_and_Vector_Object_Information</dt>
        <dd id="definition" name="definition">The types and numbers of vector or nongridded point spatial objects in the data set.</dd>
        <dd>
        <dl>
          <xsl:if test="count(sdtsterm) = 0">
             <xsl:call-template name="no_sdtsterm_element"/>
          </xsl:if>
          <xsl:for-each select="sdtsterm">
            <dt class="mandatory">SDTS_Terms_Description</dt>
            <dd id="definition" name="definition">Point and vector object information using the terminology and concepts from "Spatial Data Concepts", which is Chapter 2 of Part 1 in Department of Commerce, 1992, Spatial Data Transfer Standard (SDTS) (Federal Information Processing Standard 173): Washington, Department of Commerce, National Institute of Standards and Technology.</dd>
            <dd>
            <dl>
              <dt class="mandatory">SDTS_Point_and_Vector_Object_Type: 
              <xsl:for-each select="sdtstype">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: Name of point and vector spatial objects used to locate zero-, one-, and two-dimensional spatial locations in the data set.</dd>
              <dd id="domain" name="domain">Domain: (The domain is from "Spatial Data Concepts", which is Chapter 2 of Part 1 in Department of Commerce, 1992, Spatial Data Transfer Standard (SDTS) (Federal Information Processing Standard 173): Washington, Department of Commerce, National Institute of Standards and Technology): "Point", "Entity point", "Label point" "Area point", "Node, planar graph", "Node, network", "String", "Link", "Complete chain", "Area chain", Network chain, planar graph", "Network chain, nonplanar graph", "Circular arc, three point center", Elliptical arc", "Uniform B-spline", "Piecewise Bezier", "Ring with mized composition", "Ring composed of strings", "Ring composed of chains", "Ring composed of arcs", "G-polygon", "GT-polygon composed of rings", "GT-polygon composed of chains", "Universe polygon composed of rings", "Universe polygon composed of chains", Void polygon composed of rings", Void polygon composed of chains",free text</dd>
              <dt id="optional" name="optional">Point_and_Vector_Object_Count: 
              <xsl:for-each select="ptvctcnt">
               <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The total number of the point or vector object type occurring in the data set.</dd>
              <dd id="domain" name="domain">Domain: Point and Vector Count &gt; 0</dd>
            </dl>
            </dd>
          </xsl:for-each>

          <dt class="normal">- or -</dt>

          <xsl:if test="count(vpfterm) = 0">
             <xsl:call-template name="no_vpfterm_element"/>
          </xsl:if>
          <xsl:for-each select="vpfterm">
            <dt class="mandatory">VPF_Terms_Description</dt>
            <dd id="definition" name="definition">Point and vector object information using the terminology and concepts from Department of Defense, 1992, Vector Product Format (MIL-STD-600006): Philadelphia, Department of Defense, Defense Printing Service Detachment Office.</dd>
            <dd>
            <dl>
               <dt class="mandatory">VPF_Topology_Level: 
              <xsl:for-each select="vpflevel">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The completeness of the topology carried by the data set. The levels of completeness are defined in Department of Defense, 1992, Vector Product Format (MIL-STD-600006): Philadelphia, Department of Defense, Defense Printing Service Detachment Office.</dd>
              <dd id="domain" name="domain">Domain: 0 &lt;= VPF Topology Level &lt;= 3</dd>
              <xsl:if test="count(vpfinfo) = 0">
                <xsl:call-template name="no_vpfinfo_element"/>
              </xsl:if>
              <xsl:for-each select="vpfinfo">
                <dt class="mandatory">VPF_Point_and_Vector_Object_Information</dt>
                <dd id="definition" name="definition">Information about VPF point and vector objects.</dd>
                <dd>
                <dl>
                  <dt class="mandatory">VPF_Point_and_Vector_Object_Type: 
                  <xsl:for-each select="vpftype">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: Name of point and vector spatial objects used to locate zero-, one-, and two-dimensional spationa locations in the data set.</dd>
                  <dd id="domain" name="domain">Domain: (The domain is from Department of Defense, 1992, Vector Product Format (MIL-STD-600006): Philidelphia, Department of Defense, Defense Printing Service Detachment Office): "Node", "Edge", "Face", "Text"</dd>
                  <dt id="optional" name="optional">Point_and_Vector_Object_Count: 
                  <xsl:for-each select="ptvctcnt">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: The total number of the point or vector object type occurring in the data set.</dd>
                  <dd id="domain" name="domain">Domain: Point and Vector Count &gt; 0</dd>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <dt>- or - </dt>
      <xsl:if test="count(rastinfo) = 0">
          <xsl:call-template name="no_rastinfo_element"/>
      </xsl:if>
      <xsl:for-each select="rastinfo">
        <dt class="mandatory">Raster_Object_Information</dt>
        <dd id="definition" name="definition">The types and numbers of raster spatial objects in the data set.</dd>
        <dd>
        <dl>
          <dt class="mandatory">Raster_Object_Type: 
          <xsl:for-each select="rasttype">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: Raster spatial objects used to locate zero-, two-, or three-dimensional locations in the data set.</dd>
          <dd id="domain" name="domain">Domain: (With the exception of "Voxel", the domain is from "Spatial Data Concepts", which is chapter 2 of part 1 in Department of Commerce, 1992, Spatial Data Transfer Standard (SDTS) (Federal Informaiton Processing Standard 173): Washington, Department of Commerce, National Institute of Standards and Technology): "Point", "Pixel", "Grid Cell", "Voxel"</dd>
          <dt class="mandatory">Row_Count: 
          <xsl:for-each select="rowcount">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: The maximum number of raster objects along the ordinate (y) axis. For use with regular raster objects.</dd>
          <dd id="domain" name="domain">Domain: Row Count &gt; 0</dd>
          <dt class="mandatory">Column_Count: 
          <xsl:for-each select="colcount">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: The maximum number of raster objects along the abscissa (x) axis. For use with rectangular raster objects.</dd>
          <dd id="domain" name="domain">Domain: Column Count &gt; 0</dd>
          <dt class="mandatoryif">Vertical_Count: 
          <xsl:for-each select="vrtcount">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: The number of raster objects along the vertical (z) axis. For use with rectangular volumetric raster objects (voxels).</dd>
          <dd id="domain" name="domain">Domain: Vertical Count &gt; 0</dd>
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- Spatial Reference -->
<xsl:template match="spref">
  <a name="Spatial_Reference_Information"><hr/></a>
  <dl>
    <dt class="mandatoryif">Spatial_Reference_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Description of the reference frame for, and the means to encode, coordinates in the data set.</dd>
    <dd>
    <dl>
      <xsl:if test="count(horizsys) = 0">
        <xsl:call-template name="no_horizsys_element"/>
      </xsl:if>
      <xsl:for-each select="horizsys">
        <dt class="mandatoryif">Horizontal_Coordinate_System_Definition</dt>
        <dd id="definition" name="definition">The reference frame or system from which linear or angular quantities are measured and assigned to the postion that a point occupies.</dd>
        <dd>
        <dl>
          <xsl:if test="count(geograph) = 0">
            <xsl:call-template name="no_geograph_element"/>
          </xsl:if>
          <xsl:for-each select="geograph">
            <dt class="mandatory">Geographic</dt>
            <dd id="definition" name="definition">The quantities of latitude and longitude which define the position of a point on the Earth's surface with respect to a reference spheriod.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Latitude_Resolution: 
              <xsl:for-each select="latres">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The minimum difference between two adjacent latitude values expressed in Geographic Coordinates Units of measure.</dd>
              <dd id="domain" name="domain">Domain: Latitude Resolution &gt; 0.0</dd>
              <dt class="mandatory">Longitude_Resolution: 
              <xsl:for-each select="longres">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The minimum difference between two adjacent longitude values expressed in Geographic Coordinates Units of measure.</dd>
              <dd id="domain" name="domain">Domain: Longitude Resolution &gt; 0.0</dd>
              <dt class="mandatory">Geographic_Coordinate_Units: 
              <xsl:for-each select="geogunit">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: Units of measurement for the latitude and longitude values.</dd>
              <dd id="domain" name="domain">Domain: "Decimal degrees", "Decimal minutes", "Decimal seconds", "Degrees and decimal minutes", "Degrees, minutes, and decimal seconds", "Radians", "Grads"</dd>
            </dl>
            </dd>
          </xsl:for-each>

          <dt class="normal">- or -</dt>

          <xsl:if test="count(planar) = 0">
            <xsl:call-template name="no_planar_element"/>
          </xsl:if>
          <xsl:for-each select="planar">
            <dt class="mandatory">Planar</dt>
            <dd id="definition" name="definition">The quantities of distances, or distances and angles, which define the position of a point on a reference plane to which the surface of the Earth has been projected.</dd>
            <dd>
            <dl>
              <xsl:if test="count(mapproj) = 0">
                <xsl:call-template name="no_mapproj_element"/>
              </xsl:if>
              <xsl:for-each select="mapproj">
                <dt class="mandatory">Map_Projection</dt>
                <dd id="definition" name="definition">The systematic representation of all or part of the surface of the Earth on a plane or developable surface.</dd>
                <dd>
                <dl>
                  <dt class="mandatory">Map_Projection_Name: 
                  <xsl:for-each select="mapprojn">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: Name of the map projection.</dd>
                  <dd id="domain" name="domain">Domain: "Albers Conical Equal Area", "Azimuthal Equidistant", "Equidistant Conic", "Equirectangular", "General Vertical Near-sided Perspective", "Gnomonic", "Lambert Azimuthal Equal Area", "Lambert Conformal Conic", "Mercator", "Modified Stereographic for Alaska", "Miller Cylindrical", "Oblique Mercator", "Orthographic", "Polar Stereographic", "Polyconic", "Robinson", "Sinusoidal", "Space Oblique Mercator (Landsat)", "Stereographic", "Transverse Mercator", "van der Grinten", free text</dd>

                  <xsl:for-each select="albers">
                    <dt class="mandatory">Albers_Conical_Equal_Area</dt>
                    <dd id="definition" name="definition">Contains parameters for the Albers Conical Equal Area projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="azimequi">
                    <dt class="mandatory">Azimuthal_Equidistant</dt>
                    <dd id="definition" name="definition">Contains parameters for the Azimuthal Equidistant projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="equicon">
                    <dt class="mandatory">Equidistant_Conic</dt>
                    <dd id="definition" name="definition">Contains parameters for the Equidistant Conic projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="equirect">
                    <dt class="mandatory">Equirectangular</dt>
                    <dd id="definition" name="definition">Contains parameters for the Equirectangular projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="gvnsp">
                    <dt class="mandatory">General_Vertical_Near-sided_Perspective</dt>
                    <dd id="definition" name="definition">Contains parameters for the General Vertical Near-sided Perspective projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="gnomonic">
                    <dt class="mandatory">Gnomonic</dt>
                    <dd id="definition" name="definition">Contains parameters for the Gnomonic projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="lamberta">
                    <dt class="mandatory">Lambert_Azimuthal_Equal_Area</dt>
                    <dd id="definition" name="definition">Contains parameters for the Lambert Azimuthal Equal Area projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="lambertc">
                    <dt class="mandatory">Lambert_Conformal_Conic</dt>
                    <dd id="definition" name="definition">Contains parameters for the Lambert Conformal Conic projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="mercator">
                    <dt class="mandatory">Mercator</dt>
                    <dd id="definition" name="definition">Contains parameters for the Mercator projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="modsak">
                    <dt class="mandatory">Modified_Stereographic_for_Alaska</dt>
                    <dd id="definition" name="definition">Contains parameters for the Modified Stereographic for Alaska projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="miller">
                    <dt class="mandatory">Miller_Cylindrical</dt>
                    <dd id="definition" name="definition">Contains parameters for the Miller Cylindrical projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="obqmerc">
                    <dt class="mandatory">Oblique_Mercator</dt>
                    <dd id="definition" name="definition">Contains parameters for the Oblique Mercator projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="orthogr">
                    <dt class="mandatory">Orthographic</dt>
                    <dd id="definition" name="definition">Contains parameters for the Orthographic projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="polarst">
                    <dt class="mandatory">Polar_Stereographic</dt>
                    <dd id="definition" name="definition">Contains parameters for the Polar Stereographic projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="polycon">
                    <dt class="mandatory">Polyconic</dt>
                    <dd id="definition" name="definition">Contains parameters for the Polyconic projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="robinson">
                    <dt class="mandatory">Robinson</dt>
                    <dd id="definition" name="definition">Contains parameters for the Robinson projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="sinusoid">
                    <dt class="mandatory">Sinusoidal</dt>
                    <dd id="definition" name="definition">Contains parameters for the Sinusoidal projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="spaceobq">
                    <dt class="mandatory">Space_Oblique_Mercator_(Landsat)</dt>
                    <dd id="definition" name="definition">Contains parameters for the Space Oblique Mercator (Landsat) projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="stereo">
                    <dt class="mandatory">Stereographic</dt>
                    <dd id="definition" name="definition">Contains parameters for the Stereographic projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="transmer">
                    <dt class="mandatory">Transverse_Mercator</dt>
                    <dd id="definition" name="definition">Contains parameters for the Transverse Mercator projection.</dd>
                  </xsl:for-each>
                  <xsl:for-each select="vdgrin">
                    <dt class="mandatory">van_der_Grinten</dt>
                    <dd id="definition" name="definition">Contains parameters for the van der Grinten projection.</dd>
                  </xsl:for-each>

                  <xsl:apply-templates select="*"/>
                </dl>
                </dd>
              </xsl:for-each>

              <dt class="normal">- or -</dt>

              <xsl:if test="count(gridsys) = 0">
                <xsl:call-template name="no_gridsys_element"/>
              </xsl:if>
              <xsl:for-each select="gridsys">
                <dt class="mandatory">Grid_Coordinate_System</dt>
                <dd id="definition" name="definition">A plane rectangular coordinate system usually based on, and mathematically adjusted to, a map projection so that geographic positions can be readily transformed to and from plane coordinates.</dd>
                <dd>
                <dl>
                  <dt class="mandatory">Grid_Coordinate_System_Name: 
                  <xsl:for-each select="gridsysn">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: Name of the grid coordinate system.</dd>
                  <dd id="domain" name="domain">Domain: "Universal Transverse Mercator", "Universal Polar Stereographic", "State Plane Coordinate System 1927", "State Plane Coordinate System 1983", "ARC Coordinate System", "other grid system"</dd>

                  <xsl:if test="count(utm) = 0">
                    <xsl:call-template name="no_utm_element"/>
                  </xsl:if>
                  <xsl:for-each select="utm">
                    <dt class="mandatory">Universal_Transverse_Mercator</dt>
                    <dd id="definition" name="definition">A grid system based on the transverse mercator projection, applied between latitudes 84 degrees north and 80 degrees south on the Earth's surface.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">UTM_Zone_Number: 
                      <xsl:for-each select="utmzone">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: Identifier for the UTM zone.</dd>
                      <dd id="domain" name="domain">Domain: 1 &lt;= UTM Zone Number &lt; 60 for the northern hemisphere; -60 &lt;= UTM Zone Number &lt;= -1 for the southern hemisphere.</dd>
                      <xsl:for-each select="transmer">
                        <dt class="mandatory">Transverse_Mercator</dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="transmer"/>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- or -</dt>

                  <xsl:if test="count(ups) = 0">
                    <xsl:call-template name="no_ups_element"/>
                  </xsl:if>
                  <xsl:for-each select="ups">
                    <dt class="mandatory">Universal_Polar_Stereographic</dt>
                    <dd id="definition" name="definition">A grid system based on the polar stereographic projection, applied to the Earth's polar regions north of 84 degrees north and south of 80 degrees south.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">UPS_Zone_Identifier: 
                      <xsl:for-each select="upszone">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: Identifier for the UPS zone.</dd>
                      <dd id="domain" name="domain">Domain: "A", "B", "Y", "Z"</dd>
                      <xsl:for-each select="polarst">
                        <dt class="mandatory">Polar_Stereographic</dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="polarst"/>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- or -</dt>

                  <xsl:if test="count(spcs) = 0">
                    <xsl:call-template name="no_spcs_element"/>
                  </xsl:if>
                  <xsl:for-each select="spcs">
                    <dt class="mandatory">State_Plane_Coordinate_System</dt>
                    <dd id="definition" name="definition">A plane-rectangular coordinate system established for each state in the United States by the National Geodetic Survey.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">SPCS_Zone_Identifier: 
                      <xsl:for-each select="spcszone">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: Identifier for the SPCS zone.</dd>
                      <dd id="domain" name="domain">Domain: Four-digit numeric codes for the State Plane Coordinate Systems based on the North American Datum of 1927 are found in Department of Commerce, 1986, Representation of geographic point locations for information interchange (Federal Information Processing Standard 70-1): Washington: Department of Commerce, National Institute of Standards and Technology. Codes for the State Plane Coordinate Systems based on the North American Datum of 1983 are found in Department of Commerce, 1989 (January), State Plane Coordinate System of 1983 (National Oceanic and Atmospheric Administration Manual NOS NGS 5): Silver Spring, Maryland, National Oceanic and Atmospheric Administration, National Ocean Service, Coast and Geodetic Survey.</dd>
                      <xsl:for-each select="lambertc">
                        <dt class="mandatory">Lambert_Conformal_Conic</dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="lambertc"/>
                      <xsl:for-each select="transmer">
                        <dt class="mandatory">Transverse_Mercator</dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="transmer"/>
                      <xsl:for-each select="obqmerc">
                        <dt class="mandatory">Oblique_Mercator</dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="obqmerc"/>
                      <xsl:for-each select="polycon">
                        <dt class="mandatory">Polyconic</dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="polycon"/>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- or -</dt>

                  <xsl:if test="count(arcsys) = 0">
                    <xsl:call-template name="no_arcsys_element"/>
                  </xsl:if>
                  <xsl:for-each select="arcsys">
                    <dt class="mandatory">ARC_Coordinate_System</dt>
                    <dd id="definition" name="definition">The Equatorial Arc-second Coordinate System, a plane-rectangular coordinate system established in the Department of Defense, 1990, Military specification ARC Digitized Raster Graphics (ADRG) (MIL-A-89007): Philadelphia, Department of Defense, Defense Printing Service Detachment Office.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">ARC_System_Zone_Identifier: 
                      <xsl:for-each select="arczone">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: Identifier for the ARC Coordinate System zone.</dd>
                      <dd id="domain" name="domain">Domain: 1 &lt;= ARC System Zone Identifier &lt;= 18</dd>
                      <xsl:for-each select="equirect">
                        <dt class="mandatory">Equirectangular</dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="equirect"/>
                      <xsl:for-each select="azimequi">
                        <dt class="mandatory">Azimuthal_Equidistant</dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="azimequi"/>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- or -</dt>

                  <dt class="mandatory">Other_Grid_System's_Definition: </dt>
                  <xsl:for-each select="othergrd">
                    <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: A complete description of a grid system, not defined elsewhere in the standard, that was used for the data set. The information provide shall include the name of the grid system, the names of the parameters and values used for the data set, and the citation of the specification for the algorithms that describe the mathematical relationship between Earth and the coordinates of the grid system.</dd>
                  <dd id="domain" name="domain">Domain: free text"</dd>
                </dl>
                </dd>
              </xsl:for-each>

             <dt class="normal">- or -</dt>

              <xsl:if test="count(localp) = 0">
                <xsl:call-template name="no_localp_element"/>
              </xsl:if>
              <xsl:for-each select="localp">
                <dt class="mandatory">Local_Planar</dt>
                <dd id="definition" name="definition">Any right-handed planar coordinate system of which the z-axis coincides with a plumb line through the origin that locally is alligned with the surface of the earth.</dd>
                <dd>
                <dl>
                  <dt class="mandatory">Local_Planar_Description: </dt>
                  <xsl:for-each select="localpd">
                    <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: A description of the local planar system.</dd>
                  <dd id="domain" name="domain">Domain: free text</dd>
                  <dt class="mandatory">Local_Planar_Georeference_Information: </dt>
                  <xsl:for-each select="localpgi">
                    <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: A description of the information provided to register the local planar system to the Earth (e.g. control points, satellite ephemeral data, inertial navigation data).</dd>
                  <dd id="domain" name="domain">Domain: free text</dd>
                </dl>
                </dd>
              </xsl:for-each>

              <xsl:if test="count(planci) = 0">
                <xsl:call-template name="no_planci_element"/>
              </xsl:if>
              <xsl:for-each select="planci">
                <dt class="mandatory">Planar_Coordinate_Information</dt>
                <dd id="definition" name="definition">Information about the coordinate system developed on the planar surface.</dd>
                <dd>
                <dl>
                  <dt class="mandatory">Planar_Coordinate_Encoding_Method: 
                  <xsl:for-each select="plance">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: The means used to represent horizontal positions.</dd>
                  <dd id="domain" name="domain">Domain: "coordinate pair", "distance and bearing", "row and column"</dd>
                  <xsl:if test="count(coordrep) = 0">
                    <xsl:call-template name="no_coordrep_element"/>
                  </xsl:if>
                  <xsl:for-each select="coordrep">
                    <dt class="mandatory">Coordinate_Representation</dt>
                    <dd id="definition" name="definition">The method of encoding the position of a point by measuring its distance from perpendicular reference axes (the "coordinate pair" and "row and column" methods).</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">Abscissa_Resolution: 
                      <xsl:for-each select="absres">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                     </dt>
                      <dd id="definition" name="definition">Definition: The (nominal) minimum distance between the "x" or column values of two adjacent points, expressed in Planar Distance Units of measure.</dd>
                      <dd id="domain" name="domain">Domain: Abscissa Resolution &gt; 0.0</dd>
                      <dt class="mandatory">Ordinate_Resolution: 
                      <xsl:for-each select="ordres">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The (nominal) minimum distance between the "y" or row values of two adjacent points, expressed in Planar Distance Units of measure.</dd>
                      <dd id="domain" name="domain">Domain: Ordinate Resolution &gt; 0.0</dd>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- or -</dt>

                  <xsl:if test="count(distbrep) = 0">
                    <xsl:call-template name="no_distbrep_element"/>
                  </xsl:if>
                  <xsl:for-each select="distbrep">
                    <dt class="mandatory">Distance_and_Bearing_Representation</dt>
                    <dd id="definition" name="definition">A method of encoding the position of a point by measuring its distance and direction (azimuth angle) from another point.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">Distance_Resolution: 
                      <xsl:for-each select="distres">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The minimum distance measurable between two points, expressed in Planar Distance Units of measure.</dd>
                      <dd id="domain" name="domain">Domain: Distance Resolution &gt; 0.0</dd>
                      <dt class="mandatory">Bearing_Resolution: 
                      <xsl:for-each select="bearres">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The minimum angle measurable between two points, expressed in Bearing Units of measure.</dd>
                      <dd id="domain" name="domain">Domain: Distance Resolution &gt; 0.0</dd>
                      <dt class="mandatory">Bearing_Units: 
                      <xsl:for-each select="bearunit">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: Units of measure used for angles.</dd>
                      <dd id="domain" name="domain">Domain: "Decimal degrees", "Decimal minutes", "Decimal seconds", "Degrees and decimal minutes", "Degrees, minutes, and decimal seconds", "Radians", "Grads"</dd>
                      <dt class="mandatory">Bearing_Reference_Direction: 
                      <xsl:for-each select="bearrefd">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: Direction from which the bearing is measured.</dd>
                      <dd id="domain" name="domain">Domain: "North", "South"</dd>
                      <dt class="mandatory">Bearing_Reference_Meridian: 
                      <xsl:for-each select="bearrefm">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: Axis from which the bearing is measured.</dd>
                      <dd id="domain" name="domain">Domain: "Assumed", "Grid", "Magnetic", "Astronomic", "Geodetic"</dd>
                    </dl>
                    </dd>
                  </xsl:for-each>
                  <dt class="mandatory">Planar_Distance_Units: 
                  <xsl:for-each select="plandu">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: Units of measure used for distances.</dd>
                  <dd id="domain" name="domain">Domain: "meters", "international feet", "survey feet", free text</dd>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>

          <dt class="normal">- or -</dt>

          <xsl:if test="count(local) = 0">
            <xsl:call-template name="no_local_element"/>
          </xsl:if>
          <xsl:for-each select="local">
            <dt class="mandatory">Local</dt>
            <dd id="definition" name="definition">A description of any coordinate system that is not alligned with the surface of the Earth.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Local_Description: 
              <xsl:for-each select="localdes">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
               </dt>
              <dd id="definition" name="definition">Definition: A description of the coordinate system and its orientation to the surface of the Earth.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <dt class="mandatory">Local_Georeference_Information: </dt>
              <xsl:for-each select="localgeo">
                <dd><span class="normal"><xsl:value-of select="."/></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: A description of the information provided to register the local system to the Earth (e.g. control points, satellite ephemeral data, inertial navigation data).</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
            </dl>
            </dd>
          </xsl:for-each>

          <xsl:if test="count(geodetic) = 0">
            <xsl:call-template name="no_geodetic_element"/>
          </xsl:if>
          <xsl:for-each select="geodetic">
            <dt class="mandatoryif">Geodetic_Model</dt>
            <dd id="definition" name="definition">Parameterf for the shape of the Earth.</dd>
            <dd>
            <dl>
              <dt class="mandatoryif">Horizontal_Datum_Name: 
              <xsl:for-each select="horizdn">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The identificatin given to the reference system used for defining the coordinates of points.</dd>
              <dd id="domain" name="domain">Domain: "North American Datum of 1927", "North American Datum of 1983", free text</dd>
              <dt class="mandatory">Ellipsoid_Name: 
              <xsl:for-each select="ellips">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: Identification given to established representations of the Earth's shape.</dd>
              <dd id="domain" name="domain">Domain: "Clarke 1866" "Geodetic Reference System 80", free text</dd>
              <dt class="mandatory">Semi-major_Axis: 
              <xsl:for-each select="semiaxis">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: Radius of the equatorial axis of the ellipsoid.</dd>
              <dd id="domain" name="domain">Domain: Semi-major Axis &gt; 0.0</dd>
              <dt class="mandatory">Denominator_of_Flattening_Ratio: 
              <xsl:for-each select="denflat">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The denominator of the ratio of the difference between the equatorial and polar radii of the ellipsoid when the numerator is set to 1.</dd>
              <dd id="domain" name="domain">Domain: Denominator of Flattening &gt; 0.0</dd>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:if test="count(vertdef) = 0">
        <xsl:call-template name="no_vertdef_element"/>
      </xsl:if>
      <xsl:for-each select="vertdef">
        <dt class="mandatoryif">Vertical_Coordinate_System_Definition</dt>
        <dd id="definition" name="definition">The reference frame or system from which vertical distances (altitudes or depths) are measured.</dd>
        <dd>
        <dl>
            <xsl:if test="count(altsys) = 0">
              <xsl:call-template name="no_altsys_element"/>
            </xsl:if>
            <xsl:for-each select="altsys">
            <dt class="mandatoryif">Altitude_System_Definition</dt>
            <dd id="definition" name="definition">The reference frame or system from which atitudes (elevations) are measured. The term "altitude" is used instead of the common term "elevation" to conform to terminology in the Federal Processing Standards 70-1 and 173.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Altitude_Datum_Name: 
              <xsl:for-each select="altdatum">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The identification given to the surface taken as the surface of reference from which altitudes are measured.</dd>
              <dd id="domain" name="domain">Domain: "National Geodetic Vertical Datum of 1929", "North American Vertical Datum of 1988", free text</dd>
              <xsl:if test="count(altres) = 0">
                <dt class="mandatory">Altitude_Resolution:</dt>
              </xsl:if>
              <xsl:for-each select="altres">
                <dt class="mandatory">Altitude_Resolution: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The minimum distance possible between two adjacent altitude values, expressed in Altitude Distance Units of measure.</dd>
              <dd id="domain" name="domain">Domain: Altitude Resolution &gt; 0.0</dd>
              <dt class="mandatory">Altitude_Distance_Units: 
              <xsl:for-each select="altunits">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: Units in which altitudes are recorded.</dd>
              <dd id="domain" name="domain">Domain: "meters", "feet", free text</dd>
              <dt class="mandatory">Altitude_Encoding_Method: 
              <xsl:for-each select="altenc">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The means used to encode the altitudes.</dd>
              <dd id="domain" name="domain">Domain: "Explicit elevation coordinate included with horizontal coordinates", Implicit coordinate", "Attribute values"</dd>
            </dl>
            </dd>
          </xsl:for-each>

          <xsl:if test="count(depthsys) = 0">
            <xsl:call-template name="no_depthsys_element"/>
          </xsl:if>
          <xsl:for-each select="depthsys">
            <dt class="mandatoryif">Depth_System_Definition</dt>
            <dd id="definition" name="definition">The reference frame or system from which depths are measured.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Depth_Datum_Name: 
              <xsl:for-each select="depthdn">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The identification given to surface or reference from which depths are measured.</dd>
              <dd id="domain" name="domain">Domain: "Local surface", "Chart datum; datum for sounding reduction", "Lowest astronomical tide", "Highest astronomical tide", "Mean low water", "Mean high water", "Mean sea level", "Land survey datum", "Mean low water springs", Mean high water springs", "Mean low water neap", Mean high water neap", "Mean lower low water", "Mean lower low water springs", "Mean higher high water", "Mean lower high water", "Sring tide", "Tropical lower low water", "Neap tide", "High water", "Higher high water", "Low water", "Low-water datum", "Lowest low water", "Lower low water", "Lowest normal low water", "Mean tide level", "Indian spring low water", "High-water full and charge", "Low-water full and charge", "Columbia River datum", "Gulf Coast low water datum", "Equatorial springs low water", "Approximate lowest astonomical tide", "No correction", free text</dd>
              <xsl:if test="count(depthres) = 0">
                <dt class="mandatory">Depth_Resolution:</dt>
              </xsl:if>
              <xsl:for-each select="depthres">
                <dt class="mandatory">Depth_Resolution: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The minimum distance possible between two adjacent depth values, expressed in Depth Distance Units of Measure.</dd>
              <dd id="domain" name="domain">Domain: Depth Resolution &gt; 0.0</dd>
              <dt class="mandatory">Depth_Distance_Units: 
              <xsl:for-each select="depthdu">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: Units in which depths are recorded.</dd>
              <dd id="domain" name="domain">Domain: "meters", "feet", free text</dd>
              <dt class="mandatory">Depth_Encoding_Method: 
              <xsl:for-each select="depthem">
                 <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The means used to encode depths.</dd>
              <dd id="domain" name="domain">Domain: "Explicit depth coordinate included with horizontal coordinates", Implicit coordinate", "Attribute values"</dd>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- Entity and Attribute -->
<xsl:template match="eainfo">
  <a name="Entity_and_Attribute_Information"><hr/></a>
  <dl>
    <dt class="mandatoryif">Entity_and_Attribute_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Details about the information content of the data set, including the entity types, their attributes, and the domains from which attribute values may be assigned.</dd>
    <dd>
    <dl>
      <xsl:if test="count(detailed) = 0">
        <xsl:call-template name="no_detailed_element"/>
      </xsl:if>
      <xsl:for-each select="detailed">
        <dt class="mandatory">Detailed_Description</dt>
        <dd id="definition" name="definition">Description of the entities, attributes, attribute values, and related characteristics encoded in the data set.</dd>
        <dd>
        <dl>
          <xsl:if test="count(enttyp) = 0">
            <xsl:call-template name="no_enttyp_element"/>
          </xsl:if>
          <xsl:for-each select="enttyp">
            <dt class="mandatory">Entity_Type</dt>
            <dd id="definition" name="definition">The definition and description of a set into which similar entity instances are classified.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Entity_Type_Label: 
              <xsl:for-each select="enttypl">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The name of the entity type.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <dt class="mandatory">Entity_Type_Definition: </dt>
              <xsl:for-each select="enttypd">
                <dd><span class="normal"><xsl:value-of select="."/></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The description of the entity type.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <dt class="mandatory">Entity_Type_Definition_Source: </dt>
              <xsl:for-each select="enttypds">
                <dd><span class="normal"><xsl:value-of select="."/></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The authority of the definition.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
            </dl>
            </dd>
          </xsl:for-each>

          <xsl:if test="count(attr) = 0">
            <xsl:call-template name="no_attr_element"/>
          </xsl:if>
          <xsl:for-each select="attr">
            <dt class="mandatoryif">Attribute</dt>
            <dd id="definition" name="definition">A defined characteristic of an entity.</dd>
            <dd>
            <dl>
              <dt class="mandatory">Attribute_Label: 
              <xsl:for-each select="attrlabl">
                <span class="normal"><xsl:value-of select="."/></span>
              </xsl:for-each>
              </dt>
              <dd id="definition" name="definition">Definition: The name of the attribute.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <dt class="mandatory">Attribute_Definition: </dt>
              <xsl:for-each select="attrdef">
              <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The description of the attribute.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
              <dt class="mandatory">Attribute_Definition_Source: </dt>
              <xsl:for-each select="attrdefs">
                <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The authority of the definition.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>

              <xsl:if test="count(attrdomv) = 0">
                <xsl:call-template name="no_attrdomv_element"/>
              </xsl:if>
              <xsl:for-each select="attrdomv">
                <dt class="mandatory">Attribute_Domain_Values</dt>
                <dd id="definition" name="definition">The valid values that can be assigned for an attribute.</dd>
                <dd>
                <dl>
                  <xsl:if test="count(edom) = 0">
                    <xsl:call-template name="no_edom_element"/>
                  </xsl:if>
                  <xsl:for-each select="edom">
                    <dt class="mandatory">Enumerated_Domain</dt>
                    <dd id="definition" name="definition">The members of an established set of valid values.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">Enumerated_Domain_Value: 
                      <xsl:for-each select="edomv">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The name or label of a member of the set.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                      <dt class="mandatory">Enumerated_Domain_Value_Definition:</dt>
                      <xsl:for-each select="edomvd">
                        <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
                      </xsl:for-each>
                      <dd id="definition" name="definition">Definition: The description of the value.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                      <dt class="mandatory">Enumerated_Domain_Value_Definition_Source: </dt>
                      <xsl:for-each select="edomvds">
                        <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
                      </xsl:for-each>
                      <dd id="definition" name="definition">Definition: The authority of the definition.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                      <xsl:for-each select="attr">
                        <dt class="mandatoryif">Attribute: <span class="normal"><xsl:value-of select="."/></span></dt>
                        <dd id="definition" name="definition">A defined characteristic of an entity.</dd>
                        <dd id="domain" name="domain">Domain: free text</dd>
                      </xsl:for-each>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- and/or -</dt>
                  <xsl:if test="count(rdom) = 0">
                    <xsl:call-template name="no_rdom_element"/>
                  </xsl:if>
                  <xsl:for-each select="rdom">
                    <dt class="mandatory">Range_Domain</dt>
                    <dd id="definition" name="definition">The minimum and maximum values of a continuum of valid values.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">Range_Domain_Minimum: 
                      <xsl:for-each select="rdommin">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The least value that the attribute can be assigned.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                      <dt class="mandatory">Range_Domain_Maximum: 
                      <xsl:for-each select="rdommax">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The greatest value that the attribute can be assigned.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                      <dt class="mandatoryif">Attribute_Units_of_Measure: 
                      <xsl:for-each select="attrunit">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The standard of measurement for an attribute value.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                      <dt id="optional" name="optional">Attribute_Measurement_Resolution: 
                      <xsl:for-each select="attrmres">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The smallest unit increment to which an attribute value is measured.</dd>
                      <dd id="domain" name="domain">Domain: Attribute Measurement Resolution &gt;= 0.0</dd>
                      <xsl:for-each select="attr">
                        <dt class="mandatoryif">Attribute: <span class="normal"><xsl:value-of select="."/></span></dt>
                        <dd id="definition" name="definition">A defined characteristic of an entity.</dd>
                        <dd id="domain" name="domain">Domain: free text</dd>
                      </xsl:for-each>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- and/or -</dt>
                  <xsl:if test="count(codesetd) = 0">
                    <xsl:call-template name="no_codesetd_element"/>
                  </xsl:if>
                  <xsl:for-each select="codesetd">
                    <dt class="mandatory">Codeset_Domain</dt>
                    <dd id="definition" name="definition">Reference to a standard or list which contains the members of an established set of valid values.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">Codeset_Name: 
                      <xsl:for-each select="codesetn">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The title of the codeset.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                      <dt class="mandatory">Codeset_Source: 
                      <xsl:for-each select="codesets">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: The authority for the codeset.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- and/or -</dt>
                  <xsl:if test="count(udom) = 0">
                    <xsl:call-template name="no_udom_element"/>
                  </xsl:if>
                  <xsl:for-each select="udom">
                    <dt class="mandatory">Unrepresentable_Domain: </dt>
                    <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                    <dd id="definition" name="definition">Definition: Description of the values and reasons why they cannot be respresented.</dd>
                    <dd id="domain" name="domain">Domain: free text</dd>
                  </xsl:for-each>
                </dl>
                </dd>
              </xsl:for-each>

              <xsl:if test="count(begdatea) = 0">
                <dt class="mandatoryif">Beginning_Date_of_Attribute_Values:</dt>
              </xsl:if>
              <xsl:for-each select="begdatea">
                <dt class="mandatoryif">Beginning_Date_of_Attribute_Values: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: Earliest or only date for which the attribute values are current. In cases when a range of dates are provided, this is the earliest date for which the information is valid.</dd>
              <dd id="domain" name="domain">Domain: free date</dd>

              <xsl:if test="count(enddatea) = 0">
                <dt class="mandatoryif">Ending_Date_of_Attribute_Values:</dt>
              </xsl:if>
              <xsl:for-each select="enddatea">
                <dt class="mandatoryif">Ending_Date_of_Attribute_Values: <span class="normal"><xsl:value-of select="."/></span></dt>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The latest date for which the information is current. Used in cases when a range of dates are provided.</dd>
              <dd id="domain" name="domain">Domain: free date</dd>


              <xsl:if test="count(attrvai) = 0">
                <xsl:call-template name="no_attrvai_element"/>
              </xsl:if>
              <xsl:for-each select="attrvai">
                <dt id="optional" name="optional">Attribute_Value_Accuracy_Information</dt>
                <dd id="definition" name="definition">An assessment of the accuracy of the assignment of attribute values.</dd>
                <dd class="optional">
                <dl>
                  <dt class="mandatory">Attribute_Value_Accuracy: 
                  <xsl:for-each select="attrva">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: An estimate of the accuracy of the assignment of attribute values.</dd>
                  <dd id="domain" name="domain">Domain: free real</dd>
                  <dt class="mandatory">Attribute_Value_Accuracy_Explanation: </dt>
                  <xsl:for-each select="attrvae">
                    <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: The definition of the Attribute Value Accuracy measure and units, and a description of how the estimate was derived.</dd>
                  <dd id="domain" name="domain">Domain: free text</dd>
                 </dl>
                </dd>
              </xsl:for-each>
              <dt id="optional" name="optional">Attribute_Measurement_Frequency: </dt>
              <xsl:for-each select="attrmfrq">
                <dd><span class="normal"><xsl:value-of select="."/></span></dd>
              </xsl:for-each>
              <dd id="definition" name="definition">Definition: The frequency with which attribute values are added.</dd>
              <dd id="domain" name="domain">Domain: "Unknown", "As needed", "Irregular", "None planned", free text</dd>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="normal">- and/or -</dt>

      <xsl:if test="count(overview) = 0">
        <xsl:call-template name="no_overview_element"/>
      </xsl:if>
      <xsl:for-each select="overview">
        <dt class="mandatory">Overview_Description</dt>
        <dd id="definition" name="definition">Summary of, and citation to detailed description of, the information content of the data set.</dd>
        <dd>
        <dl>
          <dt class="mandatory">Entity_and_Attribute_Overview: </dt>
          <xsl:for-each select="eaover">
            <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: Detailed summary of the information in a data set.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
          <xsl:if test="count(eadetcit) = 0">
            <dt class="mandatory">Entity_and_Attribute_Detail_Citation: </dt>
          </xsl:if>
          <xsl:for-each select="eadetcit">
            <dt class="mandatory">Entity_and_Attribute_Detail_Citation: </dt>
            <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: Reference to the complete description of the entity types, attributes, and attribute values of the data set.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- Distribution -->
<xsl:template match="distinfo">
  <a>
    <xsl:attribute name="name"><xsl:text>Distributor</xsl:text><xsl:value-of select="position()"/></xsl:attribute>
    <hr/>
  </a>
  <dl>
    <dt class="mandatoryif">Distribution_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Information about the distributor of and options for obtaining the data set.</dd>
    <dd>
    <dl>
      <xsl:if test="count(distrib) = 0">
        <dt class="mandatory">Distributor</dt>
        <dd id="definition" name="definition">The party from whom the data set may be obtained.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_cntinfo_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="distrib">
        <dt class="mandatory">Distributor</dt>
        <dd id="definition" name="definition">The party from whom the data set may be obtained.</dd>
        <xsl:if test="count(cntinfo) = 0">
          <dd>
          <dl>
            <xsl:call-template name="no_cntinfo_element"/>
          </dl>
          </dd>
        </xsl:if>
        <dd>
        <dl>
          <xsl:apply-templates select="cntinfo"/>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatoryif">Resource_Description: 
      <xsl:for-each select="resdesc">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: The identifier by which the distributor knows the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
      <dt class="mandatory">Distribution_Liability: </dt>
      <xsl:for-each select="distliab">
        <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: Statement of the liability assumed by the distributor.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <xsl:if test="count(stdorder) = 0">
        <xsl:call-template name="no_stdorder_element"/>
      </xsl:if>
      <xsl:for-each select="stdorder">
      <dt class="mandatoryif">Standard_Order_Process</dt>
      <dd id="definition" name="definition">The common ways in which the data set may be obtained or received, and related instructions and fee information.</dd>
        <dd>
        <dl>
          <dt class="mandatory">Non-digital_Form: </dt>
          <xsl:for-each select="nondig">
            <dd><span class="normal"><xsl:value-of select="."/></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: The description of options for obtaining the data set on non-computer-compatible media.</dd>
              <dd id="domain" name="domain">Domain: free text</dd>
          <dt class="normal">- or -</dt>
          <xsl:if test="count(digform) = 0">
            <xsl:call-template name="no_digform_element"/>
          </xsl:if>
          <xsl:for-each select="digform">
            <dt class="mandatory">Digital_Form</dt>
            <dd id="definition" name="definition">The description of options for obtaining the data set on a computer-compatible media.</dd>
            <dd>
            <dl>
              <xsl:if test="count(digtinfo) = 0">
                <xsl:call-template name="no_digtinfo_element"/>
              </xsl:if>
              <xsl:for-each select="digtinfo">
                <dt class="mandatory">Digital_Transfer_Information</dt>
                <dd id="definition" name="definition">The description of the form of the data to be distributed.</dd>
                <dd>
                <dl>
                  <dt class="mandatory">Format_Name: 
                  <xsl:for-each select="formname">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: The name of the data transfer format.</dd>
                  <dd id="domain" name="domain">Domain: "ARCE", "ARCG", "ASCII", "BIL", "BIP", "BSQ", "CDF", "CFF", "COORD", "DEM", "DFAD", "DGN", "DIGEST", "DLG", DTED", "DWG", DX90", DXF", "ERDAS", "GRASS", "HDF", "IGDS", "IGES", "MOSS", "netDCF", "NITF", "RPF", "RVC", "RVF", "SDTS", "SIF", "SLF", "TIFF", "TGRLN", "VPF", free text</dd>
                  <dt class="mandatory">Format_Version_Number: 
                  <xsl:for-each select="formvern">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: Version number of the format.</dd>
                  <dd id="domain" name="domain">Domain: free text</dd>
                  <dt class="normal">- or -</dt>
                  <dt class="mandatory">Format_Version_Date: 
                  <xsl:for-each select="formverd">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: Date of the version of the format.</dd>
                  <dd id="domain" name="domain">Domain: free date</dd>
                  <dt id="optional" name="optional">Format_Specification:</dt>
                  <xsl:for-each select="formspec">
                    <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: Name of a subset, profile, or product specification of the fomat.</dd>
                  <dd id="domain" name="domain">Domain: free text</dd>
                  <dt id="optional" name="optional">Format_Information_Content: </dt>
                  <xsl:for-each select="formcont">
                    <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
                  </xsl:for-each>
                  <dd id="definition" name="definition">Definition: Description of the content of the data encoded in a format.</dd>
                  <dd id="domain" name="domain">Domain: free text</dd>
                  <dt class="mandatoryif">File_Decompression_Technique: 
                  <xsl:for-each select="filedec">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: Recommendations of algorithms or process (including means of obtaining these algorithms or processes) that can be applied to read or expand data sets to which data compression techniques have been applied.</dd>
                  <dd id="domain" name="domain">Domain: "No compression applied", free text</dd>
                  <dt id="optional" name="optional">Transfer_Size: 
                  <xsl:for-each select="transize">
                    <span class="normal"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  </dt>
                  <dd id="definition" name="definition">Definition: The size, or estimated size, of the transferred data set in megabytes.</dd>
                  <dd id="domain" name="domain">Domain: Transfer Size &gt; 0.0</dd>
                </dl>
                </dd>
              </xsl:for-each>

              <xsl:if test="count(digtopt) = 0">
                <xsl:call-template name="no_digtopt_element"/>
              </xsl:if>

              <xsl:for-each select="digtopt">
                <dt class="mandatory">Digital_Transfer_Option</dt>
                <dd id="definition" name="definition">The means and media by which a data set is obtained from the distributor.</dd>
                <dd>
                <dl>
                  <xsl:if test="count(onlinopt) = 0">
                     <xsl:call-template name="no_onlinopt_element"/>
                  </xsl:if>
                  <xsl:for-each select="onlinopt">
                    <dt class="mandatory">Online_Option</dt>
                    <dd id="definition" name="definition">Information required to directly obtain the data set electronically.</dd>
                    <dd>
                    <dl>
                      <xsl:if test="count(computer) = 0">
                        <xsl:call-template name="no_computer_element"/>
                      </xsl:if>
                      <xsl:for-each select="computer">
                        <dt class="mandatory">Computer_Contact_Information</dt>
                        <dd id="definition" name="definition">Instructions for establishing communications with the distribution computer.</dd>
                        <dd>
                        <dl>
                          <xsl:if test="count(networka) = 0">
                             <xsl:call-template name="no_networka_element"/>
                          </xsl:if>
                          <xsl:for-each select="networka">
                            <dt  class="mandatory">Network_Address</dt>
                            <dd id="definition" name="definition">The electronic address from which the data set can be obtained from the distribution computer.</dd>
                            <dd>
                            <dl>
                              <xsl:for-each select="networkr">
                                <dt class="mandatory">Network_Resource_Name: <a target="viewer">
                                  <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a>
                                </dt>
                              </xsl:for-each>
                              <dd id="definition" name="definition">Definition: The name of the file or service from which the data set can be obtained.</dd>
                              <dd id="domain" name="domain">Domain: free text</dd>
                            </dl>
                            </dd>
                          </xsl:for-each>
                          <dt class="normal">- or -</dt>
                          <xsl:if test="count(dialinst) = 0">
                             <xsl:call-template name="no_dialinst_element"/>
                          </xsl:if>
                          <xsl:for-each select="dialinst">
                            <dt class="mandatory">Dialup_Instructions</dt>
                            <dd id="definition" name="definition">Definition: Information required to access the distribution computer remotely through telephone lines.</dd>
                            <dd>
                            <dl>
                              <dt class="mandatory">Lowest_BPS: 
                              <xsl:for-each select="lowbps">
                                <span class="normal"><xsl:value-of select="."/></span>
                              </xsl:for-each>
                              </dt>
                              <dd id="definition" name="definition">Definition: Lowest or only speed for the connection's communication, expressed in bits per second.</dd>
                              <dd id="domain" name="domain">Domain: Lowest BPS &gt;= 110</dd>
                              <dt class="mandatoryif">Highest_BPS: 
                              <xsl:for-each select="highbps">
                                <span class="normal"><xsl:value-of select="."/></span>
                              </xsl:for-each>
                              </dt>
                              <dd id="definition" name="definition">Definition: Highest speed for the connnection's communication, expressed in bits per second. Used in cases when a range of rates are provided.</dd>
                              <dd id="domain" name="domain">Domain: Highest BPS &gt; Lowest BPS</dd>
                              <dt class="mandatory">Number_DataBits: 
                              <xsl:for-each select="numdata">
                                <span class="normal"><xsl:value-of select="."/></span>
                              </xsl:for-each>
                              </dt>
                              <dd id="definition" name="definition">Definition: Number of data bits in each character exhanged in the communication.</dd>
                              <dd id="domain" name="domain">Domain: 7 &lt;= Number DataBits &lt;= 8</dd>
                              <dt class="mandatory">Number_StopBits: 
                              <xsl:for-each select="numstop">
                                <span class="normal"><xsl:value-of select="."/></span>
                              </xsl:for-each>
                              </dt>
                              <dd id="definition" name="definition">Definition: Number of stop bits in each character exchanged in the communication.</dd>
                              <dd id="domain" name="domain">Domain: 1 &lt;= Number StopBits &lt;= 2</dd>
                              <dt class="mandatory">Parity: 
                              <xsl:for-each select="parity">
                                <span class="normal"><xsl:value-of select="."/></span>
                              </xsl:for-each>
                              </dt>
                              <dd id="definition" name="definition">Definition: Parity error checking used in each character exchanged in the communication.</dd>
                              <dd id="domain" name="domain">Domain: "None", "Odd", "Even", "Mark", "Space"</dd>
                              <dt class="mandatoryif">Compression_Support: 
                              <xsl:for-each select="compress">
                                <span class="normal"><xsl:value-of select="."/></span>
                              </xsl:for-each>
                              </dt>
                              <dd id="definition" name="definition">Definition: Data compression available through the modem service to speed data transfer.</dd>
                              <dd id="domain" name="domain">Domain: "V.32", "V.32bis", "V.42", "V.42bis"</dd>
                              <xsl:if test="count(dialtel) = 0">
                                <dt class="mandatory">Dialup_Telephone:</dt>
                              </xsl:if> 
                              <xsl:for-each select="dialtel">
                                <dt class="mandatory">Dialup_Telephone: <span class="normal"><xsl:value-of select="."/></span></dt>
                              </xsl:for-each>
                              <dd id="definition" name="definition">Definition: The telephone number of the distribution computer.</dd>
                              <dd id="domain" name="domain">Domain: free text</dd>
                              <xsl:if test="count(dialfile) = 0">
                                <dt class="mandatory">Dialup_File_Name:</dt>
                              </xsl:if>
                              <xsl:for-each select="dialfile">
                                <dt class="mandatory">Dialup_File_Name: <span class="normal"><xsl:value-of select="."/></span></dt>
                              </xsl:for-each>
                              <dd id="definition" name="definition">Definition: The name of a file containing the data set on the distribution computer.</dd>
                              <dd id="domain" name="domain">Domain: free text</dd>
                            </dl>
                            </dd>
                          </xsl:for-each>
                        </dl>
                        </dd>
                      </xsl:for-each>
                      <dt id="optional" name="optional">Access_Instructions: </dt>
                      <xsl:for-each select="accinstr">
                        <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                      </xsl:for-each>
                      <dd id="definition" name="definition">Definition: Instructions on the steps required to access the data set.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                      <dt id="optional" name="optional">Online_Computer_and_Operating_System: </dt>
                      <xsl:for-each select="oncomp">
                        <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                      </xsl:for-each>
                      <dd id="definition" name="definition">Definition: The brand of distribution computer and its operating system.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <dt class="normal">- or -</dt>

                  <xsl:if test="count(offoptn) = 0">
                     <xsl:call-template name="no_offoptn_element"/>
                  </xsl:if>
                  <xsl:for-each select="offoptn">
                    <dt class="mandatory">Offline_Option</dt>
                    <dd id="definition" name="definition">Information about media-specific options for receiving the data set.</dd>
                    <dd>
                    <dl>
                      <dt class="mandatory">Offline_Media: 
                      <xsl:for-each select="offmedia">
                        <span class="normal"><xsl:value-of select="."/></span>
                      </xsl:for-each>
                      </dt>
                      <dd id="definition" name="definition">Definition: Name of the media on which the data set can be received.</dd>
                      <dd id="domain" name="domain">Domain: "CD-ROM", "3-1/2 inch floppy disk", "5-1/4 inch floppy disk", "9-track tape", "4mm cartridge tape", "8mm cartridge tape", "1/4-inch cartridge tape", free text</dd>
                      <dt class="mandatoryif">Recording_Capacity</dt>
                      <dd id="definition" name="definition">The density of information to which data are written. Used in cases where different recording capacities are possible.</dd>
                      <xsl:if test="count(reccap) = 0">
                         <xsl:call-template name="no_reccap_element"/>
                      </xsl:if>
                      <xsl:for-each select="reccap">
                        <dd>
                        <dl>
                          <xsl:if test="count(recden) = 0">
                            <dt class="mandatory">Recording_Density:</dt>
                          </xsl:if>
                          <xsl:for-each select="recden">
                            <dt class="mandatory">Recording_Density: <span class="normal"><xsl:value-of select="."/></span></dt>
                          </xsl:for-each>
                          <dd id="definition" name="definition">Definition: The density in which the data set can be recorded.</dd>
                          <dd id="domain" name="domain">Domain: Recording Density &gt; 0.0</dd>
                          <dt class="mandatory">Recording_Density_Units: 
                          <xsl:for-each select="recdenu">
                            <span class="normal"><xsl:value-of select="."/></span>
                          </xsl:for-each>
                          </dt>
                          <dd id="definition" name="definition">Definition: The units of measure for the recording density.</dd>
                          <dd id="domain" name="domain">Domain: free text</dd>
                        </dl>
                        </dd>
                      </xsl:for-each>
                      <xsl:if test="count(recfmt) = 0">
                        <dt class="mandatory">Recording_Format:</dt>
                      </xsl:if>
                      <xsl:for-each select="recfmt">
                        <dt class="mandatory">Recording_Format: <span class="normal"><xsl:value-of select="."/></span></dt>
                      </xsl:for-each>
                      <dd id="definition" name="definition">Definition: The options available or method used to write the data set to the medium.</dd>
                      <dd id="domain" name="domain">Domain: "cpio", "tar", "High Sierra", "ISO 9660", "ISO 9660 with Rock Ridge Extensions" "ISO 9660 with Apple HFS extensions", free text</dd>
                      <dt class="mandatoryif">Compatibility_Information: </dt>
                      <xsl:for-each select="compat">
                        <dd><span class="normal"><xsl:value-of select="."/></span></dd>
                      </xsl:for-each>
                      <dd id="definition" name="definition">Definition: Description of other limitations or requirements for using the medium.</dd>
                      <dd id="domain" name="domain">Domain: free text</dd>
                    </dl>
                    </dd>
                  </xsl:for-each>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>

          <dt class="mandatory">Fees: 
          <xsl:for-each select="fees">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: The fees and terms for retrieving the data set.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
          <dt id="optional" name="optional">Ordering_Instructions: </dt>
          <xsl:for-each select="ordering">
          <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: General instructions and advice about, and special terms and services provided for, the data set by the distributor.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
          <dt id="optional" name="optional">Turnaround: 
          <xsl:for-each select="turnarnd">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: Typical turnaround time for the filling of an order.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatoryif">Custom_Order_Process: </dt>
      <xsl:for-each select="custom">
        <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: Description of custom distribution services available, and the terms and conditions for obtaining these services.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
       <dt id="optional" name="optional">Technical_Prerequisites: </dt>
       <xsl:for-each select="techpreq">
        <dd class="optional"><span class="normal"><xsl:value-of select="."/></span></dd>
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: Description of any technical capabilities that the consumer must have to use the data set in the form(s) provided by the distributor.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
      <xsl:if test="count(availabl) = 0">
        <dt id="optional" name="optional">Available_Time_Period</dt>
        <dd id="definition" name="definition">The time period when the data set will be available from the the distributor.</dd>
        <dd class="optional">
        <dl>
        <xsl:call-template name="no_timeinfo_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="availabl">
        <dt id="optional" name="optional">Available_Time_Period</dt>
        <dd id="definition" name="definition">The time period when the data set will be available from the the distributor.</dd>
        <dd class="optional">
        <dl>
          <xsl:apply-templates select="timeinfo"/>
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- Metadata -->
<xsl:template match="metainfo">
  <a name="Metadata_Reference_Information"><hr/></a>
  <dl>
    <dt class="mandatory">Metadata_Reference_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Information on the currentness of the metadata information, and the responsible party.</dd>
    <dd>
    <dl>
      <dt class="mandatory">Metadata_Date: 
      <xsl:for-each select="metd">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: The date that the metadata were created or last updated.</dd>
      <dd id="domain" name="domain">Domain: free date</dd>
      <dt id="optional" name="optional">Metadata_Review_Date: 
      <xsl:for-each select="metrd">
         <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: The date of the last review of the metadata entry.</dd>
      <dd id="domain" name="domain">Domain: free date; Metadata Review Date later than Metadata Date.</dd>
      <dt id="optional" name="optional">Metadata_Future_Review_Date:
      <xsl:for-each select="metfrd">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: The date by which the metadata should be reviewed.</dd>
      <dd id="domain" name="domain">Domain: free date; Metadata Future Review Date later than Metadata Review Date.</dd>

      <xsl:if test="count(metc) = 0">
        <dt class="mandatory">Metadata_Contact</dt>
        <dd id="definition" name="definition">The party responsible for the metadata information.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_cntinfo_element"/>
        </dl>
        </dd>
      </xsl:if>
      <xsl:for-each select="metc">
        <dt class="mandatory">Metadata_Contact</dt>
        <dd id="definition" name="definition">The party responsible for the metadata information.</dd>
        <xsl:if test="count(cntinfo) = 0">
          <dd>
          <dl>
            <xsl:call-template name="no_cntinfo_element"/>
          </dl>
          </dd>
        </xsl:if>
        <dd>
        <dl>
          <xsl:apply-templates select="cntinfo"/>
        </dl>
        </dd>
      </xsl:for-each>

      <dt class="mandatory">Metadata_Standard_Name: 
      <xsl:for-each select="metstdn">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: The name of the metadata standard used to document the data set.</dd>
      <dd id="domain" name="domain">Domain: "FGDC Content Standard for Digital Geospatial Metadata", free text</dd>

      <dt class="mandatory">Metadata_Standard_Version: 
      <xsl:for-each select="metstdv">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: Identification of the version of the metadata standard used to document the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <dt class="mandatoryif">Metadata_Time_Convention: 
      <xsl:for-each select="mettc">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: Form used to convey time of day information in the metadata entry. Used if time of day information is included in the metadata for a data set.</dd>
      <dd id="domain" name="domain">Domain: "local time", "local time with time differential factor", "universal time", free text</dd>

      <dt id="optional" name="optional">Metadata_Access_Constraints: 
      <xsl:for-each select="metac">
        <span class="normal"><xsl:value-of select="."/></span>
      </xsl:for-each>
      </dt>
      <dd id="definition" name="definition">Definition: Restrictions and legal prerequisites for accessing the metadata. These include any access constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations or obtaining the metadata.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <dt id="optional" name="optional">Metadata_Use_Constraints: </dt>
      <xsl:for-each select="metuc">
        <dd><span class="normal"><xsl:value-of select="."/></span></dd>
      </xsl:for-each>
      <dd id="definition" name="definition">Definition: Restrictions and legal prerequisites for using the metadata after access is granted. These include any metadata use constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations on using the metadata.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <xsl:if test="count(metsi) = 0">
        <xsl:call-template name="no_metsi_element"/>
      </xsl:if>
      <xsl:for-each select="metsi">
        <dt id="optional" name="optional">Metadata_Security_Information</dt>
        <dd id="definition" name="definition">Handling restrictions imposed on the metadata because of national security, privacy, or other concerns.</dd>
        <dd class="optional">
        <dl>

          <dt class="mandatory">Metadata_Security_Classification_System: 
          <xsl:for-each select="metscs">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: Name of the classification system for the metadata.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>

          <dt class="mandatory">Metadata_Security_Classification: 
          <xsl:for-each select="metsc">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: Name of the handling restrictions on the metadata.</dd>
          <dd id="domain" name="domain">Domain: "Top secret", "Secret", "Confidential", "Restricted", "Unclassified", "Sensitive", free text</dd>

          <dt class="mandatory">Metadata_Security_Handling_Description: </dt>
          <xsl:for-each select="metshd">
            <dd><span class="normal"><xsl:value-of select="."/></span></dd>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: Additional information about the restrictions on handling the metadata.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:if test="count(metextns) = 0">
        <xsl:call-template name="no_metextns_element"/>
      </xsl:if>
      <xsl:for-each select="metextns">
        <dt class="mandatoryif">Metadata_Extensions</dt>
        <dd id="definition" name="definition">A reference to extended elements to the standard which may be defined by a metadata producer or a user community. Extended elements are elements outside the Standard, but needed by the metadata producer. If extened elements are created, they must follow the guidelines in Appendix D, Guidelines for Creating Extended Elements to the Content Standard for Digital Geospatial Data.</dd>
        <dd>
        <dl>
          <xsl:if test="count(onlink) = 0">
            <dt class="mandatoryif">Online_Linkage: </dt>
          </xsl:if>
          <xsl:for-each select="onlink">
            <dt class="mandatoryif">Online_Linkage: <a target="viewer">
              <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a>
            </dt>
          </xsl:for-each>
          <dd id="definition" name="definition">Definition: The name of an online computer resource that contains the metadata extension information for the data set. Entries should follow the Uniform Resource Locator (URL) convention of the Internet.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
          <dt class="mandatoryif">Profile_Name: 
          <xsl:for-each select="metprof">
            <span class="normal"><xsl:value-of select="."/></span>
          </xsl:for-each>
          </dt>
          <dd id="definition" name="definition">Definition: The name given to a document that describes the application of the Standard to a specific user community.</dd>
          <dd id="domain" name="domain">Domain: free text</dd>
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- No Idinfo Element -->
<xsl:template name="no_idinfo_element">
  <a name="Identification_Information"><hr/></a>
  <dl>
    <dt class="mandatory">Identification_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Basic information about the data set.</dd>
    <dd>
    <dl>
      <dt class="mandatory">Citation</dt>
      <dd id="definition" name="definition">Information to be used to reference the data set.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_citeinfo_element"/>
        </dl>
        </dd>
      <dt class="mandatory">Description</dt>
      <dd id="definition" name="definition">A characterization of the data set, including its intended use and limitations.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_descript_element"/>
        </dl>
        </dd>
      <dt class="mandatory">Time_Period_of_Content</dt>
      <dd id="definition" name="definition">Time periods(s) for which the data set corresponds to the currentness reference.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_timeinfo_element"/>
          <dt class="mandatory">Currentness_Reference: </dt>
          <dd id="definition" name="definition">Definition: The basis on which the time period of content information is determined.</dd>
          <dd id="domain" name="domain">Domain: "ground condition", "publication date", free text</dd>
        </dl>
        </dd>
      <dt class="mandatory">Status</dt>
      <dd id="definition" name="definition">The state of and maintenance information for the data set.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_status_element"/>
        </dl>
        </dd>
      <dt class="mandatory">Spatial_Domain</dt>
      <dd id="definition" name="definition">The geographic areal domain of the data set.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_spdom_element"/>
        </dl>
        </dd>
      <dt class="mandatory">Keywords</dt>
        <dd id="definition" name="definition">Words or phrases summarizing an aspect of the data set.</dd>
        <xsl:call-template name="no_keywords_element"/>	
      <dt class="mandatory">Access_Constraints:</dt>
        <dd id="definition" name="definition">Definition: Restrictions and legal prerequisites for accessing the data set. These include any access constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations on obtaining the data set.</dd>
        <dd id="domain" name="domain">Domain: "None", free text</dd>
      <dt class="mandatory">Use_Constraints: </dt>
        <dd id="definition" name="definition">Definition: Restrictions and legal prerequisites for using the data set after access is granted. These include any use constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations on using the data set.</dd>
        <dd id="domain" name="domain">Domain: "None", free text</dd>
      <dt id="optional" name="optional">Point_of_Contact</dt>
        <dd id="definition" name="definition">Definition: Contact information for an individual or organization that is knowledgeable about the data set.</dd>
        <dd class="optional">
        <dl>
          <xsl:call-template name="no_cntinfo_element"/>
        </dl>
        </dd>
      <xsl:call-template name="no_browse_element"/>
      <dt id="optional" name="optional">Data_Set_Credit: </dt> 
      <dd id="definition" name="definition">Definition: Recognition of those who contributed to the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
      <xsl:call-template name="no_secinfo_element"/>
      <dt id="optional" name="optional">Native_Data_Set_Environment: </dt>
      <dd id="definition" name="definition">Definition: A description of the data set in the producer's processing environment, including items such as the name of the software, (including version), the computer operating system, filename (including host-, path-, and filenames), and the data set size.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
      <xsl:call-template name="no_crossref_element"/>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- No Descript Element -->
<xsl:template name="no_descript_element">
  <dt class="mandatory">Abstract: </dt>
  <dd id="definition" name="definition">Definition: A brief narrative summary of the data set.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>
  <dt class="mandatory">Purpose: </dt>
  <dd id="definition" name="definition">Definition: A summary of the intentions with which the data set was developed.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>
  <dt id="optional" name="optional">Supplemental_Information: </dt>
  <dd id="definition" name="definition">Definition: Other descriptive information about the data set.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>
</xsl:template>

<!-- No Status Element -->
<xsl:template name="no_status_element">
  <dt class="mandatory">Progress: </dt>
  <dd id="definition" name="definition">Definition: The state of the data set.</dd>
  <dd id="domain" name="domain">Domain: "Complete", "In work", "Planned"</dd>
  <dt class="mandatory">Maintenance_and_Update_Frequency: </dt>
  <dd id="definition" name="definition">Definition: The frequency with which changes and additions are made to the data set after the initial data set is completed.</dd>
  <dd id="domain" name="domain">Domain: "Continually", "Daily", "Weekly", "Monthly", "Annually", "Unknown", "As needed", "Irregular", "None planned", free text</dd>
</xsl:template>

<!-- No Spdom Element -->
<xsl:template name="no_spdom_element">
  <dt class="mandatory">Bounding_Coordinates</dt>
  <dd id="definition" name="definition">The limits of coverage of a data set expresed by latitude and longitude values in the order western-most, eastern-most, northern-most, and southern-most. For data sets that include a complete band of latitude and longitude around the earth, the West Bounding Coordinates shall be assigned the value -180.0, and the East Bounding Coordinate shall be assigned the value 180.0</dd>
    <dd>
    <dl>
      <dt class="mandatory">West_Bounding_Coordinate: </dt>
      <dd id="definition" name="definition">Western-most coordinate of the limit of coverages expressed in longitude.</dd>
      <dd id="domain" name="domain">Domain: -180.0 &lt;= West Bonding Coordinate &lt;= 180.0</dd>
      <dt class="mandatory">East_Bounding_Coordinate: </dt>
      <dd id="definition" name="definition">Eastern-most coordinate of the limit of coverages expressed in longitude.</dd>
      <dd id="domain" name="domain">Domain: -180.0 &lt;= East Bonding Coordinate &lt;= 180.0</dd>
      <dt class="mandatory">North_Bounding_Coordinate: </dt>
      <dd id="definition" name="definition">Northern-most coordinate of the limit of coverages expressed in latitude.</dd>
      <dd id="domain" name="domain">Domain: -90.0 &lt;= North Bonding Coordinate &lt;= 90.0; North Bounding Coordinate &gt;= South Bounding Coordinate</dd>
      <dt class="mandatory">South_Bounding_Coordinate: </dt>
      <dd id="definition" name="definition">Southern-most coordinate of the limit of coverages expressed in latitude.</dd>
      <dd id="domain" name="domain">Domain: -90.0 &lt;= South Bonding Coordinate &lt;= 90.0; South Bounding Coordinate &lt;= North Bounding Coordinate</dd>
    </dl>
    </dd>
  <dt id="optional" name="optional">Data_Set_G-Polygon</dt>
  <dd id="definition" name="definition">Coordinates defining the outline of an area covered by a data set.</dd>
  <dd class="optional">
  <dl>
    <dt class="mandatory">Data_Set_G-Polygon_Outer_G-Ring</dt>
    <dd id="definition" name="definition">The closed non-intersecting boundary of an interior area.</dd>
      <dd>
      <dl>
          <xsl:call-template name="no_grngpoin_element"/>
          <dt class="normal">- or -</dt>
          <xsl:call-template name="no_gring_element"/>
      </dl>
      </dd>
    <dt class="mandatoryif">Data_Set_G-Polygon_Exclusion_G-Ring</dt>
    <dd id="definition" name="definition">The closed non-intersecting boundary of a void area (or "hole" in an interior area).</dd>
      <dd>
      <dl>
          <xsl:call-template name="no_grngpoin_element"/>
          <dt class="normal">- or -</dt>
          <xsl:call-template name="no_gring_element"/>
      </dl>
      </dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Browse Element -->
<xsl:template name="no_browse_element">
  <dt id="optional" name="optional">Browse_Graphic</dt>
  <dd id="definition" name="definition">A graphic that provides an illustration of the data set. The graphic should include a legend for interpreting the graphic.</dd>
  <dd class="optional">
  <dl>
    <dt class="mandatory">Browse_Graphic_File_Name: </dt>
      <dd id="definition" name="definition">Definition: Name of the related graphic file that provides an illustration of the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Browse_Graphic_File_Description: </dt>
      <dd id="definition" name="definition">Definition: A text description of the illustration.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Browse_Graphic_File_Type: </dt>
      <dd id="definition" name="definition">Definition: Graphic file type of a related graphic file.</dd>
      <dd id="domain" name="domain">Domain: '"CGM", "EPS", "EMF", "GIF", "JPEG", "PBM", "PS", "TIFF", WMF", "XWD", free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Secinfo Element -->
<xsl:template name="no_secinfo_element">
  <dt id="optional" name="optional">Security_Information</dt>
  <dd id="definition" name="definition">Definition: Handling restrictions imposed on the data set because of national security, privacy or other concerns.</dd>
  <dd class="optional">
  <dl>
    <dt class="mandatory">Security_Classification_System: </dt>
      <dd id="definition" name="definition">Definition: Name of the classification system.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Security_Classification: </dt>
      <dd id="definition" name="definition">Definition: Name of the handling restrictions on the data set.</dd>
      <dd id="domain" name="domain">Domain: "Top secret", "Secret", "Confidential", "Restricted", "Unclassified", "Sensitive", free text</dd>
    <dt class="mandatory">Security_Handling_Description: </dt>
      <dd id="definition" name="definition">Definition: Additional information about the restrictions on handling the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Crossref Element -->
<xsl:template name="no_crossref_element">
  <dt id="optional" name="optional">Cross_Reference</dt>
  <dd id="definition" name="definition">Information about other, related data sets that are likely to be of interest.</dd>
  <dd class="optional">
  <dl>
    <xsl:call-template name="no_citeinfo_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- Time Period Info -->
<xsl:template match="timeinfo">
  <dt class="mandatory">Time_Period_Information</dt>
  <dd id="definition" name="definition">Information about the date and time of the event. A choice of 1 of 3 elements: Single_Date/Time or Multiple_Dates/Times or Range_of_Dates/Times.</dd>
  <dd>
  <dl>
    <xsl:if test="count(sngdate) = 0">
      <xsl:call-template name="no_sngdate_element"/>
    </xsl:if>
    <xsl:apply-templates select="sngdate"/>
    <dt class="normal">- or -</dt>
    <xsl:if test="count(mdattim) = 0">
      <xsl:call-template name="no_mdattim_element"/>
    </xsl:if>
    <xsl:apply-templates select="mdattim"/>
    <dt class="normal">- or -</dt>
    <xsl:if test="count(rngdates) = 0">
      <xsl:call-template name="no_rngdates_element"/>
    </xsl:if>
    <xsl:apply-templates select="rngdates"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Time Period Info Element -->
<xsl:template name="no_timeinfo_element">
  <dt class="mandatory">Time_Period_Information</dt>
  <dd id="definition" name="definition">Information about the date and time of the event. A choice of 1 of 3 elements: Single_Date/Time or Multiple_Dates/Times or Range_of_Dates/Times.</dd>
  <dd>
  <dl>
    <xsl:call-template name="no_sngdate_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_mdattim_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_rngdates_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Bounding Element-->
<xsl:template name="no_bounding_element">
  <dd>
  <dl>
    <dt class="mandatory">West_Bounding_Coordinate: </dt>
    <dd id="definition" name="definition">Western-most coordinate of the limit of coverages expressed in longitude.</dd>
    <dd id="domain" name="domain">Domain: -180.0 &lt;= West Bonding Coordinate &lt;= 180.0</dd>
    <dt class="mandatory">East_Bounding_Coordinate: </dt>
    <dd id="definition" name="definition">Eastern-most coordinate of the limit of coverages expressed in longitude.</dd>
    <dd id="domain" name="domain">Domain: -180.0 &lt;= East Bonding Coordinate &lt;= 180.0</dd>
    <dt class="mandatory">North_Bounding_Coordinate: </dt>
    <dd id="definition" name="definition">Northern-most coordinate of the limit of coverages expressed in latitude.</dd>
    <dd id="domain" name="domain">Domain: -90.0 &lt;= North Bonding Coordinate &lt;= 90.0; North Bounding Coordinate &lt;= South Bounding Coordinate</dd>
    <dt class="mandatory">South_Bounding_Coordinate: </dt>
    <dd id="definition" name="definition">Southern-most coordinate of the limit of coverages expressed in latitude.</dd>
    <dd id="domain" name="domain">Domain: -90.0 &lt;= South Bonding Coordinate &lt;= 90.0; South Bounding Coordinate &lt;= North Bounding Coordinate</dd>
  </dl>
  </dd>
</xsl:template>

<!-- G-Ring Point-->
<xsl:template match="grngpoin">
  <dt class="mandatory">G-Ring_Point</dt>
  <dd id="definition" name="definition">A single geographic location.</dd>
  <dd>
  <dl>
    <xsl:if test="count(gringlat) = 0">
      <dt class="mandatory">G-Ring_Latitude: </dt>
    </xsl:if>
    <xsl:for-each select="gringlat">
      <dt class="mandatory">G-Ring_Latitude: <span class="normal"><xsl:value-of select="."/></span></dt>
    </xsl:for-each>
    <dd id="definition" name="definition">The latitude of a point of the g-ring.</dd>
    <dd id="domain" name="domain">Domain: -90.0 &lt;= G-Ring Latitude &lt; 90.0</dd>
    <xsl:if test="count(gringlon) = 0">
      <dt class="mandatory">G-Ring_Latitude: </dt>
    </xsl:if>
    <xsl:for-each select="gringlon">
      <dt class="mandatory">G-Ring_Longitude: <span class="normal"><xsl:value-of select="."/></span></dt>
    </xsl:for-each>
    <dd id="definition" name="definition">The longitude of a point of the g-ring.</dd>
    <dd id="domain" name="domain">Domain: -180.0 &lt;= G-Ring Longitude &lt; 180.0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No G-Ring Point Element-->
<xsl:template name="no_grngpoin_element">
  <dt class="mandatory">G-Ring_Point</dt>
  <dd id="definition" name="definition">A single geographic location.</dd>
  <dd>
  <dl>
    <dt class="mandatory">G-Ring_Latitude: </dt>
    <dd id="definition" name="definition">The latitude of a point of the g-ring.</dd>
    <dd id="domain" name="domain">Domain: -90.0 &lt;= G-Ring Latitude &lt; 90.0</dd>
    <dt class="mandatory">G-Ring_Latitude: </dt>
    <dd id="definition" name="definition">The longitude of a point of the g-ring.</dd>
    <dd id="domain" name="domain">Domain: -180.0 &lt;= G-Ring Longitude &lt; 180.0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- G-Ring -->
<xsl:template match="gring">
  <dt class="mandatory">G-Ring: </dt>
  <dd><span class="normal"><xsl:value-of select="."/></span></dd>
  <dd id="definition" name="definition">A set of ordered pairs of floating-point numbers, separated by commas, in which the first number in each pair is the longitude of a point and the second is the latitude of the point. Longitude and latitude are specified in decimal degrees with north latitudes positive and south negative, east longitude positive and west negative.</dd>
  <dd id="domain" name="domain">Domain: -90 &lt;= Latitude Elements &lt;=90, -180 &lt;= Longitude Elements &lt;= 180</dd>
</xsl:template>

<!-- No G-Ring Element -->
<xsl:template name="no_gring_element">
  <dt class="mandatory">G-Ring: </dt>
  <dd id="definition" name="definition">A set of ordered pairs of floating-point numbers, separated by commas, in which the first number in each pair is the longitude of a point and the second is the latitude of the point. Longitude and latitude are specified in decimal degrees with north latitudes positive and south negative, east longitude positive and west negative.</dd>
  <dd id="domain" name="domain">Domain: -90 &lt;= Latitude Elements &lt;=90, -180 &lt;= Longitude Elements &lt;= 180</dd>
</xsl:template>

<!-- No Keywords Element-->
<xsl:template name="no_keywords_element">
  <dd>
  <dl>
    <xsl:call-template name="no_theme_element"/>
    <xsl:call-template name="no_place_element"/>
    <xsl:call-template name="no_stratum_element"/>
    <xsl:call-template name="no_temporal_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Theme Element-->
<xsl:template name="no_theme_element">
  <dt class="mandatory">Theme</dt>
  <dd id="definition" name="definition">Subjects covered by the data set (for a list of some commonly-used thesauri, see Part IV: Subject/index terms in Network Development and MARK Standards Office, 1988, USMARC code list for relators, sources, and description conventions: Washington Library of Congress).</dd>
    <dd>
    <dl>
    <dt class="mandatory">Theme_Keyword_Thesaurus: </dt>
      <dd id="definition" name="definition">Definition: Reference to a formally registered thesaurus or a similar authoritative source of theme keywords.</dd>
      <dd id="domain" name="domain">Domain: "None", free text</dd>
      <dt class="mandatory">Theme_Keyword: </dt>
      <dd id="definition" name="definition">Definition: Common-use word or phrase used to describe the subject of the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    </dl>
    </dd>
</xsl:template>

<!-- No Place Element-->
<xsl:template name="no_place_element">
  <dt class="mandatoryif">Place</dt>
  <dd id="definition" name="definition">Geographic locations characterized by the data set.</dd>
    <dd>
    <dl>
      <dt class="mandatory">Place_Keyword_Thesaurus: </dt>
      <dd id="definition" name="definition">Definition: Reference to a formally registered thesaurus or a similar authoritative source of place keywords.</dd>
      <dd id="domain" name="domain">Domain: "None", free text</dd>
      <dt class="mandatory">Place_Keyword: </dt>
      <dd id="definition" name="definition">Definition: The geographic name of a location covered by a data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    </dl>
    </dd>
</xsl:template>

<!-- No Stratum Element-->
<xsl:template name="no_stratum_element">
  <dt class="mandatoryif">Stratum</dt>
  <dd id="definition" name="definition">Layered, vertical locations characterized by the data set.</dd>
    <dd>
    <dl>
      <dt class="mandatory">Stratum_Keyword_Thesaurus: </dt>
      <dd id="definition" name="definition">Definition: Reference to a formally registered thesaurus or a similar authoritative source of stratum keywords.</dd>
      <dd id="domain" name="domain">Domain: "None", free text</dd>
      <dt class="mandatory">Stratum_Keyword: </dt>
      <dd id="definition" name="definition">Definition: The name of a vertical location used to describe the locations covered by a data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    </dl>
    </dd>
</xsl:template>

<!-- No Temporal Element-->
<xsl:template name="no_temporal_element">
  <dt class="mandatoryif">Temporal</dt>
  <dd id="definition" name="definition">Time period(s) covered by the data set.</dd>
    <dd>
    <dl>
      <dt class="mandatory">Temporal_Keyword_Thesaurus: </dt>
      <dd id="definition" name="definition">Definition: Reference to a formally registered thesaurus or a similar authoritative source of temporal keywords.</dd>
      <dd id="domain" name="domain">Domain: "None", free text</dd>
      <dt class="mandatory">Temporal_Keyword: </dt>
      <dd id="definition" name="definition">Definition: The name of a time period covered by a data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    </dl>
    </dd>
</xsl:template>

<!-- No Dataqual Element -->
<xsl:template name="no_dataqual_element">
  <a name="Data_Quality_Information"><hr/></a>
  <dl>
    <dt class="mandatoryif">Data_Quality_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">A general assessment of the quality of the data set. (Recommendations on information to be reported and tests to be performed are found in "Spatial Data Quality," which is chapter 3 of part 1 in Department of Commerce, 1992, Spatial Data Transfer Standard (SDTS) (Federal Information Processing Standard 173): Washington, Department of Commerce, National Institute of Standards and Technology.)</dd>
    <dd>
    <dl>
        <xsl:call-template name="no_attracc_element"/>

      <dt class="mandatory">Logical_Consistency_Report: </dt>
      <dd id="definition" name="definition">Definition: An explanation of the fidelity of relationships in the data set and tests used.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <dt class="mandatory">Completeness_Report: </dt>
      <dd id="definition" name="definition">Definition: Information about omissions, selection criteria, generalization, definitions used, and other rules used to derive the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <dt class="mandatoryif">Positional_Accuracy</dt>
      <dd id="definition" name="definition">An assessment of the accuracy of the positions of spatial objects.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_horizpa_element"/>
          <xsl:call-template name="no_vertacc_element"/>
        </dl>
        </dd>
      <dt class="mandatory">Lineage</dt>
      <dd id="definition" name="definition">Information about the events, parameters, and source data which constructed the data set, and information about the responsible parties.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_srcinfo_element"/>
          <xsl:call-template name="no_procstep_element"/>
        </dl>
        </dd>
      <dt id="optional" name="optional">Cloud_Cover:</dt>
      <dd id="definition" name="definition">Definition: Area of a data set obstructed by clouds, expressed as a percentage of the spatial extent.</dd>
      <dd id="domain" name="domain">Domain: 0&lt;= Cloud Cover &lt;= 100, "Unknown"</dd>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- No Attracc Element -->
<xsl:template name="no_attracc_element">
  <dt class="mandatoryif">Attribute_Accuracy</dt>
  <dd id="definition" name="definition">An assessment of the accuracy of the identification of entities and the assignment of attribute values in the data set.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Attribute_Accuracy_Report: </dt>
    <dd id="definition" name="definition">Definition: An explanation of the accuracy of the identification of the entities and assignments of values in the data set and a description of the tests used.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <xsl:call-template name="no_qattracc_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Qattracc Element -->
<xsl:template name="no_qattracc_element">
  <dt id="optional" name="optional">Quantitative_Attribute_Accuracy_Assessment</dt>
  <dd id="definition" name="definition">A value assigned to summarize the accuracy of the identification of the entities and the assignment of values in the data set and the identification of the test that yielded the value.</dd>
  <dd class="optional">
  <dl>
    <dt class="mandatory">Attribute_Accuracy_Value: </dt>
    <dd id="definition" name="definition">Definition: An estimate of the accuracy of the identification of the entities and assignments of attributes in the data set.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free text</dd>
    <dt class="mandatory">Attribute_Accuracy_Explanation: </dt>
    <dd id="definition" name="definition">Definition: The identification of the test that yielded the Attribute Accuracy Value.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Horizpa Element -->
<xsl:template name="no_horizpa_element">
  <dt class="mandatoryif">Horizontal_Positional_Accuracy</dt>
  <dd id="definition" name="definition">An estimate of accuracy of the horizontal positions of the spatial objects.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Horizontal_Positional_Accuracy_Report: </dt>
    <dd id="definition" name="definition">Definition: An explanation of the accuracy of the horizontal coordinate measurements and a description of the tests used.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <xsl:call-template name="no_qhorizpa_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Qhorizpa Element -->
<xsl:template name="no_qhorizpa_element">
  <dt id="optional" name="optional">Quantitative_Horizontal_Positional_Accuracy_Assessment</dt>
  <dd id="definition" name="definition">Numeric value assigned to summarize the accuracy of the horizontal coordinate measurements and the identification of the test that yielded the value.</dd>
  <dd class="optional">
  <dl>
    <dt class="mandatory">Horizontal_Positional_Accuracy_Value: </dt>
    <dd id="definition" name="definition">Definition: An estimate of the accuracy of the horizontal coordinate measurements in the data set expressed in (ground) meters.</dd>
    <dd id="domain" name="domain">Domain: free real</dd>
    <dt class="mandatory">Horizontal_Positional_Accuracy_Explanation: </dt>
    <dd id="definition" name="definition">Definition: The identification of the test that yielded the Horizontal Positional Accuracy Value.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Vertacc Element -->
<xsl:template name="no_vertacc_element">
  <dt class="mandatoryif">Vertical_Positional_Accuracy</dt>
  <dd id="definition" name="definition">An estimate of accuracy of the vertical positions in the data set.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Vertical_Positional_Accuracy_Report: </dt>
    <dd id="definition" name="definition">Definition: An estimation of the accuracy of the vertical coordinate measurements and a description of the tests used.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <xsl:call-template name="no_qvertpa_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Qvertpa Element -->
<xsl:template name="no_qvertpa_element">
  <dt id="optional" name="optional">Quantitative_Vertical_Positional_Accuracy_Assessment</dt>
  <dd id="definition" name="definition">Numeric value assigned to summarize the accuracy of vertical coordinate measurements and the identification of the test that yielded the value.</dd>
  <dd class="optional">
  <dl>
    <dt class="mandatory">Vertical_Positional_Accuracy_Value: </dt>
    <dd id="definition" name="definition">Definition: An estimate of the accuracy of the vertical coordinate measurements in the data set expressed in (ground) meters.</dd>
    <dd id="domain" name="domain">Domain: free real</dd>
    <dt class="mandatory">Vertical_Positional_Accuracy_Explanation: </dt>
    <dd id="definition" name="definition">Definition: The identification of the test that yielded the Vertical Postional Accuracy Value.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Srcinfo Element -->
<xsl:template name="no_srcinfo_element">
  <dt class="mandatoryif">Source_Information</dt>
  <dd id="definition" name="definition">List of sources and a short discussion of the information contributed by each.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Source_Citation</dt>
    <dd id="definition" name="definition">Reference for a source data set.</dd>
    <dd>
      <dl>
        <xsl:call-template name="no_citeinfo_element"/>
      </dl>
    </dd>
    <dt class="mandatoryif">Source_Scale_Denominator: </dt>
    <dd id="definition" name="definition">Definition: The denominator of the representative fraction on a map (for example, on a 1:24,000-scale map, the Source Scale Denominator is 24000).</dd>
    <dd id="domain" name="domain">Domain: Source Scale Denominator &gt; 1</dd>
    <dt class="mandatory">Type_of_Source_Media: </dt>
    <dd id="definition" name="definition">Definition: The medium of the source data set.</dd>
    <dd id="domain" name="domain">Domain: "paper", "stable-based material", "microfiche", "microfilm", "audiocassette", "chart", "filmstrip", "transparency", "videocassette", "videodisc", "videotape", "physical model", "computer program", "disc", "cartridge tape" "magnetic tape", "online", "CD-ROM", "electronic bulletin board", "electronic mail system", free text</dd>
    <dt class="mandatory">Source_Time_Period_of_Content</dt>
    <dd id="definition" name="definition">Time period(s) for which the source data set corresponds to the ground.</dd>
    <dd>
      <dl>
        <xsl:call-template name="no_timeinfo_element"/>
        <dt class="mandatory">Source_Currentness_Reference: </dt>
        <dd id="definition" name="definition">Definition: The basis on which the source time period of content information of the source data set is determined.</dd>
        <dd id="domain" name="domain">Domain: "ground condition", "publication date", free text</dd>
      </dl>
    </dd>
    <dt class="mandatory">Source_Citation_Abbreviation: </dt>
    <dd id="definition" name="definition">Definition: Short form alias for the source citation.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Source_Contribution: </dt>
    <dd id="definition" name="definition">Definition: Brief statement identifying the information contributed by the source to the data set.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Procstep Element -->
<xsl:template name="no_procstep_element">
  <dt class="mandatory">Process_Step</dt>
  <dd id="definition" name="definition">Information about a single event.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Process_Description: </dt>
    <dd id="definition" name="definition">Definition: An explanation of the event and related parameters or tolerances.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatoryif">Source_Used_Citation_Abbreviation: </dt>
    <dd id="definition" name="definition">Definition: The Source Citation Abbreviation of a data set used in the processing step.</dd>
    <dd id="domain" name="domain">Domain: Source Citation Abbreviations from the Source Information entries for the data set.</dd>
    <dt class="mandatory">Process_Date: </dt>
    <dd id="definition" name="definition">Definition: The date when the event was completed.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", "Not complete", free date</dd>
    <dt id="optional" name="optional">Process_Time: </dt>
    <dd id="definition" name="definition">Definition: The time when the event was completed.</dd>
    <dd id="domain" name="domain">Domain: free time</dd>
    <dt class="mandatoryif">Source_Produced_Citation_Abbreviation: </dt>
    <dd id="definition" name="definition">Definition: The Source Citation Abbreviation of an intermediate data set that (1) is significant in the opinion of the data producer, (2) is generated in the processing step, and (3) is used in later processing steps.</dd>
    <dd id="domain" name="domain">Domain: Source Citation Abbreviations from the Source Information entries for the data set.</dd>
    <dt id="optional" name="optional">Process_Contact</dt>
    <dd id="definition" name="definition">The party responsible for the processing step information.</dd>
    <dd class="optional">
    <dl>
      <xsl:call-template name="no_cntinfo_element"/>
    </dl>
    </dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Spdoinfo Element -->
<xsl:template name="no_spdoinfo_element">
  <a name="Spatial_Data_Organization_Information"><hr/></a>
  <dl>
    <dt class="mandatoryif">Spatial_Data_Organization_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">The mechanism used to represent spatial information in the data set.</dd>
    <dd>
    <dl>
      <dt class="mandatoryif">Indirect_Spatial_Reference_Method: </dt>
      <dd id="definition" name="definition">Definition: Name of types of geographic features, addressing schemes, or other means through which locations are referenced in the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>

      <dt class="mandatory">Direct_Spatial_Reference_Method:</dt>
      <dd id="definition" name="definition">Definition: The system of objects used to represent space in the data set.</dd>
      <dd id="domain" name="domain">Domain: "Point", "Vector", "Raster"</dd>

      <dt class="mandatory">Point_and_Vector_Object_Information</dt>
      <dd id="definition" name="definition">The types and numbers of vector or nongridded point spatial objects in the data set.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_sdtsterm_element"/>
          <dt class="normal">- or -</dt>
          <xsl:call-template name="no_vpfterm_element"/>
        </dl>
        </dd>
        <dt>- or - </dt>
        <xsl:call-template name="no_rastinfo_element"/>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- No Sdtsterm Element -->
<xsl:template name="no_sdtsterm_element">
  <dt class="mandatory">SDTS_Terms_Description <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Point and vector object information using the terminology and concepts from "Spatial Data Concepts", which is Chapter 2 of Part 1 in Department of Commerce, 1992, Spatial Data Transfer Standard (SDTS) (Federal Information Processing Standard 173): Washington, Department of Commerce, National Institute of Standards and Technology.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">SDTS_Point_and_Vector_Object_Type:</dt>
    <dd id="definition" name="definition">Definition: Name of point and vector spatial objects used to locate zero-, one-, and two-dimensional spatial locations in the data set.</dd>
    <dd id="domain" name="domain">Domain: (The domain is from "Spatial Data Concepts", which is Chapter 2 of Part 1 in Department of Commerce, 1992, Spatial Data Transfer Standard (SDTS) (Federal Information Processing Standard 173): Washington, Department of Commerce, National Institute of Standards and Technology): "Point", "Entity point", "Label point" "Area point", "Node, planar graph", "Node, network", "String", "Link", "Complete chain", "Area chain", Network chain, planar graph", "Network chain, nonplanar graph", "Circular arc, three point center", Elliptical arc", "Uniform B-spline", "Piecewise Bezier", "Ring with mized composition", "Ring composed of strings", "Ring composed of chains", "Ring composed of arcs", "G-polygon", "GT-polygon composed of rings", "GT-polygon composed of chains", "Universe polygon composed of rings", "Universe polygon composed of chains", Void polygon composed of rings", Void polygon composed of chains",free text</dd>
    <dt id="optional" name="optional">Point_and_Vector_Object_Count:</dt>
    <dd id="definition" name="definition">Definition: The total number of the point or vector object type occurring in the data set.</dd>
    <dd id="domain" name="domain">Domain: Point and Vector Count &gt; 0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Vpfterm Element -->
<xsl:template name="no_vpfterm_element">
  <dt class="mandatory">VPF_Terms_Description <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Point and vector object information using the terminology and concepts from Department of Defense, 1992, Vector Product Format (MIL-STD-600006): Philadelphia, Department of Defense, Defense Printing Service Detachment Office.</dd>
  <dd class="opentarget">
  <dl>
     <dt class="mandatory">VPF_Topology_Level:</dt>
    <dd id="definition" name="definition">Definition: The completeness of the topology carried by the data set. The levels of completeness are defined in Department of Defense, 1992, Vector Product Format (MIL-STD-600006): Philadelphia, Department of Defense, Defense Printing Service Detachment Office.</dd>
    <dd id="domain" name="domain">Domain: 0 &lt;= VPF Topology Level &lt;= 3</dd>
    <xsl:call-template name="no_vpfinfo_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Vpfinfo Element -->
<xsl:template name="no_vpfinfo_element">
    <dt class="mandatory">VPF_Point_and_Vector_Object_Information</dt>
    <dd id="definition" name="definition">Information about VPF point and vector objects.</dd>
    <dd>
    <dl>
      <dt class="mandatory">VPF_Point_and_Vector_Object_Type:</dt>
      <dd id="definition" name="definition">Definition: Name of point and vector spatial objects used to locate zero-, one-, and two-dimensional spationa locations in the data set.</dd>
                  <dd id="domain" name="domain">Domain: (The domain is from Department of Defense, 1992, Vector Product Format (MIL-STD-600006): Philidelphia, Department of Defense, Defense Printing Service Detachment Office): "Node", "Edge", "Face", "Text"</dd>
      <dt id="optional" name="optional">Point_and_Vector_Object_Count:</dt>
      <dd id="definition" name="definition">Definition: The total number of the point or vector object type occurring in the data set.</dd>
      <dd id="domain" name="domain">Domain: Point and Vector Count &gt; 0</dd>
    </dl>
    </dd>
</xsl:template>

<!-- No Rastinfo Element -->
<xsl:template name="no_rastinfo_element">
  <dt class="mandatory">Raster_Object_Information <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The types and numbers of raster spatial objects in the data set.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Raster_Object_Type:</dt>
    <dd id="definition" name="definition">Definition: Raster spatial objects used to locate zero-, two-, or three-dimensional locations in the data set.</dd>
    <dd id="domain" name="domain">Domain: (With the exception of "Voxel", the domain is from "Spatial Data Concepts", which is chapter 2 of part 1 in Department of Commerce, 1992, Spatial Data Transfer Standard (SDTS) (Federal Informaiton Processing Standard 173): Washington, Department of Commerce, National Institute of Standards and Technology): "Point", "Pixel", "Grid Cell", "Voxel"</dd>
    <dt class="mandatory">Row_Count:</dt>
    <dd id="definition" name="definition">Definition: The maximum number of raster objects along the ordinate (y) axis. For use with regular raster objects.</dd>
    <dd id="domain" name="domain">Domain: Row Count &gt; 0</dd>
    <dt class="mandatory">Column_Count:</dt>
    <dd id="definition" name="definition">Definition: The maximum number of raster objects along the abscissa (x) axis. For use with rectangular raster objects.</dd>
    <dd id="domain" name="domain">Domain: Column Count &gt; 0</dd>
    <dt class="mandatoryif">Vertical_Count:</dt>
    <dd id="definition" name="definition">Definition: The number of raster objects along the vertical (z) axis. For use with rectangular volumetric raster objects (voxels).</dd>
    <dd id="domain" name="domain">Domain: Vertical Count &gt; 0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Spref Element-->
<xsl:template name="no_spref_element">
  <a name="Spatial_Reference_Information"><hr/></a>
  <dl>
    <dt class="mandatoryif">Spatial_Reference_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Description of the reference frame for, and the means to encode, coordinates in the data set.</dd>
    <dd>
    <dl>
        <xsl:call-template name="no_horizsys_element"/>
        <xsl:call-template name="no_vertdef_element"/>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- No Horizsys Element-->
<xsl:template name="no_horizsys_element">
  <dt class="mandatoryif">Horizontal_Coordinate_System_Definition</dt>
  <dd id="definition" name="definition">The reference frame or system from which linear or angular quantities are measured and assigned to the postion that a point occupies.</dd>
  <dd>
  <dl>
    <xsl:call-template name="no_geograph_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_planar_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_local_element"/>
    <xsl:call-template name="no_geodetic_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Geograph Element-->
<xsl:template name="no_geograph_element">
  <dt class="mandatory">Geographic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The quantities of latitude and longitude which define the position of a point on the Earth's surface with respect to a reference spheriod.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Latitude_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The minimum difference between two adjacent latitude values expressed in Geographic Coordinates Units of measure.</dd>
    <dd id="domain" name="domain">Domain: Latitude Resolution &gt; 0.0</dd>
    <dt class="mandatory">Longitude_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The minimum difference between two adjacent longitude values expressed in Geographic Coordinates Units of measure.</dd>
    <dd id="domain" name="domain">Domain: Longitude Resolution &gt; 0.0</dd>
    <dt class="mandatory">Geographic_Coordinate_Units:</dt>
    <dd id="definition" name="definition">Definition: Units of measurement for the latitude and longitude values.</dd>
    <dd id="domain" name="domain">Domain: "Decimal degrees", "Decimal minutes", "Decimal seconds", "Degrees and decimal minutes", "Degrees, minutes, and decimal seconds", "Radians", "Grads"</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Planar Element-->
<xsl:template name="no_planar_element">
  <dt class="mandatory">Planar <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The quantities of distances, or distances and angles, which define the position of a point on a reference plane to which the surface of the Earth has been projected.</dd>
  <dd class="opentarget">
  <dl>
     <xsl:call-template name="no_mapproj_element"/>
     <dt class="normal">- or -</dt>
     <xsl:call-template name="no_gridsys_element"/>
     <dt class="normal">- or -</dt>
     <xsl:call-template name="no_localp_element"/>
     <xsl:call-template name="no_planci_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Mapproj Element-->
<xsl:template name="no_mapproj_element">
  <dt class="mandatory">Map_Projection <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The systematic representation of all or part of the surface of the Earth on a plane or developable surface.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Map_Projection_Name:</dt>
    <dd id="definition" name="definition">Definition: Name of the map projection.</dd>
    <dd id="domain" name="domain">Domain: "Albers Conical Equal Area", "Azimuthal Equidistant", "Equidistant Conic", "Equirectangular", "General Vertical Near-sided Perspective", "Gnomonic", "Lambert Azimuthal Equal Area", "Lambert Conformal Conic", "Mercator", "Modified Stereographic for Alaska", "Miller Cylindrical", "Oblique Mercator", "Orthographic", "Polar Stereographic", "Polyconic", "Robinson", "Sinusoidal", "Space Oblique Mercator (Landsat)", "Stereographic", "Transverse Mercator", "van der Grinten", free text</dd>     <xsl:call-template name="no_albers_conic_equal_area"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_azimuthal_equidistant"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_equidistic_conic"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_equirectangular"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_general_vertical_near-sided_perspective"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_gnomonic"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_lambert_azimuthal_equal_area"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_lambert_conformal_conic"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_mercator"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_modified_stereographic_for_alaska"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_miller_cylindrical"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_oblique_mercator"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_orthographic"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_polar_stereographic"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_polyconic"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_robinson"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_sinusoidal"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_space_oblique_mercator"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_stereographic"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_transverse_mercator"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_van_der_grinten"/>
    <!-- <xsl:call-template name="no_mapproj_property"/> -->
  </dl>
  </dd>
</xsl:template>

<!-- No Gridsys Element-->
<xsl:template name="no_gridsys_element">
  <dt class="mandatory">Grid_Coordinate_System <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">A plane rectangular coordinate system usually based on, and mathematically adjusted to, a map projection so that geographic positions can be readily transformed to and from plane coordinates.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Grid_Coordinate_System_Name:</dt>
    <dd id="definition" name="definition">Definition: Name of the grid coordinate system.</dd>
    <dd id="domain" name="domain">Domain: "Universal Transverse Mercator", "Universal Polar Stereographic", "State Plane Coordinate System 1927", "State Plane Coordinate System 1983", "ARC Coordinate System", "other grid system"</dd>
    <xsl:call-template name="no_utm_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_ups_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_spcs_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_arcsys_element"/>
    <dt class="normal">- or -</dt>
    <dt class="mandatory">Other_Grid_System's_Definition: </dt>
    <dd id="definition" name="definition">Definition: A complete description of a grid system, not defined elsewhere in the standard, that was used for the data set. The information provide shall include the name of the grid system, the names of the parameters and values used for the data set, and the citation of the specification for the algorithms that describe the mathematical relationship between Earth and the coordinates of the grid system.</dd>
    <dd id="domain" name="domain">Domain: free text"</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Utm Element-->
<xsl:template name="no_utm_element">
  <dt class="mandatory">Universal_Transverse_Mercator <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">A grid system based on the transverse mercator projection, applied between latitudes 84 degrees north and 80 degrees south on the Earth's surface.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">UTM_Zone_Number:</dt>
    <dd id="definition" name="definition">Definition: Identifier for the UTM zone.</dd>
    <dd id="domain" name="domain">Domain: 1 &lt;= UTM Zone Number &lt; 60 for the northern hemisphere; -60 &lt;= UTM Zone Number &lt;= -1 for the southern hemisphere.</dd>
    <!-- <dt class="mandatory">Transverse_Mercator</dt> -->
    <xsl:call-template name="no_transverse_mercator"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Ups Element-->
<xsl:template name="no_ups_element">
  <dt class="mandatory">Universal_Polar_Stereographic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">A grid system based on the polar stereographic projection, applied to the Earth's polar regions north of 84 degrees north and south of 80 degrees south.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">UPS_Zone_Identifier:</dt>
    <dd id="definition" name="definition">Definition: Identifier for the UPS zone.</dd>
    <dd id="domain" name="domain">Domain: "A", "B", "Y", "Z"</dd>
    <!-- <dt class="mandatory">Polar_Stereographic</dt> -->
    <xsl:call-template name="no_polar_stereographic"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Spcs Element-->
<xsl:template name="no_spcs_element">
  <dt class="mandatory">State_Plane_Coordinate_System <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">A plane-rectangular coordinate system established for each state in the United States by the National Geodetic Survey.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">SPCS_Zone_Identifier:</dt>
    <dd id="definition" name="definition">Definition: Identifier for the SPCS zone.</dd>
    <dd id="domain" name="domain">Domain: Four-digit numeric codes for the State Plane Coordinate Systems based on the North American Datum of 1927 are found in Department of Commerce, 1986, Representation of geographic point locations for information interchange (Federal Information Processing Standard 70-1): Washington: Department of Commerce, National Institute of Standards and Technology. Codes for the State Plane Coordinate Systems based on the North American Datum of 1983 are found in Department of Commerce, 1989 (January), State Plane Coordinate System of 1983 (National Oceanic and Atmospheric Administration Manual NOS NGS 5): Silver Spring, Maryland, National Oceanic and Atmospheric Administration, National Ocean Service, Coast and Geodetic Survey.</dd>
     <!-- <dt class="mandatory">Lambert_Conformal_Conic</dt> -->
    <xsl:call-template name="no_lambert_conformal_conic"/>
    <dt class="normal">- or -</dt>
     <!-- <dt class="mandatory">Transverse_Mercator</dt> -->
    <xsl:call-template name="no_transverse_mercator"/>
    <dt class="normal">- or -</dt>
     <!-- <dt class="mandatory">Oblique_Mercator</dt> -->
    <xsl:call-template name="no_oblique_mercator"/>
    <dt class="normal">- or -</dt>
     <!-- <dt class="mandatory">Polyconic</dt> -->
    <xsl:call-template name="no_polyconic"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Arcsys Element-->
<xsl:template name="no_arcsys_element">
  <dt class="mandatory">ARC_Coordinate_System <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The Equatorial Arc-second Coordinate System, a plane-rectangular coordinate system established in the Department of Defense, 1990, Military specification ARC Digitized Raster Graphics (ADRG) (MIL-A-89007): Philadelphia, Department of Defense, Defense Printing Service Detachment Office.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">ARC_System_Zone_Identifier:</dt>
    <dd id="definition" name="definition">Definition: Identifier for the ARC Coordinate System zone.</dd>
    <dd id="domain" name="domain">Domain: 1 &lt;= ARC System Zone Identifier &lt;= 18</dd>
    <!-- <dt class="mandatory">Equirectangular</dt> -->
    <xsl:call-template name="no_equirectangular"/>
    <dt class="normal">- or -</dt>
    <!-- <dt class="mandatory">Azimuthal_Equidistant</dt> -->
    <xsl:call-template name="no_azimuthal_equidistant"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Localp Element-->
<xsl:template name="no_localp_element">
  <dt class="mandatory">Local_Planar <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Any right-handed planar coordinate system of which the z-axis coincides with a plumb line through the origin that locally is alligned with the surface of the earth.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Local_Planar_Description: </dt>
    <dd id="definition" name="definition">Definition: A description of the local planar system.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Local_Planar_Georeference_Information: </dt>
    <dd id="definition" name="definition">Definition: A description of the information provided to register the local planar system to the Earth (e.g. control points, satellite ephemeral data, inertial navigation data).</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Planci Element-->
<xsl:template name="no_planci_element">
  <dt class="mandatory">Planar_Coordinate_Information</dt>
  <dd id="definition" name="definition">Information about the coordinate system developed on the planar surface.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Planar_Coordinate_Encoding_Method:</dt>
    <dd id="definition" name="definition">Definition: The means used to represent horizontal positions.</dd>
    <dd id="domain" name="domain">Domain: "coordinate pair", "distance and bearing", "row and column"</dd>
    <xsl:call-template name="no_coordrep_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_distbrep_element"/>
    <dt class="mandatory">Planar_Distance_Units:</dt>
    <dd id="definition" name="definition">Definition: Units of measure used for distances.</dd>
    <dd id="domain" name="domain">Domain: "meters", "international feet", "survey feet", free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Coordrep Element-->
<xsl:template name="no_coordrep_element">
  <dt class="mandatory">Coordinate_Representation <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The method of encoding the position of a point by measuring its distance from perpendicular reference axes (the "coordinate pair" and "row and column" methods).</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Abscissa_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The (nominal) minimum distance between the "x" or column values of two adjacent points, expressed in Planar Distance Units of measure.</dd>
    <dd id="domain" name="domain">Domain: Abscissa Resolution &gt; 0.0</dd>
    <dt class="mandatory">Ordinate_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The (nominal) minimum distance between the "y" or row values of two adjacent points, expressed in Planar Distance Units of measure.</dd>
    <dd id="domain" name="domain">Domain: Ordinate Resolution &gt; 0.0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Distbrep Element-->
<xsl:template name="no_distbrep_element">
  <dt class="mandatory">Distance_and_Bearing_Representation <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">A method of encoding the position of a point by measuring its distance and direction (azimuth angle) from another point.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Distance_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The minimum distance measurable between two points, expressed in Planar Distance Units of measure.</dd>
    <dd id="domain" name="domain">Domain: Distance Resolution &gt; 0.0</dd>
    <dt class="mandatory">Bearing_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The minimum angle measurable between two points, expressed in Bearing Units of measure.</dd>
    <dd id="domain" name="domain">Domain: Distance Resolution &gt; 0.0</dd>
    <dt class="mandatory">Bearing_Units:</dt>
    <dd id="definition" name="definition">Definition: Units of measure used for angles.</dd>
    <dd id="domain" name="domain">Domain: "Decimal degrees", "Decimal minutes", "Decimal seconds", "Degrees and decimal minutes", "Degrees, minutes, and decimal seconds", "Radians", "Grads"</dd>
    <dt class="mandatory">Bearing_Reference_Direction:</dt>
    <dd id="definition" name="definition">Definition: Direction from which the bearing is measured.</dd>
    <dd id="domain" name="domain">Domain: "North", "South"</dd>
    <dt class="mandatory">Bearing_Reference_Meridian:</dt>
    <dd id="definition" name="definition">Definition: Axis from which the bearing is measured.</dd>
    <dd id="domain" name="domain">Domain: "Assumed", "Grid", "Magnetic", "Astronomic", "Geodetic"</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Local Element-->
<xsl:template name="no_local_element">
  <dt class="mandatory">Local <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">A description of any coordinate system that is not alligned with the surface of the Earth.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Local_Description:</dt>
    <dd id="definition" name="definition">Definition: A description of the coordinate system and its orientation to the surface of the Earth.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Local_Georeference_Information: </dt>
    <dd id="definition" name="definition">Definition: A description of the information provided to register the local system to the Earth (e.g. control points, satellite ephemeral data, inertial navigation data).</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Geodetic Element-->
<xsl:template name="no_geodetic_element">
  <dt class="mandatoryif">Geodetic_Model</dt>
  <dd id="definition" name="definition">Parameterf for the shape of the Earth.</dd>
  <dd>
  <dl>
    <dt class="mandatoryif">Horizontal_Datum_Name:</dt>
    <dd id="definition" name="definition">Definition: The identificatin given to the reference system used for defining the coordinates of points.</dd>
    <dd id="domain" name="domain">Domain: "North American Datum of 1927", "North American Datum of 1983", free text</dd>
    <dt class="mandatory">Ellipsoid_Name:</dt>
    <dd id="definition" name="definition">Definition: Identification given to established representations of the Earth's shape.</dd>
    <dd id="domain" name="domain">Domain: "Clarke 1866" "Geodetic Reference System 80", free text</dd>
    <dt class="mandatory">Semi-major_Axis:</dt>
    <dd id="definition" name="definition">Definition: Radius of the equatorial axis of the ellipsoid.</dd>
    <dd id="domain" name="domain">Domain: Semi-major Axis &gt; 0.0</dd>
    <dt class="mandatory">Denominator_of_Flattening_Ratio:</dt>
    <dd id="definition" name="definition">Definition: The denominator of the ratio of the difference between the equatorial and polar radii of the ellipsoid when the numerator is set to 1.</dd>
    <dd id="domain" name="domain">Domain: Denominator of Flattening &gt; 0.0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Vertdef Element-->
<xsl:template name="no_vertdef_element">
  <dt class="mandatoryif">Vertical_Coordinate_System_Definition</dt>
  <dd id="definition" name="definition">The reference frame or system from which vertical distances (altitudes or depths) are measured.</dd>
  <dd>
  <dl>
     <xsl:call-template name="no_altsys_element"/>
     <xsl:call-template name="no_depthsys_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Altsys Element-->
<xsl:template name="no_altsys_element">
  <dt class="mandatoryif">Altitude_System_Definition</dt>
  <dd id="definition" name="definition">The reference frame or system from which atitudes (elevations) are measured. The term "altitude" is used instead of the common term "elevation" to conform to terminology in the Federal Processing Standards 70-1 and 173.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Altitude_Datum_Name:</dt>
    <dd id="definition" name="definition">Definition: The identification given to the surface taken as the surface of reference from which altitudes are measured.</dd>
    <dd id="domain" name="domain">Domain: "National Geodetic Vertical Datum of 1929", "North American Vertical Datum of 1988", free text</dd>
    <dt class="mandatory">Altitude_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The minimum distance possible between two adjacent altitude values, expressed in Altitude Distance Units of measure.</dd>
    <dd id="domain" name="domain">Domain: Altitude Resolution &gt; 0.0</dd>
    <dt class="mandatory">Altitude_Distance_Units:</dt>
    <dd id="definition" name="definition">Definition: Units in which altitudes are recorded.</dd>
    <dd id="domain" name="domain">Domain: "meters", "feet", free text</dd>
    <dt class="mandatory">Altitude_Encoding_Method:</dt>
    <dd id="definition" name="definition">Definition: The means used to encode the altitudes.</dd>
    <dd id="domain" name="domain">Domain: "Explicit elevation coordinate included with horizontal coordinates", Implicit coordinate", "Attribute values"</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Depthsys Element-->
<xsl:template name="no_depthsys_element">
  <dt class="mandatoryif">Depth_System_Definition</dt>
  <dd id="definition" name="definition">The reference frame or system from which depths are measured.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Depth_Datum_Name:</dt>
    <dd id="definition" name="definition">Definition: The identification given to surface or reference from which depths are measured.</dd>
    <dd id="domain" name="domain">Domain: "Local surface", "Chart datum; datum for sounding reduction", "Lowest astronomical tide", "Highest astronomical tide", "Mean low water", "Mean high water", "Mean sea level", "Land survey datum", "Mean low water springs", Mean high water springs", "Mean low water neap", Mean high water neap", "Mean lower low water", "Mean lower low water springs", "Mean higher high water", "Mean lower high water", "Sring tide", "Tropical lower low water", "Neap tide", "High water", "Higher high water", "Low water", "Low-water datum", "Lowest low water", "Lower low water", "Lowest normal low water", "Mean tide level", "Indian spring low water", "High-water full and charge", "Low-water full and charge", "Columbia River datum", "Gulf Coast low water datum", "Equatorial springs low water", "Approximate lowest astonomical tide", "No correction", free text</dd>
    <dt class="mandatory">Depth_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The minimum distance possible between two adjacent depth values, expressed in Depth Distance Units of Measure.</dd>
    <dd id="domain" name="domain">Domain: Depth Resolution &gt; 0.0</dd>
    <dt class="mandatory">Depth_Distance_Units:</dt>
    <dd id="definition" name="definition">Definition: Units in which depths are recorded.</dd>
    <dd id="domain" name="domain">Domain: "meters", "feet", free text</dd>
    <dt class="mandatory">Depth_Encoding_Method:</dt>
    <dd id="definition" name="definition">Definition: The means used to encode depths.</dd>
    <dd id="domain" name="domain">Domain: "Explicit depth coordinate included with horizontal coordinates", Implicit coordinate", "Attribute values"</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Entity and Attribute Element-->
<xsl:template name="no_eainfo_element">
  <a name="Entity_and_Attribute_Information"><hr/></a>
  <dl>
    <dt class="mandatoryif">Entity_and_Attribute_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Details about the information content of the data set, including the entity types, their attributes, and the domains from which attribute values may be assigned.</dd>
    <dd>
    <dl>
        <xsl:call-template name="no_detailed_element"/>
        <dt class="normal">- and/or -</dt>
        <xsl:call-template name="no_overview_element"/>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- No Detailed Element-->
<xsl:template name="no_detailed_element">
  <dt class="mandatory">Detailed_Description</dt>
  <dd id="definition" name="definition">Description of the entities, attributes, attribute values, and related characteristics encoded in the data set.</dd>
  <dd>
  <dl>
    <xsl:call-template name="no_enttyp_element"/>
    <xsl:call-template name="no_attr_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Enttyp Element-->
<xsl:template name="no_enttyp_element">
  <dt class="mandatory">Entity_Type</dt>
  <dd id="definition" name="definition">The definition and description of a set into which similar entity instances are classified.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Entity_Type_Label:</dt>
    <dd id="definition" name="definition">Definition: The name of the entity type.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Entity_Type_Definition: </dt>
    <dd id="definition" name="definition">Definition: The description of the entity type.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Entity_Type_Definition_Source: </dt>
    <dd id="definition" name="definition">Definition: The authority of the definition.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Attr Element-->
<xsl:template name="no_attr_element">
  <dt class="mandatoryif">Attribute</dt>
  <dd id="definition" name="definition">A defined characteristic of an entity.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Attribute_Label:</dt>
    <dd id="definition" name="definition">Definition: The name of the attribute.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Attribute_Definition: </dt>
    <dd id="definition" name="definition">Definition: The description of the attribute.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Attribute_Definition_Source: </dt>
    <dd id="definition" name="definition">Definition: The authority of the definition.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <xsl:call-template name="no_attrdomv_element"/>
    <dt class="mandatoryif">Beginning_Date_of_Attribute_Values:</dt>
    <dd id="definition" name="definition">Definition: Earliest or only date for which the attribute values are current. In cases when a range of dates are provided, this is the earliest date for which the information is valid.</dd>
    <dd id="domain" name="domain">Domain: free date</dd>
    <dt class="mandatoryif">Ending_Date_of_Attribute_Values:</dt>
    <dd id="definition" name="definition">Definition: The latest date for which the information is current. Used in cases when a range of dates are provided.</dd>
    <dd id="domain" name="domain">Domain: free date</dd>
    <xsl:call-template name="no_attrvai_element"/>
    <dt id="optional" name="optional">Attribute_Measurement_Frequency: </dt>
    <dd id="definition" name="definition">Definition: The frequency with which attribute values are added.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", "As needed", "Irregular", "None planned", free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Attrdomv Element-->
<xsl:template name="no_attrdomv_element">
  <dt class="mandatory">Attribute_Domain_Values</dt>
  <dd id="definition" name="definition">The valid values that can be assigned for an attribute.</dd>
  <dd>
  <dl>
    <xsl:call-template name="no_edom_element"/>
    <dt class="normal">- and/or -</dt>
    <xsl:call-template name="no_rdom_element"/>
    <dt class="normal">- and/or -</dt>
    <xsl:call-template name="no_codesetd_element"/>
    <dt class="normal">- and/or -</dt>
    <xsl:call-template name="no_udom_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Edom Element-->
<xsl:template name="no_edom_element">
  <dt class="mandatory">Enumerated_Domain <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The members of an established set of valid values.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Enumerated_Domain_Value:</dt>
    <dd id="definition" name="definition">Definition: The name or label of a member of the set.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Enumerated_Domain_Value_Definition:</dt>
    <dd id="definition" name="definition">Definition: The description of the value.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Enumerated_Domain_Value_Definition_Source: </dt>
    <dd id="definition" name="definition">Definition: The authority of the definition.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Rdom Element-->
<xsl:template name="no_rdom_element">
  <dt class="mandatory">Range_Domain <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The minimum and maximum values of a continuum of valid values.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Range_Domain_Minimum:</dt> 
    <dd id="definition" name="definition">Definition: The least value that the attribute can be assigned.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Range_Domain_Maximum:</dt>
    <dd id="definition" name="definition">Definition: The greatest value that the attribute can be assigned.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatoryif">Attribute_Units_of_Measure:</dt>
    <dd id="definition" name="definition">Definition: The standard of measurement for an attribute value.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt id="optional" name="optional">Attribute_Measurement_Resolution:</dt>
    <dd id="definition" name="definition">Definition: The smallest unit increment to which an attribute value is measured.</dd>
    <dd id="domain" name="domain">Domain: Attribute Measurement Resolution &gt;= 0.0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Codesetd Element-->
<xsl:template name="no_codesetd_element">
    <dt class="mandatory">Codeset_Domain <span id="open" class="open">open</span></dt>
    <dd id="definition" name="definition">Reference to a standard or list which contains the members of an established set of valid values.</dd>
    <dd class="opentarget">
    <dl>
      <dt class="mandatory">Codeset_Name:</dt>
      <dd id="definition" name="definition">Definition: The title of the codeset.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
      <dt class="mandatory">Codeset_Source:</dt>
      <dd id="definition" name="definition">Definition: The authority for the codeset.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    </dl>
    </dd>
</xsl:template>

<!-- No Udom Element-->
<xsl:template name="no_udom_element">
  <dt class="mandatory">Unrepresentable_Domain: </dt>
  <dd id="definition" name="definition">Definition: Description of the values and reasons why they cannot be respresented.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>
</xsl:template>

<!-- No Attrvai Element-->
<xsl:template name="no_attrvai_element">
  <dt id="optional" name="optional">Attribute_Value_Accuracy_Information</dt>
  <dd id="definition" name="definition">An assessment of the accuracy of the assignment of attribute values.</dd>
  <dd class="optional">
  <dl>
    <dt class="mandatory">Attribute_Value_Accuracy:</dt>
    <dd id="definition" name="definition">Definition: An estimate of the accuracy of the assignment of attribute values.</dd>
    <dd id="domain" name="domain">Domain: free real</dd>
    <dt class="mandatory">Attribute_Value_Accuracy_Explanation: </dt>
    <dd id="definition" name="definition">Definition: The definition of the Attribute Value Accuracy measure and units, and a description of how the estimate was derived.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
   </dl>
  </dd>
</xsl:template>

<!-- No Overview Element-->
<xsl:template name="no_overview_element">
  <dt class="mandatory">Overview_Description</dt>
  <dd id="definition" name="definition">Summary of, and citation to detailed description of, the information content of the data set.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Entity_and_Attribute_Overview: </dt>
    <dd id="definition" name="definition">Definition: Detailed summary of the information in a data set.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Entity_and_Attribute_Detail_Citation: </dt>
    <dd id="definition" name="definition">Definition: Reference to the complete description of the entity types, attributes, and attribute values of the data set.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Distribution Element-->
<xsl:template name="no_distinfo_element">
  <a>
    <xsl:attribute name="name"><xsl:text>Distributor1</xsl:text></xsl:attribute>
    <hr/>
  </a>
  <dl>
    <dt class="mandatoryif">Distribution_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Information about the distributor of and options for obtaining the data set.</dd>
    <dd>
    <dl>
        <dt class="mandatory">Distributor</dt>
        <dd id="definition" name="definition">The party from whom the data set may be obtained.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_cntinfo_element"/>
        </dl>
        </dd>
        <dt class="mandatoryif">Resource_Description: </dt>
        <dd id="definition" name="definition">Definition: The identifier by which the distributor knows the data set.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt class="mandatory">Distribution_Liability: </dt>
        <dd id="definition" name="definition">Definition: Statement of the liability assumed by the distributor.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <xsl:call-template name="no_stdorder_element"/>
        <dt class="mandatoryif">Custom_Order_Process: </dt>
        <dd id="definition" name="definition">Definition: Description of custom distribution services available, and the terms and conditions for obtaining these services.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt id="optional" name="optional">Technical_Prerequisites: </dt>
        <dd id="definition" name="definition">Definition: Description of any technical capabilities that the consumer must have to use the data set in the form(s) provided by the distributor.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt id="optional" name="optional">Available_Time_Period</dt>
        <dd id="definition" name="definition">The time period when the data set will be available from the the distributor.</dd>
        <dd class="optional">
        <dl>
          <xsl:call-template name="no_timeinfo_element"/>
        </dl>
        </dd>
    </dl>
    </dd>
  </dl>
  <a href="#Top">Back to Top</a>
</xsl:template>

<!-- No Stdorder Element-->
<xsl:template name="no_stdorder_element">
  <dt class="mandatoryif">Standard_Order_Process</dt>
  <dd id="definition" name="definition">The common ways in which the data set may be obtained or received, and related instructions and fee information.</dd>
    <dd>
    <dl>
      <dt class="mandatory">Non-digital_Form: </dt>
      <dd id="definition" name="definition">Definition: The description of options for obtaining the data set on non-computer-compatible media.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
      <dt class="normal">- or -</dt>
      <xsl:call-template name="no_digform_element"/>
      <dt class="mandatory">Fees:</dt>
      <dd id="definition" name="definition">Definition: The fees and terms for retrieving the data set.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
      <dt id="optional" name="optional">Ordering_Instructions: </dt>
      <dd id="definition" name="definition">Definition: General instructions and advice about, and special terms and services provided for, the data set by the distributor.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
      <dt id="optional" name="optional">Turnaround:</dt>
      <dd id="definition" name="definition">Definition: Typical turnaround time for the filling of an order.</dd>
      <dd id="domain" name="domain">Domain: free text</dd>
    </dl>
    </dd>
</xsl:template>

<!-- No Digform Element-->
<xsl:template name="no_digform_element">
  <dt class="mandatory">Digital_Form</dt>
  <dd id="definition" name="definition">The description of options for obtaining the data set on a computer-compatible media.</dd>
  <dd>
  <dl>
   <xsl:call-template name="no_digtinfo_element"/>
   <xsl:call-template name="no_digtopt_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Digtinfo Element-->
<xsl:template name="no_digtinfo_element">
  <dt class="mandatory">Digital_Transfer_Information</dt>
  <dd id="definition" name="definition">The description of the form of the data to be distributed.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Format_Name:</dt>
    <dd id="definition" name="definition">Definition: The name of the data transfer format.</dd>
    <dd id="domain" name="domain">Domain: "ARCE", "ARCG", "ASCII", "BIL", "BIP", "BSQ", "CDF", "CFF", "COORD", "DEM", "DFAD", "DGN", "DIGEST", "DLG", DTED", "DWG", DX90", DXF", "ERDAS", "GRASS", "HDF", "IGDS", "IGES", "MOSS", "netDCF", "NITF", "RPF", "RVC", "RVF", "SDTS", "SIF", "SLF", "TIFF", "TGRLN", "VPF", free text</dd>
    <dt class="mandatory">Format_Version_Number:</dt>
    <dd id="definition" name="definition">Definition: Version number of the format.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="normal">- or -</dt>
    <dt class="mandatory">Format_Version_Date:</dt>
    <dd id="definition" name="definition">Definition: Date of the version of the format.</dd>
    <dd id="domain" name="domain">Domain: free date</dd>
    <dt id="optional" name="optional">Format_Specification:</dt>
    <xsl:for-each select="formspec">
      <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: Name of a subset, profile, or product specification of the fomat.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt id="optional" name="optional">Format_Information_Content: </dt>
    <xsl:for-each select="formcont">
      <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: Description of the content of the data encoded in a format.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatoryif">File_Decompression_Technique:</dt>
    <dd id="definition" name="definition">Definition: Recommendations of algorithms or process (including means of obtaining these algorithms or processes) that can be applied to read or expand data sets to which data compression techniques have been applied.</dd>
    <dd id="domain" name="domain">Domain: "No compression applied", free text</dd>
    <dt id="optional" name="optional">Transfer_Size:</dt>
    <dd id="definition" name="definition">Definition: The size, or estimated size, of the transferred data set in megabytes.</dd>
    <dd id="domain" name="domain">Domain: Transfer Size &gt; 0.0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Digtopt Element-->
<xsl:template name="no_digtopt_element">
  <dt class="mandatory">Digital_Transfer_Option</dt>
  <dd id="definition" name="definition">The means and media by which a data set is obtained from the distributor.</dd>
  <dd>
  <dl>
    <xsl:call-template name="no_onlinopt_element"/>
    <dt>- or - </dt>
    <xsl:call-template name="no_offoptn_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Onlinopt Element-->
<xsl:template name="no_onlinopt_element">
  <dt class="mandatory">Online_Option <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Information required to directly obtain the data set electronically.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_computer_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No computer Element-->
<xsl:template name="no_computer_element">
  <dt class="mandatory">Computer_Contact_Information</dt>
  <dd id="definition" name="definition">Instructions for establishing communications with the distribution computer.</dd>
  <dd>
  <dl>
    <xsl:call-template name="no_networka_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_dialinst_element"/>
    <dt id="optional" name="optional">Access_Instructions: </dt>
    <dd id="definition" name="definition">Definition: Instructions on the steps required to access the data set.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt id="optional" name="optional">Online_Computer_and_Operating_System: </dt>
    <dd id="definition" name="definition">Definition: The brand of distribution computer and its operating system.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Networka Element-->
<xsl:template name="no_networka_element">
  <dt  class="mandatory">Network_Address</dt>
  <dd id="definition" name="definition">The electronic address from which the data set can be obtained from the distribution computer.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Network_Resource_Name:</dt>
    <dd id="definition" name="definition">Definition: The name of the file or service from which the data set can be obtained.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Dialinst Element-->
<xsl:template name="no_dialinst_element">
  <dt class="mandatory">Dialup_Instructions</dt>
  <dd id="definition" name="definition">Definition: Information required to access the distribution computer remotely through telephone lines.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Lowest_BPS:</dt>
    <dd id="definition" name="definition">Definition: Lowest or only speed for the connection's communication, expressed in bits per second.</dd>
    <dd id="domain" name="domain">Domain: Lowest BPS &gt;= 110</dd>
    <dt class="mandatoryif">Highest_BPS:</dt>
    <dd id="definition" name="definition">Definition: Highest speed for the connnection's communication, expressed in bits per second. Used in cases when a range of rates are provided.</dd>
    <dd id="domain" name="domain">Domain: Highest BPS &gt; Lowest BPS</dd>
    <dt class="mandatory">Number_DataBits:</dt>
    <dd id="definition" name="definition">Definition: Number of data bits in each character exhanged in the communication.</dd>
    <dd id="domain" name="domain">Domain: 7 &lt;= Number DataBits &lt;= 8</dd>
    <dt class="mandatory">Number_StopBits:</dt>
    <dd id="definition" name="definition">Definition: Number of stop bits in each character exchanged in the communication.</dd>
    <dd id="domain" name="domain">Domain: 1 &lt;= Number StopBits &lt;= 2</dd>
    <dt class="mandatory">Parity:</dt>
    <dd id="definition" name="definition">Definition: Parity error checking used in each character exchanged in the communication.</dd>
    <dd id="domain" name="domain">Domain: "None", "Odd", "Even", "Mark", "Space"</dd>
    <dt class="mandatoryif">Compression_Support:</dt>
    <dd id="definition" name="definition">Definition: Data compression available through the modem service to speed data transfer.</dd>
    <dd id="domain" name="domain">Domain: "V.32", "V.32bis", "V.42", "V.42bis"</dd>
    <dt class="mandatory">Dialup_Telephone:</dt>
    <dd id="definition" name="definition">Definition: The telephone number of the distribution computer.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Dialup_File_Name:</dt>
    <dd id="definition" name="definition">Definition: The name of a file containing the data set on the distribution computer.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Offoptn Element-->
<xsl:template name="no_offoptn_element">
  <dt class="mandatory">Offline_Option <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Information about media-specific options for receiving the data set.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Offline_Media:</dt>
    <dd id="definition" name="definition">Definition: Name of the media on which the data set can be received.</dd>
    <dd id="domain" name="domain">Domain: "CD-ROM", "3-1/2 inch floppy disk", "5-1/4 inch floppy disk", "9-track tape", "4mm cartridge tape", "8mm cartridge tape", "1/4-inch cartridge tape", free text</dd>
    <dt class="mandatoryif">Recording_Capacity</dt>
    <dd id="definition" name="definition">The density of information to which data are written. Used in cases where different recording capacities are possible.</dd>
    <xsl:call-template name="no_reccap_element"/>
    <dt class="mandatory">Recording_Format:</dt>
    <dd id="definition" name="definition">Definition: The options available or method used to write the data set to the medium.</dd>
    <dd id="domain" name="domain">Domain: "cpio", "tar", "High Sierra", "ISO 9660", "ISO 9660 with Rock Ridge Extensions" "ISO 9660 with Apple HFS extensions", free text</dd>
    <dt class="mandatoryif">Compatibility_Information: </dt>
    <dd id="definition" name="definition">Definition: Description of other limitations or requirements for using the medium.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Reccap Element-->
<xsl:template name="no_reccap_element">
  <dd>
  <dl>
    <dt class="mandatory">Recording_Density:</dt>
    <dd id="definition" name="definition">Definition: The density in which the data set can be recorded.</dd>
    <dd id="domain" name="domain">Domain: Recording Density &gt; 0.0</dd>
    <dt class="mandatory">Recording_Density_Units:</dt>
    <dd id="definition" name="definition">Definition: The units of measure for the recording density.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Metadata Element -->
<xsl:template name="no_metadata_element">
  <a name="Metadata_Reference_Information"><hr/></a>
  <dl>
    <dt class="mandatory">Metadata_Reference_Information <span id="open" class="open">close</span></dt>
    <dd id="definition" name="definition">Information on the currentness of the metadata information, and the responsible party.</dd>
    <dd>
    <dl>
      <dt class="mandatory">Metadata_Date: </dt>
        <dd id="definition" name="definition">Definition: The date that the metadata were created or last updated.</dd>
        <dd id="domain" name="domain">Domain: free date</dd>
      <dt id="optional" name="optional">Metadata_Review_Date: </dt>
        <dd id="definition" name="definition">Definition: The date of the last review of the metadata entry.</dd>
        <dd id="domain" name="domain">Domain: free date; Metadata Review Date later than Metadata Date.</dd>
      <dt id="optional" name="optional">Metadata_Future_Review_Date: </dt>
        <dd id="definition" name="definition">Definition: The date by which the metadata should be reviewed.</dd>
        <dd id="domain" name="domain">Domain: free date; Metadata Future Review Date later than Metadata Review Date.</dd>

      <dt class="mandatory">Metadata_Contact</dt>
        <dd id="definition" name="definition">The party responsible for the metadata information.</dd>
        <dd>
        <dl>
          <xsl:call-template name="no_cntinfo_element"/>
        </dl>
        </dd>
      <dt class="mandatory">Metadata_Standard_Name: </dt>
        <dd id="definition" name="definition">Definition: The name of the metadata standard used to document the data set.</dd>
        <dd id="domain" name="domain">Domain: "FGDC Content Standard for Digital Geospatial Metadata", free text</dd>
      <dt class="mandatory">Metadata_Standard_Version: </dt>
        <dd id="definition" name="definition">Definition: Identification of the version of the metadata standard used to document the data set.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      <dt class="mandatoryif">Metadata_Time_Convention: </dt>
        <dd id="definition" name="definition">Definition: Form used to convey time of day information in the metadata entry. Used if time of day information is included in the metadata for a data set.</dd>
        <dd id="domain" name="domain">Domain: "local time", "local time with time differential factor", "universal time", free text</dd>

      <dt id="optional" name="optional">Metadata_Access_Constraints: </dt>
        <dd id="definition" name="definition">Definition: Restrictions and legal prerequisites for accessing the metadata. These include any access constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations or obtaining the metadata.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      <dt id="optional" name="optional">Metadata_Use_Constraints: </dt>
        <dd id="definition" name="definition">Definition: Restrictions and legal prerequisites for using the metadata after access is granted. These include any metadata use constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations on using the metadata.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

      <xsl:call-template name="no_metsi_element"/>
      <xsl:call-template name="no_metextns_element"/>
      </dl>
      </dd>
  </dl>
  <dt><a href="#Top">Back to Top</a></dt>
</xsl:template>

<!-- No Metsi Element-->
<xsl:template name="no_metsi_element">
  <dt id="optional" name="optional">Metadata_Security_Information</dt>
  <dd id="definition" name="definition">Handling restrictions imposed on the metadata because of national security, privacy, or other concerns.</dd>
  <dd class="optional">
  <dl>
    <dt class="mandatory">Metadata_Security_Classification_System: </dt>
    <dd id="definition" name="definition">Definition: Name of the classification system for the metadata.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatory">Metadata_Security_Classification: </dt>
    <dd id="definition" name="definition">Definition: Name of the handling restrictions on the metadata.</dd>
    <dd id="domain" name="domain">Domain: "Top secret", "Secret", "Confidential", "Restricted", "Unclassified", "Sensitive", free text</dd>
    <dt class="mandatory">Metadata_Security_Handling_Description: </dt>
    <dd id="definition" name="definition">Definition: Additional information about the restrictions on handling the metadata.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Metextns Element-->
<xsl:template name="no_metextns_element">
  <dt class="mandatoryif">Metadata_Extensions</dt>
  <dd id="definition" name="definition">A reference to extended elements to the standard which may be defined by a metadata producer or a user community. Extended elements are elements outside the Standard, but needed by the metadata producer. If extened elements are created, they must follow the guidelines in Appendix D, Guidelines for Creating Extended Elements to the Content Standard for Digital Geospatial Data.</dd>
  <dd>
  <dl>
    <dt class="mandatoryif">Online_Linkage: </dt>
    <dd id="definition" name="definition">Definition: The name of an online computer resource that contains the metadata extension information for the data set. Entries should follow the Uniform Resource Locator (URL) convention of the Internet.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatoryif">Profile_Name: </dt>
    <dd id="definition" name="definition">Definition: The name given to a document that describes the application of the Standard to a specific user community.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- Citation -->
<xsl:template match="citeinfo">
  <dt class="mandatory">Citation_Information</dt>
  <dd id="definition" name="definition">The recommended reference to be used for the data set.</dd>
  <dd>
  <dl>

    <xsl:if test="count(origin) = 0">
      <dt class="mandatory">Originator: </dt>
    </xsl:if>
    <xsl:for-each select="origin">
      <dt class="mandatory">Originator: <span class="normal"><xsl:value-of select="."/></span></dt>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: The name of the organization or individual that developed the data set. If the name of the editors or compilers are provided, the name must be followed by "(ed.)" or "(comp.)", respectively.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free text</dd>

    <dt class="mandatory">Publication_Date: 
    <xsl:for-each select="pubdate">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The date when the data set is published or otherwise made available for release.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", "Unpublished material", free date</dd>
    <dt id="optional" name="optional">Publication_Time: 
    <xsl:for-each select="pubtime">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The time of day when the data set is published or otherwise made available for release.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free time</dd>

    <dt class="mandatory">Title: </dt>
    <xsl:for-each select="title">
      <dd><span class="normal"><xsl:value-of select="."/></span></dd>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: The name by which the data set is known.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatoryif">Edition: 
    <xsl:for-each select="edition">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The version of the title.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <dt class="mandatoryif">Geospatial_Data_Presentation_Form: 
    <xsl:for-each select="geoform">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The mode in which the geospatial data are represented.</dd>
    <dd id="domain" name="domain">Domain: "atlas", "audio", "diagram", "document", "globe", "map", "model", "multimedia presentation", "profile", "raster digital data", "remote-sensing image", "section", "spreadsheet", "tabular digital form" "vector digital data", "video", "view", free text</dd>

    <dt class="mandatoryif">Series_Information</dt>
    <dd id="definition" name="definition">The identification of the series of publications of which the data set is a part.</dd>
    <xsl:if test="count(serinfo) = 0">
      <dd>
      <dl>
        <dt class="mandatory">Series_Name: </dt>
        <dd id="definition" name="definition">Definition: The name of the series publications of which the data set is a part.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt class="mandatory">Issue_Identification: </dt>
        <dd id="definition" name="definition">Definition: Information identifying the issue of the series publication of which the data set is a part.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>
    </xsl:if>
    <xsl:for-each select="serinfo">
      <dd>
      <dl>
        <dt class="mandatory">Series_Name:
        <xsl:for-each select="sername">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The name of the series publications of which the data set is a part.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt class="mandatory">Issue_Identification: 
        <xsl:for-each select="issue">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: Information identifying the issue of the series publication of which the data set is a part.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>
    </xsl:for-each>

    <dt class="mandatoryif">Publication_Information</dt>
    <dd id="definition" name="definition">Publication details for published data sets.</dd>
    <xsl:if test="count(pubinfo) = 0">
      <dd class="opentarget">
      <dl>
        <dt class="mandatory">Publication_Place: </dt>
        <dd id="definition" name="definition">Definition: The name of the city (and state or province, and country, if needed to identify the city) where the data set was published or released.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt class="mandatory">Publisher: </dt>
        <dd id="definition" name="definition">Definition: The name of the individual or organization that published the data set.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>
    </xsl:if>
    <xsl:for-each select="pubinfo">
      <dd>
      <dl>
        <dt class="mandatory">Publication_Place: 
        <xsl:for-each select="pubplace">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The name of the city (and state or province, and country, if needed to identify the city) where the data set was published or released.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt class="mandatory">Publisher: 
        <xsl:for-each select="publish">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The name of the individual or organization that published the data set.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>
    </xsl:for-each>

    <dt class="mandatoryif">Other_Citation_Details: </dt>
    <xsl:for-each select="othercit">
      <dd><span class="normal"><xsl:value-of select="."/></span></dd>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: Other information required to complete the citation.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <xsl:if test="count(onlink) = 0">
      <dt id="optional" name="optional">Online_Linkage: </dt>
    </xsl:if>
    <xsl:for-each select="onlink">
     <dt id="optional" name="optional">Online_Linkage:
       <a target="viewer"><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a>
     </dt>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: The name of the online computer resource that contains the data set. Entries should follow the Uniform Resource Locator (URL) convention of the Internet.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <xsl:if test="count(lworkcit) = 0">
      <dt class="mandatoryif">Larger_Work_Citation</dt>
      <dd id="definition" name="definition">The information identifying a larger work in which the data set is included.</dd>
      <dd>
      <dl>
        <xsl:call-template name="no_citeinfo_element"/>
      </dl>
      </dd>
    </xsl:if>
    <xsl:for-each select="lworkcit">
      <dt class="mandatoryif">Larger_Work_Citation</dt>
      <dd id="definition" name="definition">The information identifying a larger work in which the data set is included.</dd>
      <dd>
      <dl>
        <xsl:apply-templates select="citeinfo"/>
      </dl>
      </dd>
    </xsl:for-each>
  </dl>
  </dd>
</xsl:template>

<!-- No Citation Element-->
<xsl:template name="no_citeinfo_element">
  <dt class="mandatory">Citation_Information <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">The recommended reference to be used for the data set.</dd>
  <dd class="opentarget">
  <dl>

    <dt class="mandatory">Originator: </dt>
    <dd id="definition" name="definition">Definition: The name of the organization or individual that developed the data set. If the name of the editors or compilers are provided, the name must be followed by "(ed.)" or "(comp.)", respectively.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free text</dd>

    <dt class="mandatory">Publication_Date: </dt>
    <dd id="definition" name="definition">Definition: The date when the data set is published or otherwise made available for release.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", "Unpublished material", free date</dd>
    <dt id="optional" name="optional">Publication_Time: </dt>
    <dd id="definition" name="definition">Definition: The time of day when the data set is published or otherwise made available for release.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free time</dd>

    <dt class="mandatory">Title: </dt>
    <dd id="definition" name="definition">Definition: The name by which the data set is known.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt class="mandatoryif">Edition: </dt>
    <dd id="definition" name="definition">Definition: The version of the title.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <dt class="mandatoryif">Geospatial_Data_Presentation_Form: </dt>
    <dd id="definition" name="definition">Definition: The mode in which the geospatial data are represented.</dd>
    <dd id="domain" name="domain">Domain: "atlas", "audio", "diagram", "document", "globe", "map", "model", "multimedia presentation", "profile", "raster digital data", "remote-sensing image", "section", "spreadsheet", "tabular digital form" "vector digital data", "video", "view", free text</dd>

    <dt class="mandatoryif">Series_Information</dt>
    <dd id="definition" name="definition">The identification of the series of publications of which the data set is a part.</dd>
      <dd>
      <dl>
        <dt class="mandatory">Series_Name: </dt>
        <dd id="definition" name="definition">Definition: The name of the series publications of which the data set is a part.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt class="mandatory">Issue_Identification: </dt>
        <dd id="definition" name="definition">Definition: Information identifying the issue of the series publication of which the data set is a part.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>

    <dt class="mandatoryif">Publication_Information</dt>
    <dd id="definition" name="definition">Publication details for published data sets.</dd>
      <dd>
      <dl>
        <dt class="mandatory">Publication_Place: </dt>
        <dd id="definition" name="definition">Definition: The name of the city (and state or province, and country, if needed to identify the city) where the data set was published or released.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt class="mandatory">Publisher: </dt>
        <dd id="definition" name="definition">Definition: The name of the individual or organization that published the data set.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>

    <dt class="mandatoryif">Other_Citation_Details: </dt>
    <dd id="definition" name="definition">Definition: Other information required to complete the citation.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <dt id="optional" name="optional">Online_Linkage: </dt>
    <dd id="definition" name="definition">Definition: The name of the online computer resource that contains the data set. Entries should follow the Uniform Resource Locator (URL) convention of the Internet.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <dt class="mandatoryif">Larger_Work_Citation</dt>
    <dd id="definition" name="definition">The information identifying a larger work in which the data set is included.</dd>
  </dl>
  </dd>
</xsl:template>

<!-- Contact Info -->
<xsl:template match="cntinfo">
  <dt class="mandatory">Contact_Information</dt>
  <dd id="definition" name="definition">Definition: Identity of, and means to communicate with, person(s) and organization(s) associated with the data set. A choice of 1 of 2 elements: Contact_Person_Primary or Contact_Organization_Primary is used with the Contact_Position and Contact_Address information.</dd>
  <dd>
  <dl>
    <xsl:if test="count(cntperp) = 0">
      <xsl:call-template name="no_cntperp_element"/>
    </xsl:if>
    <xsl:for-each select="cntperp">
    <dt class="mandatory">Contact_Person_Primary</dt>
    <dd id="definition" name="definition">Definition: The person, and the affiliation of the person, associated with the data set. Used in cases where the association of the person to the data set is more significant than the association of the organization to the data set.</dd>
      <dd>
      <dl>
        <dt class="mandatory">Contact_Person: 
        <xsl:for-each select="cntper">
         <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The name of the individual to which the contact type applies.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt id="optional" name="optional">Contact_Organization: 
        <xsl:for-each select="cntorg">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The name of the organization to which the contact type applies.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>
    </xsl:for-each>
    <dt class="normal">- or -</dt>
    <xsl:if test="count(cntorgp) = 0">
      <xsl:call-template name="no_cntorgp_element"/>
    </xsl:if>
    <xsl:for-each select="cntorgp">
    <dt class="mandatory">Contact_Organization_Primary</dt>
    <dd id="definition" name="definition">Definition: The organization, and the member of the organization, associated with the data set. Used in cases where the association of the organiztion to the data set is more significant than the association of the person to the data set.</dd>
      <dd>
      <dl>
        <dt class="mandatory">Contact_Organization: 
        <xsl:for-each select="cntorg">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The name of the organization to which the contact type applies.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
        <dt id="optional" name="optional">Contact_Person: 
        <xsl:for-each select="cntper">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The name of the individual to which the contact type applies.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>
    </xsl:for-each>
    <dt id="optional" name="optional">Contact_Position: 
    <xsl:for-each select="cntpos">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The title of the individual.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <xsl:if test="count(cntaddr) = 0">
      <xsl:call-template name="no_cntaddr_element"/>
    </xsl:if>
    <xsl:for-each select="cntaddr">
    <dt class="mandatory">Contact_Address</dt>
    <dd id="definition" name="definition">The address for the organization or individual.</dd>
      <dd>
      <dl>
        <dt class="mandatory">Address_Type: 
        <xsl:for-each select="addrtype">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The information provided by the address.</dd>
        <dd id="domain" name="domain">Domain: "mailing", "physical", "mailing and physical", free text</dd>

        <dt class="mandatoryif">Address: </dt>
        <xsl:for-each select="address">
          <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>    
        </xsl:for-each>
        <dd id="definition" name="definition">Definition: An address line for the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

        <dt class="mandatory">City: 
        <xsl:for-each select="city">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The city of the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

        <dt class="mandatory">State_or_Province: 
        <xsl:for-each select="state">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The state or province of the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

        <dt class="mandatory">Postal_Code: 
        <xsl:for-each select="postal">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The ZIP or other postal code of the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

        <dt id="optional" name="optional">Country: 
        <xsl:for-each select="country">
          <span class="normal"><xsl:value-of select="."/></span>
        </xsl:for-each>
        </dt>
        <dd id="definition" name="definition">Definition: The country of the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>
    </xsl:for-each>

    <xsl:if test="count(cntvoice) = 0">
      <dt class="mandatory">Contact_Voice_Telephone:</dt>
    </xsl:if>
    <xsl:for-each select="cntvoice">
      <dt class="mandatory">Contact_Voice_Telephone: <span class="normal"><xsl:value-of select="."/></span></dt>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: The telephone number by which individuals can speak to the organization or individual.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <xsl:if test="count(cnttdd) = 0">
      <dt id="optional" name="optional">Contact_TDD/TTY_Telephone: </dt>
    </xsl:if>
    <xsl:for-each select="cnttdd">
    <dt id="optional" name="optional">Contact_TDD/TTY_Telephone: <span class="normal"><xsl:value-of select="."/></span></dt>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: The telephone number by which hearing-impaired individuals can contact the organization or individual.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <xsl:if test="count(cntfax) = 0">
      <dt id="optional" name="optional">Contact_Facsimile_Telephone:</dt>
    </xsl:if>
    <xsl:for-each select="cntfax">
      <dt id="optional" name="optional">Contact_Facsimile_Telephone: <span class="normal"><xsl:value-of select="."/></span></dt>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: The telephone number of the facsimile machine of the organization or individual.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <xsl:if test="count(cntemail) = 0">
      <dt id="optional" name="optional">Contact_Electronic_Mail_Address:</dt>
    </xsl:if>
    <xsl:for-each select="cntemail">
      <dt id="optional" name="optional">Contact_Electronic_Mail_Address:<span class="normal"><xsl:value-of select="."/></span></dt>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: The address of the electronic mailbox of the organization or individual.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <dt id="optional" name="optional">Hours_of_Service: 
    <xsl:for-each select="hours">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: Time period when individuals can speak to the organization or individual.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>

    <dt id="optional" name="optional">Contact Instructions: </dt>
    <xsl:for-each select="cntinst">
      <dd><span class="normal"><pre id="fixvalue"><xsl:value-of select="."/></pre></span></dd>
    </xsl:for-each>
    <dd id="definition" name="definition">Definition: Supplemental instructions on how or when to contact the individual or organization.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Contact Info Element -->
<xsl:template name="no_cntinfo_element">
  <dt class="mandatory">Contact_Information <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Identity of, and means to communicate with, person(s) and organization(s) associated with the data set. A choice of 1 of 2 elements: Contact_Person_Primary or Contact_Organization_Primary is used with the Contact_Position and Contact_Address information.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_cntperp_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_cntorgp_element"/>
    <xsl:call-template name="no_cntpos_element"/>
    <xsl:call-template name="no_cntaddr_element"/>
    <xsl:call-template name="no_cntdetail_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Contact Person Primary Element -->
<xsl:template name="no_cntperp_element">
  <dt class="mandatory">Contact_Person_Primary <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Definition: The person, and the affiliation of the person, associated with the data set. Used in cases where the association of the person to the data set is more significant than the association of the organization to the data set.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Contact_Person: </dt>
    <dd id="definition" name="definition">Definition: The name of the individual to which the contact type applies.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt id="optional" name="optional">Contact_Organization: </dt>
    <dd id="definition" name="definition">Definition: The name of the organization to which the contact type applies.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Contact Organization Primary Element -->
<xsl:template name="no_cntorgp_element">
  <dt class="mandatory">Contact_Organization_Primary <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Definition: The organization, and the member of the organization, associated with the data set. Used in cases where the association of the organiztion to the data set is more significant than the association of the person to the data set.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Contact_Organization: </dt>
    <dd id="definition" name="definition">Definition: The name of the organization to which the contact type applies.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
    <dt id="optional" name="optional">Contact_Person: </dt>
    <dd id="definition" name="definition">Definition: The name of the individual to which the contact type applies.</dd>
    <dd id="domain" name="domain">Domain: free text</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Cntpos Element -->
<xsl:template name="no_cntpos_element">
  <dt id="optional" name="optional">Contact_Position: </dt>
  <dd id="definition" name="definition">Definition: The title of the individual.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>
</xsl:template>

<!-- No Cntaddr Element -->
<xsl:template name="no_cntaddr_element">
    <dt class="mandatory">Contact_Address</dt>
    <dd id="definition" name="definition">Definition: The address for the organization or individual.</dd>
      <dd>
      <dl>
          <dt class="mandatory">Address_Type: </dt>
        <dd id="definition" name="definition">Definition: The information provided by the address.</dd>
        <dd id="domain" name="domain">Domain: "mailing", "physical", "mailing and physical", free text</dd>

        <dt class="mandatoryif">Address: </dt>
        <dd id="definition" name="definition">Definition: An address line for the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

        <dt class="mandatory">City: </dt>
        <dd id="definition" name="definition">Definition: The city of the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

        <dt class="mandatory">State_or_Province: </dt>
        <dd id="definition" name="definition">Definition: The state or province of the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

        <dt class="mandatory">Postal_Code: </dt>
        <dd id="definition" name="definition">Definition: The ZIP or other postal code of the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>

        <dt id="optional" name="optional">Country: </dt>
        <dd id="definition" name="definition">Definition: The country of the address.</dd>
        <dd id="domain" name="domain">Domain: free text</dd>
      </dl>
      </dd>
</xsl:template>

<!-- No Contact Detail Elements -->
<xsl:template name="no_cntdetail_element">
  <dt class="mandatory">Contact_Voice_Telephone: </dt>
  <dd id="definition" name="definition">Definition: The telephone number by which individuals can speak to the organization or individual.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>

  <dt id="optional" name="optional">Contact_TDD/TTY_Telephone: </dt>
  <dd id="definition" name="definition">Definition: The telephone number by which hearing-impaired individuals can contact the organization or individual.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>

  <dt id="optional" name="optional">Contact_Facsimile_Telephone: </dt>
  <dd id="definition" name="definition">Definition: The telephone number of the facsimile machine of the organization or individual.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>

  <dt id="optional" name="optional">Contact_Electronic_Mail_Address: </dt>
  <dd id="definition" name="definition">Definition: The address of the electronic mailbox of the organization or individual.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>

  <dt id="optional" name="optional">Hours_of_Service: </dt>
  <dd id="definition" name="definition">Definition: Time period when individuals can speak to the organization or individual.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>

  <dt id="optional" name="optional">Contact Instructions: </dt>
  <dd id="definition" name="definition">Definition: Supplemental instructions on how or when to contact the individual or organization.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>
</xsl:template>

<!-- Single Date/Time -->
<xsl:template match="sngdate">
  <dt class="mandatory">Single_Date/Time</dt>
  <dd id="definition" name="definition">Means of encoding a single date and time.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Calendar_Date:
    <xsl:for-each select="caldate">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The year (and optionally month, or month and day).</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free date</dd>
    <dt class="mandatoryif">Time of Day:
    <xsl:for-each select="time">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The hour (and optionally minute, or minute and second) of the day.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free time</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Single Date/Time Element-->
<xsl:template name="no_sngdate_element">
  <dt class="mandatory">Single_Date/Time <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Means of encoding a single date and time.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Calendar_Date: </dt>
    <dd id="definition" name="definition">Definition: The year (and optionally month, or month and day).</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free date</dd>
    <dt class="mandatoryif">Time of Day: </dt>
    <dd id="definition" name="definition">Definition: The hour (and optionally minute, or minute and second) of the day.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free time</dd>
  </dl>
  </dd>
</xsl:template>

<!-- Multiple Date/Time -->
<xsl:template match="mdattim">
  <dt class="mandatory">Multiple_Dates/Times</dt>
  <dd id="definition" name="definition">Means of encoding multiple individual dates and times.</dd>
  <dd>
  <dl>
    <xsl:apply-templates select="sngdate"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Multiple Date/Time Element-->
<xsl:template name="no_mdattim_element">
  <dt class="mandatory">Multiple_Dates/Times <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Means of encoding multiple individual dates and times.</dd>
  <dd class="opentarget">
  <dl>
      <xsl:call-template name="no_sngdate_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- Range of Dates/Times -->
<xsl:template match="rngdates">
  <dt class="mandatory">Range_of_Dates/Times</dt>
  <dd id="definition" name="definition">Means of encoding a range of dates and times.</dd>
  <dd>
  <dl>
    <dt class="mandatory">Beginning_Date:
    <xsl:for-each select="begdate">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The first year (and optionally the month, or month and day) of the event.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free date</dd>
    <dt class="mandatoryif">Beginning_Time:
    <xsl:for-each select="begtime">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The first hour (and optionally minute, or minute and second) of the day of the event.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free time</dd>
    <dt class="mandatory">Ending_Date:
    <xsl:for-each select="enddate">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The last year (and optionally the month, or month and day) for the event.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", "Present", free date</dd>
    <dt class="mandatoryif">Ending_Time:
    <xsl:for-each select="endtime">
      <span class="normal"><xsl:value-of select="."/></span>
    </xsl:for-each>
    </dt>
    <dd id="definition" name="definition">Definition: The last hour (and optionally minute, or minute and second) of the day of the event.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free time</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Range of Dates/Times Element-->
<xsl:template name="no_rngdates_element">
  <dt class="mandatory">Range_of_Dates/Times <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Means of encoding a range of dates and times.</dd>
  <dd class="opentarget">
  <dl>
    <dt class="mandatory">Beginning_Date: </dt>
    <dd id="definition" name="definition">Definition: The first year (and optionally the month, or month and day) of the event.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free date</dd>
    <dt class="mandatoryif">Beginning_Time: </dt>
    <dd id="definition" name="definition">Definition: The first hour (and optionally minute, or minute and second) of the day of the event.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free time</dd>
    <dt class="mandatory">Ending_Date: </dt>
    <dd id="definition" name="definition">Definition: The last year (and optionally the month, or month and day) for the event.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", "Present", free date</dd>
    <dt class="mandatoryif">Ending_Time: </dt>
    <dd id="definition" name="definition">Definition: The last hour (and optionally minute, or minute and second) of the day of the event.</dd>
    <dd id="domain" name="domain">Domain: "Unknown", free time</dd>
  </dl>
  </dd>
</xsl:template>

<!-- Map Projections -->
<xsl:template match="albers | equicon | lambertc">
  <dd>
  <dl>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="gnomonic | lamberta | orthogr | stereo | gvnsp">
  <dd>
  <dl>
    <xsl:for-each select="../gvnsp">
      <xsl:apply-templates select="heightpt"/>
    </xsl:for-each>
    <xsl:apply-templates select="longpc"/>
    <xsl:apply-templates select="latprjc"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="azimequi | polycon | transmer">
  <dd>
  <dl>
    <xsl:for-each select="../transmer">
      <xsl:apply-templates select="sfctrmer"/>
    </xsl:for-each>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="miller | sinusoid | vdgrin">
  <dd>
  <dl>
    <xsl:for-each select="../equirect">
      <xsl:apply-templates select="stdparll"/>
    </xsl:for-each>
    <xsl:for-each select="../mercator">
      <xsl:apply-templates select="stdparll"/>
      <xsl:apply-templates select="sfequat"/>
    </xsl:for-each>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="equirect">
  <dd>
  <dl>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="mercator">
  <dd>
  <dl>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="sfequat"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="polarst">
  <dd>
  <dl>
    <xsl:apply-templates select="svlong"/>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="sfprjorg"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="obqmerc">
  <dd>
  <dl>
    <xsl:apply-templates select="sfctrlin"/>
    <xsl:apply-templates select="obqlazim"/>
    <xsl:apply-templates select="obqlpt"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="spaceobq">
  <dd>
  <dl>
    <xsl:apply-templates select="landsat"/>
    <xsl:apply-templates select="pathnum"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="robinson">
  <dd>
  <dl>
    <xsl:apply-templates select="longpc"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="modsak">
  <dd>
  <dl>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </dl>
  </dd>
</xsl:template>

<!-- Map Projection Parameters -->
<xsl:template match="stdparll">
  <dt class="mandatory">Standard_Parallel: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: Line of consistant latitude at which the surface of the Earth and the plane or developable surface intersect.</dd>
  <dd id="domain" name="domain">Domain: -90 &lt;= Standard Parallel &lt;= 90</dd>
</xsl:template>

<xsl:template match="longcm">
  <dt class="mandatory">Longitude_of_Central_Meridian: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: The line of longitude at the center of the map projection generally used as the basis for constructing the projection.</dd>
  <dd id="domain" name="domain">Domain: -180 &lt;= Longitude of Central Meridian &lt; 180</dd>
</xsl:template>

<xsl:template match="latprjo">
  <dt class="mandatory">Latitude_of_Projection_Origin: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: Latitude chosen as the origin of rectangular coordinates for a map projection.</dd>
  <dd id="domain" name="domain">Domain: -90 &lt;= Latitude of Projection Origin &lt;= 90</dd>
</xsl:template>

<xsl:template match="feast">
  <dt class="mandatory">False_Easting: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: The value added to all "x" values in the rectangular coordinates for a map projection. This value frequently is assigned to eliminate negative numbers. Expressed in the unit of measure identified in the Planar Coordinate Units.</dd>
  <dd id="domain" name="domain">Domain: free real</dd>
</xsl:template>

<xsl:template match="fnorth">
  <dt class="mandatory">False_Northing: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: The value added to all "y" values in the rectangular coordinates for a map projection. This value frequently is assigned to eliminate negative numbers. Expressed in the unit of measure identified in the Planar Coordinate Units.</dd>
  <dd id="domain" name="domain">Domain: free real</dd>
</xsl:template>

<xsl:template match="sfequat">
  <dt class="mandatory">Scale_Factor_at_Equator: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: The multiplier for reducing a distance obtainied from a map by computation or scaling to the actual distance along the equator.</dd>
  <dd id="domain" name="domain">Domain: Scale Factor at Equator &gt; 0.0</dd>
</xsl:template>

<xsl:template match="heightpt">
  <dt class="mandatory">Height_of_Perspective_Point_Above_Surface: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: Height of viewpoint above the Earth, expressed in meters.</dd>
  <dd id="domain" name="domain">Domain: Height of Perspective Above Surface &gt; 0.0</dd>
</xsl:template>

<xsl:template match="longpc">
  <dt class="mandatory">Longitude_of_Projection_Center: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: Longitude of the point of projection for azimuthal projections.</dd>
  <dd id="domain" name="domain">Domain: -180 &lt;= Longitude of Projection Center &lt; 180</dd>
</xsl:template>

<xsl:template match="latprjc">
  <dt class="mandatory">Latitude_of_Projection_Center: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: Latitude of the point of projection for azimuthal projections.</dd>
  <dd id="domain" name="domain">Domain: -90 &lt;= Latitude of Projection Center &lt;= 90</dd>
</xsl:template>

<xsl:template match="sfctrlin">
  <dt class="mandatory">Scale_Factor_at_Center_Line: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: A multiplier for reducing a distance obtained from a map by computation or scaling to the actual distance along the center line.</dd>
  <dd id="domain" name="domain">Domain: Scale Factor at Center Line &gt; 0.0</dd>
</xsl:template>

<xsl:template match="obqlazim">
  <dt class="mandatory">Oblique_Line_Azimuth</dt>
  <dd id="definition" name="definition">Definition: Method used to describe the line along which an oblique mercator map projection is centered using the map projection origin and an azimuth.</dd>
  <dd>
  <dl>
    <xsl:for-each select="azimangl">
      <dt class="mandatory">Azimuthal_Angle: <span class="normal"><xsl:value-of select="."/></span></dt>
      <dd id="definition" name="definition">Definition: Angle measured clockwise from north, and expressed in degrees.</dd>
      <dd id="domain" name="domain">Domain: 0.0 &lt;= Azimuthal Angle &lt; 360.0</dd>
    </xsl:for-each>
    <xsl:for-each select="azimptl">
      <dt class="mandatory">Azimuthal_Measure_Point_Longitude: <span class="normal"><xsl:value-of select="."/></span></dt>
      <dd id="definition" name="definition">Definition: Longitude of the map projection origin.</dd>
      <dd id="domain" name="domain">Domain: -180.0 &lt;= Azimuthal Measure Point Longitude &lt; 180.0</dd>
    </xsl:for-each>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="obqlpt">
  <dt class="mandatory">Oblique_Line_Point</dt>
  <dd id="definition" name="definition">Definition: Method used to describe the line along which an oblique mercator map projection is centered using two points near the limits of the mapped region that define the center line.</dd>
  <dd>
  <dl>
    <xsl:for-each select="obqllat">
      <dt class="mandatory">Oblique_Line_Latitude: <span class="normal"><xsl:value-of select="."/></span></dt>
      <dd id="definition" name="definition">Definition: Latitude of a point defining the oblique line.</dd>
      <dd id="domain" name="domain">Domain: -90.0 &lt;= Oblique Line Latitude &lt;= 90.0</dd>
    </xsl:for-each>
    <xsl:for-each select="obqllong">
      <dt class="mandatory">Oblique_Line_Longitude: <span class="normal"><xsl:value-of select="."/></span></dt>
      <dd id="definition" name="definition">Definition: Longitude of a point defining the oblique line.</dd>
      <dd id="domain" name="domain">Domain: -180.0 &lt;= Oblique Line Longitude &lt; 180.0</dd>
    </xsl:for-each>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="svlong">
  <dt class="mandatory">Straight_Vertical_Longitude_from_Pole: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: Longitude to be orientated straight up from the North or South Pole.</dd>
  <dd id="domain" name="domain">Domain: -180.0 &lt;= Straight Vertical Longitude from Pole &lt; 180.0</dd>
</xsl:template>

<xsl:template match="sfprjorg">
  <dt class="mandatory">Scale_Factor_at_Projection_Origin: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: A multiplier for reducing a distance obtainied from a map by computation or scaling to the actual distance at the projection origin.</dd>
  <dd id="domain" name="domain">Domain: Scale Factor at Projection Origin &gt;= 0.0</dd>
</xsl:template>

<xsl:template match="landsat">
  <dt class="mandatory">Landsat_Number: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: number of the Landsat satellite.</dd>
  <dd id="domain" name="domain">Domain: free integer</dd>
</xsl:template>

<xsl:template match="pathnum">
  <dt class="mandatory">Path_Number: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: number of the orbit of the Landsat satellite.</dd>
  <dd id="domain" name="domain">Domain: 0 &lt; Path Number &lt; 251 for Landsats 1,2, or 3; 0 &lt; Path Number &lt; 233 for Landsats 4 or 5, free integer</dd>
</xsl:template>

<xsl:template match="sfctrmer">
  <dt class="mandatory">Scale_Factor_at_Central_Meridian: <span class="normal"><xsl:value-of select="."/></span></dt>
  <dd id="definition" name="definition">Definition: A multiplier for reducing a distance obtained from a map by computation or scaling to the actual distance along the central meridian.</dd>
  <dd id="domain" name="domain">Domain: Scale Factor at Central Meridian &gt; 0.0</dd>
</xsl:template>

<xsl:template match="otherprj">
  <dt class="mandatory">Other_Projection's_Definition: </dt>
  <dd><span class="normal"><xsl:value-of select="."/></span></dd>
  <dd id="definition" name="definition">Definition: A description of the projection, not defined elsewhere in the standard, that was used for the data set. The information provide shall include the name of the projection, names of parameters and values used for the data set, and the citation of the specification for the algorithms that describe the mathematical relationship between Earth and the plane or the developable surface for the projection.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>
</xsl:template>

<!-- no Mapproj Property -->
<xsl:template name="no_mapproj_property">
<dt class="mandatory">Map Projection Parameters <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">A complete parameter set of the projection that was used for the data set. The information provided shall include the names of the paramters and values used for the data set that describe the mathematical relationships between the Earth and the plane or developable surface for the projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_stdparl_element"/>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_latprjo_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
    <xsl:call-template name="no_sfequat_element"/>
    <xsl:call-template name="no_heightpt_element"/>
    <xsl:call-template name="no_longpc_element"/>
    <xsl:call-template name="no_latprjc_element"/>
    <xsl:call-template name="no_sfctrlin_element"/>
    <xsl:call-template name="no_obqlazim_element"/>
    <xsl:call-template name="no_obqlpt_element"/>
    <xsl:call-template name="no_svlong_element"/>
    <xsl:call-template name="no_sfprjorg_element"/>
    <xsl:call-template name="no_landsat_element"/>
    <xsl:call-template name="no_pathnum_element"/>
    <xsl:call-template name="no_sfctrmer_element"/>
    <xsl:call-template name="no_otherprj_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Albers Conic Equal Area Mapproj Property -->
<xsl:template name="no_albers_conic_equal_area">
  <dt class="mandatory">Albers_Conical_Equal_Area <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Albers Conical Equal Area projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_stdparl_element"/>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_latprjo_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Azimuthal_Equidistant Mapproj Property -->
<xsl:template name="no_azimuthal_equidistant">
  <dt class="mandatory">Azimuthal_Equidistant <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Azimuthal Equidistant projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_latprjo_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Equidistic Conic Mapproj Property -->
<xsl:template name="no_equidistic_conic">
  <dt class="mandatory">Equidistant_Conic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Equidistant Conic projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_stdparl_element"/>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_latprjo_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Equirectangular Mapproj Property -->
<xsl:template name="no_equirectangular">
  <dt class="mandatory">Equirectangular <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Equirectangular projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_stdparl_element"/>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No General Vertical Near-sided Perspective -->
<xsl:template name="no_general_vertical_near-sided_perspective">
  <dt class="mandatory">General_Vertical_Near-sided_Perspective <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the General Vertical Near-sided Perspective projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_heightpt_element"/>
    <xsl:call-template name="no_longpc_element"/>
    <xsl:call-template name="no_latprjc_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- no Gnomonic Property -->
<xsl:template name="no_gnomonic">
  <dt class="mandatory">Gnomonic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Gnomonic projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longpc_element"/>
    <xsl:call-template name="no_latprjc_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Lambert Azimuthal Equal Area -->
<xsl:template name="no_lambert_azimuthal_equal_area">
  <dt class="mandatory">Lambert_Azimuthal_Equal_Area <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Lambert Azimuthal Equal Area projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longpc_element"/>
    <xsl:call-template name="no_latprjc_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Lambert Conformal Conic -->
<xsl:template name="no_lambert_conformal_conic">
  <dt class="mandatory">Lambert_Conformal_Conic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Lambert Conformal Conic projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_stdparl_element"/>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_latprjo_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!--No Mercator -->
<xsl:template name="no_mercator">
  <dt class="mandatory">Mercator <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Mercator projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_stdparl_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_sfequat_element"/>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Modified Stereographic For Alaska -->
<xsl:template name="no_modified_stereographic_for_alaska">
  <dt class="mandatory">Modified_Stereographic_for_Alaska <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Modified Stereographic for Alaska projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!--No Miller Cylindrical -->
<xsl:template name="no_miller_cylindrical">
  <dt class="mandatory">Miller_Cylindrical <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Miller Cylindrical projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Oblique Mercator -->
<xsl:template name="no_oblique_mercator">
  <dt class="mandatory">Oblique_Mercator <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Oblique Mercator projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_sfctrlin_element"/>
    <xsl:call-template name="no_obqlazim_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_obqlpt_element"/>
    <xsl:call-template name="no_latprjo_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Orthographic -->
<xsl:template name="no_orthographic">
  <dt class="mandatory">Orthographic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Orthographic projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longpc_element"/>
    <xsl:call-template name="no_latprjc_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!--No Polar Stereographic -->
<xsl:template name="no_polar_stereographic">
  <dt class="mandatory">Polar_Stereographic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Polar Stereographic projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_svlong_element"/>
    <xsl:call-template name="no_stdparl_element"/>
    <dt class="normal">- or -</dt>
    <xsl:call-template name="no_sfprjorg_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Polyconic -->
<xsl:template name="no_polyconic">
  <dt class="mandatory">Polyconic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Polyconic projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_latprjo_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Robinson -->
<xsl:template name="no_robinson">
  <dt class="mandatory">Robinson <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Robinson projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longpc_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Sinusoidal -->
<xsl:template name="no_sinusoidal">
  <dt class="mandatory">Sinusoidal <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Sinusoidal projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Space_Oblique_Mercator_(Landsat) -->
<xsl:template name="no_space_oblique_mercator">
  <dt class="mandatory">Space_Oblique_Mercator_(Landsat) <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Space Oblique Mercator (Landsat) projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_landsat_element"/>
    <xsl:call-template name="no_pathnum_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- No Stereographic -->
<xsl:template name="no_stereographic">
  <dt class="mandatory">Stereographic <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Stereographic projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longpc_element"/>
    <xsl:call-template name="no_latprjc_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- no Transverse Mercator -->
<xsl:template name="no_transverse_mercator">
  <dt class="mandatory">Transverse_Mercator <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the Transverse Mercator projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_sfctrmer_element"/>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_latprjo_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

<!-- no van der Grinten -->
<xsl:template name="no_van_der_grinten">
  <dt class="mandatory">van_der_Grinten <span id="open" class="open">open</span></dt>
  <dd id="definition" name="definition">Contains parameters for the van der Grinten projection.</dd>
  <dd class="opentarget">
  <dl>
    <xsl:call-template name="no_longcm_element"/>
    <xsl:call-template name="no_feast_element"/>
    <xsl:call-template name="no_fnorth_element"/>
  </dl>
  </dd>
</xsl:template>

	
<!-- No Stdparl Element -->
<xsl:template name="no_stdparl_element">
  <dt class="mandatory">Standard_Parallel:</dt>
  <dd id="definition" name="definition">Definition: Line of consistant latitude at which the surface of the Earth and the plane or developable surface intersect.</dd>
  <dd id="domain" name="domain">Domain: -90 &lt;= Standard Parallel &lt;= 90</dd>
</xsl:template>

<!-- No Longcm Element -->
<xsl:template name="no_longcm_element">
  <dt class="mandatory">Longitude_of_Central_Meridian:</dt>
  <dd id="definition" name="definition">Definition: The line of longitude at the center of the map projection generally used as the basis for constructing the projection.</dd>
  <dd id="domain" name="domain">Domain: -180 &lt;= Longitude of Central Meridian &lt; 180</dd>
</xsl:template>

<!-- No Latprjo Element -->
<xsl:template name="no_latprjo_element">
  <dt class="mandatory">Latitude_of_Projection_Origin:</dt>
  <dd id="definition" name="definition">Definition: Latitude chosen as the origin of rectangular coordinates for a map projection.</dd>
  <dd id="domain" name="domain">Domain: -90 &lt;= Latitude of Projection Origin &lt;= 90</dd>
</xsl:template>

<!-- No Feast Element -->
<xsl:template name="no_feast_element">
  <dt class="mandatory">False_Easting:</dt>
  <dd id="definition" name="definition">Definition: The value added to all "x" values in the rectangular coordinates for a map projection. This value frequently is assigned to eliminate negative numbers. Expressed in the unit of measure identified in the Planar Coordinate Units.</dd>
  <dd id="domain" name="domain">Domain: free real</dd>
</xsl:template>

<!-- No Fnorth Element -->
<xsl:template name="no_fnorth_element">
  <dt class="mandatory">False_Northing:</dt>
  <dd id="definition" name="definition">Definition: The value added to all "y" values in the rectangular coordinates for a map projection. This value frequently is assigned to eliminate negative numbers. Expressed in the unit of measure identified in the Planar Coordinate Units.</dd>
  <dd id="domain" name="domain">Domain: free real</dd>
</xsl:template>

<!-- No Sfequat Element -->
<xsl:template name="no_sfequat_element">
  <dt class="mandatory">Scale_Factor_at_Equator:</dt>
  <dd id="definition" name="definition">Definition: The multiplier for reducing a distance obtainied from a map by computation or scaling to the actual distance along the equator.</dd>
  <dd id="domain" name="domain">Domain: Scale Factor at Equator &gt; 0.0</dd>
</xsl:template>

<!-- No Heightpt Element -->
<xsl:template name="no_heightpt_element">
  <dt class="mandatory">Height_of_Perspective_Point_Above_Surface:</dt>
  <dd id="definition" name="definition">Definition: Height of viewpoint above the Earth, expressed in meters.</dd>
  <dd id="domain" name="domain">Domain: Height of Perspective Above Surface &gt; 0.0</dd>
</xsl:template>

<!-- No Longpc Element -->
<xsl:template name="no_longpc_element">
  <dt class="mandatory">Longitude_of_Projection_Center:</dt>
  <dd id="definition" name="definition">Definition: Longitude of the point of projection for azimuthal projections.</dd>
  <dd id="domain" name="domain">Domain: -180 &lt;= Longitude of Projection Center &lt; 180</dd>
</xsl:template>

<!-- No Latprjc Element -->
<xsl:template name="no_latprjc_element">
  <dt class="mandatory">Latitude_of_Projection_Center:</dt>
  <dd id="definition" name="definition">Definition: Latitude of the point of projection for azimuthal projections.</dd>
  <dd id="domain" name="domain">Domain: -90 &lt;= Latitude of Projection Center &lt;= 90</dd>
</xsl:template>

<!-- No Sfctrlin Element -->
<xsl:template name="no_sfctrlin_element">
  <dt class="mandatory">Scale_Factor_at_Center_Line:</dt>
  <dd id="definition" name="definition">Definition: A multiplier for reducing a distance obtained from a map by computation or scaling to the actual distance along the center line.</dd>
  <dd id="domain" name="domain">Domain: Scale Factor at Center Line &gt; 0.0</dd>
</xsl:template>

<!-- No Obqlazim Element -->
<xsl:template name="no_obqlazim_element">
  <dt class="mandatory">Oblique_Line_Azimuth</dt>
  <dd id="definition" name="definition">Definition: Method used to describe the line along which an oblique mercator map projection is centered using the map projection origin and an azimuth.</dd>
  <dd>
  <dl>
      <dt class="mandatory">Azimuthal_Angle:</dt>
      <dd id="definition" name="definition">Definition: Angle measured clockwise from north, and expressed in degrees.</dd>
      <dd id="domain" name="domain">Domain: 0.0 &lt;= Azimuthal Angle &lt; 360.0</dd>
      <dt class="mandatory">Azimuthal_Measure_Point_Longitude:</dt>
      <dd id="definition" name="definition">Definition: Longitude of the map projection origin.</dd>
      <dd id="domain" name="domain">Domain: -180.0 &lt;= Azimuthal Measure Point Longitude &lt; 180.0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Obqlpt Element -->
<xsl:template name="no_obqlpt_element">
  <dt class="mandatory">Oblique_Line_Point</dt>
  <dd id="definition" name="definition">Definition: Method used to describe the line along which an oblique mercator map projection is centered using two points near the limits of the mapped region that define the center line.</dd>
  <dd>
  <dl>
      <dt class="mandatory">Oblique_Line_Latitude:</dt>
      <dd id="definition" name="definition">Definition: Latitude of a point defining the oblique line.</dd>
      <dd id="domain" name="domain">Domain: -90.0 &lt;= Oblique Line Latitude &lt;= 90.0</dd>
      <dt class="mandatory">Oblique_Line_Longitude:</dt>
      <dd id="definition" name="definition">Definition: Longitude of a point defining the oblique line.</dd>
      <dd id="domain" name="domain">Domain: -180.0 &lt;= Oblique Line Longitude &lt; 180.0</dd>
  </dl>
  </dd>
</xsl:template>

<!-- No Svlong Element -->
<xsl:template name="no_svlong_element">
  <dt class="mandatory">Straight_Vertical_Longitude_from_Pole: </dt>
  <dd id="definition" name="definition">Definition: Longitude to be orientated straight up from the North or South Pole.</dd>
  <dd id="domain" name="domain">Domain: -180.0 &lt;= Straight Vertical Longitude from Pole &lt; 180.0</dd>
</xsl:template>

<!-- No Sfprjorg Element -->
<xsl:template name="no_sfprjorg_element">
  <dt class="mandatory">Scale_Factor_at_Projection_Origin:</dt>
  <dd id="definition" name="definition">Definition: A multiplier for reducing a distance obtainied from a map by computation or scaling to the actual distance at the projection origin.</dd>
  <dd id="domain" name="domain">Domain: Scale Factor at Projection Origin &gt;= 0.0</dd>
</xsl:template>

<!-- No Landsat Element -->
<xsl:template name="no_landsat_element">
  <dt class="mandatory">Landsat_Number: </dt>
  <dd id="definition" name="definition">Definition: number of the Landsat satellite.</dd>
  <dd id="domain" name="domain">Domain: free integer</dd>
</xsl:template>

<!-- No Pathnum Element -->
<xsl:template name="no_pathnum_element">
  <dt class="mandatory">Path_Number: </dt>
  <dd id="definition" name="definition">Definition: number of the orbit of the Landsat satellite.</dd>
  <dd id="domain" name="domain">Domain: 0 &lt; Path Number &lt; 251 for Landsats 1,2, or 3; 0 &lt; Path Number &lt; 233 for Landsats 4 or 5, free integer</dd>
</xsl:template>

<!-- No Sfctrmer Element -->
<xsl:template name="no_sfctrmer_element">
  <dt class="mandatory">Scale_Factor_at_Central_Meridian:</dt>
  <dd id="definition" name="definition">Definition: A multiplier for reducing a distance obtained from a map by computation or scaling to the actual distance along the central meridian.</dd>
  <dd id="domain" name="domain">Domain: Scale Factor at Central Meridian &gt; 0.0</dd>
</xsl:template>

<!-- No Otherprj Element -->
<xsl:template name="no_otherprj_element">
  <dt class="mandatory">Other_Projection's_Definition: </dt>
  <dd id="definition" name="definition">Definition: A description of the projection, not defined elsewhere in the standard, that was used for the data set. The information provide shall include the name of the projection, names of parameters and values used for the data set, and the citation of the specification for the algorithms that describe the mathematical relationship between Earth and the plane or the developable surface for the projection.</dd>
  <dd id="domain" name="domain">Domain: free text</dd>
</xsl:template>

</xsl:stylesheet>