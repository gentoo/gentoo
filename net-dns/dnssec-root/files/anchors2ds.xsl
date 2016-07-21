<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>

  <xsl:template match="/">
     <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/TrustAnchor">
     <xsl:apply-templates select="Zone"/>
     <xsl:apply-templates select="KeyDigest"/>
     <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="KeyDigest">
     <xsl:apply-templates select="KeyTag"/>
     <xsl:apply-templates select="Algorithm"/>
     <xsl:apply-templates select="DigestType"/>
     <xsl:apply-templates select="Digest"/>
  </xsl:template>

  <xsl:template match="Zone">
     <xsl:value-of select="text()"/><xsl:text> IN DS </xsl:text>
  </xsl:template>

  <xsl:template match="*">
     <xsl:value-of select="text()"/><xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>