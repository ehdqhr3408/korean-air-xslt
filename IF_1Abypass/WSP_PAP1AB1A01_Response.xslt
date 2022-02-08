<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    extension-element-prefixes="dp"
    exclude-result-prefixes="dp dpconfig awsl wsa awss pip pip1 wsu"

>

<xsl:output encoding="UTF-8" version="1.0" method="xml"/>

<xsl:template match="/">
	
	<dp:remove-http-response-header name="SOAPAction"/>
  <dp:remove-http-response-header name="Host"/>	
<xsl:variable name="sessionId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SessionId']/text()"/></xsl:variable>
<xsl:variable name="sequenceNumber"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SequenceNumber']/text()"/></xsl:variable>
<xsl:variable name="securityToken"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SecurityToken']/text()"/></xsl:variable>
<xsl:variable name="CompanyName"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='AMA_SecurityHostedUser']/*[local-name()='UserID']/*[local-name()='RequestorID']/*[local-name()='CompanyName']/text()"/></xsl:variable>
<dp:set-variable name="'var://context/MYVAR/XresponseSystem'" value="dp:response-header('X-responseSystem')"/>


	<xsl:variable name="headerTo"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaTo')" /></xsl:variable>
	<xsl:variable name="headerFrom"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaFrom')" /></xsl:variable>
	<xsl:variable name="headerMessageID"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')" /></xsl:variable>
	<xsl:variable name="headerAction"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaAction')" /></xsl:variable>
	 <!--xsl:copy-of select="." /-->
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
		<soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:To><xsl:value-of select="string('http://www.w3.org/2005/08/addressing/anonymous')" /></wsa:To>
			<wsa:From>
				<wsa:Address><xsl:value-of select="$headerTo"/></wsa:Address>
			</wsa:From>
			<wsa:Action><xsl:value-of select="$headerAction"/></wsa:Action>
			<wsa:MessageID><xsl:value-of select="substring(dp:generate-uuid(),1,35)" /></wsa:MessageID>
			<wsa:RelatesTo RelationshipType="http://www.w3.org/2005/08/addressing/reply"><xsl:value-of select="$headerMessageID"/></wsa:RelatesTo>
	

   
	
			
			<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']" />
			
		</soapenv:Header>
<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']" />
				          
	</soapenv:Envelope>
</xsl:template>
</xsl:stylesheet>