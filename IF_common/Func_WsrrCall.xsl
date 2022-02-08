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


    <func:function name="func:WsrrCall">
     	  <xsl:param name="WSRRQUERY" />
			    <xsl:variable name="WSRRMetaInfo"><dp:url-open target="{$WSRRQUERY}" /></xsl:variable> 
			    
					<xsl:variable name="WSRRMetaInfoBoolean"><xsl:value-of select="boolean($WSRRMetaInfo/resources/resource/properties/property)" /></xsl:variable>
			    <xsl:if test=" $WSRRMetaInfoBoolean = 'false' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'notFound_WSRRInfo'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.R01'"/>
						<dp:xreject reason="concat('Routing Rule[', $IFID, '] not found')"/>
			    </xsl:if>
			
			    <xsl:for-each select="$WSRRMetaInfo/resources/resource/properties/property">
				    <xsl:if test="@name='PIP_soapActionUrl'">
					    <xsl:variable name="PIP_soapActionUrl"><a><xsl:value-of select="@value"/></a></xsl:variable>
				    	<dp:set-variable name="'var://context/MYVAR/PIP_soapActionUrl'" value="string($PIP_soapActionUrl)" />
				    </xsl:if>
				    <xsl:if test="@name='PIP_location'">
					    <xsl:variable name="PIP_location"><xsl:value-of select="@value"/></xsl:variable>
				    	<dp:set-variable name="'var://context/MYVAR/PIP_location'" value="string($PIP_location)" />
				    </xsl:if>
				    <xsl:if test="@name='PIP_xsdVersion'">
					    <xsl:variable name="PIP_xsdVersion"><xsl:value-of select="@value"/></xsl:variable>
				    	<dp:set-variable name="'var://context/MYVAR/PIP_xsdVersion'" value="string($PIP_xsdVersion)" />
				    </xsl:if>
				    <xsl:if test="@name='PIP_security'">
					    <xsl:variable name="PIP_security"><xsl:value-of select="@value"/></xsl:variable>
				    	<dp:set-variable name="'var://context/MYVAR/PIP_security'" value="string($PIP_security)" />
				    </xsl:if>
				    <xsl:if test="@name='PIP_RecvSystem'">
					    <xsl:variable name="PIP_recvsystem"><xsl:value-of select="@value"/></xsl:variable>
				    	<dp:set-variable name="'var://context/MYVAR/PIP_recvsystem'" value="string($PIP_recvsystem)" />
				    </xsl:if> 
				  </xsl:for-each> 
			
			    <func:result select="$WSRRMetaInfo" />
    </func:function>  

</xsl:stylesheet>