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
	
	<xsl:variable name="wsaTo"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaTo')"/></xsl:variable>
	<xsl:variable name="wsaFrom"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaFrom')"/></xsl:variable>
	<xsl:variable name="wsaAction"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaAction')"/></xsl:variable>
	<xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')"/></xsl:variable>
	<xsl:variable name="BooleanSession"><xsl:value-of select="dp:variable('var://context/MYVAR/BooleanSession')"/></xsl:variable>
	
	<xsl:variable name="headerSessionId"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSessionId')"/></xsl:variable>
	<xsl:variable name="headerSequenceNumber"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSequenceNumber')"/></xsl:variable>
	<xsl:variable name="headerSecurityToken"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSecurityToken')"/></xsl:variable>
	  
	<xsl:variable name="interfaceId"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')" /></xsl:variable>
	<xsl:variable name="userName"><xsl:value-of select="dp:variable('var://context/MYVAR/userName')" /></xsl:variable>
	<xsl:variable name="bodyLongText"><xsl:value-of select="dp:variable('var://context/MYVAR/bodyLongText')" /></xsl:variable>
  <xsl:variable name="procdtsndsyscd"><xsl:value-of select="dp:variable('var://context/MYVAR/procdtsndsyscd')" /></xsl:variable>
  <xsl:variable name="codeId"><xsl:value-of select="dp:variable('var://context/MYVAR/codeId')" /></xsl:variable>

	<dp:set-http-request-header name="'X-interfaceId'" value="$interfaceId"/>	
	<dp:set-http-request-header name="'X-requestSystem'" value="$userName"/>	
	<dp:set-http-request-header name="'X-crypticCommand'" value="$bodyLongText"/>
  <dp:set-http-request-header name="'X-procdtsndsyscd'" value="$procdtsndsyscd"/>		


	<xsl:choose>	
	<xsl:when test=" $codeId='PIP.V07' ">
	<dp:remove-http-request-header name="SOAPAction"/>
  <dp:remove-http-request-header name="Host"/>
	<xsl:variable name="tscode"><xsl:value-of select="dp:variable('var://context/MYVAR/attrTransactionStatusCode')"/></xsl:variable>

		<xsl:if test=" 'Start' = $tscode">
			<dp:set-variable name="'var://context/MYVAR/attrTransactionStatusCode'" value="string('InSeries')" />
		</xsl:if> 	
		<xsl:variable name="tscode"><xsl:value-of select="dp:variable('var://context/MYVAR/attrTransactionStatusCode')"/></xsl:variable>
	
	<dp:set-variable name="'var://service/routing-url'" value="string('http://localhost:8090/loopBack')" />

			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"  
				xmlns:se="http://xml.amadeus.com/2010/06/Session_v3" 
				xmlns:wsa="http://www.w3.org/2005/08/addressing">
				<soapenv:Header>
					<wsa:To><xsl:value-of select="string('http://www.w3.org/2005/08/addressing/anonymous')" /></wsa:To>
					<wsa:From>
						<wsa:Address><xsl:value-of select="$wsaTo" /></wsa:Address>
					</wsa:From>
					<wsa:Action><xsl:value-of select="$wsaAction" /></wsa:Action>	
					<wsa:MessageID><xsl:value-of select="substring(dp:generate-uuid(),1,35)" /></wsa:MessageID>
					<wsa:RelatesTo RelationshipType="http://www.w3.org/2005/08/addressing/reply"><xsl:value-of select="$guid" /></wsa:RelatesTo>
					<xsl:choose>
						<xsl:when test=" $BooleanSession='true' ">	
             <!--xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']" /-->	
             	
             	<pip:Session TransactionStatusCode="{$tscode}" xmlns:pip="http://xml.amadeus.com/2010/06/Session_v3">	        
								<pip:SessionId><xsl:value-of select="$headerSessionId" /></pip:SessionId>
								<pip:SequenceNumber><xsl:value-of select="$headerSequenceNumber" /></pip:SequenceNumber>
								<pip:SecurityToken><xsl:value-of select="$headerSecurityToken" /></pip:SecurityToken>
						  </pip:Session>
						</xsl:when>
					</xsl:choose> 
				</soapenv:Header>				
		    <soapenv:Body>
		        <Command_CrypticReply xmlns="http://xml.amadeus.com/HSFRES_07_3_1A">
		            <longTextString>
		                <textStringDetails>INVALID ENTRY OR FORMAT</textStringDetails>
		            </longTextString>
		        </Command_CrypticReply>
		    </soapenv:Body>
		</soapenv:Envelope>
		
			</xsl:when>	
			<xsl:otherwise>
				<dp:accept />
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="' '"/>
	    		<xsl:copy-of select="." />
			</xsl:otherwise>
	</xsl:choose>	
		
  </xsl:template>
</xsl:stylesheet>