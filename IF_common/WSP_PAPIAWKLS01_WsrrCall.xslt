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

		<xsl:variable name="IFID">
			<xsl:value-of select="dp:variable('var://context/MYVAR/IFID')"/>
		</xsl:variable>
		
    <!-- KALis get xquery-->
    <xsl:variable name="WSRRQUERY">
    	<xsl:value-of select="func:getXquery('KALis',$IFID)"/>
    </xsl:variable>
    <!--LOG--><xsl:value-of select="func:LoggingError('wsrr xquery=',$WSRRQUERY)"/>
    		
		<!--LOG--><xsl:value-of select="func:LoggingInfo('WSRRCall start',$WSRRQUERY)"/>
		<xsl:variable name="WSRRMetaInfo" select="func:WsrrCall($WSRRQUERY)"/>
		<!--LOG--><xsl:value-of select="func:LoggingInfo('WSRRCall end',$WSRRQUERY)"/>
		
		
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
	  	<xsl:value-of select="dp:variable('var://context/MYVAR/wsap')"/>
	  </xsl:variable>
			    
    <!-- Setting the context variable. -->
   	<dp:set-variable name="'var://context/MYVAR/PIP_soapAction'" value="string($PIP_soapAction)" />
   	<dp:set-variable name="'var://context/MYVAR/PIP_location'" value="string($PIP_location)" />
		    
    <!-- Soapaction set http request headers. -->
		<dp:set-http-request-header name="'SOAPAction'" value="$PIP_soapAction"/>
					
		<!-- location set service variable. -->
		<dp:set-variable name="'var://service/routing-url'" value="$PIP_location"/>
		
    <xsl:copy-of select="." />
    </xsl:template>
    
</xsl:stylesheet>

