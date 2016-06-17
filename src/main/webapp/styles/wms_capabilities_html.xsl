<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">

       <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	   
       <xsl:template match="WMT_MS_Capabilities">

			<h1><xsl:value-of select="Service/Title"/></h1>
			<h2><xsl:value-of select="Service/Abstract"/></h2>

			<p>GetMap - Format</p>
			<ul>
			<xsl:for-each select="Capability/Request/GetMap/Format">
				<li><xsl:value-of select="."/></li>
			</xsl:for-each>
			</ul>
			
			<p>GetFeatureInfo - Format</p>
			<ul>
			<xsl:for-each select="Capability/Request/GetFeatureInfo/Format">
				<li><xsl:value-of select="."/></li>
			</xsl:for-each>
			</ul>
			
			<p>Exception</p>
			<ul>
			<xsl:for-each select="Capability/Exception/Format">
				<li><xsl:value-of select="."/></li>
			</xsl:for-each>
			</ul>
			
			<p>Layer</p>
			
			<xsl:for-each select="Capability/Layer/Layer">
				<table>
					<tr>
						<td>Nome</td>
						<td><xsl:value-of select="Name"/></td>
					</tr>
					<tr>
						<td>Title</td>
						<td><xsl:value-of select="Title"/></td>
					</tr>
					<tr>
						<td>SRRS</td>
						<td><xsl:value-of select="SRS"/></td>
					</tr>
					<tr>
						<td>BoundingBox</td>
						<td><xsl:value-of select="LatLonBoundingBox/@minx"/> - <xsl:value-of select="LatLonBoundingBox/@miny"/> - <xsl:value-of select="LatLonBoundingBox/@maxx"/> - <xsl:value-of select="LatLonBoundingBox/@maxy"/></td>
					</tr>
					
					<tr>
						<td>Queryable</td>
						<td>
							<xsl:if test="@queryable='1'">
								si
							</xsl:if>
							<xsl:if test="@queryable='0'">
								no
							</xsl:if>
						</td>
					</tr>
					<xsl:if test="ScaleHint">
						<tr>
							<td>ScaleHint</td>
							<td>Min: <xsl:value-of select="ScaleHint/@min"/> - Max:  <xsl:value-of select="ScaleHint/@max"/></td>
						</tr>
					</xsl:if>
				</table>
				
				<xsl:if test="Style/LegendURL/OnlineResource/@xlink:href">
					<img src="{Style/LegendURL/OnlineResource/@xlink:href}" alt="Legenda {Title}"/> 
				</xsl:if>
				
			</xsl:for-each>
			
		
       </xsl:template>

</xsl:stylesheet>