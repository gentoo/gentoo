<?xml version="1.0" encoding="ISO-8859-1" ?>
 
<!-- 
Description:
    Stylesheet for converting the HTML documentation 
    for various ntp commands into proper manual pages 
    (in troff format).

Author:
    Per Cederberg, <per at percederberg dot net>
-->

<!DOCTYPE stylesheet [
<!ENTITY newline "
">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  
  <!-- ### INPUT PARAMETERS ### -->
  <xsl:param name="version" select="''" />


  <!-- ### OUTPUT DECLARATION ### -->
  <xsl:output method="text"
              encoding="ISO-8859-1" />

  <xsl:strip-space elements="html" />


  <!-- ### TEMPLATES ### -->
  <xsl:template match="/">
    <xsl:text>.\" Automatically generated from HTML source. </xsl:text>
    <xsl:text>DO NOT EDIT!&newline;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="head">
    <xsl:text>.TH </xsl:text>
    <xsl:value-of select="substring-before(title, ' ')" />
    <xsl:text> 1 "" "ntp </xsl:text>
    <xsl:value-of select="$version" />
    <xsl:text>"</xsl:text>
    <xsl:text>&newline;</xsl:text>
    <xsl:text>.SH NAME</xsl:text>
    <xsl:text>&newline;</xsl:text>
    <xsl:value-of select="title" />
    <xsl:text>&newline;</xsl:text>
  </xsl:template>

  <xsl:template match="body">
    <xsl:apply-templates select="*[preceding-sibling::hr]" />
  </xsl:template>

  <xsl:template match="h3">
  </xsl:template>

  <xsl:template match="h4">
    <xsl:variable name="text">
      <xsl:call-template name="stringToUpper">
        <xsl:with-param name="str" select="." />
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="name(preceding-sibling::*[1]) = 'tt'">
      <xsl:text>&newline;</xsl:text>
    </xsl:if>
    <xsl:text>.SH </xsl:text>
    <xsl:value-of select="$text" />
    <xsl:text>&newline;</xsl:text>
  </xsl:template>

  <xsl:template match="address">
    <xsl:text>.SH AUTHOR</xsl:text>
    <xsl:text>&newline;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="p">
    <xsl:variable name="text">
      <xsl:apply-templates />
    </xsl:variable>
    <xsl:if test="starts-with($text, 'Disclaimer:')">
      <xsl:text>&newline;</xsl:text>
    </xsl:if>
    <xsl:text>.P</xsl:text>
    <xsl:text>&newline;</xsl:text>
    <xsl:value-of select="$text" />
    <xsl:text>&newline;</xsl:text>
  </xsl:template>
 
  <xsl:template match="dd/p">
    <xsl:text>&newline;</xsl:text>
    <xsl:text>&newline;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>
 
  <xsl:template match="hr">
  </xsl:template>

  <xsl:template match="pre">
    <xsl:text>&newline;</xsl:text>
    <xsl:text>.ft CW</xsl:text>
    <xsl:text>&newline;</xsl:text>
    <xsl:text>.nf</xsl:text>
    <xsl:text>&newline;</xsl:text>
    <xsl:call-template name="trim-newlines">
      <xsl:with-param name="str" select="." />
    </xsl:call-template>
    <xsl:text>&newline;</xsl:text>
    <xsl:text>.ft R</xsl:text>
    <xsl:text>&newline;</xsl:text>
    <xsl:text>.fi</xsl:text>
    <xsl:text>&newline;</xsl:text>
  </xsl:template>

  <xsl:template match="ul">
  </xsl:template>

  <xsl:template match="nobr">
    <xsl:text> </xsl:text>
    <xsl:apply-templates />
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="dl">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="dt">
    <xsl:text>.TP&newline;</xsl:text>
    <xsl:text>.B </xsl:text>
    <xsl:value-of select="normalize-space(.)" />
    <xsl:text>&newline;</xsl:text>
  </xsl:template>

  <xsl:template match="dd">
    <xsl:apply-templates />
    <xsl:text>&newline;</xsl:text>
  </xsl:template>

  <xsl:template match="tr">
    <xsl:if test="position() &gt; 1">
      <xsl:apply-templates />
      <xsl:text>&newline;</xsl:text>
      <xsl:text>&newline;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tt">
    <xsl:text>&newline;</xsl:text>
    <xsl:text>\fB</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\fR </xsl:text>
  </xsl:template>

  <xsl:template match="i">
    <xsl:text>&newline;</xsl:text>
    <xsl:text>\fI</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\fR </xsl:text>
  </xsl:template>

  <xsl:template match="a">
    <xsl:text> </xsl:text>
    <xsl:apply-templates />
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="br">
    <xsl:text>&newline;</xsl:text>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)" />
  </xsl:template>


  <!-- ### HELPER FUNCTIONS ### -->
  <xsl:template name="stringToUpper">
    <xsl:param name="str" />
    <xsl:value-of select="translate($str,
                                    'abcdefghijklmnopqrstuvwxyz',
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
  </xsl:template>

  <xsl:template name="trim-newlines">
    <xsl:param name="str" />
    <xsl:choose>
      <xsl:when test="starts-with($str,'&newline;')">
        <xsl:call-template name="trim-newlines">
          <xsl:with-param name="str" select="substring($str, 2)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="trim-newlines-tail">
          <xsl:with-param name="str" select="$str" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="trim-newlines-tail">
    <xsl:param name="str" />
    <xsl:variable name="len" select="string-length($str)" />
    <xsl:choose>
      <xsl:when test="substring($str,$len) = '&newline;'">
        <xsl:call-template name="trim-newlines-tail">
          <xsl:with-param name="str" select="substring($str, 1, $len - 1)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
