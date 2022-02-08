<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    extension-element-prefixes="dp"
    exclude-result-prefixes="dp dpconfig"
>

  <xsl:output encoding="UTF-8" version="1.0" method="xml"/>

  <xsl:template match="/">


	  
	  <xsl:variable name="interfaceId"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')" /></xsl:variable>
	  <xsl:variable name="userName"><xsl:value-of select="dp:variable('var://context/MYVAR/userName')" /></xsl:variable>
	  <xsl:variable name="procdtsndsyscd"><xsl:value-of select="dp:variable('var://context/MYVAR/procdtsndsyscd')" /></xsl:variable>
		<dp:set-http-request-header name="'X-procdtsndsyscd'" value="$procdtsndsyscd"/>
		<dp:set-http-request-header name="'X-interfaceId'" value="$interfaceId"/>	
		<dp:set-http-request-header name="'X-requestSystem'" value="$userName"/>		
		<xsl:copy-of select="." />

  </xsl:template>
</xsl:stylesheet>