<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    exclude-result-prefixes="dp" 
    xmlns:func="http://exslt.org/functions"
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
 
<xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
   <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">   
		  <xsl:variable name="faultcode"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultcode']/text()"/></xsl:variable>
		  <xsl:variable name="faultactor"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultactor']/text()"/></xsl:variable>
		  <xsl:variable name="faultstring"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultstring']/text()"/></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/XresponseSystem'" value="dp:response-header('X-responseSystem')"/>
			<dp:set-variable name="'var://context/MYVAR/faultactor'" value="string($faultactor)"/>
				    	
		  <xsl:variable name="codeId">
				<xsl:choose>
					<xsl:when test=" $faultactor='WESB' or contains ($faultcode,'ActionMismatch')">
					  <xsl:value-of select="string('PIP.I01')" /> 
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test=" contains ($faultstring,'PIP.E02') ">
							  <xsl:value-of select="string('PIP.E02')" /> 
							</xsl:when>
							<xsl:when test=" contains ($faultstring,'PIP.T01') ">
							  <xsl:value-of select="string('PIP.T01')" /> 
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="string('PIP.E01')" /> 	
							</xsl:otherwise>
						</xsl:choose>		
					</xsl:otherwise>
				</xsl:choose>	
	    </xsl:variable>
	    
	    <dp:set-variable name="'var://context/MYVAR/codeId'" value="string($codeId)"/>
			<xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('getWdpErrorCode start',$codeId)"/>
	    <xsl:variable name="ErrorCodeResult" select="func:getWdpErrorCode('PIP_ERROR_01',$codeId)"/>
	    <xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('getWdpErrorCode End',$ErrorCodeResult)"/>

			<xsl:variable name="errorMsg">
				<xsl:choose>
					<xsl:when test=" $codeId = 'PIP.E01' ">
						<xsl:value-of select="string($faultstring)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="dp:variable('var://context/MYVAR/codeType')"/>|<xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/>
			 		</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>			

			<xsl:variable name="customerErrorCode"><xsl:value-of select="dp:variable('var://context/MYVAR/customerErrorCode')"/></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/errorCode'" value="string($customerErrorCode)"/>
			<dp:set-variable name="'var://context/MYVAR/errorMsg'" value="string($errorMsg)"/>
			
			<xsl:copy-of select="." />

    </xsl:template>
</xsl:stylesheet>