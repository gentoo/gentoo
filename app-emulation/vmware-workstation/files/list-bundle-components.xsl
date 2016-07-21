<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output omit-xml-declaration="yes"/>

	<xsl:template match="text()"/>

	<xsl:template match="/bundle/components/component">
		<xsl:value-of select="@offset"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@size"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
