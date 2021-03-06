<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    exclude-result-prefixes="dp" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">   
			<xsl:variable name="wsaTo"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaTo')"/></xsl:variable>
			<xsl:variable name="wsaFrom"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaFrom')"/></xsl:variable>
			<xsl:variable name="wsaAction"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaAction')"/></xsl:variable>
			<xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')"/></xsl:variable>
			<xsl:variable name="BooleanFaultactor"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultactor'])" /></xsl:variable>
			<xsl:variable name="BooleanDetail"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='detail'])" /></xsl:variable>
		
			<xsl:variable name="sessionId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SessionId']/text()"/></xsl:variable>
			<xsl:variable name="sequenceNumber"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SequenceNumber']/text()"/></xsl:variable>
			<xsl:variable name="securityToken"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SecurityToken']/text()"/></xsl:variable>
		
			<xsl:variable name="BooleanSession"><xsl:value-of select="dp:variable('var://context/MYVAR/BooleanSession')"/></xsl:variable>
			<xsl:variable name="BooleanSecurityHostedUser"><xsl:value-of select="dp:variable('var://context/MYVAR/BooleanSecurityHostedUser')"/></xsl:variable>
		
			<xsl:variable name="headerSessionId"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSessionId')"/></xsl:variable>
			<xsl:variable name="headerSequenceNumber"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSequenceNumber')"/></xsl:variable>
			<xsl:variable name="headerSecurityToken"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSecurityToken')"/></xsl:variable>
		 	<xsl:variable name="headerSecurityHostedUser"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSecurityHostedUser')"/></xsl:variable>
		
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:pip="http://xml.amadeus.com/2010/06/Session_v3" xmlns:pip1="http://xml.amadeus.com/2010/06/Security_v1" xmlns:wsa="http://www.w3.org/2005/08/addressing">
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
            	<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']" />	
						</xsl:when>
					</xsl:choose>
 
				</soapenv:Header>				
				<soapenv:Body>					
					<soapenv:Fault>
						<faultcode><xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultcode']/text()" /></faultcode>
						<faultstring><xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultstring']/text()" /></faultstring>
						<xsl:choose>
							<xsl:when test=" $BooleanFaultactor = 'true' ">
								<faultactor><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultactor']/text()"/></faultactor>
							</xsl:when>
						</xsl:choose>	
						<xsl:choose>
							<xsl:when test=" $BooleanDetail = 'true' ">
								<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='detail']"/>
							</xsl:when>
						</xsl:choose>	
					</soapenv:Fault>			  		
				</soapenv:Body>
			</soapenv:Envelope>

    </xsl:template>
</xsl:stylesheet>