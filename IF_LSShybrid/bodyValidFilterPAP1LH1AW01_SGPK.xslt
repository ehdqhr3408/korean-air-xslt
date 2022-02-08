<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes="dp">
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">

  	<xsl:variable name="bodyUnit"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_GetPublicKey']/*[local-name()='unitsOfMesure']/*[local-name()='valueRange']/*[local-name()='unit']/text()" /></xsl:variable>
		<xsl:variable name="bodyValue"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_GetPublicKey']/*[local-name()='unitsOfMesure']/*[local-name()='valueRange']/*[local-name()='value']/text()" /></xsl:variable>
		<xsl:variable name="bodyCompanyId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_GetPublicKey']/*[local-name()='systemDetailsInfoType']/*[local-name()='deliveringSystem']/*[local-name()='companyId']/text()" /></xsl:variable>

		<dp:set-variable name="'var://context/MYVAR/bodyUnit'" value="string($bodyUnit)" />
		<dp:set-variable name="'var://context/MYVAR/bodyValue'" value="string($bodyValue)" />
		<dp:set-variable name="'var://context/MYVAR/bodyCompanyId'" value="string($bodyCompanyId)" />
  		
		<!-- check empty and wrong Body data (no error code in DB) -->
		<xsl:choose>
			<xsl:when test=" $BooleanUnit='false' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_unit'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V04'"/>				
				<dp:xreject reason="'Common Soap Header is missing'"/>
			</xsl:when>
			<xsl:when test=" $BooleanValue='false' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_value'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V04'"/>
				<dp:xreject reason="'Common Soap Header is missing'"/>
			</xsl:when>
			<xsl:when test=" $BooleanCompanyId='false' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_comanyId'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V04'"/>
				<dp:xreject reason="'Common Soap Header is missing'"/>
			</xsl:when>				
			<xsl:when test=" $bodyUnit != 'BY' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'wrong_unit'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V04'"/>
			</xsl:when>
			<!--xsl:when test=" $bodyValue != '512' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'wrong_value'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V04'"/>
			</xsl:when-->
			<xsl:when test=" $bodyCompanyId != 'KE' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'wrong_comanyId'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V04'"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:accept />
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="' '"/>
	    		<xsl:copy-of select="." />
			</xsl:otherwise>
		</xsl:choose>	
    <xsl:copy-of select="." />
    </xsl:template>
</xsl:stylesheet>