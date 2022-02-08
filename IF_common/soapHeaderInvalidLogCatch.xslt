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
    	<dp:set-variable name="'var://context/MYVAR/XresponseSystem'" value="dp:response-header('X-responseSystem')"/>
    	<!--1220 add-->
			<dp:set-variable name="'var://context/MYVAR/faultactor'" value="string('WDP')"/>
			<xsl:variable name="subcode"><xsl:value-of select="dp:variable('var://service/error-subcode')"/></xsl:variable>
			<xsl:variable name="valid"><xsl:value-of select="dp:variable('var://context/MYVAR/valid')"/></xsl:variable>
					
<!-- http error,validation error check 

		  	<xsl:param name="HVI"/>
			  <xsl:param name="codeId"/>

-->       
      <xsl:variable name="codeId" select="func:CodeIdChk(string('H'))"/>
<!-- http error,validation error check -->
	    
	    <dp:set-variable name="'var://context/MYVAR/codeId'" value="$codeId"/>


			<xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('getWdpErrorCode start',$codeId)"/>
	    <xsl:variable name="ErrorCodeResult" select="func:getWdpErrorCode('PIP_ERROR_01',$codeId)"/>
	    <xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('getWdpErrorCode End',$ErrorCodeResult)"/>
	    
	    <xsl:variable name="codeDesc" select="func:setErrorMsg($valid)"/>
	    <xsl:variable name="LOGGINGPRINT" select="func:LoggingDebug('setErrorMsg End',$codeDesc)"/>	
			
			<xsl:variable name="errorMsg"><xsl:value-of select="dp:variable('var://context/MYVAR/codeType')"/>|<xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/></xsl:variable>
			<xsl:variable name="customerErrorCode"><xsl:value-of select="dp:variable('var://context/MYVAR/customerErrorCode')"/></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/errorCode'" value="string($customerErrorCode)"/>
			<dp:set-variable name="'var://context/MYVAR/errorMsg'" value="string($errorMsg)"/>
			
			<xsl:copy-of select="." />

    </xsl:template>
</xsl:stylesheet>