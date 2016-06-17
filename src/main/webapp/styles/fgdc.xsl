<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl" TYPE="text/javascript">

<!-- An xsl template for displaying FGDC and ESRI metadata in ArcGIS 
     with similar to the traditional FGDC look, but without italics.
     Shows all elements in FGDC standard and ESRI profile, and indicates
     which elements have been automatically updated by ArcCatalog.

     Copyright (c) 2000-2002, Environmental Systems Research Institute, Inc. All rights reserved.
     	
     Revision History: Created 6/21/01 avienneau
                       Modified 18/09/02 dagna

-->

<xsl:template match="/">
  <HTML>
  <HEAD>
    <STYLE>
      A   {font-size:12; font-family:Verdana, sans-serif; color:#003E88}
      BODY  {font-size:10; font-family:Verdana, sans-serif; color:#000000}
    </STYLE>
    <SCRIPT><xsl:comment><![CDATA[

function test() {
  var ua = window.navigator.userAgent
  var msie = ua.indexOf ( "MSIE " )
  if ( msie == -1 ) 
    document.write("<P>" + "Netscape")
}

      function fix(e) {
        var par = e.parentNode;
        e.id = "";
        e.style.marginLeft = "0.42in";
        var pos = e.innerText.indexOf("\n");
        if (pos > 0) {
          while (pos > 0) {
            var t = e.childNodes(0);
            var n = document.createElement("PRE");
            var s = t.splitText(pos);
            e.insertAdjacentElement("afterEnd", n);
            n.appendChild(s);
            n.style.marginLeft = "0.42in";
            e = n;
            pos = e.innerText.indexOf("\n");
          }
          var count = (par.children.length);
          for (var i = 0; i < count; i++) {
            e = par.children(i);
            if (e.tagName == "PRE") {
              pos = e.innerText.indexOf(">");
              if (pos != 0) {
                n = document.createElement("DD");
                e.insertAdjacentElement("afterEnd", n);
                n.innerText = e.innerText;
                e.removeNode(true);
              }
            }
          }
          if (par.children.tags("PRE").length > 0) {
            count = (par.children.length);
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
          n = document.createElement("DD");
          par.appendChild(n);
          n.innerText = e.innerText;
          e.removeNode(true);
        }
      }

// modificato da marucci_f il 07/11/2007
function getThumbnail()
{
	
	if (document.getElementById("thumbnail")){
		s=document.location.href.split("/");
		//ss=s[s.length-1].split(".");
		//sss=ss[0];
		//alert(document.location.href);
		document.getElementById("thumbnail").src=s[s.length-1].replace(".html",".bmp");
	}
}

    ]]></xsl:comment></SCRIPT>
  </HEAD>

  <BODY BGCOLOR="#E1E1E1" onload="getThumbnail()">
  <FONT COLOR="000000" FACE="Verdana, Arial">
     

    <A name="Top"/>

    <!-- show metadata summary -->
    <xsl:if test="/metadata[($any$ (idinfo/citation/citeinfo/title/text() | 
          Binary/Thumbnail/img | idinfo/browse/img | idinfo/natvform/text() | 
          idinfo/citation/citeinfo/ftname/text() | spref/horizsys/(geograph/*/text() | 
          planar/(mapproj/mapprojn/text() | gridsys/gridsysn/text() | localp/*/text()) | 
          local/*/text()) | idinfo/keywords/theme/themekey/text()))]">

      <TABLE COLS="2" WIDTH="100%" BGCOLOR="#B3D9D9" CELLPADDING="11" BORDER="0" CELLSPACING="0">

        <!-- show title -->
        <xsl:if test="/metadata/idinfo/citation/citeinfo/title[text()]">
          <TR ALIGN="center" VALIGN="center">
            <TD COLSPAN="2">
              <FONT COLOR="#003E88" FACE="Verdana" SIZE="4">
                <xsl:for-each select="/metadata/idinfo/citation/citeinfo/title[text()]">
                  <B><xsl:value-of /></B>
                </xsl:for-each>
              </FONT>
            </TD>
          </TR>
        </xsl:if>

        <xsl:if test="/metadata[($any$ Binary/Thumbnail/img | idinfo/browse/img |
              idinfo/natvform/text() | idinfo/citation/citeinfo/ftname/text() | 
              spref/horizsys/(geograph/*/text() | planar/(mapproj/mapprojn/text() | 
              gridsys/gridsysn/text() | localp/*/text()) | local/*/text()) | 
              idinfo/keywords/theme/themekey/text())]">

          <TR ALIGN="left" VALIGN="top">

            <!-- show thumbnail  -->
            <xsl:if test="/metadata[($any$ Binary/Thumbnail/img | idinfo/browse/img)]">
              <TD>
                <xsl:choose>
                  <xsl:when test="/metadata[($any$ idinfo/natvform/text() |
                        idinfo/citation/citeinfo/ftname/text() | 
                        spref/horizsys/(geograph/text() | planar/(mapproj/mapprojn/text() | 
                        gridsys/gridsysn/text() | localp/*/text()) | local/*/text()) | 
                        idinfo/keywords/theme/themekey/text())]">
                    <xsl:attribute name="WIDTH">210</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="ALIGN">center</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>

                <FONT COLOR="#003E88" FACE="Verdana" SIZE="2">
                  <xsl:apply-templates select="/metadata//img[@src]" />
                </FONT>
              </TD>
            </xsl:if>

            <!-- show format, file name, coordinate system, theme keywords  -->
            <xsl:if test="/metadata[($any$ idinfo/natvform/text() | 
                  idinfo/citation/citeinfo/ftname/text() | 
                  spref/horizsys/(geograph/*/text() | planar/(mapproj/mapprojn/text() | 
                  gridsys/gridsysn/text() | localp/*/text()) | local/*/text()) | 
                  idinfo/keywords/theme/themekey/text())]">
              <TD>
                <FONT COLOR="#003E88" FACE="Verdana" SIZE="2">
                  <xsl:for-each select="/metadata/idinfo/natvform[text()]">
                    <DT>
                      <B>Formato del dato:</B> <xsl:value-of />
                      <xsl:if test="/metadata[(idinfo/natvform = 'Raster Dataset') 
                            and (spdoinfo/rastinfo/rastifor/text())]">
                        - <xsl:value-of select="/metadata/spdoinfo/rastinfo/rastifor" />
                      </xsl:if>
                    </DT><BR/><BR/>
                  </xsl:for-each>

                  <xsl:for-each select="/metadata/idinfo/citation/citeinfo/ftname[text()]">
                    <DT><B>Nome del file:</B> <xsl:value-of /></DT><BR/><BR/>
                  </xsl:for-each>

                  <xsl:if test="/metadata/spref/horizsys[($any$ geograph/*/text() | 
                        planar/(mapproj/mapprojn/text() | gridsys/gridsysn/text() | 
                        localp/*/text()) | local/*/text())]">

                    <DT><B>Sistema di coordinate:</B> 
                      <xsl:for-each select="/metadata/spref/horizsys/geograph[*/text()]">Geografiche </xsl:for-each>
                      <xsl:value-of select="/metadata/spref/horizsys/planar/mapproj/mapprojn[text()]"/>
                      <xsl:value-of select="/metadata/spref/horizsys/planar/gridsys/gridsysn[text()]"/>
                      <xsl:for-each select="/metadata/spref/horizsys/planar/localp[*/text()]">Planari locali </xsl:for-each>
                      <xsl:for-each select="/metadata/spref/horizsys/local[*/text()]">Locali </xsl:for-each>
                    </DT><BR/><BR/>
                  </xsl:if>

                  <xsl:if test="context()[(/metadata/idinfo/keywords/theme/themekey[(text())
                        and (. != 'REQUIRED: Common-use word or phrase used to describe the subject of the data set.')
                        and (. != 'Common-use word or phrase used to describe the subject of the data set.  REQUIRED.')])]">
                    <DT><B>Temi:</B>
                      <xsl:for-each select="/metadata/idinfo/keywords/theme[themekey/text()]">
                        <xsl:for-each select="themekey[text()]">
                          <xsl:value-of /><xsl:if test="context()[not(end()) and (text())]">, </xsl:if>
                        </xsl:for-each><xsl:if test="context()[not(end())]">, </xsl:if>
                      </xsl:for-each>
                    </DT>
                  </xsl:if>
                </FONT>
              </TD>
            </xsl:if>
          </TR>
        </xsl:if>
      	  <TR>
	    <TD  COLSPAN="2">
              <FONT COLOR="#003E88" FACE="Verdana" SIZE="2">
		Metadati provvisori in attesa di compilare il Repository regionale
	      </FONT>
            </TD>
	  </TR>
	</TABLE>
    </xsl:if>

    <H3>Metadati del Servizio Geologico, Sismico e dei Suoli:</H3>
    <UL>
      <xsl:for-each select="metadata/idinfo">
        <LI><A HREF="#Identification_Information">Informazioni identificative</A></LI>
      </xsl:for-each>
      <xsl:for-each select="metadata/dataqual">
        <LI><A HREF="#Data_Quality_Information">Informazioni sulla qualità del dato</A></LI>
      </xsl:for-each>
      <xsl:for-each select="metadata/spdoinfo">
        <LI><A HREF="#Spatial_Data_Organization_Information">Informazioni sull'organizzazione dei dati spaziali</A></LI>
      </xsl:for-each>
      <xsl:for-each select="metadata/spref">
        <LI><A HREF="#Spatial_Reference_Information">Informazioni sul sistema di riferimento spaziale</A></LI>
      </xsl:for-each>
      <xsl:for-each select="metadata/eainfo">
        <LI><A HREF="#Entity_and_Attribute_Information">Informazioni sulle entità e attributi</A></LI>
      </xsl:for-each>
      
      <xsl:if expr="(this.selectNodes('metadata/distinfo').length == 1)">
        <xsl:for-each select="metadata/distinfo">
          <LI><A>
            <xsl:attribute name="HREF">#<xsl:eval>uniqueID(this)</xsl:eval></xsl:attribute>
            Informazioni sulla distribuzione
          </A></LI>
        </xsl:for-each>
      </xsl:if>
      <xsl:if expr="(this.selectNodes('metadata/distinfo').length > 1)">
        <LI>Informazioni sulla distribuzione</LI>
        <xsl:for-each select="metadata/distinfo">
          <LI STYLE="margin-left:0.3in"><A>
            <xsl:attribute name="HREF">#<xsl:eval>uniqueID(this)</xsl:eval></xsl:attribute>
           Distributor <xsl:eval>formatIndex(childNumber(this), "1")</xsl:eval>
          </A></LI>
        </xsl:for-each>
      </xsl:if>

      <xsl:for-each select="metadata/metainfo">
        <LI><A HREF="#Metadata_Reference_Information">Informazioni di riferimento sul metadata</A></LI>
      </xsl:for-each>
      <!--Fede<xsl:for-each select="metadata/Binary">
        <LI><A HREF="#Binary_Enclosures">Allegati Binari</A></LI>
      </xsl:for-each>-->
    </UL>

    <BLOCKQUOTE><FONT SIZE="1">      
      Gli elementi preceduti dall'asterisco (<FONT color="#2E8B00">*</FONT>)
      saranno automaticamente aggiornati da ArcCatalog.     
    </FONT></BLOCKQUOTE>

    <xsl:apply-templates select="metadata/idinfo"/>
    <xsl:apply-templates select="metadata/dataqual"/>
    <xsl:apply-templates select="metadata/spdoinfo"/>
    <xsl:apply-templates select="metadata/spref"/>
    <xsl:apply-templates select="metadata/eainfo"/>
    <xsl:apply-templates select="metadata/distinfo"/>
    <xsl:apply-templates select="metadata/metainfo"/>
    <!--Fede<xsl:apply-templates select="metadata/Binary"/>-->

   </FONT>


  <!-- <BR/><BR/><BR/><CENTER><FONT COLOR="#6495ED">Metadata stylesheets are provided courtesy of ESRI.  Copyright (c) 2000-2002, Environmental Systems Research Institute, Inc.  All rights reserved.</FONT></CENTER> -->

  </BODY>
  </HTML>
</xsl:template>

================================

<!-- Thumbnail -->
<xsl:template match="/metadata/Binary/Thumbnail/img[@src]">
      <IMG ID="thumbnail" ALIGN="absmiddle" STYLE="width:217; 
          border:'2 outset #FFFFFF'; position:relative">
        <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
      </IMG>
      <BR/><BR/>
</xsl:template>
<xsl:template match="/metadata/idinfo/browse/img[@src]">
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

<!-- Identification -->
<xsl:template match="idinfo">
  <A name="Identification_Information"><HR/></A>
  <DL>
    <DT><FONT size="2"><B>Informazioni identificative:</B></FONT></DT>
    <BR/><BR/>
    <DD>
    <DL>
      <xsl:for-each select="citation">
        <DT><B>Informazioni sulla pubblicazione:</B></DT>
        <DD>
        <DL>
          <xsl:apply-templates select="citeinfo"/>
        </DL>
        </DD>
      </xsl:for-each>

      <xsl:for-each select="descript">
        <DT><B>Descrizione:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="abstract">
            <DIV>
              <DT><B>Riassunto:</B></DT>
              <xsl:choose>
                <xsl:when test="context()[. = 'REQUIRED: A brief narrative summary of the data set.']">
                  <DD><FONT color="#999999"><xsl:value-of /></FONT></DD>
                </xsl:when>
                <xsl:when test="context()[. = 'A brief narrative summary of the data set.  REQUIRED.']">
                  <DD><FONT color="#999999"><xsl:value-of /></FONT></DD>
                </xsl:when>
                <xsl:otherwise>
                  <PRE ID="original"><xsl:value-of /></PRE>
                  <SCRIPT>fix(original)</SCRIPT>      
                </xsl:otherwise>
              </xsl:choose>
            </DIV><BR/>
          </xsl:for-each>

          <xsl:for-each select="purpose">
            <DIV>
              <DT><B>Scopo:</B></DT>
              <xsl:choose>
                <xsl:when test="context()[. = 'REQUIRED: A summary of the intentions with which the data set was developed.']">
                  <DD><FONT color="#999999"><xsl:value-of /></FONT></DD>
                </xsl:when>
                <xsl:when test="context()[. = 'A summary of the intentions with which the data set was developed.  REQUIRED.']">
                  <DD><FONT color="#999999"><xsl:value-of /></FONT></DD>
                </xsl:when>
                <xsl:otherwise>
                  <PRE ID="original"><xsl:value-of /></PRE>
                  <SCRIPT>fix(original)</SCRIPT>      
                </xsl:otherwise>
              </xsl:choose>
            </DIV><BR/>
          </xsl:for-each>

          <xsl:for-each select="supplinf">
            <DIV>
              <DT><B>Informazioni supplementari:</B></DT>
              <PRE ID="original"><xsl:value-of /></PRE>
              <SCRIPT>fix(original)</SCRIPT>      
            </DIV><BR/>
          </xsl:for-each>

          <!-- ESRI Profile element  -->
          <xsl:for-each select="langdata">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Linguaggio del dataset:</B> 
                <xsl:value-of/></DT><BR/><BR/>
          </xsl:for-each>
        </DL>
        </DD>
      </xsl:for-each>

      <!--Fede<xsl:for-each select="timeperd">
        <DT><B>Time period of content:</B></DT>
        <DD>
        <DL>
          <xsl:apply-templates select="timeinfo"/>
          
          <xsl:for-each select="current">
            <DIV>
              <DT><B>Currentness reference:</B></DT>
              <xsl:choose>
                <xsl:when test="context()[. = 'REQUIRED: The basis on which the time period of content information is determined.']">
                  <DD><FONT color="#999999"><xsl:value-of /></FONT></DD>
                </xsl:when>
                <xsl:when test="context()[. = 'The basis on which the time period of content information is determined.  REQUIRED.']">
                  <DD><FONT color="#999999"><xsl:value-of /></FONT></DD>
                </xsl:when>
                <xsl:otherwise>
                  <PRE ID="original"><xsl:value-of /></PRE>
                  <SCRIPT>fix(original)</SCRIPT>      
                </xsl:otherwise>
              </xsl:choose>
            </DIV><BR/>
          </xsl:for-each>
        </DL>
        </DD>
      </xsl:for-each>-->

      <xsl:for-each select="status">
        <DT><B>Stato:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="progress">
            <DT>
              <B>Completezza dell'acquisizione:</B>
              <xsl:choose>
                <xsl:when test="context()[. = 'REQUIRED: The state of the data set.']">
                  <FONT color="#999999"><xsl:value-of /></FONT>
                </xsl:when>
                <xsl:when test="context()[. = 'The state of the data set.  REQUIRED.']">
                  <FONT color="#999999"><xsl:value-of /></FONT>
                </xsl:when>
                <xsl:otherwise><xsl:value-of/></xsl:otherwise>
              </xsl:choose>
            </DT>
          </xsl:for-each>
          <xsl:for-each select="update">
            <DT>
              <B>Frequenza di aggiornamento:</B> 
              <xsl:choose>
                <xsl:when test="context()[. = 'REQUIRED: The frequency with which changes and additions are made to the data set after the initial data set is completed.']">
                  <FONT color="#999999"><xsl:value-of /></FONT>
                </xsl:when>
                <xsl:when test="context()[. = 'The frequency with which changes and additions are made to the data set after the initial data set is completed.  REQUIRED.']">
                  <FONT color="#999999"><xsl:value-of /></FONT>
                </xsl:when>
                <xsl:otherwise><xsl:value-of/></xsl:otherwise>
              </xsl:choose>
            </DT>
          </xsl:for-each>
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>

      <xsl:for-each select="spdom">
        <DT><B>Dominio Spaziale:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="bounding">
            <DT><B>Estensione territoriale geografica (in gradi decimali):</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="westbc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Ovest:</B>
                  <xsl:choose>
                    <xsl:when test="context()[. = 'REQUIRED: Western-most coordinate of the limit of coverage expressed in longitude.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:when test="context()[. = 'Western-most coordinate of the limit of coverage expressed in longitude.  REQUIRED.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of /></xsl:otherwise>
                  </xsl:choose>
                </DT>
              </xsl:for-each>
              <xsl:for-each select="eastbc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Est:</B>
                  <xsl:choose>
                    <xsl:when test="context()[. = 'REQUIRED: Eastern-most coordinate of the limit of coverage expressed in longitude.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:when test="context()[. = 'Eastern-most coordinate of the limit of coverage expressed in longitude.  REQUIRED.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of /></xsl:otherwise>
                  </xsl:choose>
                </DT>
              </xsl:for-each>
              <xsl:for-each select="northbc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Nord:</B>
                  <xsl:choose>
                    <xsl:when test="context()[. = 'REQUIRED: Northern-most coordinate of the limit of coverage expressed in latitude.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:when test="context()[. = 'Northern-most coordinate of the limit of coverage expressed in latitude.  REQUIRED.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of /></xsl:otherwise>
                  </xsl:choose>
                </DT>
              </xsl:for-each>
              <xsl:for-each select="southbc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Sud:</B>
                  <xsl:choose>
                    <xsl:when test="context()[. = 'REQUIRED: Southern-most coordinate of the limit of coverage expressed in latitude.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:when test="context()[. = 'Southern-most coordinate of the limit of coverage expressed in latitude.  REQUIRED.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of /></xsl:otherwise>
                  </xsl:choose>
                </DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>
          
          <!-- ESRI Profile element  -->
          <xsl:for-each select="lboundng">
            <DT><B>Estensione territoriale in coordinate proiettate locali (in metri):</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="leftbc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Sinistra:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="rightbc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Destra:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="topbc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Sopra:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="bottombc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Sotto:</B> <xsl:value-of /></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <!--Fede<xsl:for-each select="dsgpoly">
            <DT><B>Data set G-polygon:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="dsgpolyo">
                <DT><B>Data set G-polygon outer G-ring:</B></DT>
                <DD>
                <DL>
                  <xsl:apply-templates select="grngpoin"/>
                  <xsl:apply-templates select="gring"/>
                </DL>
                </DD>
              </xsl:for-each>
              <xsl:for-each select="dsgpolyx">
                <DT><B>Data set G-polygon exclusion G-ring:</B></DT>
                <DD>
                <DL>
                  <xsl:apply-templates select="grngpoin"/>
                  <xsl:apply-templates select="gring"/>
                </DL>
                </DD>
              </xsl:for-each>
            </DL>
            </DD>
          </xsl:for-each>-->

          <!-- ESRI Profile element  -->
          <xsl:for-each select="minalti">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Altitudine minima:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="maxalti">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Altitudine massima:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="altunits">
            <DT><B>Unità di altitudine:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:if test="context()[($any$ minalti | maxalti | altunits)]"><BR/><BR/></xsl:if>

          <!-- ESRI Profile element  -->
          <!--Fede<xsl:for-each select="eframes">
            <DT><B>Data frames:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="framect">
                <DT><B>Data frame count:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="framenam">
                <DT><B>Data frame name:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>-->
        </DL>
        </DD>
      </xsl:for-each>

      <xsl:for-each select="keywords">
        <DT><B>Parole chiave:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="theme">
            <DT><B>Tema:</B></DT>
            <DD>
            <DL>
              <xsl:if test="context()[themekey/text()]">
                <DT>
                <xsl:for-each select="themekey[text()]">
                  <!--Fede<xsl:if test="context()[0]"><B>Theme keywords:</B> </xsl:if>-->
                  <xsl:choose>
                    <xsl:when test="context()[. = 'REQUIRED: Common-use word or phrase used to describe the subject of the data set.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:when test="context()[. = 'Common-use word or phrase used to describe the subject of the data set.  REQUIRED.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of /></xsl:otherwise>
                  </xsl:choose><xsl:if test="context()[not(end())]">, </xsl:if>
                </xsl:for-each>
                </DT>
              </xsl:if>
              <!--Fede<xsl:for-each select="themekt">
                <DT>
                  <B>Theme keyword thesaurus:</B> 
                  <xsl:choose>
                    <xsl:when test="context()[. = 'REQUIRED: Reference to a formally registered thesaurus or a similar authoritative source of theme keywords.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:when test="context()[. = 'Reference to a formally registered thesaurus or a similar authoritative source of theme keywords.  REQUIRED.']">
                      <FONT color="#999999"><xsl:value-of /></FONT>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of /></xsl:otherwise>
                  </xsl:choose>
                </DT>
              </xsl:for-each>-->
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="place">
            <DT><B>Place:</B></DT>
            <DD>
            <DL>
              <xsl:if test="context()[placekey/text()]">
                <DT>
                <xsl:for-each select="placekey[text()]">
                  <xsl:if test="context()[0]"><B>Place keywords:</B> </xsl:if>
                  <xsl:value-of /><xsl:if test="context()[not(end())]">, </xsl:if>
                </xsl:for-each>
                </DT>
              </xsl:if>
              <xsl:for-each select="placekt">
                <DT><B>Place keyword thesaurus:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="stratum">
            <DT><B>Stratum:</B></DT>
            <DD>
            <DL>
              <xsl:if test="context()[stratkey/text()]">
                <DT>
                <xsl:for-each select="stratkey[text()]">
                  <xsl:if test="context()[0]"><B>Stratum keywords:</B> </xsl:if>
                  <xsl:value-of /><xsl:if test="context()[not(end())]">, </xsl:if>
                </xsl:for-each>
                </DT>
              </xsl:if>
              <xsl:for-each select="stratkt">
                <DT><B>Stratum keyword thesaurus:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>
 
          <xsl:for-each select="temporal">
            <DT><B>Temporal:</B></DT>
            <DD>
            <DL>
              <xsl:if test="context()[tempkey/text()]">
                <DT>
                <xsl:for-each select="tempkey[text()]">
                  <xsl:if test="context()[0]"><B>Temporal keywords:</B> </xsl:if>
                  <xsl:value-of /><xsl:if test="context()[not(end())]">, </xsl:if>
                </xsl:for-each>
                </DT>
              </xsl:if>
              <xsl:for-each select="tempkt">
                <DT><B>Temporal keyword thesaurus:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>
        </DL>
        </DD>
      </xsl:for-each>

      <!--Fede<xsl:for-each select="accconst">
        <DT><B>Access constraints:</B>
          <xsl:choose>
            <xsl:when test="context()[. = 'REQUIRED: Restrictions and legal prerequisites for accessing the data set.']">
              <FONT color="#999999"><xsl:value-of /></FONT>
            </xsl:when>
            <xsl:when test="context()[. = 'Restrictions and legal prerequisites for accessing the data set.  REQUIRED.']">
              <FONT color="#999999"><xsl:value-of /></FONT>
            </xsl:when>
            <xsl:otherwise><xsl:value-of /></xsl:otherwise>
          </xsl:choose>
        </DT>
      </xsl:for-each>-->
      <xsl:for-each select="useconst">
        <DIV>
          <DT><B>Restrizioni all'uso:</B></DT>
          <xsl:choose>
            <xsl:when test="context()[. = 'REQUIRED: Restrictions and legal prerequisites for using the data set after access is granted.']">
              <DD><FONT color="#999999"><xsl:value-of /></FONT></DD>
            </xsl:when>
            <xsl:when test="context()[. = 'Restrictions and legal prerequisites for using the data set after access is granted.  REQUIRED.']">
              <DD><FONT color="#999999"><xsl:value-of /></FONT></DD>
            </xsl:when>
            <xsl:otherwise>
              <PRE ID="original"><xsl:value-of /></PRE>
              <SCRIPT>fix(original)</SCRIPT>      
            </xsl:otherwise>
          </xsl:choose>
        </DIV>
      </xsl:for-each>
      <xsl:if test="context()[($any$ accconst | useconst)]"><BR/></xsl:if>
      <xsl:if test="context()[($any$ accconst | useconst) and not ($any$ useconst)]"><BR/></xsl:if>

      <xsl:for-each select="ptcontac">
        <DT><B>Point of contact:</B></DT>
        <DD>
        <DL>
          <xsl:apply-templates select="cntinfo"/>
        </DL>
        </DD>
        <xsl:if test="context()[not (cntinfo/*)]"><BR/></xsl:if>
      </xsl:for-each>

      <xsl:for-each select="browse">
        <DT><B>Browse graphic:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="browsen">
            <DT><B>Browse graphic file name:</B> <A TARGET="viewer">
              <xsl:attribute name="HREF"><xsl:value-of/></xsl:attribute>
              <xsl:value-of/></A>
            </DT>
          </xsl:for-each>
          <xsl:for-each select="browsed">
            <DT><B>Browse graphic file description:</B></DT>
            <DD><xsl:value-of/></DD>
          </xsl:for-each>
          <xsl:for-each select="browset">
            <DT><B>Browse graphic file type:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="img">
            <DT><B>Browse graphic embedded:</B></DT>
            <DD>
            <DL>
              <DT><B>Enclosure type:</B> Picture</DT>
              <BR/><BR/>
              <IMG ID="thumbnail" ALIGN="absmiddle" STYLE="height:144; 
                  border:'2 outset #FFFFFF'; position:relative">
                <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
              </IMG>
            </DL>
            </DD>
          </xsl:for-each>
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>

      <xsl:for-each select="datacred">
        <DIV>
          <DT><B>Data set credit:</B></DT>
          <PRE ID="original"><xsl:value-of/></PRE>      
          <SCRIPT>fix(original)</SCRIPT>      
        </DIV>
        <BR/>
      </xsl:for-each>

      <xsl:for-each select="secinfo">
        <DT><B>Security information:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="secsys">
            <DT><B>Security classification system:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="secclass">
            <DT><B>Security classification:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="sechandl">
            <DT><B>Security handling description:</B> <xsl:value-of/></DT>
          </xsl:for-each>
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>

      <!-- ESRI Profile element  -->
      <xsl:for-each select="natvform">
        <DT><xsl:if test="context()[@Sync = 'TRUE']">
            <FONT color="#2E8B00">*</FONT></xsl:if><B>Formato del dato:</B> <xsl:value-of/></DT>
      </xsl:for-each>
      <!--Fede<xsl:for-each select="native">
        <DT><xsl:if test="context()[@Sync = 'TRUE']">
            <FONT color="#2E8B00">*</FONT></xsl:if><B>Native data set environment:</B></DT>
        <DD><xsl:value-of/></DD>
      </xsl:for-each>-->
      <xsl:if test="context()[($any$ natvform | native)]"><BR/><BR/></xsl:if>

      <xsl:for-each select="crossref">
        <DT><B>Cross reference:</B></DT>
        <DD>
        <DL>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="assndesc">
            <DT><B>Association description:</B> <xsl:value-of/></DT>
            <BR/><BR/>
          </xsl:for-each>
          <xsl:apply-templates select="citeinfo"/>
        </DL>
        </DD>
      </xsl:for-each>

    </DL>
    </DD>
  </DL>
  <A HREF="#Top">Torna all'Indice</A>
</xsl:template>

--------

<!-- Data Quality -->
<xsl:template match="dataqual">
  <A name="Data_Quality_Information"><HR/></A>
  <DL>
    <DT><FONT size="2"><B>Informazioni sulla Qualità del dato:</B></FONT></DT>
    <BR/><BR/>
    <DD>
    <DL>
      <xsl:for-each select="attracc">
        <DT><B>Accuratezza tematica:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="attraccr">
            <DIV>
              <DT><B>Indice di accuratezza tematica:</B></DT>
              <PRE ID="original"><xsl:value-of/></PRE>      
              <SCRIPT>fix(original)</SCRIPT>      
            </DIV>
            <BR/>
          </xsl:for-each>
          <!--Fede<xsl:for-each select="qattracc">
            <DT><B>Quantitative attribute accuracy assessment:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="attraccv">
                <DT><B>Attribute accuracy value:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="attracce">
                <DIV>
                  <DT><B>Attribute accuracy explanation:</B></DT>
                  <PRE ID="original"><xsl:value-of/></PRE>      
                  <SCRIPT>fix(original)</SCRIPT>      
                </DIV>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>-->
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>

      <xsl:for-each select="logic">
        <DIV>
          <DT><B>Consistenza logica:</B></DT>
          <PRE ID="original"><xsl:value-of/></PRE>      
          <SCRIPT>fix(original)</SCRIPT>      
        </DIV>
        <BR/>
      </xsl:for-each>
      <xsl:for-each select="complete">
        <DIV>
          <DT><B>Completezza:</B></DT>
          <PRE ID="original"><xsl:value-of/></PRE>      
          <SCRIPT>fix(original)</SCRIPT>      
        </DIV>
        <BR/>
      </xsl:for-each>

      <xsl:for-each select="posacc">
        <DT><B>Accuratezza posizionale:</B></DT>
        <DD>
        <DL>
          <!--Fede<xsl:for-each select="horizpa">
            <DT><B>Accuratezza planare:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="horizpar">
                <DIV>
                  <DT><B>Misura di accuratezza planare:</B></DT>
                  <PRE ID="original"><xsl:value-of/></PRE>      
                  <SCRIPT>fix(original)</SCRIPT>      
                </DIV>
                <BR/>
              </xsl:for-each>
              <xsl:for-each select="qhorizpa">
                <DT><B>Quantitative horizontal positional accuracy assessment:</B></DT>
                <DD>
                <DL>-->
                  <xsl:for-each select="//horizpav">
                    <DT><B>Misura di accuratezza planare:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <!--<xsl:for-each select="horizpae">
                    <DIV>
                      <DT><B>Horizontal positional accuracy explanation:</B></DT>
                      <PRE ID="original"><xsl:value-of/></PRE>      
                      <SCRIPT>fix(original)</SCRIPT>      
                    </DIV>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>
            </DL>
            </DD>
          </xsl:for-each>
          <xsl:for-each select="vertacc">
            <DT><B>Vertical positional accuracy:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="vertaccr">
                <DIV>
                  <DT><B>Vertical positional accuracy report:</B></DT>
                  <PRE ID="original"><xsl:value-of/></PRE>      
                  <SCRIPT>fix(original)</SCRIPT>      
                </DIV>
                <BR/>
              </xsl:for-each>
              <xsl:for-each select="qvertpa">
                <DT><B>Quantitative vertical positional accuracy assessment:</B></DT>
                <DD>
                <DL>-->
                  <xsl:for-each select="//vertaccv">
                    <DT><B>Misura di accuratezza verticale:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <!--<xsl:for-each select="vertacce">
                    <DIV>
                      <DT><B>Vertical positional accuracy explanation:</B></DT>
                      <PRE ID="original"><xsl:value-of/></PRE>      
                      <SCRIPT>fix(original)</SCRIPT>      
                    </DIV>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>
            </DL>
            </DD>
          </xsl:for-each>-->
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>

      <xsl:for-each select="lineage">
        <!--<DT><B>Lineage:</B></DT>
        <DD>
        <DL>-->
          <xsl:for-each select="srcinfo">
            <DT><B>Informazioni sulla fonte:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="srccite">
                <DT><B>Citazione della fonte:</B></DT>
                <DD>
                <DL>
                  <xsl:apply-templates select="citeinfo"/>
                </DL>
                </DD>
              </xsl:for-each>

              <xsl:for-each select="srcscale">
                <DT><B>Denominatore di scala della fonte:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="typesrc">
                <DT><B>Supporto della fonte:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="srccitea">
                <DT><B>Source citation abbreviation:</B></DT>
                <DD><xsl:value-of/></DD>
              </xsl:for-each>
              <xsl:for-each select="srccontr">
                <DIV>
                  <DT><B>Source contribution:</B></DT>
                  <PRE ID="original"><xsl:value-of/></PRE>      
                  <SCRIPT>fix(original)</SCRIPT>      
                </DIV>
              </xsl:for-each>
              <xsl:if test="context()[($any$ srcscale | typesrc | srccitea | srccontr)]"><BR/>  </xsl:if>

              <xsl:for-each select="srctime">
                <DT><B>Source time period of content:</B></DT>
                <DD>
                <DL>
                  <xsl:apply-templates select="timeinfo"/>
                  <xsl:for-each select="srccurr">
                    <DT><B>Source currentness reference:</B></DT>
                    <DD><xsl:value-of/></DD>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="procstep">
            <DT><B>Step di realizzazione:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="procdesc">
                <DIV>
                  <DT><B>Descrizione del processo:</B></DT>
                  <PRE ID="original"><xsl:value-of/></PRE>      
                  <SCRIPT>fix(original)</SCRIPT>      
                </DIV>
                
              </xsl:for-each>

              <!-- ESRI Profile element  -->
              <xsl:for-each select="procsv">
                <DT><B>Process software and version:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="procdate">
                <DT><B>Data di fine processo:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="proctime">
                <DT><B>Process time:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ procsv | procdate | proctime)]"><BR/><BR/></xsl:if>

              <xsl:for-each select="srcused">
                <DT><B>Source used citation abbreviation:</B></DT>
                <DD><xsl:value-of/></DD>
              </xsl:for-each>
              <xsl:for-each select="srcprod">
                <DT><B>Source produced citation abbreviation:</B></DT>
                <DD><xsl:value-of/></DD>
              </xsl:for-each>
              <xsl:if test="context()[($any$ srcused | srcprod)]"><BR/><BR/></xsl:if>

              <xsl:for-each select="proccont">
                <DT><B>Process contact:</B></DT>
                <DD>
                <DL>
                  <xsl:apply-templates select="cntinfo"/>
                </DL>
                </DD>
                <xsl:if test="context()[not (cntinfo/*)]"><BR/></xsl:if>
              </xsl:for-each>
            </DL>
            </DD>
          </xsl:for-each>
        <!--</DL>
        </DD>-->
      </xsl:for-each>
      <xsl:for-each select="cloud">
        <DT><B>Cloud cover:</B> <xsl:value-of/></DT>
      </xsl:for-each>
    </DL>
    </DD>
  </DL>
  <A HREF="#Top">Torna all'Indice</A>
</xsl:template>

--------

<!-- Spatial Data Organization -->
<xsl:template match="spdoinfo">
  <A name="Spatial_Data_Organization_Information"><HR/></A>
  <DL>
    <DT><FONT size="2"><B>Informazioni sulla organizzazione dei dati spaziali:</B></FONT></DT>
    <BR/><BR/>
    <DD>
    <DL>
      <xsl:for-each select="indspref">
        <DT><B>Sistema di riferimento indiretto:</B></DT>
        <DD><xsl:value-of/></DD>
        <BR/><BR/>
      </xsl:for-each>

      <xsl:for-each select="direct">
        <DT><xsl:if test="context()[@Sync = 'TRUE']">
            <FONT color="#2E8B00">*</FONT></xsl:if><B>Metodo di riferimento spaziale diretto:</B> <xsl:value-of/></DT>
        <BR/><BR/>
      </xsl:for-each>

      <!--Fede<xsl:for-each select="ptvctinf">
        <DT><B>Point and vector object information:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="sdtsterm">
            <DT><B>SDTS terms description:</B></DT>
            <DD>
            <DL>
              ESRI Profile element  
              <xsl:for-each select="@Name">
                <DT><FONT color="#2E8B00">*</FONT><B>Name:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="sdtstype">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>SDTS point and vector object type:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="ptvctcnt">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Point and vector object count:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="vpfterm">
            <DT><B>VPF terms description:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="vpflevel">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>VPF topology level:</B> <xsl:value-of/></DT>
                <BR/><BR/>
              </xsl:for-each>
              <xsl:for-each select="vpfinfo">
                <DT><B>VPF point and vector object information:</B></DT>
                <DD>
                <DL>
                  ESRI Profile element
                  <xsl:for-each select="@Name">
                    <DT><FONT color="#2E8B00">*</FONT><B>Name:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="vpftype">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>VPF point and vector object type:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="ptvctcnt">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Point and vector object count:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>
            </DL>
            </DD>
          </xsl:for-each>-->

          <!-- ESRI Profile element  -->
          <xsl:for-each select="//esriterm">
            <DT><B>Descrizione ESRI:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="@Name">
                <DT><FONT color="#2E8B00">*</FONT><B>Nome:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="efeatyp">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo di oggetti:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="efeageom">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo di geometria:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="esritopo">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Presenza di topologia:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="efeacnt">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Numero di oggetti:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="spindex">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Presenza di indici spaziali:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="linrefer">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Presenza di referenziazione lineare:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <!--<xsl:for-each select="netwrole">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Network role:</B> <xsl:value-of /></DT>
              </xsl:for-each>-->
              <xsl:for-each select="featdesc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Descrizione degli oggetti:</B> <xsl:value-of /></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>
        <!--Fede</DL>
        </DD>
      </xsl:for-each>-->

      <xsl:for-each select="rastinfo">
        <DT><B>Descrizione dei dati raster:</B></DT>
        <DD>
        <DL>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="rastifor">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Formato del raster:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="rastityp">
            <DT><B>Tipo di raster:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="rastband">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Numero di bande:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- <xsl:if test="context()[($any$ rastifor | rastityp | rastband)]"><BR/><BR/></xsl:if>-->

          <xsl:for-each select="rowcount">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Righe:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="colcount">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Colonne:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="vrtcount">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Livelli:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!--<xsl:if test="context()[($any$ rowcount | colcount | vrtcount)]"><BR/><BR/></xsl:if>-->

          <!-- ESRI Profile element  
          <xsl:for-each select="rastxsz">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Cell size X direction:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          ESRI Profile element  
          <xsl:for-each select="rastxu">
            <DT><B>Cell size X units:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          ESRI Profile element
          <xsl:for-each select="rastysz">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Cell size Y direction:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          ESRI Profile element  
          <xsl:for-each select="rastyu">
            <DT><B>Cell size Y units:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:if test="context()[($any$ rastxsz | rastxu | rastysz | rastyu)]"><BR/><BR/></xsl:if>-->

          <!-- ESRI Profile element  -->
          <xsl:for-each select="rastbpp">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Bits per pixel:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element 
          <xsl:for-each select="rastnodt">
            <DT><B>Background nodata value:</B> <xsl:value-of/></DT>
          </xsl:for-each> -->
          <!-- ESRI Profile element  -->
          <xsl:for-each select="rastplyr">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Presenza piramide:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="rastcmap">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Mappa colori:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="rastcomp">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo di compressione:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!--<xsl:if test="context()[($any$ rastbpp | rastnodt | rastplyr | rastcmap | rastcomp)]"><BR/><BR/></xsl:if>-->

          <xsl:for-each select="rasttype">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo di raster:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <!-- ESRI Profile element 
          <xsl:for-each select="rastdtyp">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Raster display type:</B> <xsl:value-of/></DT>
          </xsl:for-each> -->
          <!-- ESRI Profile element  -->
          <xsl:for-each select="rastorig">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Origine:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:if test="context()[($any$ rasttype | rastdtyp | rastorig)]"><BR/><BR/></xsl:if>
        </DL>
        </DD>
      </xsl:for-each>

      <!-- ESRI Profile element  -->
      <xsl:for-each select="netinfo">
        <DT><B>Descrizione dati network:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="nettype">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo di network:</B> <xsl:value-of/></DT>
            <BR/><BR/>
          </xsl:for-each>
          <xsl:for-each select="connrule">
            <DT><B>Regole di connettività (solo GeoDB):</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="ruletype">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="rulecat">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Categoria:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="rulehelp">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Help:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ ruletype | rulecat | rulehelp)]"><BR/><BR/></xsl:if>

              <xsl:for-each select="rulefeid">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>From edge FC:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="rulefest">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>From edge subtype:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="ruleteid">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>To edge FC:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="ruletest">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>To edge subtype:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ rulefeid | rulefest | ruleteid | ruletest)]"><BR/><BR/></xsl:if>
              
              <xsl:for-each select="ruledjid">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Default junction FC:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="ruledjst">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Default junction subtype:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!--Fede<xsl:for-each select="rulejunc">
                <DT><B>Available junctions:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="junctid">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Junction feature class:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="junctst">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Junction subtype:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>
              <xsl:if test="context()[($any$ rulefeid | rulefest) and not (rulejunc)]"><BR/><BR/></xsl:if>

              <xsl:for-each select="ruleeid">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Edge feature class:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="ruleest">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Edge subtype:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="ruleemnc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Edge minimum cardinality:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="ruleemxc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Edge maximum cardinality:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ ruleeid | ruleest | ruleemnc | ruleemxc)]"><BR/><BR/></xsl:if>

              <xsl:for-each select="rulejid">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Junction feature class:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="rulejst">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Junction subtype:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="rulejmnc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Junction minimum cardinality:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="rulejmxc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Junction maximum cardinality:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ rulejid | rulejst | rulejmnc | rulejmxc)]"><BR/><BR/></xsl:if>-->
            </DL>
            </DD>
          </xsl:for-each>
          
          <!--Fede<xsl:for-each select="elemcls">
            <DT><B>Network element:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="roletype">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Ancillary role:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="rolefld">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Ancillary role attribute:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="enabfld">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Enabled attribute:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>-->
        </DL>
        </DD>
      </xsl:for-each>
    </DL>
    </DD>
  </DL>
  <A HREF="#Top">Torna all'Indice</A>
</xsl:template>

--------

<!-- Spatial Reference -->
<xsl:template match="spref">
  <A name="Spatial_Reference_Information"><HR/></A>
  <DL>
    <DT><FONT size="2"><B>Sistema di riferimento spaziale:</B></FONT></DT>
    <BR/><BR/>
    <DD>
    <DL>
      <xsl:for-each select="horizsys">
        <DT><B>Definizione del sistema di coordinate planare:</B></DT>
        <DD>
        <DL>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="cordsysn">
            <DT><B>Nome del sistema di coordinate planare:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="projcsn">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome del sistema di coordinate proiettate:</B> <xsl:value-of /></DT>
              </xsl:for-each>
              <xsl:for-each select="geogcsn">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome del sistema di coordinate geografiche:</B> <xsl:value-of /></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="geograph">
            <DT><B>Sistema geografico:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="latres">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Risoluzione di latitudine:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="longres">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Risoluzione di longitudine:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="geogunit">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Unità di coordinate geografiche:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="planar">
            <DT><B>Sistema planare:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="mapproj">
                <DT><B>Proiezione:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="mapprojn">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome della proiezione:</B> <xsl:value-of/></DT>
                  </xsl:for-each>

                  <xsl:for-each select="albers">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Albers conical equal area:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="azimequi">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Azimuthal equidistant:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="equicon">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Equidistant conic:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="equirect">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Equirectangular:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="gvnsp">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>General vertical near-sided perspective:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="gnomonic">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Gnomonic:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="lamberta">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Lambert azimuthal equal area:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="lambertc">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Lambert conformal conic:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="mercator">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Mercator:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="modsak">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Modified stereographic for alaska:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="miller">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Miller cylindrical:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="obqmerc">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Oblique mercator:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="orthogr">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Orthographic:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="polarst">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Polar stereographic:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="polycon">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Polyconic:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="robinson">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Robinson:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="sinusoid">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Sinusoidal:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="spaceobq">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Space oblique mercator (Landsat):</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="stereo">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Stereographic:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="transmer">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Transverse mercator:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="vdgrin">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>van der Grinten:</B></DT>
                  </xsl:for-each>
                  <xsl:for-each select="mapprojp">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Map projection parameters:</B></DT>
                  </xsl:for-each>

                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="behrmann">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Behrmann:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="bonne">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Bonne:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="cassini">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Cassini:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="eckert1">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Eckert I:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="eckert2">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Eckert II:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="eckert3">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Eckert III:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="eckert4">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Eckert IV:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="eckert5">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Eckert V:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="eckert6">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Eckert VI:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="gallster">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Gall stereographic:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="loximuth">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Loximuthal:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="mollweid">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Mollweide:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="quartic">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Quartic authalic:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="winkel1">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Winkel I:</B></DT>
                  </xsl:for-each>
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="winkel2">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Winkel II:</B></DT>
                  </xsl:for-each>

                  <xsl:apply-templates select="*"/>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>

              <xsl:for-each select="gridsys">
                <DT><B>Grid coordinate system:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="gridsysn">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Grid coordinate system name:</B> <xsl:value-of/></DT>
                  </xsl:for-each>

                  <xsl:for-each select="utm">
                    <DT><B>Universal Transverse Mercator:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="utmzone">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>UTM zone number:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="transmer">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Transverse mercator:</B></DT>
                      </xsl:for-each>
                      <xsl:apply-templates select="transmer"/>
                    </DL>
                    </DD>
                  </xsl:for-each>

                  <xsl:for-each select="ups">
                    <DT><B>Universal Polar Stereographic:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="upszone">
                        <DT><B>UPS zone identifier:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="polarst">
                        <DT><B>Polar stereographic:</B></DT>
                      </xsl:for-each>
                      <xsl:apply-templates select="polarst"/>
                    </DL>
                    </DD>
                  </xsl:for-each>

                  <xsl:for-each select="spcs">
                    <DT><B>State Plane Coordinate System:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="spcszone">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>SPCS zone identifier:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="lambertc">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Lambert conformal conic:</B></DT>
                      </xsl:for-each>
                      <xsl:apply-templates select="lambertc"/>
                      <xsl:for-each select="transmer">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Transverse mercator:</B></DT>
                      </xsl:for-each>
                      <xsl:apply-templates select="transmer"/>
                      <xsl:for-each select="obqmerc">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Oblique mercator:</B></DT>
                      </xsl:for-each>
                      <xsl:apply-templates select="obqmerc"/>
                      <xsl:for-each select="polycon">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Polyconic:</B></DT>
                      </xsl:for-each>
                      <xsl:apply-templates select="polycon"/>
                    </DL>
                    </DD>
                  </xsl:for-each>

                  <xsl:for-each select="arcsys">
                    <DT><B>ARC coordinate system:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="arczone">
                        <DT><B>ARC system zone identifier:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="equirect">
                        <DT><B>Equirectangular:</B></DT>
                      </xsl:for-each>
                      <xsl:apply-templates select="equirect"/>
                      <xsl:for-each select="azimequi">
                        <DT><B>Azimuthal equidistant:</B></DT>
                      </xsl:for-each>
                      <xsl:apply-templates select="azimequi"/>
                    </DL>
                    </DD>
                  </xsl:for-each>

                  <xsl:for-each select="othergrd">
                    <DT><B>Other grid system's definition:</B></DT>
                    <DD><xsl:value-of/></DD>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>

              <xsl:for-each select="localp">
                <DT><B>Local planar:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="localpd">
                    <DT><B>Local planar description:</B></DT>
                    <DD><xsl:value-of/></DD>
                  </xsl:for-each>
                  <xsl:for-each select="localpgi">
                    <DT><B>Local planar georeference information:</B></DT>
                    <DD><xsl:value-of/></DD>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>

              <xsl:for-each select="planci">
                <DT><B>Planar coordinate information:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="plance">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Planar coordinate encoding method:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="coordrep">
                    <DT><B>Coordinate representation:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="absres">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Abscissa resolution:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="ordres">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Ordinate resolution:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                    </DL>
                    </DD>
                  </xsl:for-each>
                  <xsl:for-each select="distbrep">
                    <DT><B>Distance and bearing representation:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="distres">
                        <DT><B>Distance resolution:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="bearres">
                        <DT><B>Bearing resolution:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="bearunit">
                        <DT><B>Bearing units:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="bearrefd">
                        <DT><B>Bearing reference direction:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="bearrefm">
                        <DT><B>Bearing reference meridian:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                    </DL>
                    </DD>
                  </xsl:for-each>
                  <xsl:for-each select="plandu">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Planar distance units:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>
            </DL>
            </DD>
          </xsl:for-each>

          <xsl:for-each select="local">
            <DT><B>Local:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="localdes">
                <DT><B>Local description:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="localgeo">
                <DT><B>Local georeference information:</B></DT>
                <DD><xsl:value-of/></DD>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="geodetic">
            <DT><B>Modello Geodetico:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="horizdn">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Horizontal datum name:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="ellips">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Ellipsoid name:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="semiaxis">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Semi-major axis:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="denflat">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Denominator of flattening ratio:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>
        </DL>
        </DD>
      </xsl:for-each>

      <xsl:for-each select="vertdef">
        <DT><B>Definizione del sistema di coordinate verticale:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="altsys">
            <DT><B>Altitude system definition:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="altdatum">
                <DT><B>Altitude datum name:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="altres">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Altitude resolution:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="altunits">
                <DT><B>Altitude distance rnits:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="altenc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Altitude encoding method:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="depthsys">
            <DT><B>Depth system definition:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="depthdn">
                <DT><B>Depth datum name:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="depthres">
                <DT><B>Depth resolution:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="depthdu">
                <DT><B>Depth distance units:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="depthem">
                <DT><B>Depth encoding method:</B> <xsl:value-of/></DT>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>
        </DL>
        </DD>
      </xsl:for-each>
    </DL>
    </DD>
  </DL>
  <A HREF="#Top">Torna all'Indice</A>
</xsl:template>

--------

<!-- Entity and Attribute -->
<xsl:template match="eainfo">
  <A name="Entity_and_Attribute_Information"><HR/></A>
  <DL>
    <DT><FONT size="2"><B>Informazioni sulle entità ed attributi:</B></FONT></DT>
    <BR/><BR/>
    <DD>
    <DL>
      <xsl:for-each select="detailed">
        <DT><B>Descrizione dettagliata:</B></DT>
        <DD>
        <DL>
          <!-- ESRI Profile element  -->
          <xsl:for-each select="@Name">
            <DT><FONT color="#2E8B00">*</FONT><B>Nome:</B> <xsl:value-of/></DT>
            <BR/><BR/>
          </xsl:for-each>

          <xsl:for-each select="enttyp">
            <DT><B>Tipo di entità:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="enttypl">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!-- ESRI Profile element  -->
              <xsl:for-each select="enttypt">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!-- ESRI Profile element  -->
              <xsl:for-each select="enttypc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Numero:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="enttypd">
                <DT><B>Definizione estesa:</B></DT>
                <DD><xsl:value-of/></DD>
              </xsl:for-each>
              <xsl:for-each select="enttypds">
                <DT><B>Fonte:</B></DT>
                <DD><xsl:value-of/></DD>
              </xsl:for-each>
            </DL>
            </DD>
            <BR/>
          </xsl:for-each>

          <xsl:for-each select="attr">
            <DT><B>Attributo:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="attrlabl">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!-- ESRI Profile element  -->
              <xsl:for-each select="attalias">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Alias:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="attrdef">
                <DIV>
                  <DT><xsl:if test="context()[@Sync = 'TRUE']">
                      <FONT color="#2E8B00">*</FONT></xsl:if><B>Descrizione:</B></DT>
                  <PRE ID="original"><xsl:value-of/></PRE>      
                  <SCRIPT>fix(original)</SCRIPT>      
                </DIV>
              </xsl:for-each>
              <xsl:for-each select="attrdefs">
                <DIV>
                  <DT><xsl:if test="context()[@Sync = 'TRUE']">
                      <FONT color="#2E8B00">*</FONT></xsl:if><B>Fonte:</B></DT>
                  <PRE ID="original"><xsl:value-of/></PRE>      
                  <SCRIPT>fix(original)</SCRIPT>      
                </DIV>
              </xsl:for-each>
              <!--<xsl:if test="context()[($any$ attrlabl | attalias | attrdef | attrdefs)]"><BR/></xsl:if>
              <xsl:if test="context()[($any$ attrlabl | attalias) and not(attrdef | attrdefs)]"><BR/></xsl:if>-->

              <!-- ESRI Profile element  -->
              <xsl:for-each select="attrtype">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!-- ESRI Profile element  -->
              <xsl:for-each select="attwidth">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Lunghezza:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!-- ESRI Profile element  -->
              <xsl:for-each select="atprecis">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Precisione:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!-- ESRI Profile element 
              <xsl:for-each select="attscale">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Attribute scale:</B> <xsl:value-of/></DT>
              </xsl:for-each> -->
              <!-- ESRI Profile element 
              <xsl:for-each select="atoutwid">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Attribute output width:</B> <xsl:value-of/></DT>
              </xsl:for-each> -->
              <!-- ESRI Profile element  -->
              <xsl:for-each select="atnumdec">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Numero di decimali:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!-- ESRI Profile element  
              <xsl:for-each select="atindex">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Attribute indexed:</B> <xsl:value-of/></DT>
              </xsl:for-each>-->
              <xsl:if test="context()[($any$ attrtype | attwidth | atprecis | attscale | atoutwid | atnumdec | atindex)]"><BR/></xsl:if>

              <xsl:for-each select="attrdomv">
                <DT><B>Dominio dell'attributo:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="edom">
                    <DT><B>Dominio di valori:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="edomv">
                        <DT><B>Valore:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="edomvd">
                        <DIV>
                          <DT><B>Descrizione:</B></DT>
                          <PRE ID="original"><xsl:value-of/></PRE>      
                          <SCRIPT>fix(original)</SCRIPT>      
                        </DIV>
                      </xsl:for-each>
                      <!--<xsl:for-each select="edomvds">
                        <DIV>
                          <DT><B>Enumerated domain value definition source:</B></DT>
                          <PRE ID="original"><xsl:value-of/></PRE>      
                          <SCRIPT>fix(original)</SCRIPT>      
                        </DIV>
                      </xsl:for-each>
                      <xsl:for-each select="attr">
                        <DT><B>Attribute:</B> <xsl:value-of/></DT>
                      </xsl:for-each>-->
                    </DL>
                    </DD>
                    <!--Fede<BR/>-->
                  </xsl:for-each>

                  <xsl:for-each select="rdom">
                    <DT><B>Dominio di range:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="rdommin">
                        <DT><B>Minimo:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="rdommax">
                        <DT><B>Massimo:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <!-- ESRI Profile element  -->
                      <xsl:for-each select="rdommean">
                        <DT><B>Media:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <!-- ESRI Profile element  -->
                      <xsl:for-each select="rdomstdv">
                        <DT><B>Deviazione standard:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <!--<xsl:for-each select="attrunit">
                        <DT><B>Attribute units of measure:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="attrmres">
                        <DT><B>Attribute measurement resolution:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="attr">
                        <DT><B>Attribute:</B> <xsl:value-of/></DT>
                      </xsl:for-each>-->
                    </DL>
                    </DD>
                    <BR/>
                  </xsl:for-each>

                  <xsl:for-each select="codesetd">
                    <DT><B>Dominio di codici:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="codesetn">
                        <DT><B>Nome:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="codesets">
                        <DT><B>Fonte:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                    </DL>
                    </DD>
                    <BR/>
                  </xsl:for-each>

                  <xsl:for-each select="udom">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Dominio non rappresentabile:</B></DT>
                    <DD><xsl:value-of/></DD>
                    <BR/><BR/>
                  </xsl:for-each>
                </DL>
                </DD>
              </xsl:for-each>

             <!--<xsl:for-each select="begdatea">
                <DT><B>Beginning date of attribute values:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="enddatea">
                <DT><B>Ending date of attribute values:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ begdatea | enddatea)]"><BR/><BR/></xsl:if>-->

              <xsl:for-each select="attrvai">
                <DT><B>Informazioni sulla accuratezza dei valori:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="attrva">
                    <DT><B>Accuratezza dei valori dell'attributo:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <!--<xsl:for-each select="attrvae">
                    <DT><B>Attribute value accuracy explanation:</B></DT>
                    <DD><xsl:value-of/></DD>
                  </xsl:for-each>-->
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>
              <!--<xsl:for-each select="attrmfrq">
                <DT><B>Attribute measurement frequency:</B></DT>
                <DD><xsl:value-of/></DD>
                <BR/><BR/>
              </xsl:for-each>-->
            </DL>
            </DD>
          </xsl:for-each>

          <!-- ESRI Profile element  -->
          <xsl:for-each select="subtype">
            <DT><B>Info sui subtype:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="stname">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="stcode">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Codice:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ stname | stcode)]"><BR/><BR/></xsl:if>

              <xsl:for-each select="stfield">
                <DT><B>Attributi del subtype:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="stfldnm">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="stflddv">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Valore di default:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="stflddd">
                    <DT><B>Dominio definito per l'attributo:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="domname">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="domdesc">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Descrizione:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="domowner">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Proprietario:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="domfldtp">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo di attributo:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="domtype">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Tipo di dominio:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="mrgtype">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Regola di merge:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="splttype">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Regola di split:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                    </DL>
                    </DD>
                    <BR/>
                  </xsl:for-each>
                  <xsl:if test="context()[($any$ stfldnm | stflddv) and not (stflddd)]"><BR/><BR/></xsl:if>
                </DL>
                </DD>
              </xsl:for-each>
            </DL>
            </DD>
          </xsl:for-each>

          <!-- ESRI Profile element  -->
          <xsl:for-each select="relinfo">
            <DT><B>Informazioni sulle relazioni:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="reldesc">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Descrizione:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="relcard">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Cardinalità:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <!--<xsl:for-each select="relattr">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Attributed relationship:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="relcomp">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Composite relationship:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="relnodir">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Notification direction:</B> <xsl:value-of/></DT>
              </xsl:for-each>-->
              <xsl:if test="context()[($any$ reldesc | relcard | relattr | relcomp | relnodir)]"><BR/><BR/></xsl:if>

              <xsl:for-each select="otfcname">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Origine:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="otfcpkey">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>PK origine:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="otfcfkey">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>FK origine:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="dtfcname">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Destinazione:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="dtfcpkey">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>PK destinazione:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="dtfcfkey">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>FK destinazione:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ otfcname | otfcpkey | otfcfkey | dtfcname | dtfcpkey | dtfcfkey)]"><BR/><BR/></xsl:if>

              <xsl:for-each select="relflab">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Descrizione relazione diretta:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:for-each select="relblab">
                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Descrizione relazione inversa:</B> <xsl:value-of/></DT>
              </xsl:for-each>
              <xsl:if test="context()[($any$ relflab | relblab)]"><BR/><BR/></xsl:if>
            </DL>
            </DD>
          </xsl:for-each>
        </DL>
        </DD>
      </xsl:for-each>

      <!--<xsl:for-each select="overview">
        <DT><B>Overview description:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="eaover">
            <DIV>
              <DT><B>Entity and attribute overview:</B></DT>
              <PRE ID="original"><xsl:value-of/></PRE>      
              <SCRIPT>fix(original)</SCRIPT>      
            </DIV>
            <BR/>
          </xsl:for-each>
          <xsl:for-each select="eadetcit">
            <DIV>
              <DT><B>Entity and attribute detail citation:</B></DT>
              <PRE ID="original"><xsl:value-of/></PRE>      
              <SCRIPT>fix(original)</SCRIPT>      
            </DIV>
            <BR/>
          </xsl:for-each>
        </DL>
        </DD>
      </xsl:for-each>-->
    </DL>
    </DD>
  </DL>
  <A HREF="#Top">Torna all'Indice</A>
</xsl:template>

--------

<!-- Distribution -->
<xsl:template match="distinfo">
  <A>
    <xsl:attribute name="NAME"><xsl:eval>uniqueID(this)</xsl:eval></xsl:attribute>
    <HR/>
  </A>
  <DL>
    <DT><FONT size="2"><B>Informazioni sulla distribuzione:</B></FONT> </DT>
    <BR/><BR/>
    <DD>
    <DL>
      <xsl:for-each select="distrib">
        <DT><B>Distributore:</B></DT>
        <DD>
        <DL>
          <xsl:apply-templates select="cntinfo"/>
        </DL>
        </DD>
        <xsl:if test="context()[not (cntinfo/*)]"><BR/></xsl:if>
      </xsl:for-each>

      <!--<xsl:for-each select="resdesc">
        <DT><B>Resource description:</B> <xsl:value-of/></DT>
        <BR/><BR/>
      </xsl:for-each>-->
      <xsl:for-each select="distliab">
        <DIV>
          <DT><B>Restrizioni all'uso:</B></DT>
          <PRE ID="original"><xsl:value-of/></PRE>      
          <SCRIPT>fix(original)</SCRIPT>      
        </DIV>
        <BR/>
      </xsl:for-each>

      <xsl:for-each select="stdorder">
        <DT><B>Processo standard di ordine:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="nondig">
            <DT><B>Formato non digitale:</B></DT>
            <DD><xsl:value-of/></DD>
            <BR/><BR/>
          </xsl:for-each>
          <xsl:for-each select="digform">
            <DT><B>Formato digitale:</B></DT>
            <DD>
            <DL>
              <xsl:for-each select="digtinfo">
                <DT><B>Trasmissione digitale:</B></DT>
                <DD>
                <DL>
                  <xsl:for-each select="formname">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Formato disponibile:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <!--<xsl:for-each select="formvern">
                    <DT><B>Format version number:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="formverd">
                    <DT><B>Format version date:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="formspec">
                    <DIV>
                      <DT><B>Format specification:</B></DT>
                      <PRE ID="original"><xsl:value-of/></PRE>      
                      <SCRIPT>fix(original)</SCRIPT>      
                    </DIV>
                  </xsl:for-each>
                  <xsl:for-each select="formcont">
                    <DIV>
                      <DT><B>Format information content:</B></DT>
                      <PRE ID="original"><xsl:value-of/></PRE>      
                      <SCRIPT>fix(original)</SCRIPT>      
                    </DIV>
                  </xsl:for-each>
                  <xsl:for-each select="filedec">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>File decompression technique:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                  <xsl:for-each select="transize">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Transfer size:</B> <xsl:value-of/></DT>
                  </xsl:for-each>-->
                  <!-- ESRI Profile element  -->
                  <xsl:for-each select="dssize">
                    <DT><xsl:if test="context()[@Sync = 'TRUE']">
                        <FONT color="#2E8B00">*</FONT></xsl:if><B>Dimensioni del dataset:</B> <xsl:value-of/></DT>
                  </xsl:for-each>
                </DL>
                </DD>
                <BR/>
              </xsl:for-each>

              <xsl:for-each select="digtopt">
                <!--<DT><B>Digital transfer option:</B></DT>
                <DD>
                <DL>-->
                  <xsl:for-each select="onlinopt">
                    <DT><B>Opzione online:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="computer">
                        <DT><B>Informazioni sulla collocazione in rete:</B></DT>
                        <DD>
                        <DL>
                          <xsl:for-each select="networka">
                            <DT><B>Indirizzo di rete:</B></DT>
                            <DD>
                            <DL>
                              <xsl:for-each select="networkr">
                                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Percorso di rete:</B> <A TARGET="viewer">
                                  <xsl:attribute name="HREF"><xsl:value-of/></xsl:attribute>
                                  <xsl:value-of/></A>
                                </DT>
                              </xsl:for-each>
                            </DL>
                            </DD>
                            <BR/>
                          </xsl:for-each>

                          <!--<xsl:for-each select="dialinst">
                            <DT><B>Dialup instructions:</B></DT>
                            <DD>
                            <DL>
                              <xsl:for-each select="lowbps">
                                <DT><B>Lowest BPS:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <xsl:for-each select="highbps">
                                <DT><B>Highest BPS:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <xsl:for-each select="numdata">
                                <DT><B>Number databits:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <xsl:for-each select="numstop">
                                <DT><B>Number stopbits:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <xsl:for-each select="parity">
                                <DT><B>Parity:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <xsl:for-each select="compress">
                                <DT><B>Compression support:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <xsl:for-each select="dialtel">
                                <DT><B>Dialup telephone:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <xsl:for-each select="dialfile">
                                <DT><B>Dialup file name:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                            </DL>
                            </DD>
                            <BR/>
                          </xsl:for-each>-->

                          <!-- ESRI Profile element  -->
                          <xsl:for-each select="sdeconn">
                            <DT><B>Informazioni sulla connessione SDE:</B></DT>
                            <DD>
                            <DL>
                              <xsl:for-each select="server">
                                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Server:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <xsl:for-each select="instance">
                                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Istanza:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <!--<xsl:for-each select="database">
                                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Database name:</B> <xsl:value-of/></DT>
                              </xsl:for-each>-->
                              <xsl:for-each select="user">
                                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Utente:</B> <xsl:value-of/></DT>
                              </xsl:for-each>
                              <!--<xsl:for-each select="version">
                                <DT><xsl:if test="context()[@Sync = 'TRUE']">
                                    <FONT color="#2E8B00">*</FONT></xsl:if><B>Version name:</B> <xsl:value-of/></DT>
                              </xsl:for-each>-->
                            </DL>
                            </DD>
                            <BR/>
                          </xsl:for-each>
                        </DL>
                        </DD>
                      </xsl:for-each>
                      <!--<xsl:for-each select="accinstr">
                        <DT><xsl:if test="context()[@Sync = 'TRUE']">
                            <FONT color="#2E8B00">*</FONT></xsl:if><B>Access instructions:</B></DT>
                        <DD><xsl:value-of/></DD>
                      </xsl:for-each>
                      <xsl:for-each select="oncomp">
                        <DT><B>Online computer and operating system:</B></DT>
                        <DD><xsl:value-of/></DD>
                      </xsl:for-each>-->
                      <xsl:if test="context()[($any$ accinstr | oncomp)]"><BR/><BR/></xsl:if>
                    </DL>
                    </DD>
                  </xsl:for-each>

                  <xsl:for-each select="offoptn">
                    <DT><B>Opzione offline:</B></DT>
                    <DD>
                    <DL>
                      <xsl:for-each select="offmedia">
                        <DT><B>Supporto:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <!--<xsl:for-each select="reccap">
                        <DT><B>Recording capacity:</B></DT>
                        <DD>
                        <DL>
                          <xsl:for-each select="recden">
                            <DT><B>Recording density:</B> <xsl:value-of/></DT>
                          </xsl:for-each>
                          <xsl:for-each select="recdenu">
                            <DT><B>Recording density Units:</B> <xsl:value-of/></DT>
                          </xsl:for-each>
                        </DL>
                        </DD>
                      </xsl:for-each>
                      <xsl:for-each select="recfmt">
                        <DT><B>Recording format:</B> <xsl:value-of/></DT>
                      </xsl:for-each>
                      <xsl:for-each select="compat">
                        <DT><B>Compatibility information:</B></DT>
                        <DD><xsl:value-of/></DD>
                      </xsl:for-each>-->
                    </DL>
                    </DD>
                    <BR/>
                  </xsl:for-each>
                <!--</DL>
                </DD>-->
              </xsl:for-each>
            </DL>
            </DD>
          </xsl:for-each>

          <xsl:for-each select="fees">
            <DT><B>Prezzo:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="ordering">
            <DIV>
              <DT><B>Istruzioni per l'ordine:</B></DT>
              <A TARGET="viewer">
              <xsl:attribute name="HREF"><xsl:value-of/></xsl:attribute>
              <xsl:value-of/></A>                   
            </DIV>
          </xsl:for-each>
          <!--<xsl:for-each select="turnarnd">
            <DT><B>Turnaround:</B> <xsl:value-of/></DT>
          </xsl:for-each>-->
          <xsl:if test="context()[($any$ fees | ordering | turnarnd)]"><BR/><BR/></xsl:if>
        </DL>
        </DD>
      </xsl:for-each>

      <!--<xsl:for-each select="custom">
        <DIV>
          <DT><B>Custom order process:</B></DT>
          <PRE ID="original"><xsl:value-of/></PRE>      
          <SCRIPT>fix(original)</SCRIPT>      
        </DIV>
      </xsl:for-each>
      <xsl:for-each select="techpreq">
        <DT><B>Technical prerequisites:</B></DT>
        <DD><xsl:value-of/></DD>
      </xsl:for-each>
      <xsl:if test="context()[($any$ custom | techpreq)]"><BR/><BR/></xsl:if>

      <xsl:for-each select="availabl">
        <DT><B>Available time period:</B></DT>
        <DD>
        <DL>
          <xsl:apply-templates select="timeinfo"/>
        </DL>
        </DD>
      </xsl:for-each>-->
    </DL>
    </DD>
  </DL>
  <A HREF="#Top">Torna all'Indice</A>
</xsl:template>

--------

<!-- Metadata -->
<xsl:template match="metainfo">
  <A name="Metadata_Reference_Information"><HR/></A>
  <DL>
    <DT><FONT size="2"><B>Informazioni di riferimento sul metadata:</B></FONT></DT>
    <BR/><BR/>
    <DD>
    <DL>
      <xsl:for-each select="metd">
        <DT><xsl:if test="context()[@Sync = 'TRUE']">
            <FONT color="#2E8B00">*</FONT></xsl:if><B>Data di ultima modifica (aaaa/mm/gg):</B> <xsl:value-of/></DT>
      </xsl:for-each>
      <xsl:for-each select="metrd">
        <DT><B>Datadi ultima revisione:</B> <xsl:value-of/></DT>
      </xsl:for-each>
      <!--<xsl:for-each select="metfrd">
        <DT><B>Metadata future Rreview date:</B> <xsl:value-of/></DT>
      </xsl:for-each>-->
      <xsl:if test="context()[($any$ metd | metrd | metfrd)]"><BR/><BR/></xsl:if>

      <!-- ESRI Profile element  -->
      <xsl:for-each select="langmeta">
        <DT><xsl:if test="context()[@Sync = 'TRUE']">
            <FONT color="#2E8B00">*</FONT></xsl:if><B>Lingua del metadata:</B> <xsl:value-of/></DT>
        <BR/><BR/>
      </xsl:for-each>

      <!--<xsl:for-each select="metc">
        <DT><B>Contatto per i metadati:</B></DT>
        <DD>
        <DL>
          <xsl:apply-templates select="cntinfo"/>
        </DL>
        </DD>
        <xsl:if test="context()[not (cntinfo/*)]"><BR/></xsl:if>
      </xsl:for-each>-->

      <!--<xsl:for-each select="metstdn">
        <DT><xsl:if test="context()[@Sync = 'TRUE']">
            <FONT color="#2E8B00">*</FONT></xsl:if><B>Metadata standard name:</B> <xsl:value-of/></DT>
      </xsl:for-each>
      <xsl:for-each select="metstdv">
        <DT><xsl:if test="context()[@Sync = 'TRUE']">
            <FONT color="#2E8B00">*</FONT></xsl:if><B>Metadata standard version:</B> <xsl:value-of/></DT>
      </xsl:for-each>
      <xsl:for-each select="mettc">
        <DT><xsl:if test="context()[@Sync = 'TRUE']">
            <FONT color="#2E8B00">*</FONT></xsl:if><B>Metadata time convention:</B> <xsl:value-of/></DT>
      </xsl:for-each>
      <xsl:if test="context()[($any$ metstdn | metstdv | mettc)]"><BR/><BR/></xsl:if>

      <xsl:for-each select="metac">
        <DT><B>Metadata access constraints:</B> <xsl:value-of/></DT>
      </xsl:for-each>
      <xsl:for-each select="metuc">
        <DT><B>Metadata use constraints:</B></DT>
        <DD><xsl:value-of/></DD>
      </xsl:for-each>
      <xsl:if test="context()[($any$ metac | metuc)]"><BR/><BR/></xsl:if>

      <xsl:for-each select="metsi">
        <DT><B>Metadata security information:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="metscs">
            <DT><B>Metadata security classification system:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="metsc">
            <DT><B>Metadata security classification:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="metshd">
            <DT><B>Metadata security handling description:</B></DT>
            <DD><xsl:value-of/></DD>
          </xsl:for-each>
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>-->

      <xsl:for-each select="metextns">
        <DT><B>Informazioni aggiuntive:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="onlink">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Documentazione:</B> <A TARGET="viewer">
              <xsl:attribute name="HREF"><xsl:value-of/></xsl:attribute>
              <xsl:value-of/></A>
            </DT>
          </xsl:for-each>
          <!--<xsl:for-each select="metprof">
            <DT><xsl:if test="context()[@Sync = 'TRUE']">
                <FONT color="#2E8B00">*</FONT></xsl:if><B>Profile name:</B> <xsl:value-of/></DT>
          </xsl:for-each>-->
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>
    </DL>
    </DD>
  </DL>
  <A HREF="#Top">Torna all'Indice</A>
</xsl:template>

--------

<!-- ESRI Profile element  -->
<!-- Binary enclosures -->
<!--Fede<xsl:template match="Binary">
  <A name="Binary_Enclosures"><HR/></A>
  <DL>
    <DT><FONT color="#2E8B00" size="3"><B>Binary Enclosures:</B></DT>
    <BR/><BR/>
    <DD>
    <DL>
      <xsl:for-each select="Thumbnail">
        <DT><FONT color="#2E8B00"><B>Thumbnail:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="img">
            <DT><FONT color="#2E8B00"><B>Enclosure type:</B> Picture</DT>
            <BR/><BR/>
            <IMG ID="thumbnail" ALIGN="absmiddle" STYLE="height:144; 
                border:'2 outset #FFFFFF'; position:relative">
              <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
            </IMG>
          </xsl:for-each>
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>

      <xsl:for-each select="Enclosure">
        <DT><FONT color="#2E8B00"><B>Enclosure:</B></DT>
        <DD>
        <DL>
          <xsl:for-each select="*/@EsriPropertyType">
            <DT><FONT color="#2E8B00"><B>Enclosure type:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="img">
            <DT><FONT color="#2E8B00"><B>Enclosure type:</B> Image</DT>
           </xsl:for-each>
          <xsl:for-each select="*/@OriginalFileName">
            <DT><FONT color="#2E8B00"><B>Original file name:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="Descript">
            <DT><FONT color="#2E8B00"><B>Description of enclosure:</B> <xsl:value-of/></DT>
          </xsl:for-each>
          <xsl:for-each select="img">
            <DD>
              <BR/>
              <IMG STYLE="height:144; border:'2 outset #FFFFFF'; position:relative">
                <xsl:attribute name="TITLE"><xsl:value-of select="img/@OriginalFileName"/></xsl:attribute>
                <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
              </IMG>
            </DD>
           </xsl:for-each>
        </DL>
        </DD>
        <BR/>
      </xsl:for-each>
    </DL>
    </DD>
  </DL>
  <A HREF="#Top">Torna all'Indice</A>
</xsl:template>-->

--------

<!-- Citation -->
<xsl:template match="citeinfo">
  <!--Fede<DT><B>Citation information:</B></DT>
  <DD>
  <DL>-->
    <xsl:for-each select="title">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Titolo:</B></DT>
          <xsl:value-of/>
    </xsl:for-each>
    <xsl:if test="context()[title]"><BR/></xsl:if>
    
    <xsl:if test="context()[origin/text()]">
      
      <DT>      
      <xsl:for-each select="origin[text()]">
        <xsl:if test="context()[0]"><B>Autori:</B> </xsl:if>
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: The name of an organization or individual that developed the data set.']">
            <FONT color="#999999"><xsl:value-of /></FONT>
          </xsl:when>
          <xsl:when test="context()[. = 'The name of an organization or individual that developed the data set.  REQUIRED.']">
            <FONT color="#999999"><xsl:value-of /></FONT>
          </xsl:when>
          <xsl:otherwise><xsl:value-of /></xsl:otherwise>
        </xsl:choose><xsl:if test="context()[not(end())]">, </xsl:if>
      </xsl:for-each>
      </DT>
    </xsl:if>
    <xsl:if test="context()[origin]"></xsl:if>
    
    <!-- ESRI Profile element  -->
    <xsl:for-each select="ftname">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Nome del file o della tabella:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <xsl:if test="context()[($any$ title | ftname)]"><BR/></xsl:if>

    <!--Fede<xsl:for-each select="pubdate">
      <DT>
        <B>Publication date:</B> 
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: The date when the data set is published or otherwise made available for release.']">
            <FONT color="#999999"><xsl:value-of /></FONT>
          </xsl:when>
          <xsl:when test="context()[. = 'The date when the data set is published or otherwise made available for release.  REQUIRED']">
            <FONT color="#999999"><xsl:value-of /></FONT>
          </xsl:when>
          <xsl:otherwise><xsl:value-of/></xsl:otherwise>
        </xsl:choose>
      </DT>
    </xsl:for-each>
    <xsl:for-each select="pubtime">
      <DT><B>Publication time:</B> <xsl:value-of/></DT>
    </xsl:for-each>-->
    <xsl:for-each select="edition">
      <DT><B>Edizione:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <!--Fede<xsl:for-each select="geoform">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Geospatial data presentation form:</B> <xsl:value-of/></DT>
    </xsl:for-each>-->
    <xsl:if test="context()[($any$ pubdate | pubtime | edition | geoform)]"><BR/></xsl:if>

    <!--Fede<xsl:for-each select="serinfo">
      <DT><B>Series information:</B></DT>
      <DD>
      <DL>
        <xsl:for-each select="sername">
          <DT><B>Series name:</B> <xsl:value-of/></DT>
        </xsl:for-each>
        <xsl:for-each select="issue">
          <DT><B>Issue identification:</B> <xsl:value-of/></DT>
        </xsl:for-each>
      </DL>
      </DD>
      <BR/>
    </xsl:for-each>-->

    <!--Fede<xsl:for-each select="pubinfo">
      <DT><B>Publication information:</B></DT>
      <DD>
      <DL>
        <xsl:for-each select="pubplace">
          <DT><B>Publication place:</B> <xsl:value-of/></DT>
        </xsl:for-each>
        <xsl:for-each select="publish">
          <DT><B>Publisher:</B> <xsl:value-of/></DT>
        </xsl:for-each>
      </DL>
      </DD>
      <BR/>
    </xsl:for-each>

    <xsl:for-each select="othercit">
      <DT><B>Other citation details:</B></DT>
      <DD><xsl:value-of/></DD>
      <BR/><BR/>
    </xsl:for-each>-->

    <xsl:for-each select="onlink">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Localizzazione del dato:</B>         
        <xsl:value-of/>
      </DT>
    </xsl:for-each>
    <xsl:if test="context()[onlink]"><BR/><BR/></xsl:if>

    <!--Fede<xsl:for-each select="lworkcit">
      <DT><B>Larger work citation:</B></DT>
      <DD>
      <DL>
        <xsl:apply-templates select="citeinfo"/>
      </DL>
      </DD>
    </xsl:for-each>
  </DL>
  </DD>-->
</xsl:template>

--------

<!-- Contact -->
<xsl:template match="cntinfo">
  <DT><B>Informazioni sul punto di contatto:</B></DT>
  <DD>
  <DL>
    <!--<xsl:for-each select="cntperp">
      <DT><B>Contact person primary:</B></DT>
      <DD>
      <DL>
        <xsl:for-each select="cntper">
          <DT>
            <B>Contact person:</B>
            <xsl:choose>
              <xsl:when test="context()[. = 'REQUIRED: The person responsible for the metadata information.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:when test="context()[. = 'The person responsible for the metadata information.  REQUIRED.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </DT>
        </xsl:for-each>
        <xsl:for-each select="cntorg">
          <DT>
            <B>Contact organization:</B>
            <xsl:choose>
              <xsl:when test="context()[. = 'REQUIRED: The organization responsible for the metadata information.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:when test="context()[. = 'The organization responsible for the metadata information.  REQUIRED.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </DT>
        </xsl:for-each>
      </DL>
      </DD>
    </xsl:for-each>-->
    <xsl:for-each select="cntorgp">
      <DT><B>Punto di contatto:</B></DT>
      <DD>
      <DL>
        <xsl:for-each select="cntper">
          <DT>
            <B>Persona:</B>
            <xsl:choose>
              <xsl:when test="context()[. = 'REQUIRED: The person responsible for the metadata information.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:when test="context()[. = 'The person responsible for the metadata information.  REQUIRED.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </DT>
        </xsl:for-each>
        <xsl:for-each select="cntorg">
          <DT>
            <B>Organizzazione:</B>
            <xsl:choose>
              <xsl:when test="context()[. = 'REQUIRED: The organization responsible for the metadata information.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:when test="context()[. = 'The organization responsible for the metadata information.  REQUIRED.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </DT>
        </xsl:for-each>
      </DL>
      </DD>
    </xsl:for-each>
    <!--<xsl:for-each select="cntpos">
      <DT><B>Contact position:</B> <xsl:value-of/></DT>
    </xsl:for-each>-->
    <xsl:if test="context()[($any$ */cntper | */cntorg | cntpos)]"><BR/></xsl:if>
    <xsl:if test="context()[cntpos]"><BR/></xsl:if>

    <xsl:for-each select="cntaddr">
      <!--<DT><B>Contact address:</B></DT>
      <DD>
      <DL>-->
        <xsl:for-each select="addrtype">
          <DT>
            <B>Tipo di contatto:</B>
            <xsl:choose>
              <xsl:when test="context()[. = 'REQUIRED: The mailing and/or physical address for the organization or individual.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:when test="context()[. = 'The mailing and/or physical address for the organization or individual.  REQUIRED.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </DT>
        </xsl:for-each>
        <xsl:for-each select="address">
          <DIV>
            <DT><B>Indirizzo:</B></DT>
            <PRE ID="original"><xsl:value-of/></PRE>      
            <SCRIPT>fix(original)</SCRIPT>      
          </DIV>
        </xsl:for-each>
        <xsl:for-each select="city">
          <DT>
            <B>Citta:</B>
            <xsl:choose>
              <xsl:when test="context()[. = 'REQUIRED: The city of the address.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:when test="context()[. = 'The city of the address.  REQUIRED.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </DT>
        </xsl:for-each>
        <xsl:for-each select="state">
          <DT>
            <B>Provincia:</B>
            <xsl:choose>
              <xsl:when test="context()[. = 'REQUIRED: The state or province of the address.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:when test="context()[. = 'The state or province of the address.  REQUIRED.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </DT>
        </xsl:for-each>
        <xsl:for-each select="postal">
          <DT>
            <B>Codice postale:</B>
            <xsl:choose>
              <xsl:when test="context()[. = 'REQUIRED: The ZIP or other postal code of the address.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:when test="context()[. = 'The ZIP or other postal code of the address.  REQUIRED.']">
                <FONT color="#999999"><xsl:value-of /></FONT>
              </xsl:when>
              <xsl:otherwise><xsl:value-of /></xsl:otherwise>
            </xsl:choose>
          </DT>
        </xsl:for-each>
        <xsl:for-each select="country">
          <DT><B>Stato:</B> <xsl:value-of/></DT>
        </xsl:for-each>
      <!--</DL>
      </DD>-->
      <BR/>
    </xsl:for-each>

    <xsl:for-each select="cntvoice">
      <DT>
        <B>Telefono:</B>
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: The telephone number by which individuals can speak to the organization or individual.']">
            <FONT color="#999999"><xsl:value-of /></FONT>
          </xsl:when>
          <xsl:when test="context()[. = 'The telephone number by which individuals can speak to the organization or individual.  REQUIRED.']">
            <FONT color="#999999"><xsl:value-of /></FONT>
          </xsl:when>
          <xsl:otherwise><xsl:value-of /></xsl:otherwise>
        </xsl:choose>
      </DT>
    </xsl:for-each>
    <!--<xsl:for-each select="cnttdd">
      <DT><B>Contact TDD/TTY telephone:</B> <xsl:value-of/></DT>
    </xsl:for-each>-->
    <xsl:for-each select="cntfax">
      <DT><B>Fax:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <!--<xsl:if test="context()[($any$ cntvoice | cnttdd | cntfax)]"><BR/><BR/></xsl:if>-->

    <xsl:for-each select="cntemail">
      <DT><B>Email:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <!--<xsl:if test="context()[cntemail]"><BR/><BR/></xsl:if>-->

    <!--<xsl:for-each select="hours">
      <DT><B>Hours of service:</B> <xsl:value-of/></DT>
    </xsl:for-each>-->
    <xsl:for-each select="cntinst">
      <DT><B>Come contattare:</B></DT>
      <DIV>
        <PRE ID="original"><xsl:value-of/></PRE>      
        <SCRIPT>fix(original)</SCRIPT>      
      </DIV>
    </xsl:for-each>
    <xsl:if test="context()[($any$ hours | cntinst)]"><BR/></xsl:if>
    <xsl:if test="context()[($any$ hours | cntinst) and not (cntinst)]"><BR/><BR/></xsl:if>
  </DL>
  </DD>
</xsl:template>

--------

<!-- Time Period Info -->
<xsl:template match="timeinfo">
  <DT><B>Time period information:</B></DT>
  <DD>
  <DL>
    <xsl:apply-templates select="sngdate"/>
    <xsl:apply-templates select="mdattim"/>
    <xsl:apply-templates select="rngdates"/>
  </DL>
  </DD>
  <BR/>
</xsl:template>

<!-- Single Date/Time -->
<xsl:template match="sngdate">
  <DT><B>Single date/time:</B></DT>
  <DD>
  <DL>
    <xsl:for-each select="caldate">
      <DT>
        <B>Calendar date:</B>
        <xsl:choose>
          <xsl:when test="context()[. = 'REQUIRED: The year (and optionally month, or month and day) for which the data set corresponds to the ground.']">
            <FONT color="#999999"><xsl:value-of /></FONT>
          </xsl:when>
          <xsl:when test="context()[. = 'The year (and optionally month, or month and day) for which the data set corresponds to the ground.  REQUIRED.']">
            <FONT color="#999999"><xsl:value-of /></FONT>
          </xsl:when>
          <xsl:otherwise><xsl:value-of/></xsl:otherwise>
        </xsl:choose>
      </DT>
    </xsl:for-each>
    <xsl:for-each select="time">
      <DT><B>Time of day:</B> <xsl:value-of/></DT>
    </xsl:for-each>
  </DL>
  </DD>
</xsl:template>

<!-- Multiple Date/Time -->
<xsl:template match="mdattim">
  <DT><B>Multiple dates/times:</B></DT>
  <DD>
  <DL>
    <xsl:apply-templates select="sngdate"/>
  </DL>
  </DD>
</xsl:template>

<!-- Range of Dates/Times -->
<xsl:template match="rngdates">
  <DT><B>Range of dates/times:</B></DT>
  <DD>
  <DL>
    <xsl:for-each select="begdate">
      <DT><B>Beginning date:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <xsl:for-each select="begtime">
      <DT><B>Beginning time:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <xsl:for-each select="enddate">
      <DT><B>Ending date:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <xsl:for-each select="endtime">
      <DT><B>Ending time:</B> <xsl:value-of/></DT>
    </xsl:for-each>
  </DL>
  </DD>
</xsl:template>

--------

<!-- G-Ring -->
<xsl:template match="grngpoin">
  <DT><B>G-Ring point:</B></DT>
  <DD>
  <DL>
    <xsl:for-each select="gringlat">
      <DT><B>G-Ring latitude:</B> <xsl:value-of/></DT>
        </xsl:for-each>
        <xsl:for-each select="gringlon">
      <DT><B>G-Ring longitude:</B> <xsl:value-of/></DT>
    </xsl:for-each>
  </DL>
  </DD>
  <BR/>
</xsl:template>
<xsl:template match="gring">
  <DT><B>G-Ring:</B></DT>
  <DD><xsl:value-of/></DD>
  <BR/><BR/>
</xsl:template>

--------

<!-- Map Projections -->
<!-- Projections explicitly supported in the FGDC standard -->
<xsl:template match="albers | azimequi | equicon | equirect | gnomonic | gvnsp | lamberta | 
    lambertc | mercator | miller | modsak | obqmerc | orthogr | polarst | polycon | robinson | 
    sinusoid | spaceobq | stereo | transmer | vdgrin | mapprojp">
  <DL><xsl:apply-templates select="*"/></DL>
</xsl:template>

<!-- Used at 8.0 for projections not explicitly supported in FGDC; mapprojp used at 8.1 -->
<xsl:template match="behrmann | bonne | cassini | eckert1 | eckert2 | eckert3 | eckert4 | 
    eckert5 | eckert6 | gallster | loximuth | mollweid | quartic | winkel1 | winkel2">
  <DL><xsl:apply-templates select="*"/></DL>
</xsl:template>

<!-- Map Projection Parameters -->
<xsl:template match="stdparll">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Standard parallel:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="longcm">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Longitude of central meridian:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="latprjo">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Latitude of projection origin:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="feast">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>False easting:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="fnorth">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>False northing:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="sfequat">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Scale factor at equator:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="heightpt">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Height of perspective point above surface:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="longpc">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Longitude of projection center:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="latprjc">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Latitude of projection center:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="sfctrlin">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Scale factor at center line:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="obqlazim">
  <DT><B>Oblique line azimuth:</B></DT>
  <DD>
  <DL>
    <xsl:for-each select="azimangl">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Azimuthal angle:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <xsl:for-each select="azimptl">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Azimuthal measure point longitude:</B> <xsl:value-of/></DT>
    </xsl:for-each>
  </DL>
  </DD>
</xsl:template>

<xsl:template match="obqlpt">
  <DT><B>Oblique line point:</B></DT>
  <DD>
  <DL>
    <xsl:for-each select="obqllat">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Oblique line latitude:</B> <xsl:value-of/></DT>
    </xsl:for-each>
    <xsl:for-each select="obqllong">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Oblique line longitude:</B> <xsl:value-of/></DT>
    </xsl:for-each>
  </DL>
  </DD>
</xsl:template>

<xsl:template match="svlong">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Straight vertical longitude from pole:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="sfprjorg">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Scale factor at projection origin:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="landsat">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Landsat number:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="pathnum">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Path number:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="sfctrmer">
  <DT><xsl:if test="context()[@Sync = 'TRUE']">
      <FONT color="#2E8B00">*</FONT></xsl:if><B>Scale factor at central meridian:</B> <xsl:value-of/></DT>
</xsl:template>

<xsl:template match="otherprj">
  <xsl:choose>
    <xsl:when test="context()[*]">
      <DT><xsl:if test="context()[@Sync = 'TRUE']">
          <FONT color="#2E8B00">*</FONT></xsl:if><B>Other ESRI projection:</B></DT>
      <DL><xsl:apply-templates select="*"/></DL>
    </xsl:when>
    <xsl:otherwise>
      <DT><B>Other projection's definition:</B></DT>
      <DD><xsl:value-of/></DD>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>