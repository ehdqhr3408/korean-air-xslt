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
		<soapenv:Envelope  xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://xml.amadeus.com/2010/06/Types_v1" xmlns:iat="http://www.iata.org/IATA/2007/00/IATA2010.1" xmlns:app="http://xml.amadeus.com/2010/06/AppMdw_CommonTypes_v3" xmlns:hsf="http://xml.amadeus.com/HSFREQ_07_3_1A">
	  	  <soapenv:Header>
		  	   <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='To']" />
		  	   <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='From']" />
		  	   <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Action']" />
		  	   <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='MessageID']" />
		  	   <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']" />
		  	   <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='AMA_SecurityHostedUser']" />
	  	   </soapenv:Header>
	       <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']" />
		</soapenv:Envelope>

  </xsl:template>
</xsl:stylesheet>