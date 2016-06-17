<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="/">
		<html>
			<head><title>Real's HowTo</title></head>

			<body>

				<table border="1">
					<xsl:for-each select="/metadata/Binary/Thumbnail">
						<tr>
						<td>
							<b><xsl:value-of select="Data" /></b>
						</td>
						</tr>
					</xsl:for-each>
				</table>

			</body>
		</html>

	</xsl:template>
</xsl:stylesheet>