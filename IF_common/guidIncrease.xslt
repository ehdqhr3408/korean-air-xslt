<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
<xsl:include href="local:///IF_common/LoggingUtil.xsl"/> 
<xsl:output encoding="UTF-8" version="1.0" method="xml"/>   
    <xsl:template match="/">   
 
		  <xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')" /></xsl:variable>
			<xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('Response Start  ',$guid)"/>
			<xsl:value-of select="func:LoggingError(concat('X-http-responseSystem XXXXXXXXXXXX: ',$guid,': '),dp:http-response-header('X-responseSystem'))"/>
			<xsl:value-of select="func:LoggingError(concat('X-responseSystem XXXXXXXXXXXX: ',$guid,': '),dp:response-header('X-responseSystem'))"/>
			<dp:set-variable name="'var://context/MYVAR/XresponseSystem'" value="dp:response-header('X-responseSystem')"/>

		  <xsl:variable name="guid_length"><xsl:value-of select="string-length($guid)"/></xsl:variable>
		  <xsl:variable name="seqguid"><xsl:value-of select="substring($guid,number($guid_length)-1,2)+101"/></xsl:variable>
		  <xsl:variable name="guid"><xsl:value-of select="substring($guid,1,number($guid_length)-2)"/><xsl:value-of select="substring($seqguid,string-length($seqguid)-1,2)"/></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/guid'" value="string($guid)"/>
			<dp:set-variable name="'var://context/MYVAR/guidSequence'" value="substring($seqguid,string-length($seqguid)-1,2)"/>

			<!--dp:set-variable name="'var://context/MYVAR/isFW'" value="'true'"/-->
	
	    <xsl:copy-of select="." />
    </xsl:template>
</xsl:stylesheet>