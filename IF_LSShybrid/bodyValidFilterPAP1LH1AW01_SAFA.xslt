<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp">
    
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>     
    <xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
    <xsl:template match="/"> 
    	<xsl:variable name="EncryptionToken" select="dp:get-cert-serial(concat('name:',$CommonCertAlice))"/>
        <xsl:value-of select="func:LoggingInfo('EncryptionToken============================',$EncryptionToken)"/>
<!-- Setting the parameters for ims logging.-->
		<xsl:variable name="bodyoriginator">
			<xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='userIdentifier']/*[local-name()='originator']/text()" />
		</xsl:variable>					
		<dp:set-variable name="'var://context/MYVAR/employeeNo'" value="string($bodyoriginator)" />	


		<!-- LOG --><xsl:value-of select="func:LoggingDebug('bodyoriginator ======================',$bodyoriginator)"/>
		<dp:set-variable name="'var://context/MYVAR/countInformation'" value="number('0')" />				
		<xsl:for-each select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']">								
			<xsl:if test="boolean(./*[local-name()='password'])='true' ">
				<xsl:variable name="count"><xsl:value-of select="dp:variable('var://context/MYVAR/countInformation')" /></xsl:variable>
				<dp:set-variable name="'var://context/MYVAR/countInformation'" value="number($count)+1" />
			</xsl:if>					
		</xsl:for-each>  
		<!-- Change the password and the old password, the new password separated. -->		 
		<xsl:variable name="countPassInfo"><xsl:value-of select="dp:variable('var://context/MYVAR/countInformation')" /></xsl:variable>
		<xsl:choose>
			<xsl:when test=" $countPassInfo = '1' ">	
				<xsl:variable name="booleanEncryptionToken1"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken'])" /></xsl:variable>

				<xsl:variable name="bodyEncryptionToken1"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken']/text()" /></xsl:variable>
				<xsl:variable name="bodyBinaryData1"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='password']/*[local-name()='binaryData']/text()" /></xsl:variable>
				<xsl:variable name="bodyAlgorithmType1"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='algorithmType']/text()" /></xsl:variable>					
				<dp:set-variable name="'var://context/MYVAR/bodyEncryptionToken1'" value="string($bodyEncryptionToken1)" />	
				<dp:set-variable name="'var://context/MYVAR/bodyBinaryData1'" value="string($bodyBinaryData1)" />	
				<dp:set-variable name="'var://context/MYVAR/bodyAlgorithmType1'" value="string($bodyAlgorithmType1)" />	
				<xsl:choose>
					<xsl:when test=" $booleanEncryptionToken1='false' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken_tag'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $bodyEncryptionToken1='' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $bodyEncryptionToken1!=$EncryptionToken ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.A02'"/>
					</xsl:when>

					<xsl:when test=" $bodyBinaryData1='' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_BinaryData'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $bodyAlgorithmType1!='RSA' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_AlgorithmType'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
				</xsl:choose>				
			</xsl:when>	
			<xsl:otherwise><!--xsl:when test=" $count >= '2' "-->
				<xsl:variable name="booleanEncryptionToken1"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken'])" /></xsl:variable>
				<xsl:variable name="booleanEncryptionToken2"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken'])" /></xsl:variable>

				<xsl:variable name="bodyEncryptionToken1"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken']/text()" /></xsl:variable>
				<xsl:variable name="bodyBinaryData1"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='password']/*[local-name()='binaryData']/text()" /></xsl:variable>
				<xsl:variable name="bodyAlgorithmType1"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='algorithmType']/text()" /></xsl:variable>					
				<xsl:variable name="bodyEncryptionToken2"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken']/text()" /></xsl:variable>
				<xsl:variable name="bodyBinaryData2"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='password']/*[local-name()='binaryData']/text()" /></xsl:variable>
				<xsl:variable name="bodyAlgorithmType2"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='algorithmType']/text()" /></xsl:variable>										
				<dp:set-variable name="'var://context/MYVAR/bodyEncryptionToken1'" value="string($bodyEncryptionToken1)" />	
				<dp:set-variable name="'var://context/MYVAR/bodyBinaryData1'" value="string($bodyBinaryData1)" />	
				<dp:set-variable name="'var://context/MYVAR/bodyAlgorithmType1'" value="string($bodyAlgorithmType1)" />	
				<dp:set-variable name="'var://context/MYVAR/bodyEncryptionToken2'" value="string($bodyEncryptionToken2)" />	
				<dp:set-variable name="'var://context/MYVAR/bodyBinaryData2'" value="string($bodyBinaryData2)" />	
				<dp:set-variable name="'var://context/MYVAR/bodyAlgorithmType2'" value="string($bodyAlgorithmType2)" />
				<xsl:choose>
					<xsl:when test=" $booleanEncryptionToken1='false' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken_tag'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $booleanEncryptionToken2='false' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken_tag'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					
					<xsl:when test=" $bodyEncryptionToken1='' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $bodyEncryptionToken1!=$EncryptionToken ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.A02'"/>
					</xsl:when>
					<xsl:when test=" $bodyBinaryData1='' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_BinaryData'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $bodyAlgorithmType1!='RSA' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_AlgorithmType'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $bodyEncryptionToken2='' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $bodyEncryptionToken2!=$EncryptionToken ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_EncryptionToken'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.A02'"/>
					</xsl:when>
					<xsl:when test=" $bodyBinaryData2='' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_BinaryData'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
					<xsl:when test=" $bodyAlgorithmType2!='RSA' ">
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_AlgorithmType'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V06'"/>
					</xsl:when>
				</xsl:choose>				
			</xsl:otherwise>
		</xsl:choose>	
			
		<xsl:copy-of select="." />
    </xsl:template>
</xsl:stylesheet>