<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl" TYPE="text/javascript">

<!-- An XSL template for displaying metadata in ArcInfo8.

     Copyright (c) 2000-2002, Environmental Systems Research Institute, Inc. All rights reserved.
     	
     Revision History: Created 5/14/99 avienneau
                       Updated 3/31/00 avienneau
		       Updated 9/14/00 mlyszkiewicz
                       Updated 11/2/00 avienneau
		       Updated 12/12/00 mlyszkiewicz
                       Updated 9/15/00 dagna
-->

<xsl:template match="/">
  <HTML>
    <HEAD>
      <STYLE>
        <!-- body -->
        BODY {background-color:#FFFFFF; margin:0.25in; 
              font-size:10pt; font-family:Arial,sans-serif}
        <!-- title -->
        H1   {margin-left:0.05in; position:relative; top:-6; text-align:center;
              font-weight:bold; font-size:18; font-family:Verdana,sans-serif; color:#AA0000}
        <!-- data type -->
        H2   {margin-left:0.25in; position:relative; top:-16; text-align:center;
              font-size:13; font-family:Verdana,sans-serif; color:#003E88}

        <!-- "tabs" table -->
        <!-- table style -->
        TABLE  {position:relative; top:-10; valign:top; table-layout:fixed; 
                border-collapse:collapse}
        <!-- table row style -->
        TD   {text-align:center}
        <!-- table cell style -->
        TD   {font-weight:bold; font-size:11pt; border-color:#00639C}
        <!-- selected tab -->
        .tsel  {color:#FFFFFF; background-color:#00639C}
        <!-- unselected tab -->
        .tun   {color:#00639C; background-color:#B3D9D9}
        <!-- unselected tab hilite -->
        .tover {color:#003E88; background-color:#B3D9D9; cursor:hand}
        <!-- properties box -->
        .f   {background-color:#FFFFFF; border:'1.5pt solid #00639C'; 
              position:relative; top:-10}

        <!-- headings -->
        <!-- group heading -->
        .ph1  {color:#2E8B57; font-weight:bold; cursor:}
        <!-- group heading indented -->
        .ph2  {margin-left:0.2in; color:#2E8B57; font-weight:bold; cursor:}
        <!-- group heading hilite -->
        .pover1 {color:#006000; font-weight:bold; cursor:hand}
        <!-- group heading hilite indented -->
        .pover2 {margin-left:0.2in; color:#006000; font-weight:bold; cursor:hand}

        <!-- values -->
        <!-- property name -->
        .pn  {color:#003E88; font-weight:bold}
        <!-- property value -->
        .pv  {font-family:Verdana,sans-serif; line-height:135%;
              color:#191970; margin:0in 0.15in 0.75in 0.15in}
        <!-- expanded properties -->
        .pe1  {margin-left:0.2in}
        <!-- expanded properties entity indent -->
        .pe2  {margin-left:0.25in; font-weight:normal; color:#191970;}
        <!-- expanded long text -->
        .lt  {line-height:115%}
        <!-- lists of comma-separated elements -->
        .lt2  {line-height:115%; margin-bottom:1mm}
        <!-- indented spatial reference parameters -->
        .sr1  {margin-left:0in}
        .sr2  {margin-left:0.2in}
        .sr3  {margin-left:0.4in}
        .srh1  {color:#003E88; font-weight:bold; margin-left:0in}
        .srh2  {color:#003E88; font-weight:bold; margin-left:0.2in}

        <!-- search results -->
        .name   {margin-left:0.05in; position:relative; top:-6; text-align:center;
                 font-weight:bold; font-size:18; font-family:Verdana,sans-serif; color:#006400}
        .sub   {margin-left:0.25in; text-align:center; position:relative; top:3; 
                font-weight:bold; font-size:13; font-family:Verdana,sans-serif; color:#006400}
        .search   {margin:0in 0.15in 0.75in 0.15in; 
                   color:#191970; font-family:Verdana,sans-serif; font-size:13}
        .head   {color:#006400}
      </STYLE>

      <SCRIPT LANGUAGE="JScript"><xsl:comment><![CDATA[

      //changes the color of the tabs or headings that you can click
      //when the mouse hovers over them
      function doHilite()  {
        var e = window.event.srcElement;
        if (e.className == "tun") {
          e.className = "tover";
        }
        else if (e.className == "tover") {
            e.className = "tun";
        }
        else if (e.className == "ph1") {
            e.className = "pover1";
        }
        else if (e.className == "ph2") {
            e.className = "pover2";
        }
        else if (e.className == "pover1") {
            e.className = "ph1";
        }
        else if (e.className == "pover2") {
            e.className = "ph2";
        }

        window.event.cancelBubble = true;
      }

      //changes the style of the selected tab to unselected and hide its text, then 
      //set the style of the tab that was clicked on to selected and show its text
      function changeTab(eRow)  {
        var tabs = eRow.cells;
        for (var i = 0; i < tabs.length; i++) {
          var oldTab = tabs[i];
          if (oldTab.className == "tsel") {
            break;
          }
        }
        oldTab.className = "tun";
        var oldContent = getAssociated(oldTab);
        oldContent.style.display = "none";

        var newTab = window.event.srcElement;
        newTab.className ="tsel";
        var newContent = getAssociated(newTab);
        newContent.style.display = "block";

        window.event.cancelBubble = true;
      }

      //hide or show the text assoicated with the heading that was clicked
      function hideShowGroup(e)  {
        var theGroup = e.children[0];
        if (theGroup.style.display == "none") {
          theGroup.style.display="block";
        }
        else { 
          theGroup.style.display="none";
        }

        window.event.cancelBubble = true;
      }

      //returns the name of the element containing the text associated with each tab
      function getAssociated(e) {
        if (e.tagName == "TD") {
          switch (e.id) {
            case "DescTab":
              return (Description);
            case "SpatialTab": 
              return (Spatial);
            case "AttribTab": 
              return (Attributes);
          }
        }
      }

      //centers the thumbnail
      function position() {
        var e;
        e = document.all("thumbnail");
        if (e != null) {
          b = document.body;
          w1 = b.clientWidth - 80;
          w2 = w1 - thumbnail.width;
          var margin = Math.floor(w2 * .5);
          thumbnail.style.visibility = "hidden";
          thumbnail.style.marginLeft = margin;
          thumbnail.style.visibility = "visible";
        }
      }

      //parse text to respect line breaks added - increases readability.
      //lines beginning with a ">" character are presented with a monospace
      //(fixed-width) font - e.g., so equations will appear correctly
      function fix(e) {
        var par = e.parentNode;
        e.id = "";
        var pos = e.innerText.indexOf("\n");
        if (pos > 0) {
          while (pos > 0) {
            var t = e.childNodes(0);
            var n = document.createElement("PRE");
            var s = t.splitText(pos);
            e.insertAdjacentElement("afterEnd", n);
            n.appendChild(s);
            e = n;
            pos = e.innerText.indexOf("\n");
          }
          var count = (par.children.length);
          for (var i = 0; i < count; i++) {
            e = par.children(i);
            if (e.tagName == "PRE") {
              pos = e.innerText.indexOf(">");
              if (pos != 0) {
                n = document.createElement("DIV");
                e.insertAdjacentElement("afterEnd", n);
                n.innerText = e.innerText;
                e.removeNode(true);
              }
            }
          }
          if (par.children.tags("PRE").length > 0) {
            count = (par.childNodes.length);
            for (i = 0; i < count; i++) {
              e = par.children(i);
              if (e.tagName == "PRE") {
                e.id = "";
                if (i < (count-1)) {
                  var e2 = par.children(i + 1);
                  if (e2.tagName == "PRE") {
                    e.insertAdjacentText("beforeEnd", e2.innerText+"\n");
                    e2.removeNode(true);
                    count = count-1;
                    i = i-1;
                  }
                }
              }
            }
          }
        }
        else {
          n = document.createElement("DIV");
          par.appendChild(n);
          n.innerText = e.innerText;
          e.removeNode(true);
        }
      }

      ]]></xsl:comment></SCRIPT>
    </HEAD>
	
    <BODY onload="position();" onresize="position();" oncontextmenu="return false">

    <xsl:choose> 
      <xsl:when test="context()[not(metadata)]"> 

        <xsl:choose> 
          <!-- Show parameters defining the search when the 
               root element of the XML file is SearchResults -->
          <xsl:when test="context()[SearchResults]"> 
            <xsl:apply-templates select="SearchResults" />
          </xsl:when> 

          <!-- If root element isn't metadata or SearchResults, 
               we don't know what data this file contains -->
          <xsl:otherwise> 
            <DIV STYLE="text-align:center; color:#2E8B57; margin-left:1in; margin-right:1in">
              <BR/><BR/>
              This document does not contain information that can be displayed 
              with the ESRI stylesheet.
            </DIV>
          </xsl:otherwise> 
        </xsl:choose> 
      </xsl:when> 

      <xsl:otherwise> 

        <!-- Add title and subtitle to the page -->
        <xsl:for-each select="/metadata/idinfo/citation/citeinfo/title[. != '']">
          <H1><xsl:value-of /></H1>
        </xsl:for-each>
        <xsl:for-each select="/metadata/idinfo/natvform[. != '']">
          <H2><xsl:value-of />
		<xsl:if test="/metadata/spdoinfo/rastinfo/rastifor[. != '']">
			- <xsl:value-of select="/metadata/spdoinfo/rastinfo/rastifor" />
		</xsl:if>
		</H2>
        </xsl:for-each>

        <!-- Set up the tabs -->
        <TABLE cols="3" frame="void" rules="cols" width="315" height="28">
          <COL WIDTH="105"/><COL WIDTH="105"/><COL WIDTH="105"/>
          <TR height="28" onmouseover="doHilite()" onmouseout="doHilite()" onclick="changeTab(this)">
            <TD ID="DescTab" CLASS="tsel" TITLE="Click to see a description of the data">Descrizione</TD>
            <TD ID="SpatialTab" CLASS="tun" TITLE="Click for details about the spatial data">Dati Spaziali</TD>
            <TD ID="AttribTab" CLASS="tun" TITLE="Click for details about the attribute data">Attributi</TD>
          </TR>
        </TABLE>

        <!-- Define the box which will contain the contents of the current tab -->
        <DIV ID="Group" CLASS="f">

          <!-- Description Tab -->
          <DIV ID="Description" CLASS="pv" STYLE="display:block"><BR/>

            <xsl:choose>
              <xsl:when test="/metadata[($any$ (idinfo/(citation/citeinfo/
                  (origin | pubdate | pubtime | ftname | geoform | onlink | pubinfo/* | 
                  serinfo/*) | timeperd//* | descript/(abstract | purpose | supplinf) | 
                  native | accconst | useconst | keywords/*/(themekey | placekey | 
                  stratkey | tempkey) | browse/(browsen | img/@src) | status/*) | 

                  distinfo/stdorder/digform/(digtinfo/(formname | dssize | transize | 
                  filedec) | digtopt/(onlinopt/(computer/(networka/* | sdeconn/* | 
                  dialinst/(dialtel | dialfile)) | accinstr) | offoptn/offmedia)) | 

                  metainfo/(metd | metrd | metfrd | metstdn | metstdv | mettc | metextns/* | 
                  metc/cntinfo/(cntvoice | cntfax | cntemail | hours | cntinst | */cntper | 
                  */cntorg | cntaddr/(address | city | state | postal | country))) | 

                  Binary/Enclosure/img/@src | Esri/ModDate) != '') or 
                  (Binary/Enclosure/Data/@EsriPropertyType = 'Base64')]">


                <!-- Show contents of Description tab -->
                <xsl:apply-templates select="/metadata//img[(@src != '')]" />

                <xsl:apply-templates select="/metadata/idinfo/keywords
                    [$any$ */(themekey | placekey | stratkey | tempkey) != '']" />

                <xsl:if test="/metadata[($any$ idinfo/(browse/img/@src | 
                    keywords/*/(themekey | placekey | stratkey | tempkey)) != '') 
                    and (($any$ (idinfo/(descript/(abstract | purpose | supplinf) | 
                    browse/browsen) | Binary/Enclosure/img/@src) != '') 
                    or (Binary/Enclosure/Data/@EsriPropertyType = 'Base64'))]">
                  <BR/>
                </xsl:if>

                <xsl:if test="/metadata[($any$ idinfo/(descript/(abstract | purpose | 
                    supplinf) | browse/browsen) != '') or 
                    ($any$ Binary/Enclosure/Data/@EsriPropertyType = 'Base64') or 
                    ($any$ Binary/Enclosure/img/@src != '')]">
                  <DIV CLASS="pn">Descrizione</DIV>
                  <xsl:apply-templates select="/metadata/idinfo/descript[
                      (abstract != '') or (purpose != '') or (supplinf != '')]" />
                  <xsl:apply-templates select="/metadata/Binary
                      [(Enclosure/Data/@EsriPropertyType = 'Base64') or 
                      (Enclosure/img/@src != '')]" />
                  <xsl:if test="/metadata[$any$ idinfo/browse/browsen != '']">
                    <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Links to graphics describing the data
                      <DIV CLASS="pe2" STYLE="display:; position:relative; top:-15; margin-left:-0.05in">
                        <UL><xsl:apply-templates select="/metadata/idinfo/browse[browsen != '']" /></UL>
                      </DIV>
                    </DIV>
                  </xsl:if>
                </xsl:if>                
               
                <xsl:if test="/metadata[($any$ idinfo/(status/* | citation/citeinfo/
                    (origin | pubdate | pubtime | pubinfo/* | serinfo/*) | timeperd//*) != '') 
                    and (($any$ (idinfo/(descript/(abstract | purpose | supplinf) | keywords/*/(themekey | placekey | 
                    stratkey | tempkey) | browse/(img/@src | browsen)) | 
                    Binary/Enclosure/img/@src) != '') or 
                    (Binary/Enclosure/Data/@EsriPropertyType = 'Base64'))]">
                  <DIV STYLE="text-align:center; color:#003E88">_________________</DIV><BR/>
                </xsl:if>

                <xsl:apply-templates select="/metadata/idinfo/status[$any$ * != '']" />
                
                <!--Fede Qualità-->
                <xsl:if test="/metadata[$any$ dataqual/* != '']">
                   <BR/>                   
                </xsl:if>
                
                <xsl:apply-templates select="/metadata/dataqual[$any$ * != '']" />
                <!--fine Fede-->
                
                <!--Fede<xsl:if test="/metadata[($any$ idinfo/status/* != '') 
                    and ($any$ idinfo/timeperd//* != '')]">
                  <BR/>
                </xsl:if>-->

                <xsl:apply-templates select="/metadata/idinfo/timeperd[$any$ .//* != '']" />

                <xsl:if test="/metadata[($any$ idinfo/(status/* | timeperd//*) != '') and 
                    ($any$ idinfo/citation/citeinfo/(origin | pubdate | pubtime | 
                    pubinfo/* | serinfo/*) != '')]">
                  <BR/>
                </xsl:if>

                <xsl:apply-templates select="/metadata/idinfo/citation/citeinfo
                    [(origin != '') or (pubdate != '') or (pubtime != '') or 
                    ($any$ pubinfo/* != '') or ($any$ serinfo/* != '')]" />

                <xsl:if test="/metadata[($any$ (idinfo/(citation/citeinfo/(ftname | 
                    geoform | onlink) | native | accconst | useconst) | distinfo/stdorder/
                    digform/(digtinfo/(formname | dssize | transize | filedec) | 
                    digtopt/(onlinopt/(computer/(networka/* | sdeconn/* | 
                    dialinst/(dialtel | dialfile)) | accinstr) | offoptn/offmedia)) | 
                    metainfo/(metd | metrd | metfrd | metstdn | metstdv | mettc | metextns/* |
                    metc/cntinfo/(cntvoice | cntfax | cntemail | hours | cntinst | */cntper | 
                    */cntorg | cntaddr/(address | city | state | postal | country))) | 
                    Esri/ModDate) != '') and 
                    (($any$ (idinfo/(descript/(abstract | purpose | supplinf) | 
                    keywords/*/(themekey | placekey | stratkey | tempkey) | 
                    browse/(img/@src | browsen) | status/* | timeperd//* | 
                    citation/citeinfo/(origin | pubdate | pubtime | pubinfo/* | 
                    serinfo/*)) | Binary/Enclosure/img/@src) != '') or 
                    (Binary/Enclosure/Data/@EsriPropertyType = 'Base64'))]">
                  <DIV STYLE="text-align:center; color:#003E88">_________________</DIV><BR/>
                </xsl:if>
                <!--Fede-->
                <xsl:if test="/metadata[$any$ (idinfo/(citation/citeinfo/(ftname | 
                    geoform | onlink) | native | accconst | useconst) | distinfo/stdorder/
                    digform/(digtinfo/(formname | dssize | transize | filedec) | 
                    digtopt/(onlinopt/(computer/(networka/* | sdeconn/* | 
                    dialinst/(dialtel | dialfile)) | accinstr) | offoptn/offmedia)) | distinfo/distrib/cntinfo/(cntvoice | cntfax | 
                    cntemail | hours | cntinst | */cntper | */cntorg | 
                    cntaddr/(address | city | state | postal | country))) != '']">
                  <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Accesso al dato e distribuzione
                    <DIV CLASS="pe2" STYLE="display:none">

                      <xsl:for-each select="/metadata/idinfo/citation/citeinfo/ftname[. != '']">
                        <I>Nome del file: </I><xsl:value-of /><BR/>
                      </xsl:for-each>
                      <!--Fede-->
                      <xsl:for-each select="/metadata/idinfo/natvform[. != '']">
                        <I>Formato del file: </I><xsl:value-of />
		        <xsl:if test="/metadata/spdoinfo/rastinfo/rastifor[. != '']">
			  - <xsl:value-of select="/metadata/spdoinfo/rastinfo/rastifor" />
		        </xsl:if><BR/>		
                      </xsl:for-each> 
                      
                      <xsl:for-each select="/metadata/distinfo//stdorder/digform/digtinfo/dssize[. != '']">
                        <I>Dimensione del file: </I><xsl:value-of /> MB<BR/>		
                      </xsl:for-each>

                      <xsl:for-each select="/metadata/idinfo/citation/citeinfo/geoform[. != '']">
                        <I>Tipo di dato: </I><xsl:value-of /><BR/>
                      </xsl:for-each>
                      
                      <xsl:for-each select="/metadata/distinfo/resdesc[. != '']">
                        <I>Tipologia del contenuto: </I><xsl:value-of /><BR/>
                      </xsl:for-each>  

                      <xsl:for-each select="/metadata/idinfo/citation/citeinfo/onlink[. != '']">
                        <xsl:if test="context()[0]"><DIV><I>Localizzazione del dato: </I></DIV></xsl:if>
                        <DIV><LI STYLE="margin-left:0.2in"><xsl:value-of/></LI></DIV>    
                      </xsl:for-each>    

                      <!--Fede<xsl:for-each select="/metadata/idinfo/native[. != '']">
                        <I>Data processing environment: </I><SPAN CLASS="lt"><xsl:value-of /></SPAN><BR/>
                      </xsl:for-each>-->
                     
                      <!--Fede Distribuzione-->
                      <xsl:if test="/metadata/distinfo[($any$ stdorder/* != '') or (stdorder/digform/digtinfo/formname != '')
                       or (stdorder/digform/digtopt/offoptn/offmedia != '') or ($any$ distrib/cntinfo/(cntvoice | cntfax | 
                       cntemail | hours | cntinst | */cntper | */cntorg | cntaddr/(address | city | state | postal | country)) != '')]">
                        <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Distribuzione
                         <DIV  CLASS="pe2" STYLE="display:none">
                          
                          <!--Fede Contatto-->                     
                          <xsl:if test="/metadata/distinfo/distrib[($any$ cntinfo/(cntvoice | cntfax | 
                             cntemail | hours | cntinst | */cntper | */cntorg | cntaddr/(address | city | state | postal | country)) != '')]"> 
                             <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Contatto per la distribuzione
                               <DIV CLASS="pe2" STYLE="display:none">
                                 <xsl:apply-templates select="/metadata/distinfo/distrib/cntinfo[(cntvoice != '') or 
                                  (cntfax != '') or (cntemail != '') or (hours != '') or (cntinst != '') or (*/cntper != '') or (*/cntorg != '') or 
                                  (cntaddr/* != '')]" />
                               </DIV>
                             </DIV>
                          </xsl:if>
                          
                          <xsl:for-each select="/metadata/distinfo/stdorder[(nondig != '') or (digform/digtinfo/formname != '')]">                                                        
                            <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">
                              <xsl:if test="context()[nondig != '']">Processo di ordine per formato non digitale
                                <DIV  CLASS="pe2" STYLE="display:none">
                                  <I>Descrizione processo: </I><xsl:value-of  select="nondig[. != '']"/><BR/>
                                  <xsl:for-each select="ordering[. != '']">
                                    <I>Istruzioni per l'ordine: </I>                                  
                                    <A TARGET="viewer"><xsl:attribute name="HREF"><xsl:value-of/></xsl:attribute><xsl:value-of/></A>
                                    <BR/>
                                  </xsl:for-each>
                                  <xsl:for-each select="fees[. != '']">
                                    <I>Prezzo: </I><xsl:value-of/><BR/>
                                  </xsl:for-each>
                                </DIV>
                              </xsl:if>                               
                              <xsl:if test="context()[digform/digtinfo/formname != '']">Processo di ordine per formato digitale                    
                               <DIV  CLASS="pe2" STYLE="display:none">                                
                                 <xsl:for-each select="digform[(digtinfo/formname != '') or (digtopt/offoptn/offmedia != '')]"> 
                                   <I>Formato disponibile: </I><xsl:value-of select="digtinfo/formname[. != '']"/><BR/>
                                   <I>Supporto (solo per offline): </I><xsl:value-of select="digtopt/offoptn/offmedia[. != '']"/><BR/>
                                 </xsl:for-each>
                                 <xsl:for-each select="ordering[. != '']">
                                    <I>Istruzioni per l'ordine: </I>                                  
                                    <A TARGET="viewer"><xsl:attribute name="HREF"><xsl:value-of/></xsl:attribute><xsl:value-of/></A>
                                    <BR/>
                                  </xsl:for-each>
                                  <xsl:for-each select="fees[. != '']">
                                    <I>Prezzo: </I><xsl:value-of/><BR/>
                                  </xsl:for-each>
                               </DIV>
                              </xsl:if>                                
                            </DIV>                                                                             
                          </xsl:for-each>
                        
                          </DIV>
                        </DIV>
                      </xsl:if>
                      
                      
                      <!--Fede<xsl:apply-templates select="/metadata/distinfo/stdorder/digform
                          [($any$ digtinfo/(formname | dssize | transize | filedec) != '') 
                          or ($any$ digtopt/onlinopt/accinstr != '') or ($any$ 
                          digtopt/onlinopt/computer/(networka/* | sdeconn/*) != '') or 
                          ($any$ digtopt/onlinopt/computer/dialinst/(dialtel | dialfile) != '') 
                          or ($any$ digtopt/offoptn/offmedia != '')]" />-->
                          

                      <xsl:if test="/metadata[$any$ idinfo/(accconst | useconst) != '']">
                        <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Restrizioni all'uso
                          <DIV CLASS="pe2" STYLE="display:none">
                            <!--<xsl:apply-templates select="/metadata/idinfo/accconst[. != '']" />-->
                            <xsl:apply-templates select="/metadata/idinfo/useconst[. != '']" />
                          </DIV>
                        </DIV>
                      </xsl:if>

                    </DIV>
                  </DIV>
                </xsl:if>

                <xsl:if test="/metadata[($any$ (idinfo/(citation/citeinfo/(ftname | 
                    geoform | onlink) | native | accconst | useconst) | distinfo/stdorder/
                    digform/(digtinfo/(formname | dssize | transize | filedec) | 
                    digtopt/(onlinopt/(computer/(networka/* | sdeconn/* | 
                    dialinst/(dialtel | dialfile)) | accinstr) | offoptn/offmedia))) != '') 
                    and ($any$ (Esri/ModDate | metainfo/(metd | metrd | metfrd | metstdn | 
                    metstdv | mettc | metextns/* | metc/cntinfo/(cntvoice | cntfax | 
                    cntemail | hours | cntinst | */cntper | */cntorg | 
                    cntaddr/(address | city | state | postal | country)))) != '')]">
                  <BR/>
                </xsl:if>

                <xsl:if test="/metadata[(Esri/ModDate != '') or 
                    ($any$ metainfo/(metd | metrd | metfrd | metstdn | metstdv | mettc | 
                    metextns/* | metc/cntinfo/(cntvoice | cntfax | cntemail | 
                    hours | cntinst | */cntper | */cntorg | cntaddr/(address | city | 
                    state | postal | country))) != '')]">
                  <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Informazioni sui metadata
                    <DIV CLASS="pe2" STYLE="display:none">

                      <xsl:choose>
                        <!-- Fede -->
                        <xsl:when test="/metadata[Esri/CreaDate != '']">
                          Data di creazione: <xsl:value-of select="/metadata/Esri/CreaDate"/><BR/>
                          <xsl:if test="/metadata[Esri/SyncDate != '']">
                            Data di sincronizzazione: <xsl:value-of select="/metadata/Esri/SyncDate"/><BR/>                          
                          </xsl:if>                        
                          <xsl:if test="/metadata[Esri/ModDate != '']">
                            Data di ultima modifica (Esri): <xsl:value-of select="/metadata/Esri/ModDate"/>
                          </xsl:if>  
                          <xsl:if test="/metadata[Esri/ModTime != '']">
                            all'ora <xsl:value-of select="/metadata/Esri/ModTime"/>
                          </xsl:if>
                        </xsl:when>
                        
                        <xsl:otherwise>
                          <xsl:for-each select="/metadata/metainfo/metd[. != '']">
                            <DIV>Ultimo aggiornamento dei contenuti: <xsl:value-of /></DIV>
                          </xsl:for-each>
                        </xsl:otherwise>                       
                      </xsl:choose><BR/>
                      
                        <xsl:for-each select="/metadata/metainfo/metrd[. != '']">
                          Data di ultima modifica: <xsl:value-of /><BR/>
                        </xsl:for-each>
                        <xsl:for-each select="/metadata/metainfo/langmeta[. != '']">
                          Lingua dei metadata: <xsl:value-of /><BR/>
                        </xsl:for-each>
                        <xsl:if test="/metadata/metainfo/metextns/onlink[. != '']">
                          Documentazione di riferimento: 
                          <xsl:for-each select="/metadata/metainfo/metextns/onlink[. != '']">
                              <LI><A TARGET="viewer"><xsl:attribute name="HREF"><xsl:value-of/></xsl:attribute><xsl:value-of/></A>
                              </LI>                            
                          </xsl:for-each>
                        </xsl:if>                          
                      
                      <!-- Fede<xsl:apply-templates select="/metadata/metainfo[(metrd != '') or 
                          (metfrd != '') or (metstdn != '') or (metstdv != '') or 
                          (mettc != '') or ($any$ metextns/* != '') or 
                          (metc/cntinfo/cntvoice != '') or (metc/cntinfo/cntfax != '') or 
                          (metc/cntinfo/cntemail != '') or (metc/cntinfo/hours != '') or 
                          (metc/cntinfo/cntinst != '') or (metc/cntinfo/cntaddr/* != '') or 
                          (metc/cntinfo/*/cntper != '') or (metc/cntinfo/*/cntorg != '')]" />-->
                          
                          

                    </DIV>
                  </DIV>
                </xsl:if>                 

              </xsl:when>

              <!-- If nothing to show in Description tab, show message -->
              <xsl:otherwise>
                <BR/>
                <DIV STYLE="text-align:center; color:#2E8B57">
                  Nessuna informazione descrittiva dettagliata disponibile.
                </DIV>
                <BR/>
              </xsl:otherwise>
            </xsl:choose>

            <BR/>
          </DIV>

          <!-- Spatial Tab -->
          <DIV ID="Spatial" class="pv" STYLE="display:none"><BR/>

            <xsl:choose>
              <xsl:when test="/metadata[($any$ (spdoinfo/(ptvctinf/(
                  esriterm/* | sdtsterm/* | vpfterm/(vpflevel | vpfinfo/*)) | 
                  rastinfo/* | netinfo/(nettype | connrule/*)) | 

                  idinfo/spdom/(bounding/* | lboundng/* | minalti | maxalti) | 

                  spref/(horizsys/(geograph/* | planar//* | local/* | cordsysn/* | 
                  geodetic/*) | vertdef//*) | 

                  dataqual/posacc/(horizpa/(horizpar | qhorizpa/horizpav) | 
                  vertacc/(vertaccr | qvertpa/vertaccv))) != '')]">


                <!-- Show contents of Spatial tab -->
                <xsl:apply-templates select="/metadata/spref/horizsys
                    [$any$ (geograph/* | planar//* | local/* | cordsysn/* | 
                    geodetic/*) != '']" />

                <xsl:if test="/metadata[($any$ spref/horizsys/(geograph/* | 
                    planar//* | local/* | cordsysn/* | geodetic/*) != '') 
                    and ($any$ spref/vertdef//* != '')]"> 
                  <BR/>
                </xsl:if>

                <xsl:apply-templates select="/metadata/spref/vertdef[$any$ */* != '']" />
                
                <!--Fede sistema di rif indiretto-->
                <xsl:apply-templates select="/metadata/spdoinfo[$any$ * != '']" />

                <xsl:if test="/metadata[($any$ idinfo/spdom/(bounding/* | 
                    lboundng/* | minalti | maxalti) != '') and ($any$ spref/
                    (horizsys/(geograph/* | planar//* | local/* | cordsysn/* | 
                    geodetic/*) | vertdef//*) != '')]">
                  <DIV STYLE="text-align:center; color:#003E88">_________________</DIV><BR/>
                </xsl:if>

                <xsl:apply-templates select="/metadata/idinfo/spdom
                    [$any$ (bounding/* | lboundng/* | minalti | maxalti) != '']" />

                <!--Fede
                <xsl:if test="/metadata[($any$ dataqual/posacc/(horizpa/
                    (horizpar | qhorizpa/horizpav) | vertacc/(vertaccr | 
                    qvertpa/vertaccv)) != '') and ($any$ (idinfo/spdom/
                    (bounding/* | lboundng/* | minalti | maxalti) | 
                    spref/(horizsys/(geograph/* | planar//* | local/* | 
                    cordsysn/* | geodetic/*) | vertdef//*)) != '')]">
                  <DIV STYLE="text-align:center; color:#003E88">_________________</DIV><BR/>
                </xsl:if>                
                <xsl:apply-templates select="/metadata/dataqual/posacc
                    [$any$ (horizpa/(horizpar | qhorizpa/horizpav) | 
                    vertacc/(vertaccr | qvertpa/vertaccv)) != '']" />-->

                <xsl:if test="/metadata[($any$ spdoinfo/(ptvctinf/(esriterm/* | 
                    sdtsterm/* | vpfterm/(vpflevel | vpfinfo/*)) | rastinfo/* | 
                    netinfo/(nettype | connrule/*)) != '') and ($any$ 
                    (idinfo/spdom/(bounding/* | lboundng/* | minalti | maxalti) | 
                    spref/(horizsys/(geograph/* | planar//* | local/* | 
                    cordsysn/* | geodetic/*) | vertdef//*) | 
                    dataqual/posacc/(horizpa/(horizpar | qhorizpa/horizpav) | 
                    vertacc/(vertaccr | qvertpa/vertaccv))) != '')]">
                  <DIV STYLE="text-align:center; color:#003E88">_________________</DIV><BR/>
                </xsl:if>

                <xsl:if test="/metadata[$any$ spdoinfo/(ptvctinf/(esriterm/* | 
                    sdtsterm/* | vpfterm/(vpflevel | vpfinfo/*)) | 
                    netinfo/(nettype | connrule/*) | rastinfo/*) != '']">
                  <DIV CLASS="pn">Descrizione dei dati spaziali</DIV>
                </xsl:if>

                <xsl:if test="/metadata[$any$ spdoinfo/ptvctinf/(esriterm/* | 
                    sdtsterm/* | vpfterm/(vpflevel | vpfinfo/*)) != '']">
                  <DIV CLASS="pn" STYLE="margin-left:0.2in">Descrizione dati vettoriali</DIV>
                </xsl:if>

                <xsl:apply-templates select="/metadata/spdoinfo/ptvctinf/esriterm
                    [$any$ * != '']" />

                <xsl:if test="/metadata[($any$ spdoinfo/ptvctinf/esriterm/* != '') and 
                    ($any$ spdoinfo/ptvctinf/sdtsterm/* != '')]">
                  <BR/>
                </xsl:if>
                <!--Fede
                <xsl:if test="/metadata[$any$ spdoinfo/ptvctinf/sdtsterm != '']">
                  <DIV CLASS="ph2" STYLE="margin-left:0.4in" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">SDTS description
                    <DIV CLASS="pe2" STYLE="display:none">
                      <xsl:apply-templates select="
                          /metadata/spdoinfo/ptvctinf/sdtsterm[$any$ * != '']" />
                    </DIV>
                  </DIV>
                </xsl:if>-->

                <xsl:if test="/metadata[($any$ spdoinfo/ptvctinf/(esriterm/* | 
                    sdtsterm/*) != '') and ($any$ spdoinfo/ptvctinf/vpfterm/(vpflevel | 
                    vpfinfo/*) != '')]">
                  <BR/>
                </xsl:if>
                <!--Fede  
                <xsl:if test="/metadata[$any$ spdoinfo/ptvctinf/vpfterm/(vpflevel | 
                    vpfinfo/*) != '']">
                  <DIV CLASS="ph2" STYLE="margin-left:0.4in" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">VPF description
                    <DIV CLASS="pe2" STYLE="display:none">
                      <xsl:apply-templates select="/metadata/spdoinfo/
                          ptvctinf/vpfterm[(vpflevel != '') or ($any$ vpfinfo/* != '')]" />
                    </DIV>
                  </DIV>
                </xsl:if>-->

                <xsl:if test="/metadata[($any$ spdoinfo/ptvctinf/(esriterm/* | 
                    sdtsterm/* | vpfterm/(vpflevel | vpfinfo/*)) != '') and 
                    ($any$ spdoinfo/netinfo/(nettype | connrule/*) != '')]">
                  <BR/>
                </xsl:if>

                <xsl:apply-templates select="/metadata/spdoinfo/netinfo
                    [(nettype != '') or ($any$ connrule/* != '')]" />

                <xsl:if test="/metadata[($any$ spdoinfo/rastinfo/* != '') and 
                    ($any$ spdoinfo/(ptvctinf/(esriterm/* | sdtsterm/* | vpfterm/
                    (vpflevel | vpfinfo/*)) | netinfo/(nettype | connrule/*)) != '')]">
                  <BR/>
                </xsl:if>

                <xsl:apply-templates select="/metadata/spdoinfo/rastinfo[$any$ * != '']" />

              </xsl:when>

              <!-- If nothing to show in Spatial tab, show message -->
              <xsl:otherwise>
                <BR/>
                <DIV STYLE="text-align:center; color:#2E8B57">
                  Nessuna informazione dettagliata sui dati spaziali.
                </DIV>
                <BR/> 
              </xsl:otherwise>
            </xsl:choose>

            <BR/>
          </DIV>

          <!-- Attributes Tab -->
          <DIV ID="Attributes" class="pv" STYLE="display:none"><BR/>

            <xsl:choose>
              <xsl:when test="/metadata[($any$ eainfo/(overview/* | 
                  detailed/(enttyp/(enttypl | enttypt | enttypc | enttypd) | relinfo/* | 
                  attr/(attrlabl | attalias | attrtype | attwidth | atprecis | 
                  atoutwid | atnumdec | atscale | attrdef) | subtype/(stname | 
                  stcode | stfield/(stfldnm | stflddv | stflddd/*)))) != '')]">


                <!-- Show contents of Attributes tab -->
                <xsl:for-each select="metadata/eainfo/detailed[$any$ 
                    (enttyp/(enttypl | enttypt | enttypc | enttypd) | relinfo/* | 
                    attr/(attrlabl | attalias | attrtype | attwidth | atprecis | 
                    atoutwid | atnumdec | atscale | attrdef) | subtype/(stname | 
                    stcode | stfield/(stfldnm | stflddv | stflddd/*))) != '']">

                  <xsl:choose>
                    <xsl:when test="context()[enttyp/enttypl != '']">
                      <DIV CLASS="pn">Dettagli di <xsl:value-of select="enttyp/enttypl"/></DIV>
                    </xsl:when>
                    <xsl:otherwise>
                      <DIV CLASS="pn">Dettagli dell'oggetto</DIV>
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:apply-templates select="enttyp[(enttypt != '') or 
                      (enttypc != '') or (enttypd != '')]" />

                  <xsl:apply-templates select="relinfo[$any$ * != '']" />

                  <xsl:apply-templates select="attr[(attrlabl != '') or 
                      (attalias != '') or (attrtype != '') or (attwidth != '') or 
                      (atprecis != '') or (atoutwid != '') or (atnumdec != '') or 
                      (attscale != '') or (attrdef != '')]" />

                  <xsl:if test="context()[($any$ subtype/(stname | stcode | 
                      stfield/(stfldnm | stflddv | stflddd/*)) != '') and 
                      ($any$ (relinfo/* | attr/(attrlabl | attalias | attrtype | 
                      attwidth | atprecis | atoutwid | atnumdec | atscale | attrdef)) != '')]">
                    <BR/>
                  </xsl:if>

                  <xsl:apply-templates select="subtype[(stname != '') or (stcode != '') or 
                      ($any$ stfield/(stfldnm | stflddv) != '') or  
                      ($any$ stfield/stflddd/* != '')]" />

                  <xsl:if test="context()[not(end())]">
                    <DIV STYLE="text-align:center; color:#003E88">_________________</DIV><BR/>
                  </xsl:if>

                </xsl:for-each>

                <xsl:if test="/metadata[($any$ eainfo/overview/* != '') and ($any$ 
                    eainfo/detailed/(enttyp/(enttypl | enttypt | enttypc | enttypd) | 
                    relinfo/* | attr/(attrlabl | attalias | attrtype | attwidth | 
                    atprecis | atoutwid | atnumdec | atscale | attrdef) | 
                    subtype/(stname | stcode | stfield/(stfldnm | stflddv | 
                    stflddd/*))) != '')]">
                  <DIV STYLE="text-align:center; color:#003E88">_________________</DIV><BR/>
                </xsl:if>

                <!--Fede<xsl:apply-templates select="metadata/eainfo/overview[$any$ * != '']" />-->

              </xsl:when>

              <!-- If nothing to show in Attributes tab, show message -->
              <xsl:otherwise>
                <BR/>
                <DIV STYLE="text-align:center; color:#2E8B57">
                  Non sono disponibili informazioni dettagliate sugli attributi.
                </DIV>
                <BR/>
              </xsl:otherwise>
            </xsl:choose>

            <BR/>
          </DIV>

        </DIV>

      </xsl:otherwise> 
    </xsl:choose> 
      
    <!-- <CENTER><FONT COLOR="#6495ED">Metadata stylesheets are provided courtesy of ESRI.  Copyright (c) 2000-2002, Environmental Systems Research Institute, Inc.  All rights reserved.</FONT></CENTER> -->

    </BODY>

  </HTML>
</xsl:template>

================================

<!-- DESCRIPTION TAB -->

<!-- Thumbnail -->
<xsl:template match="/metadata/Binary/Thumbnail/img[(@src != '')]">
      <IMG ID="thumbnail" ALIGN="absmiddle" STYLE="height:144; 
          border:'2 outset #FFFFFF'; position:relative">
        <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
      </IMG>
      <BR/><BR/>
</xsl:template>
<xsl:template match="/metadata/idinfo/browse/img[@src != '']">
  <xsl:if test="context()[not (/metadata/Binary/Thumbnail/img)]">
      <xsl:if test="../@BrowseGraphicType[. = 'Thumbnail']">
        <IMG ID="thumbnail" ALIGN="absmiddle" STYLE="height:144; 
            border:'2 outset #FFFFFF'; position:relative">
          <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
        </IMG>
        <BR/><BR/>
      </xsl:if>
      <xsl:if test="context()[not (../../browse/@BrowseGraphicType)]">
        <IMG ID="thumbnail" ALIGN="absmiddle" STYLE="height:144; 
            border:'2 outset #FFFFFF'; position:relative">
          <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
        </IMG>
        <BR/><BR/>
      </xsl:if>
  </xsl:if>
</xsl:template>

--------

<!-- Keywords -->
<xsl:template match="/metadata/idinfo/keywords[$any$ */(themekey | placekey | stratkey | tempkey) != '']">
  <DIV CLASS="pn">Parole chiave</DIV>
  <xsl:for-each select="theme[$any$ themekey != '']">
    <DIV STYLE="margin-left:0.2in" CLASS="lt2"><SPAN CLASS="pn">Tema: </SPAN>
      <xsl:for-each select="themekey">
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: Common-use word or phrase used to describe the subject of the data set.']">
            <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[. = 'Common-use word or phrase used to describe the subject of the data set.  REQUIRED.']">
                <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose><xsl:if test="context()[not(end()) and . != '']">, </xsl:if>
      </xsl:for-each>
    </DIV>
  </xsl:for-each>
  <xsl:for-each select="place[$any$ placekey != '']">
    <DIV STYLE="margin-left:0.2in" CLASS="lt2"><SPAN CLASS="pn">Place: </SPAN>
      <xsl:for-each select="placekey">
        <xsl:value-of /><xsl:if test="context()[not(end()) and . != '']">, </xsl:if>
      </xsl:for-each>
    </DIV>
  </xsl:for-each>
  <xsl:for-each select="stratum[$any$ stratkey != '']">
    <DIV STYLE="margin-left:0.2in" CLASS="lt2"><SPAN CLASS="pn">Stratum: </SPAN>
      <xsl:for-each select="stratkey">
        <xsl:value-of /><xsl:if test="context()[not(end()) and . != '']">, </xsl:if>
      </xsl:for-each>
    </DIV>
  </xsl:for-each>
  <xsl:for-each select="temporal[$any$ tempkey != '']">
    <DIV STYLE="margin-left:0.2in" CLASS="lt2"><SPAN CLASS="pn">Temporal: </SPAN>
      <xsl:for-each select="tempkey">
        <xsl:value-of /><xsl:if test="context()[not(end()) and . != '']">, </xsl:if>
      </xsl:for-each>
    </DIV>
  </xsl:for-each>
</xsl:template>

--------

<!-- Description -->
<xsl:template match="/metadata/idinfo/descript[(abstract != '') or (purpose != '') or 
    (supplinf != '')]">
  <xsl:for-each select="abstract[. != '']">
    <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Riassunto
      <DIV CLASS="pe2" STYLE="display:">
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: A brief narrative summary of the data set.']">
            <SPAN CLASS="lt" STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[. = 'A brief narrative summary of the data set.  REQUIRED.']">
                <SPAN CLASS="lt" STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
              </xsl:when>
              <xsl:otherwise>
                <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN><BR/>
                <SCRIPT>fix(original)</SCRIPT>      
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </DIV>
    </DIV>
  </xsl:for-each>
  <xsl:for-each select="purpose[. != '']">
    <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Scopo
      <DIV ID="Purpose" CLASS="pe2" STYLE="display:">
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: A summary of the intentions with which the data set was developed.']">
            <SPAN CLASS="lt" STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[. = 'A summary of the intentions with which the data set was developed.  REQUIRED.']">
                <SPAN CLASS="lt" STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
              </xsl:when>
              <xsl:otherwise>
                <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN><BR/>
                <SCRIPT>fix(original)</SCRIPT>      
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </DIV>
    </DIV>
  </xsl:for-each>
  <xsl:for-each select="supplinf[. != '']">
    <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Info supplementari
      <DIV CLASS="pe2" STYLE="display:">
        <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN><BR/>
        <SCRIPT>fix(original)</SCRIPT>      
      </DIV>
    </DIV>
  </xsl:for-each>
  <!--Fede-->
  <xsl:for-each select="langdata[. != '']">
   <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Linguaggio del dataset
      <DIV CLASS="pe2" STYLE="display:">
        <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN><BR/>
        <SCRIPT>fix(original)</SCRIPT>      
      </DIV>
    </DIV>    
  </xsl:for-each>  
  <!-- fine Fede-->
</xsl:template>

--------

<!-- Enclosures -->
<xsl:template match="/metadata/Binary[(Enclosure/Data/@EsriPropertyType = 'Base64') or 
    (Enclosure/img/@src != '')]">
  <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Enclosed files containing additional information
    <DIV CLASS="pe2" STYLE="display:">
      <xsl:for-each select="Enclosure[Data/@EsriPropertyType = 'Base64']">
        <LI><xsl:value-of select="Data/@OriginalFileName"/>: <xsl:value-of select="./Descript"/></LI>
      </xsl:for-each>
      <xsl:for-each select="Enclosure[img/@src != '']">
        <LI><xsl:value-of select="img/@OriginalFileName"/> (Image): <xsl:value-of select="./Descript"/></LI>
      </xsl:for-each>
      <xsl:if test="context()[$any$ Enclosure[img/@src != '']]">
        <DIV CLASS="ph2" STYLE="margin-left=-0.25" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Show thumbnails of images
          <DIV CLASS="pe2" STYLE="display:none">
            <BR/>
            <xsl:for-each select="Enclosure[img/@src != '']">
              <IMG STYLE="height:144; border:'2 outset #FFFFFF'; position:relative">
                <xsl:attribute name="TITLE"><xsl:value-of select="img/@OriginalFileName"/></xsl:attribute>
                <xsl:attribute name="SRC"><xsl:value-of select="img/@src"/></xsl:attribute>
              </IMG>
              <BR/><BR/>
            </xsl:for-each>
          </DIV>
        </DIV>
      </xsl:if>
    </DIV>
  </DIV>
</xsl:template>

--------

<!-- Browse Graphics -->
<xsl:template match="/metadata/idinfo/browse[browsen != '']">
  <LI>
    <xsl:for-each select="browsed[. != '']"><xsl:value-of /></xsl:for-each><xsl:for-each select="browset[. != '']"> (<xsl:value-of/>)</xsl:for-each><xsl:if test="context()[(browset != '') or (browsed != '')]">: </xsl:if>
    <xsl:for-each select="browsen[. != '']">
      <A TARGET="viewer"><xsl:attribute name="HREF"><xsl:value-of/></xsl:attribute><xsl:value-of/></A>
    </xsl:for-each>
  </LI>
</xsl:template>

--------

<!-- Status -->
<xsl:template match="/metadata/idinfo/status[$any$ * != '']">
  <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Stato del dataset
    <DIV CLASS="pe2" STYLE="display:none">
      <xsl:for-each select="progress[. != '']">
        <I>Completezza dell'acquisizione: </I>
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: The state of the data set.']">
            <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[. = 'The state of the data set.  REQUIRED.']">
                <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of/><BR/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="update[. != '']">
        <I>Frequenza di aggiornamento: </I>
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: The frequency with which changes and additions are made to the data set after the initial data set is completed.']">
            <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[. = 'The frequency with which changes and additions are made to the data set after the initial data set is completed.  REQUIRED.']">
                <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of/><BR/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </DIV>
  </DIV>
</xsl:template>


--------

<!-- Informazioni sulla qualità -->
<xsl:template match="/metadata/dataqual[$any$ * != '']">
  <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Qualità del dataset
   <DIV CLASS="pe2" STYLE="display:none">
    <xsl:for-each select="attracc/attraccr[. != '']">     
        <I>Indice di accuratezza tematica: </I><xsl:value-of /><BR/>      
    </xsl:for-each> 
    <xsl:for-each select="logic[. != '']">
        <I>Consistenza logica: </I><xsl:value-of /><BR/>
    </xsl:for-each>
    <xsl:for-each select="complete[. != '']">
        <I>Completezza: </I><xsl:value-of /><BR/>
    </xsl:for-each>     
     <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Accuratezza posizionale
       <DIV CLASS="pe2" STYLE="display:none">
         <xsl:for-each select="posacc/horizpa/qhorizpa/horizpav[. != '']">
           <I>Misura di accuratezza planare: </I><xsl:value-of /><BR/>
         </xsl:for-each>
         <xsl:for-each select="posacc/vertacc/qvertpa/vertaccv[. != '']">
           <I>Misura di accuratezza verticale: </I><xsl:value-of /><BR/>
         </xsl:for-each>
       </DIV>    
     </DIV>
     <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Informazioni sulle fonti
       <DIV CLASS="pe2" STYLE="display:none">
         <xsl:for-each select="lineage/srcinfo">
           <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)"><xsl:value-of select="srccite/citeinfo/title" /> 
             <DIV CLASS="pe2" STYLE="display:none">
               <xsl:for-each select="srccite/citeinfo/origin[. != '']">
                 <I>Autore: </I><xsl:value-of /><BR/>
               </xsl:for-each>
               <xsl:for-each select="srccite/citeinfo/edition[. != '']">
                 <I>Edizione: </I><xsl:value-of /><BR/>
               </xsl:for-each>
               <xsl:for-each select="srcscale[. != '']">
                 <I>Denominatore di scala della fonte: </I><xsl:value-of /><BR/>
               </xsl:for-each>
               <xsl:for-each select="typesrc[. != '']">
                 <I>Supporto della fonte: </I><xsl:value-of /><BR/>
               </xsl:for-each>
             </DIV>    
           </DIV>
         </xsl:for-each>
       </DIV>    
     </DIV>    
     
     <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Step di realizzazione
       <DIV CLASS="pe2" STYLE="display:none">
         <xsl:for-each select="lineage/procstep">           
           <xsl:for-each select="procdesc[. != '']">
             <I>Descrizione del processo: </I><xsl:value-of /><BR/>
           </xsl:for-each>
           <xsl:for-each select="procdate[. != '']">
             <I>Data di fine processo: </I><xsl:value-of /><BR/>
           </xsl:for-each>          
         </xsl:for-each>
       </DIV>    
     </DIV>      
       
   </DIV>    
  </DIV>
</xsl:template>

--------


<!-- Time Period of the Data Fede
<xsl:template match="/metadata/idinfo/timeperd[$any$ .//* != '']">
  <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Time period for which the data is relevant
    <DIV CLASS="pe2" STYLE="display:none">
      <xsl:apply-templates select="timeinfo/sngdate[$any$ * != '']"/>
      <xsl:apply-templates select="timeinfo/mdattim/sngdate[$any$ * != '']"/>
      <xsl:apply-templates select="timeinfo/rngdates[$any$ * != '']"/>
      <xsl:for-each select="current[. != '']">
        <DIV>
          <I>Description: </I>
          <xsl:choose>
            <xsl:when test="context()[. = 'REQUIRED: The basis on which the time period of content information is determined.']">
              <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="context()[. = 'The basis on which the time period of content information is determined.  REQUIRED.']">
                  <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN>
                </xsl:when>
                <xsl:otherwise>
                  <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN><BR/>
                  <SCRIPT>fix(original)</SCRIPT>      
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </DIV>
      </xsl:for-each>
    </DIV>
  </DIV>
</xsl:template>Fede -->

--------


<!-- Publication Info -->
<xsl:template match="/metadata/idinfo/citation/citeinfo[(origin != '') or (pubdate != '') or 
    (pubtime != '') or ($any$ pubinfo/* != '') or ($any$ serinfo/* != '')]">
  <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Informazioni sulla pubblicazione
    <DIV CLASS="pe2" STYLE="display:none"><SPAN CLASS="lt2">
      <xsl:for-each select="origin[$any$ . != '']">
        <xsl:if test="context()[0]"><I>Fonte: </I></xsl:if>
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: The name of an organization or individual that developed the data set.']">
            <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[. = 'The name of an organization or individual that developed the data set.  REQUIRED.']">
                <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN>
              </xsl:when>
              <xsl:otherwise><xsl:if test="context()[. != '']"><xsl:value-of/></xsl:if></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="context()[not(end()) and . != '']">, </xsl:if>
        <xsl:if test="context()[end()]"><BR/></xsl:if>
      </xsl:for-each></SPAN>
      <!-- Fede <xsl:if test="context()[(pubdate != '') or (pubtime != '')]">
        <DIV><I>Date and time: </I>
          <xsl:choose>
            <xsl:when test="context()[pubdate = 'REQUIRED: The date when the data set is published or otherwise made available for release.']">
              <SPAN STYLE="color:#999999"><xsl:value-of select="pubdate"/></SPAN>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="context()[pubdate = 'The date when the data set is published or otherwise made available for release.  REQUIRED']">
                  <SPAN STYLE="color:#999999"><xsl:value-of select="pubdate"/></SPAN>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="pubdate"/></xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="context()[pubtime != '']"> at time <xsl:value-of select="pubtime"/></xsl:if>
        </DIV>
      </xsl:if>
      <xsl:for-each select="pubinfo[$any$ * != '']">
        <DIV><I>Publisher and place: </I>
          <xsl:value-of select="publish"/><xsl:if test="context()[publish != '' and pubplace != '']">, </xsl:if>
          <xsl:value-of select="pubplace"/>
        </DIV>
      </xsl:for-each>
      <xsl:for-each select="serinfo/sername[. != '']">
        <DIV><I>Series name: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="serinfo/issue[. != '']">
        <DIV><I>Series issue: </I><xsl:value-of/></DIV>
      </xsl:for-each> -->
      <!--Fede-->      
      <xsl:for-each select="edition[. != '']">
        <DIV><I>Edizione: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      
    </DIV>
  </DIV>
</xsl:template>

--------

<!-- Distribution Info -->
<xsl:template match="/metadata/distinfo/stdorder/digform[($any$ digtinfo/(formname | 
    dssize | transize | filedec) != '') or ($any$ digtopt/onlinopt/accinstr != '') or 
    ($any$ digtopt/onlinopt/computer/(networka/* | sdeconn/*) != '') or 
    ($any$ digtopt/onlinopt/computer/dialinst/(dialtel | dialfile) != '') or 
    ($any$ digtopt/offoptn/offmedia != '')]">
  <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Accesso al dato
    <DIV CLASS="pe2" STYLE="display:none">
      <xsl:for-each select="digtinfo/formname[. != '']">
        <I>Formato del dato: </I><xsl:value-of /><BR/>
      </xsl:for-each>
      <xsl:for-each select="digtinfo/dssize[. != '']">
        <I>Dimensione del dato: </I><xsl:value-of /> MB<BR/>
      </xsl:for-each>
      <!--Fede<xsl:for-each select="digtinfo/transize[. != '']">
        <I>Data transfer size: </I><xsl:value-of /> MB<BR/>
      </xsl:for-each>
      <xsl:for-each select="digtinfo/filedec[. != '']">
        <I>How to decompress the file: </I><xsl:value-of /><BR/>
      </xsl:for-each>-->
      <xsl:for-each select="digtopt/onlinopt"> 
        <xsl:for-each select="computer/networka/networkr[. != '']">
          <xsl:if test="context()[0]"><DIV CLASS="pn">Localizzazione sulla rete:</DIV></xsl:if>
          <DIV CLASS="pe2">
            <xsl:for-each select="context()[. != '']">
              <LI><xsl:value-of /></LI>
            </xsl:for-each>
          </DIV>
        </xsl:for-each>
        <xsl:for-each select="computer/sdeconn[$any$ * != '']">
          <DIV CLASS="pn">Connessione SDE:</DIV>
          <DIV CLASS="pe2">
            <LI>Server: <xsl:value-of select="server"/></LI>
            <LI>Istanza: <xsl:value-of select="instance"/></LI>
            <LI>Versione: <xsl:value-of select="version"/></LI>
            <LI>Username: <xsl:value-of select="user"/></LI>
          </DIV>
        </xsl:for-each>
       
         <!--Fede<xsl:for-each select="computer/dialinst[($any$ dialtel != '') or ($any$ dialfile != '')]">
          <xsl:if test="context()[0]"><DIV CLASS="pn">Dialup instructions:</DIV></xsl:if>
          <DIV CLASS="pe2">
            <xsl:for-each select="dialtel[. != '']">
              <LI><xsl:value-of /></LI>
            </xsl:for-each>
            <xsl:for-each select="dialfile[. != '']">
              <LI><xsl:value-of /></LI>
            </xsl:for-each>
          </DIV>
        </xsl:for-each>
        
        <xsl:for-each select="accinstr[. != '']">
          <DIV CLASS="pe2"><I>Access instructions: </I><xsl:value-of /></DIV>
        </xsl:for-each>-->
      </xsl:for-each>
      <xsl:for-each select="digtopt/offoptn/offmedia[. != '']">
        <xsl:if test="context()[0]"><I>Available media: </I></xsl:if>
        <xsl:if test="context()[. != '']"><xsl:value-of/></xsl:if>
        <xsl:if test="context()[not(end()) and . != '']">, </xsl:if>
        <xsl:if test="context()[end()]"><BR/></xsl:if>
      </xsl:for-each> 
      <xsl:if test="/metadata[($any$ distinfo/stdorder/digform/(digtinfo/(formname | 
          dssize | transize | filedec) | digtopt/(onlinopt/(computer/(networka/* | 
          sdeconn/* | dialinst/(dialtel | dialfile)) | accinstr | offoptn/offmedia))) != '')
          and ($any$ idinfo/(accconst | useconst) != '')]">
        <BR/>
      </xsl:if>   
    </DIV>
  </DIV>
 
</xsl:template>

--------

<!-- Data access constraints -->
<xsl:template match="/metadata/idinfo/accconst[. != '']">
  <I>Access constraints: </I>
  <xsl:choose>
    <xsl:when test="context()[. = 'REQUIRED: Restrictions and legal prerequisites for accessing the data set.']">
      <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="context()[. = 'Restrictions and legal prerequisites for accessing the data set.  REQUIRED.']">
          <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
        </xsl:when>
        <xsl:otherwise><SPAN CLASS="lt"><xsl:value-of /><BR/></SPAN></xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

--------

<!-- Data use constraints -->
<xsl:template match="/metadata/idinfo/useconst[. != '']">
  <DIV>
    <!--Fede<I>Restrizioni all'uso: </I>-->
    <xsl:choose>
      <xsl:when test="context()[. = 'REQUIRED: Restrictions and legal prerequisites for using the data set after access is granted.']">
        <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="context()[. = 'Restrictions and legal prerequisites for using the data set after access is granted.  REQUIRED.']">
            <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise>
            <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN><BR/>
            <SCRIPT>fix(original)</SCRIPT>      
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </DIV>
</xsl:template>

--------

<!-- Metadata Info -->
<xsl:template match="/metadata/metainfo[(metrd != '') or (metfrd != '') or (metstdn != '') or 
    (metstdv != '') or (mettc != '') or ($any$ metextns/* != '') or (metc/cntinfo/cntvoice != '') or 
    (metc/cntinfo/cntfax != '') or (metc/cntinfo/cntemail != '') or (metc/cntinfo/hours != '') or 
    (metc/cntinfo/cntinst != '') or (metc/cntinfo/cntaddr/* != '') or 
    (metc/cntinfo/*/cntper != '') or (metc/cntinfo/*/cntorg != '')]">
  <xsl:for-each select="metrd[. != '']">
    <DIV>Contents last reviewed: <xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:for-each select="metfrd[. != '']">
    <DIV>Contents to be reviewed: <xsl:value-of /></DIV>
  </xsl:for-each>
  <!--Fede
  <xsl:if test="context()[($any$ metc/cntinfo/(cntvoice | cntfax | cntemail | hours | cntinst | 
      */cntper | */cntorg | cntaddr/(address | city | state | postal | country)) != '')]">
    <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Chi ha compilato il metadata
      <DIV CLASS="pe2" STYLE="display:none">
        <xsl:apply-templates select="metc/cntinfo"/>
      </DIV>
    </DIV>
  </xsl:if> --> 
  <xsl:if test="context()[(metstdn != '') or (metstdv != '') or (mettc != '') or 
      ($any$ metextns/* != '')]">
    <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Standards utilizzati per la creazione di questo documento
      <DIV CLASS="pe2" STYLE="display:none">
        <xsl:for-each select="metstdn[. != '']">
          <I>Standard name: </I><xsl:value-of /><BR/>
        </xsl:for-each>
        <xsl:for-each select="metstdv[. != '']">
          <I>Standard version: </I><xsl:value-of /><BR/>
        </xsl:for-each>
        <xsl:for-each select="mettc[. != '']">
          <I>Time convention used in this document: </I><xsl:value-of /><BR/>
        </xsl:for-each>
        <xsl:for-each select="metextns[(metprof != '') or (onlink != '')]">
          <xsl:if test="context()[0]">Metadata profiles defining additonal information</xsl:if>
          <LI STYLE="margin-left:0.2in">
            <xsl:for-each select="metprof[. != '']"><xsl:value-of/></xsl:for-each><xsl:if test="context()[(metprof != '') and (onlink != '')]">: </xsl:if>
            <xsl:for-each select="onlink[. != '']">
              <A TARGET="viewer"><xsl:attribute name="HREF"><xsl:value-of/>
                </xsl:attribute><xsl:value-of/>
              </A>
              <xsl:if test="context()[not(end())]">, </xsl:if>
            </xsl:for-each>
          </LI>
        </xsl:for-each>
      </DIV>
    </DIV>
  </xsl:if>
</xsl:template>


================================


<!-- SPATIAL TAB -->

<!-- Horizontal Coordinate Systems -->
<xsl:template match="/metadata/spref/horizsys[$any$ (geograph/* | 
    planar//* | local/* | cordsysn/* | geodetic/*) != '']">
  <DIV CLASS="pn">Sistema di coordinate planare</DIV>
  <xsl:if test="context()[$any$ cordsysn/* != '']">
    <xsl:for-each select="cordsysn/projcsn[. != '']">
      <DIV STYLE="margin-left:0.2in"><I>Sistema di coordinate proiettate: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="cordsysn/geogcsn[. != '']">
      <DIV STYLE="margin-left:0.2in"><I>Sistema di coordinate geografiche: </I><xsl:value-of/></DIV>
    </xsl:for-each>
  </xsl:if>
  <xsl:if test="context()[$any$ (geograph/* | planar//* | local/* | geodetic/*) != '']">
    <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Dettagli
      <DIV CLASS="pe2" STYLE="display:none">

        <xsl:apply-templates select="geograph[$any$ * != '']"/>
        <xsl:apply-templates select="planar[$any$ .//* != '']"/>
        <xsl:apply-templates select="local[$any$ * != '']"/>

        <xsl:if test="context()[($any$ (geograph/* | planar//* | local/*) != '') and 
            ($any$ geodetic/* != '')]">
          <BR/>
        </xsl:if>

        <xsl:apply-templates select="geodetic[$any$ * != '']"/>

      </DIV>
    </DIV>
  </xsl:if>
</xsl:template>

--------

<!-- Vertical Coordinate Systems -->
<xsl:template match="/metadata/spref/vertdef[$any$ .//* != '']">
  <DIV CLASS="pn">Sistema di coordinate verticale</DIV>
  <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Details
    <DIV CLASS="pe2" STYLE="display:none">
      <xsl:apply-templates select="context()"/>
    </DIV>
  </DIV>
</xsl:template>

--------

<!--Fede sistema di rif indiretto-->
<xsl:template match="/metadata/spdoinfo[$any$ * != '']">
  <xsl:for-each select="indspref[. != '']">
    <BR/>
    <DIV CLASS="pn">Sistema di riferimento indiretto</DIV>
    <DIV STYLE="margin-left:0.2in"><xsl:value-of/></DIV>       
  </xsl:for-each>
</xsl:template>

--------

<!-- Bounding Coordinates -->
<xsl:template match="/metadata/idinfo/spdom[$any$ (bounding/* | lboundng/* | 
    minalti | maxalti) != '']">
  <DIV CLASS="pn">Estensione territoriale</DIV>
  <xsl:if test="context()[$any$ (bounding/* | lboundng/*) != '']">
    <DIV STYLE="margin-left:0.2in" CLASS="pn">Orizzontale</DIV>
    <xsl:for-each select="bounding[$any$ * != '']">
      <DIV STYLE="margin-left:0.4in" CLASS="pn">In gradi decimali</DIV>
      <DIV STYLE="margin-left:0.6in"><I>Ovest: </I>
        <xsl:choose>
          <xsl:when test="context()[westbc = 'REQUIRED: Western-most coordinate of the limit of coverage expressed in longitude.']">
            <SPAN STYLE="color:#999999"><xsl:value-of select="westbc"/></SPAN>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[westbc = 'Western-most coordinate of the limit of coverage expressed in longitude.  REQUIRED.']">
                <SPAN STYLE="color:#999999"><xsl:value-of select="westbc"/></SPAN>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="westbc"/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </DIV>
      <DIV STYLE="margin-left:0.6in"><I>Est: </I>
        <xsl:choose>
          <xsl:when test="context()[eastbc = 'REQUIRED: Eastern-most coordinate of the limit of coverage expressed in longitude.']">
            <SPAN STYLE="color:#999999"><xsl:value-of select="eastbc"/></SPAN>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[eastbc = 'Eastern-most coordinate of the limit of coverage expressed in longitude.  REQUIRED.']">
                <SPAN STYLE="color:#999999"><xsl:value-of select="eastbc"/></SPAN>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="eastbc"/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </DIV>
      <DIV STYLE="margin-left:0.6in"><I>Nord: </I>
        <xsl:choose>
          <xsl:when test="context()[northbc = 'REQUIRED: Northern-most coordinate of the limit of coverage expressed in latitude.']">
            <SPAN STYLE="color:#999999"><xsl:value-of select="northbc"/></SPAN>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[northbc = 'Northern-most coordinate of the limit of coverage expressed in latitude.  REQUIRED.']">
                <SPAN STYLE="color:#999999"><xsl:value-of select="northbc"/></SPAN>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="northbc"/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </DIV>
      <DIV STYLE="margin-left:0.6in"><I>Sud: </I>
        <xsl:choose>
          <xsl:when test="context()[southbc = 'REQUIRED: Southern-most coordinate of the limit of coverage expressed in latitude.']">
            <SPAN STYLE="color:#999999"><xsl:value-of select="southbc"/></SPAN>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="context()[southbc = 'Southern-most coordinate of the limit of coverage expressed in latitude.  REQUIRED.']">
                <SPAN STYLE="color:#999999"><xsl:value-of select="southbc"/></SPAN>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="southbc"/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </DIV>
    </xsl:for-each>
    <xsl:for-each select="lboundng[$any$ * != '']">
      <DIV STYLE="margin-left:0.4in" CLASS="pn">In coordinate proiettate o locali</DIV>
      <DIV STYLE="margin-left:0.6in"><I>Sinistra: </I><xsl:value-of select="leftbc"/></DIV>
      <DIV STYLE="margin-left:0.6in"><I>Destra: </I><xsl:value-of select="rightbc"/></DIV>
      <DIV STYLE="margin-left:0.6in"><I>Alto: </I><xsl:value-of select="topbc"/></DIV>
      <DIV STYLE="margin-left:0.6in"><I>Basso: </I><xsl:value-of select="bottombc"/></DIV>
    </xsl:for-each>
  </xsl:if>

  <xsl:if test="context()[($any$ (bounding/* | lboundng/*) != '') and 
      ($any$ (minalti | maxalti) !='')]">
    <BR/>
  </xsl:if>

  <xsl:if test="context()[$any$ (minalti | maxalti) != '']">
    <DIV STYLE="margin-left:0.2in" CLASS="pn">Verticale</DIV>
    <xsl:for-each select="minalti[. != '']">
      <DIV STYLE="margin-left:0.4in"><I>Altitudine minima: </I>
        <xsl:if test="context()[. != '1.#QNAN0']"><xsl:value-of /></xsl:if>
        <xsl:if test="context()[. = '1.#QNAN0']">Unknown</xsl:if>
      </DIV>
    </xsl:for-each>
    <xsl:for-each select="maxalti[. != '']">
      <DIV STYLE="margin-left:0.4in"><I>Altitudine massima: </I>
        <xsl:if test="context()[. != '1.#QNAN0']"><xsl:value-of /></xsl:if>
        <xsl:if test="context()[. = '1.#QNAN0']">Unknown</xsl:if>
      </DIV>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

--------

<!-- Data Quality Position Accuracy-->
<xsl:template match="/metadata/dataqual/posacc[$any$ (horizpa/(horizpar | 
    qhorizpa/horizpav) | vertacc/(vertaccr | qvertpa/vertaccv)) != '']">
  <DIV CLASS="pn">Spatial data quality</DIV>
  <xsl:for-each select="horizpa[(horizpar != '') or (qhorizpa/horizpav != '')]">
    <DIV CLASS="ph2" STYLE="margin-left:0.2in" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Horizontal positional accuracy
      <DIV CLASS="pe2" STYLE="margin-left:0.2in; display:none">
        <xsl:for-each select="horizpar[. != '']">
          <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN>
          <SCRIPT>fix(original)</SCRIPT>      
        </xsl:for-each>
        <xsl:for-each select="qhorizpa[$any$ horizpav != '']">
          <xsl:for-each select="horizpav[. != '']">
            <DIV STYLE="margin-left:0.2in"><I>Estimated accuracy: </I><xsl:value-of /></DIV>
          </xsl:for-each>
          <xsl:for-each select="horizpae[. != '']">
            <DIV STYLE="margin-left:0.2in">
              <I>How this value was determined: </I>
              <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN>
              <SCRIPT>fix(original)</SCRIPT>
            </DIV>      
          </xsl:for-each>
        </xsl:for-each>
      </DIV>
    </DIV>
  </xsl:for-each>

  <xsl:if test="context()[($any$ horizpa/(horizpar | qhorizpa/horizpav) != '')
      and ($any$ vertacc/(vertaccr | qvertpa/vertaccv) != '')]">
    <BR/>
  </xsl:if>

  <xsl:for-each select="vertacc[(vertaccr != '') or (qvertpa/vertaccv != '')]">
    <DIV CLASS="ph2" STYLE="margin-left:0.2in" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Vertical positional accuracy
      <DIV CLASS="pe2" STYLE="margin-left:0.2in; display:none">
        <xsl:for-each select="vertaccr[. != '']">
          <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN>
          <SCRIPT>fix(original)</SCRIPT>      
        </xsl:for-each>
        <xsl:for-each select="qvertpa[$any$ vertaccv != '']">
          <xsl:for-each select="vertaccv[. != '']">
            <DIV STYLE="margin-left:0.2in"><I>Estimated accuracy: </I><xsl:value-of /></DIV>
          </xsl:for-each>
          <xsl:for-each select="vertacce[. != '']">
            <DIV STYLE="margin-left:0.2in">
              <I>How this value was determined: </I>
              <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN>
              <SCRIPT>fix(original)</SCRIPT>
            </DIV>      
          </xsl:for-each>
        </xsl:for-each>
      </DIV>
    </DIV>
  </xsl:for-each>
</xsl:template>

--------

<!-- ESRI feature description -->
<xsl:template match="/metadata/spdoinfo/ptvctinf/esriterm[$any$ * != '']">
  <xsl:if test="context()[0]"> 
    <DIV STYLE="margin-left:0.4in" CLASS="pn">Descrizione ESRI</DIV>
  </xsl:if>
  <DIV CLASS="ph2" STYLE="margin-left:0.6in" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">
    <xsl:choose>
      <xsl:when test="context()[@Name != '']">
        <xsl:value-of select="@Name"/>
      </xsl:when>
      <xsl:otherwise>
        Feature class
      </xsl:otherwise>
    </xsl:choose>
    <DIV CLASS="pe2" STYLE="display:none">
      <xsl:for-each select="efeatyp[. != '']">
        <I>Tipo di oggetti: </I><xsl:value-of /><BR/>
      </xsl:for-each>
      <xsl:for-each select="efeageom[. != '']">
        <I>Tipo di geometria: </I><xsl:value-of /><BR/>
      </xsl:for-each>
      <xsl:for-each select="featdesc[. != '']">
        <I>Descrizione degli oggetti: </I><xsl:value-of /><BR/>
      </xsl:for-each>
      <xsl:for-each select="esritopo[. != '']">
        <I>Presenza di topologia: </I><xsl:value-of /><BR/>
      </xsl:for-each>
      <xsl:for-each select="efeacnt[. != '']">
        <I>Numero di oggetti: </I><xsl:value-of /><BR/>
      </xsl:for-each>
      <xsl:for-each select="spindex[. != '']">
        <I>Presenza di indici spaziali: </I><xsl:value-of /><BR/>
      </xsl:for-each>
      <xsl:for-each select="linrefer[. != '']">
        <I>Presenza di referenziazione lineare: </I><xsl:value-of /><BR/>
      </xsl:for-each>
      <!--Fede<xsl:for-each select="netwrole[. != '']">
        <I>Network role: </I><xsl:value-of /><BR/>
      </xsl:for-each>-->      
      <BR/>
    </DIV>
  </DIV>
</xsl:template>

--------

<!-- SDTS feature description -->
<xsl:template match="/metadata/spdoinfo/ptvctinf/sdtsterm[$any$ * != '']">
  <xsl:if test="context()[0]">
    <DIV>Feature class: SDTS feature type, feature count</DIV>
  </xsl:if>
  <DIV STYLE="margin-left:0.2in">
    <LI>
      <xsl:choose>
        <xsl:when test="context()[@Name != '']">
          <xsl:value-of select="@Name"/>: 
        </xsl:when>
        <xsl:otherwise>
          Feature class: 
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="sdtstype"/><xsl:if test="context()[sdtstype != '' and ptvctcnt != '']">, </xsl:if>
      <xsl:value-of select="ptvctcnt"/>
    </LI>
  </DIV>
</xsl:template>

--------

<!-- VPF feature description -->
<xsl:template match="/metadata/spdoinfo/ptvctinf/vpfterm[(vpflevel != '') or ($any$ vpfinfo/* != '')]">
  <xsl:for-each select="vpflevel[. != '']">
    <DIV><I>Level of topology: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:for-each select="vpfinfo[$any$ * != '']">
    <xsl:if test="context()[0]">
      <DIV>Feature class: VPF feature type, feature count</DIV>
    </xsl:if>
    <DIV STYLE="margin-left:0.2in">
      <LI>
        <xsl:choose>
          <xsl:when test="context()[@Name != '']">
            <xsl:value-of select="@Name"/>: 
          </xsl:when>
          <xsl:otherwise>
            Feature class: 
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="vpftype"/><xsl:if test="context()[vpftype != '' and ptvctcnt != '']">, </xsl:if>
        <xsl:value-of select="ptvctcnt"/>
      </LI>
    </DIV>
  </xsl:for-each>
</xsl:template>

--------

<!-- Geometric Network Information -->
<xsl:template match="/metadata/spdoinfo/netinfo[(nettype != '') or ($any$ connrule/* != '')]">
  <DIV CLASS="pn" STYLE="margin-left:0.2in">Descrizione dati network</DIV>
  <xsl:for-each select="nettype[. != '']">
    <DIV STYLE="margin-left:0.4in"><I>Tipo di network: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:if test="context()[$any$ connrule/* != '']">
    <DIV CLASS="ph2" STYLE="margin-left:0.4in" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Connectivity rule information
      <DIV STYLE="display:none">
        <DIV CLASS="pe2">In the connectivity rules below, feature classes are listed followed by their subtype.</DIV>
        <xsl:for-each select="connrule[$any$ * != '']">
          <DIV CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Regole di connettività (solo per GeoDB)
            <DIV CLASS="pe2" STYLE="display:none">
              <xsl:for-each select="ruletype[. != '']">
                <I>Tipo di regola: </I><xsl:value-of /><BR/>
              </xsl:for-each>
              <xsl:for-each select="rulehelp[. != '']">
                <I>Descrizione della regola: </I><xsl:value-of /><BR/>
              </xsl:for-each>
              <xsl:for-each select="rulecat[. != '']">
                <I>Categoria di regola: </I><xsl:value-of /><BR/>
              </xsl:for-each>
              <xsl:if test="context()[(rulefeid != '') or (rulefest != '')]">
                <I>From edge:</I> 
                <xsl:value-of select="rulefeid"/><xsl:if test="context()[rulefeid != '' and rulefest != '']">, </xsl:if>
                <xsl:value-of select="rulefest"/><BR/>
              </xsl:if>
              <xsl:if test="context()[(ruleteid != '') or (ruletest != '')]">
                <I>To edge:</I> 
                <xsl:value-of select="ruleteid"/><xsl:if test="context()[ruleteid != '' and ruletest != '']">, </xsl:if>
                <xsl:value-of select="ruletest"/><BR/>
              </xsl:if>
              <xsl:if test="context()[(ruleeid != '') or (ruleest != '') or 
                  (ruleemnc != '') or (ruleemxc != '')]">
                <SPAN CLASS="pn">Edge:</SPAN> 
                <xsl:value-of select="ruleeid"/><xsl:if test="context()[ruleeid != '' and ruleest != '']">, </xsl:if>
                <xsl:value-of select="ruleest"/><BR/>
                <DIV STYLE="margin-left:0.2in">
                  <xsl:for-each select="ruleemnc[. != '']">
                    <I>Minima cardinalità: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                  <xsl:for-each select="ruleemxc[. != '']">
                    <I>Massima cardinalita: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                </DIV>
              </xsl:if>
              <xsl:if test="context()[(rulejid != '') or (rulejst != '') or 
                  (rulejmnc != '') or (rulejmxc != '')]">
                <SPAN CLASS="pn">Junction:</SPAN> 
                <xsl:value-of select="rulejid"/><xsl:if test="context()[rulejid != '' and rulejst != '']">, </xsl:if>
                <xsl:value-of select="rulejst"/><BR/>
                <DIV STYLE="margin-left:0.2in">
                  <xsl:for-each select="rulejmnc[. != '']">
                    <I>Minima cardinalità: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                  <xsl:for-each select="rulejmxc[. != '']">
                    <I>Massima cardinalita: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                </DIV>
              </xsl:if>
              <xsl:if test="context()[(ruledjid != '') or (ruledjst != '')]">
                <DIV>
                  <I>Default junction:</I>
                  <xsl:value-of select="ruledjid"/><xsl:if test="context()[ruledjid != '' and ruledjst != '']">, </xsl:if>
                  <xsl:value-of select="ruledjst"/>
                </DIV>
              </xsl:if>
              <xsl:for-each select="rulejunc[(junctid != '') or (junctst != '')]">
                <xsl:if test="context()[0]">
                  <DIV><SPAN CLASS="pn">Junctions disponibili</SPAN></DIV>
                </xsl:if>
                <DIV STYLE="margin-left:0.2in">
                  <LI>
                    <xsl:value-of select="junctid"/><xsl:if test="context()[junctid != '' and junctst != '']">, </xsl:if>
                    <xsl:value-of select="junctst"/>
                  </LI>
                </DIV>
              </xsl:for-each>
            </DIV>
          </DIV>
          <xsl:if test="context()[end()]"><BR/></xsl:if>
        </xsl:for-each>
      </DIV>
    </DIV>
  </xsl:if>
</xsl:template>

--------

<!-- Raster Dataset Information -->
<xsl:template match="/metadata/spdoinfo/rastinfo[$any$ * != '']">
  <DIV CLASS="pn" STYLE="margin-left:0.2in">Descrizione dati raster</DIV>
  <xsl:for-each select="rastifor[. != '']">
    <DIV STYLE="margin-left:0.4in"><I>Formato: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:for-each select="rasttype[. != '']">
    <DIV STYLE="margin-left:0.4in"><I>Tipo: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:for-each select="rastband[. != '']">
    <DIV STYLE="margin-left:0.4in"><I>Bande: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:if test="context()[(rastorig != '') or (rastplyr != '') or (rastcmap != '') or 
      (rastcomp != '') or (rastdtyp != '')]">
    <DIV CLASS="ph2" STYLE="margin-left:0.4in" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Proprietà del raster
      <DIV CLASS="pe2" STYLE="display:none">
        <xsl:for-each select="rastorig[. != '']">
          <DIV><I>Origine: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="rastplyr[. != '']">
          <DIV><I>Presenza piramide: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="rastcmap[. != '']">
          <DIV><I>Mappa colori: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="rastcomp[. != '']">
          <DIV><I>Tipo di compressione: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <!--Fede<xsl:for-each select="rastdtyp[. != '']">
          <DIV><I>Display type: </I><xsl:value-of /></DIV>
        </xsl:for-each>-->
      </DIV>
    </DIV>
  </xsl:if>
  <xsl:if test="context()[(rastxsz != '') or (rastysz != '') or (rastbpp != '') or 
      (vrtcount != '') or (rowcount != '') or (colcount != '')]">
    <DIV CLASS="ph2" STYLE="margin-left:0.4in" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Informazioni sulle celle
      <DIV CLASS="pe2" STYLE="display:none">
        <xsl:for-each select="colcount[. != '']">
          <DIV><I>Numero di celle sull'asse X: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="rowcount[. != '']">
          <DIV><I>Numero di celle sull'asse Y: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="vrtcount[. != '']">
          <DIV><I>Numero di celle sull'asse Z: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="rastbpp[. != '']">
          <DIV><I>Numero di bit per cella: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:if test="context()[(rastxsz != '') or (rastysz != '')]">
          <DIV CLASS="pn">Dimensione della cella</DIV>
          <xsl:for-each select="rastxsz[. != '']">
            <DIV STYLE="margin-left:0.2in"><I>Dimensione X: </I><xsl:value-of /></DIV>
          </xsl:for-each>
          <xsl:for-each select="rastysz[. != '']">
            <DIV STYLE="margin-left:0.2in"><I>Dimensione Y: </I><xsl:value-of /></DIV>
          </xsl:for-each>
        </xsl:if>
      </DIV>
    </DIV>
  </xsl:if>
  <xsl:if test="context()[not(end())]"><BR/></xsl:if>
</xsl:template>


================================


<!-- ATTRIBUTES TAB -->

<!-- Entity type -->
<xsl:template match="/metadata/eainfo/detailed/enttyp[(enttypt != '') or (enttypc != '') or 
    (enttypd != '')]">
  <xsl:for-each select="enttypt[. != '']">
    <DIV STYLE="margin-left:0.2in"><I>Tipo di oggetto: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:for-each select="enttypc[. != '']">
    <DIV STYLE="margin-left:0.2in"><I>Numero di records: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:if test="context()[enttypd != '']">
    <DIV STYLE="margin-left:0.2in" CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Definizione estesa
      <DIV CLASS="pe2" STYLE="display:none">
        <SPAN CLASS="lt"><xsl:value-of select="enttypd"/></SPAN><BR/>
        <xsl:for-each select="enttypds[. != '']">
          <SPAN CLASS="lt"><I>Sorgente: </I><xsl:value-of /></SPAN><BR/>
        </xsl:for-each><BR/>
      </DIV>
    </DIV>
  </xsl:if>
</xsl:template>

--------

<!-- Relationship Information -->
<xsl:template match="/metadata/eainfo/detailed/relinfo[$any$ * != '']">
  <DIV STYLE="margin-left:0.2in" CLASS="pn">Informazioni sulle relazioni (GeoDB)</DIV>
  <xsl:for-each select="relcomp[. != '']">
    <DIV STYLE="margin-left:0.4in"><I>Tipo di relazione: </I>
      <xsl:choose>
        <xsl:when test="context()[. = 'TRUE']">Complessa</xsl:when>
        <xsl:otherwise>Semplice</xsl:otherwise>
      </xsl:choose>
    </DIV>
  </xsl:for-each>
  <xsl:for-each select="relcard[. != '']">
    <DIV STYLE="margin-left:0.4in"><I>Cardinalità: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:for-each select="relattr[. != '']">
    <DIV STYLE="margin-left:0.4in"><I>Attributi: </I><xsl:value-of /></DIV>
  </xsl:for-each>
  <xsl:if test="context()[(otfcname != '') or (otfcpkey != '') or (otfcfkey != '')]">
    <DIV STYLE="margin-left:0.4in" CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Informazioni sull'origine
      <DIV CLASS="pe2" STYLE="display:none">
        <xsl:for-each select="otfcname[. != '']">
          <DIV><I>Nome dell'origine: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="otfcpkey[. != '']">
          <DIV><I>Primary key: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="otfcfkey[. != '']">
          <DIV><I>Foreign key: </I><xsl:value-of /></DIV>
        </xsl:for-each>
      </DIV>
    </DIV>
  </xsl:if>
  <xsl:if test="context()[(dtfcname != '') or (dtfcpkey != '') or (dtfcfkey != '')]">
    <DIV STYLE="margin-left:0.4in" CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Informazioni sulla destinazione
      <DIV CLASS="pe2" STYLE="display:none">
        <xsl:for-each select="dtfcname[. != '']">
          <DIV><I>Nome della destinazione: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="dtfcpkey[. != '']">
          <DIV><I>Primary key: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="dtfcfkey[. != '']">
          <DIV><I>Foreign key: </I><xsl:value-of /></DIV>
        </xsl:for-each>
      </DIV>
    </DIV>
  </xsl:if>
  <xsl:if test="context()[(relnodir != '') or (relflab != '') or (relblab != '')]">
    <DIV STYLE="margin-left:0.4in" CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Informazioni sulla notifica
      <DIV CLASS="pe2" STYLE="display:none">
        <xsl:for-each select="relnodir[. != '']">
          <DIV><I>Direzione di notifica: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="relflab[. != '']">
          <DIV><I>Descrizione relazione diretta: </I><xsl:value-of /></DIV>
        </xsl:for-each>
        <xsl:for-each select="relblab[. != '']">
          <DIV><I>Descrizione relazione inversa: </I><xsl:value-of /></DIV>
        </xsl:for-each>
      </DIV>
    </DIV>
  </xsl:if>
</xsl:template>

--------

<!-- Attribute Information -->
<xsl:template match="/metadata/eainfo/detailed/attr[(attrlabl != '') or (attalias != '') or 
    (attrtype != '') or (attwidth != '') or (atprecis != '') or (atoutwid != '') or 
    (atnumdec != '') or (attscale != '') or (attrdef != '')]">
  <DIV STYLE="margin-left:0.2in" CLASS="pn">
    <xsl:if test="context()[0]">Attributi</xsl:if>
    <xsl:choose> 
      <xsl:when test="context()[(attalias != '') or (attrtype != '') or (attwidth != '') or 
          (atprecis != '') or (atoutwid != '') or (atnumdec != '') or (attscale != '') or 
          (attrdef != '')]">
        <DIV STYLE="margin-left:0.25in" CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">
          <xsl:choose>
            <xsl:when test="context()[attrlabl != '']">
              <xsl:value-of select="attrlabl"/>
            </xsl:when>
            <xsl:otherwise>Attributo</xsl:otherwise>
          </xsl:choose>
          <DIV CLASS="pe2" STYLE="display:none">
            <xsl:for-each select="attalias[. != '']">
              <I>Alias: </I><xsl:value-of /><BR/>
            </xsl:for-each>
            <xsl:for-each select="attrtype[. != '']">
              <I>Tipo di dato: </I><xsl:value-of /><BR/>
            </xsl:for-each>
            <xsl:for-each select="attwidth[. != '']">
              <I>Lunghezza: </I><xsl:value-of /><BR/>
            </xsl:for-each>
            <!--Fede<xsl:for-each select="atoutwid[. != '']">
              <I>Output width: </I><xsl:value-of /><BR/>
            </xsl:for-each>-->
            <xsl:for-each select="atnumdec[. != '']">
              <I>Numero di decimali: </I><xsl:value-of /><BR/>
            </xsl:for-each>
            <xsl:for-each select="atprecis[. != '']">
              <I>Precisione: </I><xsl:value-of /><BR/>
            </xsl:for-each>
            <!--Fede<xsl:for-each select="attscale[. != '']">
              <I>Scale: </I><xsl:value-of /><BR/>
            </xsl:for-each>-->
            <xsl:for-each select="attrdef[. != '']">
              <!--<SPAN CLASS="lt"><I>Definition: </I><xsl:value-of /></SPAN><BR/>-->
              <SPAN CLASS="lt"><I>Descrizione: </I><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN>
              <SCRIPT>fix(original)</SCRIPT>      
            </xsl:for-each>
            <xsl:for-each select="attrdefs[. != '']">
              <!--<SPAN CLASS="lt"><I>Definition Source: </I><xsl:value-of /></SPAN><BR/>-->
              <SPAN CLASS="lt"><I>Fonte: </I><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN>
              <SCRIPT>fix(original)</SCRIPT>      
            </xsl:for-each>
            
            <!--Fede Domini-->
            <xsl:if test="context()[$any$ (attrdomv/edom/* | attrdomv/rdom/* | attrdomv/codesetd/* | attrdomv/udom) != '']">
             <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Dominio dell'attributo 
               <xsl:if test="attrdomv[$any$ edom/* != '']">
                <DIV CLASS="ph2"  onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)" STYLE="display:none">Dominio di valori
                 <DIV CLASS="pe2" STYLE="display:none">
                   <xsl:for-each select="attrdomv/edom[$any$ ./* != '']">
                     <I>Descrizione: </I><xsl:value-of select="edomvd[. != '']"/> 
                     <I> - Valore: </I><xsl:value-of select="edomv[. != '']"/><BR/>
                   </xsl:for-each>
                 </DIV> 
                </DIV>
               </xsl:if>
               <xsl:if test="attrdomv[$any$ rdom/* != '']">
                <DIV CLASS="ph2"  onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)" STYLE="display:none">Range di valori
                 <DIV CLASS="pe2" STYLE="display:none">
                   <xsl:for-each select="attrdomv/rdom[$any$ ./* != '']">
                     <I>Minimo: </I><xsl:value-of select="rdommin[. != '']"/><BR/>
                     <I>Massimo: </I><xsl:value-of  select="rdommax[. != '']"/><BR/>                     
                   </xsl:for-each>
                 </DIV> 
                </DIV>
               </xsl:if>
               <xsl:if test="attrdomv[$any$ codesetd/* != '']">
                <DIV CLASS="ph2"  onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)" STYLE="display:none">Dominio di codici
                 <DIV CLASS="pe2" STYLE="display:none">
                   <xsl:for-each select="attrdomv/codesetd[$any$ ./* != '']">
                     <I>Nome: </I><xsl:value-of select="codesetn[. != '']"/><BR/> 
                     <I>Fonte: </I><xsl:value-of select="codesets[. != '']"/><BR/>
                   </xsl:for-each>
                 </DIV> 
                </DIV>
               </xsl:if>
               <xsl:if test="attrdomv/udom[. != '']">
                <DIV CLASS="ph2"  onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)" STYLE="display:none">Dominio non rappresentabile
                 <DIV CLASS="pe2" STYLE="display:none">
                   <xsl:for-each select="attrdomv/udom[. != '']">
                     <I>Descrizione: </I><xsl:value-of /><BR/>                      
                   </xsl:for-each>
                 </DIV> 
                </DIV>
               </xsl:if>
             </DIV>
            </xsl:if>
            <!--fine Fede Domini-->    
            
            <!--Fede accuratezza attributi-->
            <xsl:if test="context()[$any$ attrvai/* != '']">
             <DIV CLASS="ph1" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">Accuratezza dei valori dell'attributo
              <DIV CLASS="pe2" STYLE="display:none">
                 <xsl:for-each select="attrvai/attrva[. != '']">
                   <I>Valore di accuratezza: </I><xsl:value-of />
                 </xsl:for-each>
               </DIV>        
             </DIV>
            </xsl:if>
            <!--fine Fede accuratezza attributo-->        
           
            <BR/>
          </DIV>
        </DIV>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="context()[attrlabl != '']">
          <DIV STYLE="margin-left:0.25in" CLASS="pe2"><xsl:value-of select="attrlabl"/></DIV>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </DIV>
</xsl:template>

--------

<!-- Subtype Information -->
<xsl:template match="/metadata/eainfo/detailed/subtype[(stname != '') or (stcode != '') or 
    ($any$ stfield/(stfldnm | stflddv) != '') or ($any$ stfield/stflddd/* != '')]">
  <DIV STYLE="margin-left:0.2in" CLASS="pn">Informazioni sul subtype (solo per GeoDB)</DIV>
  <DIV STYLE="margin-left:0.4in" CLASS="pe2">
    <xsl:for-each select="stname[. != '']">
      <I>Nome: </I><xsl:value-of /><BR/>
    </xsl:for-each>
    <xsl:for-each select="stcode[. != '']">
      <I>Codice: </I><xsl:value-of /><BR/>
    </xsl:for-each>
    <xsl:for-each select="stfield[$any$ * != '']">
      <xsl:if test="context()[0]"><SPAN CLASS="pn">Attributi del subtype</SPAN><BR/></xsl:if>
      <xsl:choose> 
        <xsl:when test="context()[(stflddv != '') or ($any$ stflddd/* != '')]">
          <DIV STYLE="margin-left:0.25in" CLASS="ph2" onmouseover="doHilite()" onmouseout="doHilite()" onclick="hideShowGroup(this)">
            <xsl:choose>
              <xsl:when test="context()[stfldnm != '']">
                <xsl:value-of select="stfldnm"/>
              </xsl:when>
              <xsl:otherwise>Campo subtype</xsl:otherwise>
            </xsl:choose>
            <DIV CLASS="pe2" STYLE="display:none">
              <xsl:for-each select="stflddv[. != '']">
                <I>Valore di default: </I><xsl:value-of /><BR/>
              </xsl:for-each>
              <xsl:for-each select="stflddd[$any$ * != '']">
                <DIV><SPAN CLASS="pn">Dominio: </SPAN><xsl:value-of select="domname"/></DIV>
                <DIV STYLE="margin-left:0.2in">
                  <xsl:for-each select="domdesc[. != '']">
                    <I>Descrizione: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                  <xsl:for-each select="domfldtp[. != '']">
                    <I>Tipo di campo: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                  <xsl:for-each select="domtype[. != '']">
                    <I>Tipo di dominio: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                  <xsl:for-each select="mrgtype[. != '']">
                    <I>Regola di Merge: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                  <xsl:for-each select="splttype[. != '']">
                    <I>Regola di Split: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                  <xsl:for-each select="domowner[. != '']">
                    <I>Proprietario del dominio: </I><xsl:value-of /><BR/>
                  </xsl:for-each>
                </DIV>
              </xsl:for-each><BR/>
            </DIV>
          </DIV>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="context()[stfldnm != '']">
            <DIV STYLE="margin-left:0.25in" CLASS="pe2"><xsl:value-of select="stfldnm"/></DIV>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose> 
    </xsl:for-each>
  </DIV>
</xsl:template>

--------

<!-- Overview info -->
<xsl:template match="/metadata/eainfo/overview[(eaover != '') or ($any$ eadetcit != '')]">
  <xsl:for-each select="eaover[. != '']">
    <DIV CLASS="srh1">Overview</DIV>
    <DIV STYLE="margin-left:0.2in">
      <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN>
      <SCRIPT>fix(original)</SCRIPT><BR/>     
    </DIV>
  </xsl:for-each>
  <xsl:for-each select="eadetcit[. != '']">
    <xsl:if test="context()[0]"><DIV CLASS="srh1">Overview citation</DIV></xsl:if>
    <DIV STYLE="margin-left:0.2in">
      <SPAN CLASS="lt"><PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE></SPAN><BR/>
      <SCRIPT>fix(original)</SCRIPT>      
    </DIV>
  </xsl:for-each>
</xsl:template>


================================


<!-- SUPPORTING TEMPLATES -->

<!-- Time Period Information -->

<!-- Single or Multiple Date/Time -->
<xsl:template match="timeinfo//sngdate[(caldate != '') or (time != '')]">
  <DIV><I>Date and time: </I>
    <xsl:choose>
      <xsl:when test="context()[caldate = 'REQUIRED: The year (and optionally month, or month and day) for which the data set corresponds to the ground.']">
        <SPAN STYLE="color:#999999"><xsl:value-of select="caldate"/></SPAN>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="context()[caldate = 'The year (and optionally month, or month and day) for which the data set corresponds to the ground.  REQUIRED.']">
            <SPAN STYLE="color:#999999"><xsl:value-of select="caldate"/></SPAN>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="caldate"/></xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="context()[time != '']"> at time <xsl:value-of select="time"/></xsl:if>
  </DIV>
</xsl:template>

<!-- Range of Dates/Times -->
<xsl:template match="timeinfo/rngdates[$any$ * != '']">
  <DIV><I>Beginning date and time: </I>
    <xsl:value-of select="begdate"/>
    <xsl:if test="context()[begtime != '']"> at time <xsl:value-of select="begtime"/></xsl:if>
  </DIV>
  <DIV><I>Ending date and time: </I>
    <xsl:value-of select="enddate"/>
    <xsl:if test="context()[endtime != '']"> at time <xsl:value-of select="endtime"/></xsl:if>
  </DIV>
</xsl:template>

--------

<!-- Contact Information -->
<xsl:template match="cntinfo[(cntvoice != '') or (cntfax != '') or (cntemail != '') or 
    (hours != '') or (cntinst != '') or (cntaddr/* != '') or (*/cntper != '') or 
    (*/cntorg != '')]">    
  <xsl:for-each select="*/cntper[. != '']"><I>Persona: </I>
    <xsl:choose>
      <xsl:when test="context()[. = 'REQUIRED: The person responsible for the metadata information.']">
        <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="context()[. = 'The person responsible for the metadata information.  REQUIRED.']">
            <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of /><BR/></xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:for-each select="*/cntorg[. != '']"><I>Organizzazione: </I>
    <xsl:choose>
      <xsl:when test="context()[. = 'REQUIRED: The organization responsible for the metadata information.']">
        <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="context()[. = 'The organization responsible for the metadata information.  REQUIRED.']">
            <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of /><BR/></xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:for-each select="cntaddr[($any$ address != '') or (city != '') or (state != '') or (postal != '') or (country != '')]">
    <xsl:choose>
      <xsl:when test="addrtype[. = 'REQUIRED: The mailing and/or physical address for the organization or individual.']">
        <SPAN STYLE="color:#999999"><I><xsl:value-of select="addrtype"/>:</I></SPAN><BR/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="addrtype[. = 'The mailing and/or physical address for the organization or individual.  REQUIRED.']">
            <SPAN STYLE="color:#999999"><I><xsl:value-of select="addrtype"/>:</I></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="addrtype[. != '']"><I>Tipo di contatto: </I><xsl:value-of select="addrtype"/><BR/></xsl:when>
              <xsl:otherwise><I>Indirizzo</I><BR/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="context()[((address != '') or (city != '') or (state != '') or 
        (postal != '') or (country != ''))]">
      <I>Indirizzo: </I>
      <DIV STYLE="margin-left:0.3in">
        <xsl:for-each select="address[. != '']">
          <DIV CLASS="lt">
            <PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE>
            <SCRIPT>fix(original)</SCRIPT>
          </DIV>      
        </xsl:for-each>
        <xsl:if test="context()[((city != '') or (state != '') or (postal != ''))]">
          <DIV>
            <xsl:for-each select="city[. != '']">
              <xsl:choose>
                <xsl:when test="context()[. = 'REQUIRED: The city of the address.']">
                  <SPAN STYLE="color:#999999"><xsl:value-of /><xsl:if test="context()[../state != '']">, </xsl:if></SPAN></xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="context()[. = 'The city of the address.  REQUIRED.']">
                      <SPAN STYLE="color:#999999"><xsl:value-of /><xsl:if test="context()[../state != '']">, </xsl:if></SPAN></xsl:when>
                    <xsl:otherwise><xsl:value-of /><xsl:if test="context()[../state != '']">, </xsl:if></xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose></xsl:for-each><xsl:for-each select="state[. != '']">
              <xsl:choose>
                <xsl:when test="context()[. = 'REQUIRED: The state or province of the address.']">
                  <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN></xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="context()[. = 'The state or province of the address.  REQUIRED.']">
                      <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN></xsl:when>
                    <xsl:otherwise><xsl:value-of /></xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose></xsl:for-each><xsl:if test="context()[((city != '') or (state != '')) and (postal != '')]" xml:space="preserve"> </xsl:if>
              <xsl:for-each select="postal[. != '']">
              <xsl:choose>
                <xsl:when test="context()[. = 'REQUIRED: The ZIP or other postal code of the address.']">
                  <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN></xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="context()[. = 'The ZIP or other postal code of the address.  REQUIRED.']">
                      <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN></xsl:when>
                    <xsl:otherwise><xsl:value-of /></xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose></xsl:for-each>
          </DIV>
        </xsl:if>
        <xsl:for-each select="country[. != '']"><DIV><xsl:value-of/></DIV></xsl:for-each>
        <xsl:if test="context()[not(end())]">
          <BR/>
        </xsl:if>
      </DIV>
    </xsl:if>
  </xsl:for-each>
  <xsl:if test="context()[(($any$ cntaddr/address != '') or (cntaddr/city != '') or 
      (cntaddr/state != '') or (cntaddr/postal != '') or (cntaddr/country != '')) 
      and ((cntvoice != '') or (cntfax != '') or (cntemail != ''))]">
    <BR/>
  </xsl:if>
  <xsl:for-each select="cntvoice[. != '']">
    <xsl:choose>
      <xsl:when test="context()[. = 'REQUIRED: The telephone number by which individuals can speak to the organization or individual.']">
        <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="context()[. = 'The telephone number by which individuals can speak to the organization or individual.  REQUIRED.']">
            <SPAN STYLE="color:#999999"><xsl:value-of /></SPAN><BR/>
          </xsl:when>
          <xsl:otherwise><I>Telefono: </I><xsl:value-of /><BR/></xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:for-each select="cntfax[. != '']"><I>Fax: </I><xsl:value-of/><BR/></xsl:for-each>
  <xsl:for-each select="cntemail[. != '']"><I>Email: </I><xsl:value-of/><BR/></xsl:for-each>
  <!--<xsl:if test="context()[(($any$ cntaddr/address != '') or (cntaddr/city != '') or 
      (cntaddr/state != '') or (cntaddr/postal != '') or (cntaddr/country != '') or 
      (cntvoice != '') or (cntfax != '') or (cntemail != '')) 
      and ((hours != '') or (cntinst != ''))]">
    <BR/>
  </xsl:if>
  <xsl:for-each select="hours[. != '']"><DIV><I>Orario di servizio:</I> <xsl:value-of/></DIV></xsl:for-each>-->
  <xsl:for-each select="cntinst[. != '']">
    <DIV><I>Come contattare:</I></DIV>
    <DIV STYLE="margin-left:0.3in">
      <PRE ID="original"><xsl:eval>this.text</xsl:eval></PRE>
      <SCRIPT>fix(original)</SCRIPT>
    </DIV>      
  </xsl:for-each>  
  <BR/>
</xsl:template>

--------

<!-- Horizontal Coordinate Systems -->

<!-- Geographic Coordinate System -->
<xsl:template match="/metadata/spref/horizsys/geograph[$any$ * != '']">
  <DIV CLASS="srh1">Geographic Coordinate System</DIV>
  <xsl:for-each select="latres[. != '']">
    <DIV CLASS="sr2"><I>Latitude Resolution: </I><xsl:value-of/></DIV>
  </xsl:for-each>
  <xsl:for-each select="longres[. != '']">
    <DIV CLASS="sr2"><I>Longitude Resolution: </I><xsl:value-of/></DIV>
  </xsl:for-each>
  <xsl:for-each select="geogunit[. != '']">
    <DIV CLASS="sr2"><I>Geographic Coordinate Units: </I><xsl:value-of/></DIV>
  </xsl:for-each>
</xsl:template>

<!-- Planar Coordinate System -->
<xsl:template match="/metadata/spref/horizsys/planar[$any$ .//* != '']">
  <xsl:for-each select="mapproj">
    <xsl:for-each select="mapprojn[. != '']">
      <DIV CLASS="sr1"><SPAN CLASS="pn">Map Projection Name: </SPAN><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:if test="context()[$any$ .//* != '']">
      <DIV CLASS="sr2"><xsl:apply-templates select="*"/></DIV>
    </xsl:if>
    <xsl:if test="context()[not(end())]"><BR/></xsl:if>
  </xsl:for-each>

  <xsl:for-each select="gridsys">
    <xsl:for-each select="gridsysn[. != '']">
      <DIV CLASS="sr1"><SPAN CLASS="pn">Grid Coordinate System Name: </SPAN><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="utm">
      <xsl:for-each select="utmzone[. != '']">
        <DIV CLASS="sr2"><I>UTM Zone Number: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="transmer[$any$ * != '']">
        <DIV CLASS="srh2">Transverse Mercator Projection</DIV>
      </xsl:for-each>
      <DIV CLASS="sr3"><xsl:apply-templates select="transmer"/></DIV>
    </xsl:for-each>
    <xsl:for-each select="ups">
      <xsl:for-each select="upszone[. != '']">
        <DIV CLASS="sr2"><I>UPS Zone Identifier: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="polarst[$any$ * != '']">
        <DIV CLASS="srh2">Polar Stereographic Projection</DIV>
      </xsl:for-each>
      <DIV CLASS="sr3"><xsl:apply-templates select="polarst"/></DIV>
    </xsl:for-each>
    <xsl:for-each select="spcs">
      <xsl:for-each select="spcszone[. != '']">
        <DIV CLASS="sr2"><I>SPCS Zone Identifier: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="lambertc[$any$ * != '']">
        <DIV CLASS="srh2">Lambert Conformal Conic Projection</DIV>
      </xsl:for-each>
      <xsl:for-each select="transmer[$any$ * != '']">
        <DIV CLASS="srh2">Transverse Mercator Projection</DIV>
      </xsl:for-each>
      <xsl:for-each select="obqmerc[$any$ * != '']">
        <DIV CLASS="srh2">Oblique Mercator Projection</DIV>
      </xsl:for-each>
      <xsl:for-each select="polycon[$any$ * != '']">
        <DIV CLASS="srh2">Polyconic Projection</DIV>
      </xsl:for-each>
      <DIV CLASS="sr3"><xsl:apply-templates select="*"/></DIV>
    </xsl:for-each>
    <xsl:for-each select="arcsys">
      <xsl:for-each select="arczone[. != '']">
        <DIV CLASS="sr2"><I>ARC System Zone Identifier: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="equirect[$any$ * != '']">
        <DIV CLASS="srh2">Equirectangular Projection</DIV>
      </xsl:for-each>
      <xsl:for-each select="azimequi[$any$ * != '']">
        <DIV CLASS="srh2">Azimuthal Equidistant Projection</DIV>
      </xsl:for-each>
      <DIV CLASS="sr3"><xsl:apply-templates select="*"/></DIV>
    </xsl:for-each>
    <xsl:for-each select="othergrd[. != '']">
      <DIV CLASS="srh2">Other Grid System's Definition</DIV>
      <DIV CLASS="sr3"><xsl:value-of/></DIV>
    </xsl:for-each>
  </xsl:for-each>

  <xsl:for-each select="localp">
    <xsl:if test="context()[$any$ * != '']">
      <DIV CLASS="srh1">Local Planar Coordinate System</DIV>
    </xsl:if>
    <xsl:for-each select="localpd[. != '']">
      <DIV CLASS="sr2"><I>Description: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="localpgi[. != '']">
      <DIV CLASS="srh2">Georeference Information</DIV>
      <DIV CLASS="sr3"><SPAN CLASS="lt"><xsl:value-of/></SPAN></DIV>
    </xsl:for-each>
  </xsl:for-each>

  <xsl:if test="context()[($any$ (mapproj//* | gridsys//* | localp/*) != '') and 
      ($any$ planci//* != '')]">
    <BR/>
  </xsl:if>

  <xsl:for-each select="planci">
    <DIV CLASS="sr1"><SPAN CLASS="pn">Planar Coordinate Information</SPAN></DIV>
    <xsl:for-each select="plandu[. != '']">
      <DIV CLASS="sr2"><I>Planar Distance Units: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="plance[. != '']">
      <DIV CLASS="sr2"><I>Coordinate Encoding Method: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="coordrep">
      <xsl:if test="context()[$any$ * != '']">
        <DIV CLASS="srh2">Coordinate Representation</DIV>
      </xsl:if>
      <xsl:for-each select="absres[. != '']">
        <DIV CLASS="sr3"><I>Abscissa Resolution: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="ordres[. != '']">
        <DIV CLASS="sr3"><I>Ordinate Resolution: </I><xsl:value-of/></DIV>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:for-each select="distbrep">
      <xsl:if test="context()[$any$ * != '']">
        <DIV CLASS="srh2">Distance and Bearing Representation</DIV>
      </xsl:if>
      <xsl:for-each select="distres[. != '']">
        <DIV CLASS="sr3"><I>Distance Resolution: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="bearres[. != '']">
        <DIV CLASS="sr3"><I>Bearing Resolution: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="bearunit[. != '']">
        <DIV CLASS="sr3"><I>Bearing Units: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="bearrefd[. != '']">
        <DIV CLASS="sr3"><I>Bearing Reference Direction: </I><xsl:value-of/></DIV>
      </xsl:for-each>
      <xsl:for-each select="bearrefm[. != '']">
        <DIV CLASS="sr3"><I>Bearing Reference Meridian: </I><xsl:value-of/></DIV>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:for-each>

  <xsl:if test="context()[not(end())]">
    <BR/>
  </xsl:if>
</xsl:template>

<!-- Local Coordinate System -->
<xsl:template match="/metadata/spref/horizsys/local[$any$ * != '']">
  <DIV CLASS="srh1">Local Coordinate System</DIV>
  <xsl:for-each select="localdes[. != '']">
    <DIV CLASS="sr2"><I>Description: </I><xsl:value-of/></DIV>
  </xsl:for-each>
  <xsl:for-each select="localgeo[. != '']">
    <DIV CLASS="srh2">Georeference Information</DIV>
    <DIV CLASS="sr3"><SPAN CLASS="lt"><xsl:value-of/></SPAN></DIV>
  </xsl:for-each>
</xsl:template>

<!-- Geodetic Model -->
<xsl:template match="/metadata/spref/horizsys/geodetic[$any$ * != '']">
  <DIV CLASS="srh1">Geodetic Model</DIV>
  <xsl:for-each select="horizdn[. != '']">
    <DIV CLASS="sr2"><I>Horizontal Datum Name: </I><xsl:value-of/></DIV>
  </xsl:for-each>
  <xsl:for-each select="ellips[. != '']">
    <DIV CLASS="sr2"><I>Ellipsoid Name: </I><xsl:value-of/></DIV>
  </xsl:for-each>
  <xsl:for-each select="semiaxis[. != '']">
    <DIV CLASS="sr2"><I>Semi-major Axis: </I><xsl:value-of/></DIV>
  </xsl:for-each>
  <xsl:for-each select="denflat[. != '']">
    <DIV CLASS="sr2"><I>Denominator of Flattening Ratio: </I><xsl:value-of/></DIV>
  </xsl:for-each>
</xsl:template>

--------

<!-- Map Projections -->
<!-- Projections explicitly supported in the FGDC standard -->
<xsl:template match="albers | azimequi | equicon | equirect | gnomonic | gvnsp | lamberta | 
    lambertc | mercator | miller | modsak | obqmerc | orthogr | polarst | polycon | robinson | 
    sinusoid | spaceobq | stereo | transmer | vdgrin">
  <xsl:apply-templates select="*"/>
</xsl:template>

<!-- Projections defined in the 8.0 ESRI Profile -->
<xsl:template match="behrmann | bonne | cassini | eckert1 | eckert2 | eckert3 | eckert4 | 
    eckert5 | eckert6 | gallster | loximuth | mollweid | quartic | winkel1 | winkel2">
  <xsl:apply-templates select="*"/>
</xsl:template>

<!-- For projections not explicitly supported, FGDC standard places parameters in mapprojp; used by Catalog at 8.1 -->
<xsl:template match="mapprojp">
  <xsl:apply-templates select="*"/>
</xsl:template>

--------

<!-- Map Projection Parameters -->
<xsl:template match="stdparll[. != '']">
  <I>Standard Parallel: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="longcm[. != '']">
  <I>Longitude of Central Meridian: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="latprjo[. != '']">
  <I>Latitude of Projection Origin: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="feast[. != '']">
  <I>False Easting: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="fnorth[. != '']">
  <I>False Northing: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="sfequat[. != '']">
  <I>Scale Factor at Equator: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="heightpt[. != '']">
  <I>Height of Perspective Point Above Surface: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="longpc[. != '']">
  <I>Longitude of Projection Center: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="latprjc[. != '']">
  <I>Latitude of Projection Center: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="sfctrlin[. != '']">
  <I>Scale_Factor at Center Line: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="obqlazim[. != '']">
  <I>Oblique Line Azimuth: </I><BR/>
    <xsl:for-each select="azimangl[. != '']">
      <DD><I>Azimuthal Angle: </I><xsl:value-of/></DD><BR/>
    </xsl:for-each>
    <xsl:for-each select="azimptl[. != '']">
      <DD><I>Azimuthal Measure Point Longitude: </I><xsl:value-of/></DD><BR/>
    </xsl:for-each>
</xsl:template>

<xsl:template match="obqlpt[. != '']">
  <I>Oblique Line Point: </I><BR/>
    <xsl:for-each select="obqllat[. != '']">
      <DD><I>Oblique Line Latitude: </I><xsl:value-of/></DD><BR/>
    </xsl:for-each>
    <xsl:for-each select="obqllong[. != '']">
      <DD><I>Oblique Line Longitude: </I><xsl:value-of/></DD><BR/>
    </xsl:for-each>
</xsl:template>

<xsl:template match="svlong[. != '']">
  <I>Straight Vertical Longitude from Pole: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="sfprjorg[. != '']">
  <I>Scale Factor at Projection Origin: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="landsat[. != '']">
  <I>Landsat Number: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="pathnum[. != '']">
  <I>Path Number: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="sfctrmer[. != '']">
  <I>Scale Factor at Central Meridian: </I><xsl:value-of/><BR/>
</xsl:template>

<xsl:template match="otherprj[. != '']">
  <I>Other Projection's Definition: </I><xsl:value-of/><BR/>
</xsl:template>

--------

<!-- Vertical Coordinate Systems -->
<xsl:template match="vertdef">
  <xsl:for-each select="altsys">
    <xsl:if test="context()[$any$ * != '']">
      <DIV CLASS="srh1">Altitude System Definition</DIV>
    </xsl:if>
    <xsl:for-each select="altdatum[. != '']">
      <DIV CLASS="sr2"><I>Datum Name: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="altres[. != '']">
      <DIV CLASS="sr2"><I>Resolution: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="altunits[. != '']">
      <DIV CLASS="sr2"><I>Distance Units: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="altenc[. != '']">
      <DIV CLASS="sr2"><I>Encoding Method: </I><xsl:value-of/></DIV>
    </xsl:for-each>
  </xsl:for-each>

  <xsl:if test="context()[($any$ altsys/* != '') and ($any$ depthsys/* != '')]">
    <BR/>
  </xsl:if>

  <xsl:for-each select="depthsys">
    <xsl:if test="context()[$any$ * != '']">
      <DIV CLASS="srh1">Depth System Definition</DIV>
    </xsl:if>
    <xsl:for-each select="depthdn[. != '']">
      <DIV CLASS="sr2"><I>Datum Name: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="depthres[. != '']">
      <DIV CLASS="sr2"><I>Resolution: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="depthdu[. != '']">
      <DIV CLASS="sr2"><I>Distance Units: </I><xsl:value-of/></DIV>
    </xsl:for-each>
    <xsl:for-each select="depthem[. != '']">
      <DIV CLASS="sr2"><I>Encoding Method: </I><xsl:value-of/></DIV>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>


================================


<!-- SEARCH RESULTS TEMPLATE -->

<xsl:template match="SearchResults">
  <xsl:for-each select="QueryName">
    <DIV CLASS="name"><xsl:value-of/></DIV>
  </xsl:for-each>
  <DIV CLASS="sub">Search Results</DIV>
  <BR/>

  <DIV CLASS="search">
    <DIV>
      <xsl:for-each select="DatasetName">
        This search looks for data named "<xsl:value-of/>". 
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="context()[DatasetType]">
          <xsl:for-each select="DatasetType">
            <xsl:if test="context()[0]">
              It retrieves the following types of data:
            </xsl:if>
            <DIV STYLE="margin-left:0.3in">
              <LI><xsl:value-of select="@Description"/></LI>
            </DIV>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          It retrieves all types of data.
        </xsl:otherwise>
      </xsl:choose>
    </DIV>
    <BR/>

    <xsl:if test="context()[Envelope]">
      <DIV CLASS="head">Geographic criteria</DIV>
      <DIV>
        Data
        <xsl:if test="EnvelopeOperator[. = '0']">located within</xsl:if>
        <xsl:if test="EnvelopeOperator[. = '1']">that overlaps</xsl:if>
        the following area will be retrieved by this search: 
      </DIV>
      <DIV STYLE="margin-left:0.3in">
        <xsl:for-each select="Envelope/XMin"><DIV>Minimum X: <xsl:value-of/></DIV></xsl:for-each>
        <xsl:for-each select="Envelope/YMin"><DIV>Minimum Y: <xsl:value-of/></DIV></xsl:for-each>
        <xsl:for-each select="Envelope/XMax"><DIV>Maximum X: <xsl:value-of/></DIV></xsl:for-each>
        <xsl:for-each select="Envelope/YMax"><DIV>Maximum Y: <xsl:value-of/></DIV></xsl:for-each>
      </DIV>
      <BR/>
    </xsl:if>

    <xsl:if test="context()[DateType]">
      <DIV CLASS="head">Temporal criteria</DIV>
      <DIV>
        Data
        <xsl:if test="DateType[. = '1']">describing the time period </xsl:if>
        <xsl:if test="DateType[. = '2']">published </xsl:if>
        <xsl:if test="DateType[. = '3']">whose metadata was updated </xsl:if>
        <xsl:if test="DateType[. = '4']">modified </xsl:if>
        <xsl:if test="DateOperator[. = '0']">during the previous <xsl:value-of select="Date1"/> days </xsl:if>
        <xsl:if test="DateOperator[. > '0']">
          <xsl:if test="DateOperator[. = '1']">before </xsl:if>
          <xsl:if test="DateOperator[. = '2']">before or during </xsl:if>
          <xsl:if test="DateOperator[. = '3']">during </xsl:if>
          <xsl:if test="DateOperator[. = '4']">equal to </xsl:if>
          <xsl:if test="DateOperator[. = '5']">after or during </xsl:if>
          <xsl:if test="DateOperator[. = '6']">after </xsl:if>
          <xsl:value-of select="Date1"/>
          <xsl:if test="context()[Date2]">through <xsl:value-of select="Date2"/> </xsl:if>
        </xsl:if>
        will be retrieved by this search. 
      </DIV>
      <BR/>
    </xsl:if>

    <xsl:for-each select="FieldQuery">
      <xsl:if test="context()[0]">
        <DIV CLASS="head">Keyword criteria</DIV>
        <DIV>
          Data whose metadata satisfies the following criteria, 
          which are <xsl:if test="../IsCaseSensitive[. = '0']">not </xsl:if>case-sensitive,
          will be retrieved by this search:
        </DIV>
      </xsl:if>
      <DIV>
        <LI STYLE="margin-left:0.3in">
          <xsl:if test="FieldType[. = '0']">Full text </xsl:if>
          <xsl:if test="FieldType[. = '1']">Title </xsl:if>
          <xsl:if test="FieldType[. = '2']">Edition </xsl:if>
          <xsl:if test="FieldType[. = '3']">Originator </xsl:if>
          <xsl:if test="FieldType[. = '4']">Source agency </xsl:if>
          <xsl:if test="FieldType[. = '5']">Abstract </xsl:if>
          <xsl:if test="FieldType[. = '6']">Purpose </xsl:if>
          <xsl:if test="FieldType[. = '7']">Geospatial data presentation form </xsl:if>
          <xsl:if test="FieldType[. = '8']">Theme keyword </xsl:if>
          <xsl:if test="FieldType[. = '9']">Place keyword </xsl:if>
          <xsl:if test="FieldType[. = '10']">Stratum keyword </xsl:if>
          <xsl:if test="FieldType[. = '11']">Temporal keyword </xsl:if>
          <xsl:if test="FieldType[. = '12']">Entity type label </xsl:if>
          <xsl:if test="FieldType[. = '13']">Attribute label </xsl:if>
          <xsl:if test="FieldType[. = '14']">Lineage </xsl:if>
          <xsl:if test="FieldType[. = '15']">Source scale </xsl:if>
          <xsl:if test="FieldType[. = '16']">Cloud cover </xsl:if>
          <xsl:if test="FieldType[. = '17']">Progress</xsl:if>
          <xsl:if test="FieldOperator[. = '0']">includes </xsl:if>
          <xsl:if test="FieldOperator[. = '1']">equals </xsl:if>
          <xsl:if test="FieldOperator[. = '2']">exists</xsl:if>
          <xsl:if test="context()[FieldValue != '']">"<xsl:value-of select="FieldValue"/>"</xsl:if>.
        </LI>
      </DIV>
      <xsl:if test="context()[end()]">
        <BR/>
      </xsl:if>
    </xsl:for-each>

    <xsl:if test="*[@Engine = 'File system']">
      <DIV CLASS="head">When searching the File system</DIV>
      <DIV>
        Data located under "<xsl:value-of select="FileSystemLocation"/>" will be retrieved. 
        <xsl:for-each select="IncludeSubFolders[@Engine = 'File system']">
          Sub-folders will <xsl:if test="IncludeSubFolders[. = '0']">not </xsl:if>be searched.
        </xsl:for-each>
      </DIV>
      <BR/>
    </xsl:if>
    <xsl:if test="*[@Engine = 'Catalog']">
      <DIV CLASS="head">When searching the Catalog</DIV>
      <DIV>Data located under "<xsl:value-of select="CatalogLocation"/>" will be retrieved.</DIV>
      <BR/>
    </xsl:if>
  </DIV>
</xsl:template>

</xsl:stylesheet>