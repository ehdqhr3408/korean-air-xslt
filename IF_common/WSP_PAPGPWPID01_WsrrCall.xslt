<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="dp"
    exclude-result-prefixes="dp" 
    xmlns:dpfunc="http://www.datapower.com/extensions/functions"
    xmlns:func="http://exslt.org/functions"
    xmlns:regexp="http://exslt.org/regular-expressions"
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    
    
    <xsl:include href="local:///IF_common/Func_WsrrCall.xsl"/>
    <xsl:include href="local:///IF_common/LoggingUtil.xsl"/>    
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">   
          <!-- GPS -->
		<xsl:variable name="IFID">
			<xsl:value-of select="dp:variable('var://context/MYVAR/IFID')"/>
		</xsl:variable>
    <xsl:variable name="WSRRQUERY">
    	<xsl:value-of select="func:getXquery('GPS',$IFID)"/>
    </xsl:variable>
    <!--LOG--><xsl:value-of select="func:LoggingError('wsrr xquery=',$WSRRQUERY)"/>		
		<xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')" /></xsl:variable>
		<!--LOG--><xsl:value-of select="func:LoggingError('wsrr call start============================',$guid)"/>

		<xsl:variable name="WSRRMetaInfo" select="func:WsrrCall($WSRRQUERY)"/>
		<!--LOG--><xsl:value-of select="func:LoggingError('wsrr call stop============================',$guid)"/>	 

  <!-- make soapaction(soapactionurl + xsdVersion) -->
	  <xsl:variable name="PIP_soapAction">
	  	<xsl:value-of select="dp:variable('var://context/MYVAR/PIP_soapActionUrl')"/>
	  	<xsl:value-of select="dp:variable('var://context/MYVAR/PIP_xsdVersion')"/>
	  </xsl:variable>
				  
	  <!-- 
	  	Setting service routing-url variable.	
	  	location + wsap
	  -->
	  <xsl:variable name="PIP_location">
	  	<xsl:value-of select="dp:variable('var://context/MYVAR/PIP_location')"/>
	  </xsl:variable>
			    
    <!-- Setting the context variable. -->
   	<dp:set-variable name="'var://context/MYVAR/PIP_soapAction'" value="string($PIP_soapAction)" />
   	<dp:set-variable name="'var://context/MYVAR/PIP_location'" value="string($PIP_location)" />
		    
    <!-- Soapaction set http request headers. -->
		<dp:set-http-request-header name="'SOAPAction'" value="$PIP_soapAction"/>
					
		<!-- location set service variable. -->
		<dp:set-variable name="'var://service/routing-url'" value="$PIP_location"/>
		
 		<!-- Setting PID user/password -->	  
		<xsl:variable name="security"><xsl:value-of select="dp:variable('var://context/MYVAR/PIP_security')"/></xsl:variable>
		<xsl:variable name="userid"><xsl:value-of select="substring-before($security, '|')"/></xsl:variable>
		<xsl:variable name="passwd"><xsl:value-of select="substring-after($security, '|')"/></xsl:variable>
		
		<!--LOG--><xsl:value-of select="func:LoggingDebug('security',$security)"/>
		<!--LOG--><xsl:value-of select="func:LoggingDebug('userid',$userid)"/>
 		<!--LOG--><xsl:value-of select="func:LoggingDebug('passwd',$passwd)"/>
 		
 		<!-- Making PID security header -->
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pip="http://PIP_Service_Library/PIP_Session" xmlns:pip1="http://PIP_Service_Library/PIP_Processing" xmlns:gps="http://GPS_Service_Library">
			 <soapenv:Header>
				<wsse:Security  xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
					<wsse:UsernameToken wsu:Id="UsernameToken-1" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
						<wsse:Username><xsl:value-of select="$userid" /></wsse:Username>
						<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">
							<xsl:value-of select="$passwd" />
						</wsse:Password>
					</wsse:UsernameToken>
				</wsse:Security>
	
	    	<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']" />
	    	<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']" />
	  	</soapenv:Header>
	    	<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']" />
		</soapenv:Envelope>
  
    <!--xsl:copy-of select="." /-->
    </xsl:template>
    
</xsl:stylesheet>
