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

		
		 <!-- Retail http -->
  	 <xsl:variable name="isECommerce"><xsl:value-of select="dp:variable('var://context/MYVAR/isECommerce')" /></xsl:variable>
  	 
	  <xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')" /></xsl:variable>
	  <xsl:variable name="requestSystem"><xsl:value-of select="dp:variable('var://context/MYVAR/requestSystem')"/></xsl:variable>
	  <xsl:variable name="employeeNo"><xsl:value-of select="dp:variable('var://context/MYVAR/employeeNo')"/></xsl:variable>
	  <xsl:variable name="lssUserId"><xsl:value-of select="dp:variable('var://context/MYVAR/lssUserId')"/></xsl:variable>
	  <xsl:variable name="officeId"><xsl:value-of select="dp:variable('var://context/MYVAR/officeId')"/></xsl:variable>
	  <xsl:variable name="wsap"><xsl:value-of select="dp:variable('var://context/MYVAR/wsap')"/></xsl:variable>
	  <xsl:variable name="sessionType"><xsl:value-of select="dp:variable('var://context/MYVAR/sessionType')"/></xsl:variable>
	  <xsl:variable name="sessionId"><xsl:value-of select="dp:variable('var://context/MYVAR/sessionId')"/></xsl:variable>
	  <xsl:variable name="sequenceNumber"><xsl:value-of select="dp:variable('var://context/MYVAR/sequenceNumber')"/></xsl:variable>
	  <xsl:variable name="securityToken"><xsl:value-of select="dp:variable('var://context/MYVAR/securityToken')"/></xsl:variable>
		<xsl:variable name="companyName"><xsl:value-of select="dp:variable('var://context/MYVAR/companyName')"/></xsl:variable><!--20130219 add-->
		<xsl:variable name="workstationId"><xsl:value-of select="dp:variable('var://context/MYVAR/workstationId')"/></xsl:variable><!--20130219 add-->

	  <xsl:variable name="dutyCode"><xsl:value-of select="dp:variable('var://context/MYVAR/dutyCode')"/></xsl:variable>
		<xsl:variable name="IFID"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')"/></xsl:variable>
		<xsl:variable name="procdtsndsyscd"><xsl:value-of select="dp:variable('var://context/MYVAR/procdtsndsyscd')" /></xsl:variable>
		<dp:set-http-request-header name="'X-procdtsndsyscd'" value="$procdtsndsyscd"/>	

		<dp:set-http-request-header name="'X-guid'" value="$guid"/>
		<dp:set-http-request-header name="'X-requestSystem'" value="$requestSystem"/>
		<dp:set-http-request-header name="'X-employeeNo'" value="$employeeNo"/>
		<dp:set-http-request-header name="'X-lssUserId'" value="$lssUserId"/>
		<dp:set-http-request-header name="'X-officeId'" value="$officeId"/>
		<dp:set-http-request-header name="'X-wsap'" value="$wsap"/>
		<dp:set-http-request-header name="'X-sessionType'" value="$sessionType"/>
		<dp:set-http-request-header name="'X-sessionId'" value="$sessionId"/>
		<dp:set-http-request-header name="'X-sequenceNumber'" value="$sequenceNumber"/>
		<dp:set-http-request-header name="'X-securityToken'" value="$securityToken"/>
		<dp:set-http-request-header name="'X-interfaceId'" value="$IFID"/>
		<dp:set-http-request-header name="'X-companyName'" value="$companyName"/><!--20130219 add-->
		<dp:set-http-request-header name="'X-workstationId'" value="$workstationId"/><!--20130219 add-->
		

<xsl:choose>
	<xsl:when test=" $isECommerce='true' ">
		<xsl:variable name="msg"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='E_Retail']/*[local-name()='request']/text()"  disable-output-escaping="yes"/></xsl:variable>
		<xsl:copy-of select="dp:parse($msg)" />
	</xsl:when>
	<xsl:otherwise>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:awss="http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd" xmlns:awsl="http://wsdl.amadeus.com/2010/06/ws/Link_v1">		
			<soapenv:Header>
				<wsa:To><xsl:value-of select="substring(dp:variable('var://service/URL-out'),1,number(string-length(dp:variable('var://service/URL-out'))))"/></wsa:To>
				<wsa:From>
					<wsa:Address><xsl:value-of select="dp:variable('var://service/URL-in')"/></wsa:Address>
				</wsa:From>
				<wsa:Action><xsl:value-of select="dp:http-request-header('SOAPAction')" /></wsa:Action>
				<wsa:MessageID><xsl:value-of select="$guid" /></wsa:MessageID>
				<awsl:TransactionFlowLink>
					<awsl:Consumer>    
						<awsl:UniqueID><xsl:value-of select="$guid" /></awsl:UniqueID>
					</awsl:Consumer>
				</awsl:TransactionFlowLink>
				<awss:Session>
					<awss:SessionId><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionId']/text()" /></awss:SessionId>
					<awss:SequenceNumber><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sequenceNumber']/text()" /></awss:SequenceNumber> 
					<awss:SecurityToken><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='securityToken']/text()" /></awss:SecurityToken>
				</awss:Session>
   		</soapenv:Header>
    	<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']" />
		</soapenv:Envelope>

	</xsl:otherwise>
</xsl:choose>	

  </xsl:template>
</xsl:stylesheet>