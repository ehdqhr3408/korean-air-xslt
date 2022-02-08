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
		

		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pip="http://PIP_Service_Library/PIP_Processing" xmlns:pips="http://PIP_Service_Library/PIP_Session">
  	   <soapenv:Header>
					
                      <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']" />
		      <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']" />
	     </soapenv:Header>
       <xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']" />

		</soapenv:Envelope>

  </xsl:template>
</xsl:stylesheet>