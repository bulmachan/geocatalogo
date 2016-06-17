<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

       <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	   
       <xsl:template match="/">

		<xsl:choose>
               
			<xsl:when test="/FeatureInfoResponse/FIELDS">
				   
				<table class="tabella_balloon">
						<xsl:for-each select="/FeatureInfoResponse/FIELDS">
							 <xsl:for-each select="@*">
								<tr>
									<th>
										<xsl:value-of select="name()"/>
									</th>
									<td>
										<xsl:choose>

										  <xsl:when test="starts-with(.,'http') or starts-with(.,'/gstatico')">
											 <a  title="Apri collegamento" target="_blank" href="{.}">Apri</a>
										  </xsl:when>
										  <xsl:when test="starts-with(.,'gstatico')">
											 <a  title="Apri collegamento" target="_blank" href="/{.}">Apri</a>
										  </xsl:when>
										  <xsl:otherwise>
											<xsl:value-of select="."/>
										  </xsl:otherwise>
										</xsl:choose>
									</td>

								</tr>
							 </xsl:for-each>
						</xsl:for-each>
				</table>
				   
			</xsl:when>
			   
			<xsl:otherwise>
				<span>Nessun oggetto trovato.</span>
				   
			</xsl:otherwise>
		</xsl:choose> 

       </xsl:template>

</xsl:stylesheet>


