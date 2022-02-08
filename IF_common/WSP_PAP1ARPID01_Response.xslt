<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    extension-element-prefixes="dp"
    exclude-result-prefixes="dp dpconfig awsl wsa awss"

>

<xsl:output encoding="UTF-8" version="1.0" method="xml"/>

<xsl:template match="/">
	<dp:set-variable name="'var://context/MYVAR/XresponseSystem'" value="dp:response-header('X-responseSystem')"/>
	
	<xsl:copy-of select="." />
</xsl:template>
</xsl:stylesheet>