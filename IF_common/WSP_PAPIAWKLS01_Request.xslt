<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    extension-element-prefixes="dp"
    xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp dpconfig"
>
<xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
  <xsl:output encoding="UTF-8" version="1.0" method="xml"/>

  <xsl:template match="/">
  	
	  <xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')" /></xsl:variable>
    <xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('request ',string($guid))"/>
	  <xsl:variable name="requestSystem"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='requestSystem']/text()"/></xsl:variable>
	  <xsl:variable name="employeeNo"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='employeeNo']/text()"/></xsl:variable>
	  <xsl:variable name="lssUserId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='lssUserId']/text()"/></xsl:variable>
	  <xsl:variable name="officeId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='officeId']/text()"/></xsl:variable>
	  <xsl:variable name="dutyCode"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='dutyCode']/text()"/></xsl:variable>
	  <xsl:variable name="wsap"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='wsap']/text()"/></xsl:variable>
	  <xsl:variable name="sessionType"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionType']/text()"/></xsl:variable>
	  <xsl:variable name="interfaceId"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')" /></xsl:variable>
		<xsl:variable name="companyName"><xsl:value-of select="dp:variable('var://context/MYVAR/companyName')"/></xsl:variable><!--20130219 add-->
		<xsl:variable name="workstationId"><xsl:value-of select="dp:variable('var://context/MYVAR/workstationId')"/></xsl:variable><!--20130219 add-->
	        <xsl:variable name="procdtsndsyscd"><xsl:value-of select="dp:variable('var://context/MYVAR/procdtsndsyscd')" /></xsl:variable>
		<dp:set-http-request-header name="'X-procdtsndsyscd'" value="$procdtsndsyscd"/>	

		<dp:set-variable name="'var://context/MYVAR/requestSystem'" value="string($requestSystem)"/>
		<dp:set-variable name="'var://context/MYVAR/employeeNo'" value="string($employeeNo)"/>
		<dp:set-variable name="'var://context/MYVAR/sessionType'" value="string($sessionType)"/>

		<dp:set-http-request-header name="'X-requestSystem'" value="$requestSystem"/>
		<dp:set-http-request-header name="'X-employeeNo'" value="$employeeNo"/>
		<dp:set-http-request-header name="'X-lssUserId'" value="$lssUserId"/>
		<dp:set-http-request-header name="'X-officeId'" value="$officeId"/>
		<dp:set-http-request-header name="'X-wsap'" value="$wsap"/>
		<dp:set-http-request-header name="'X-sessionType'" value="$sessionType"/>
		<dp:set-http-request-header name="'X-interfaceId'" value="$interfaceId"/>
		<dp:set-http-request-header name="'X-companyName'" value="$companyName"/><!--20130219 add-->
		<dp:set-http-request-header name="'X-workstationId'" value="$workstationId"/><!--20130219 add-->
		
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
  </xsl:template>

</xsl:stylesheet>