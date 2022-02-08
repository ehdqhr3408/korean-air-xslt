<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp">
    
    <xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">				
			
		<xsl:variable name="flag_error"><xsl:value-of select="dp:variable('var://context/MYVAR/codeId')" /></xsl:variable>
		
		<xsl:choose>
			<xsl:when test=" $flag_error = '' or $flag_error = ' ' ">
				<xsl:value-of select="func:LoggingInfo(' flag_error is empty ============================',$flag_error)"/>					    	
		    	<!-- test decrypt-key -->	    	
				<xsl:variable name="recipient" select="concat('name:',$CommonKeyAlice)"/>			
				<xsl:variable name="algorithm">http://www.w3.org/2001/04/xmlenc#rsa-1_5</xsl:variable>		    	
			   <xsl:variable name="bodyBinaryData1"><xsl:value-of select="dp:variable('var://context/MYVAR/bodyBinaryData1')" /></xsl:variable>	
	  			<xsl:variable name="bodyBinaryData2"><xsl:value-of select="dp:variable('var://context/MYVAR/bodyBinaryData2')" /></xsl:variable>				
	  			
				<xsl:value-of select="func:LoggingInfo('bodyBinaryData1 ============================',$bodyBinaryData1)"/>
				<xsl:value-of select="func:LoggingInfo('bodyBinaryData2 ============================',$bodyBinaryData2)"/>
				
				<xsl:variable name="binaryData1Decrypted"><xsl:value-of select="dp:decrypt-key($bodyBinaryData1,$recipient,$algorithm)"/></xsl:variable>
				<xsl:value-of select="func:LoggingInfo('binaryData1Decrypted ============================',$binaryData1Decrypted)"/>
				
				<xsl:variable name="binaryData2Decrypted"><xsl:value-of select="dp:decrypt-key($bodyBinaryData2,$recipient,$algorithm)"/></xsl:variable>
						
				<xsl:value-of select="func:LoggingInfo('binaryData2Decrypted ============================',$binaryData2Decrypted)"/>
				
				<dp:set-variable name="'var://context/MYVAR/binaryData1Decrypted'" value="string($binaryData1Decrypted)" />
				<dp:set-variable name="'var://context/MYVAR/binaryData2Decrypted'" value="string($binaryData2Decrypted)" />		
						

				<xsl:choose>	
					<xsl:when test=" $binaryData1Decrypted!='' ">
		 				<!--xsl:variable name="flag_curDecrypt"><xsl:value-of select="substring(dp:decode($decryptedCurPass,'base-64'),1,1)"/></xsl:variable-->
		 				<xsl:variable name="flag1"><xsl:value-of select="substring(string($binaryData1Decrypted),1,1)"/></xsl:variable>
		 				<dp:set-variable name="'var://context/MYVAR/flag1'" value="$flag1" />
		 				<xsl:value-of select="func:LoggingInfo('flag1 ============================',$flag1)"/>
	 				</xsl:when>
 				</xsl:choose>
 				<xsl:choose>
	 				<xsl:when test=" $binaryData2Decrypted!='' ">
						<!--xsl:variable name="flag_newDecrypt"><xsl:value-of select="substring(dp:decode($decryptedNewPass,'base-64'),1,1)"/></xsl:variable-->
		 				<xsl:variable name="flag2"><xsl:value-of select="substring(string($binaryData2Decrypted),1,1)"/></xsl:variable>
		 				<dp:set-variable name="'var://context/MYVAR/flag2'" value="$flag2" />
		 				<xsl:value-of select="func:LoggingInfo('flag2 ============================',$flag2)"/>
					</xsl:when>
				</xsl:choose>
				
				<xsl:choose>	
					<xsl:when test=" $flag1='*' "><!-- fail decrypt -->
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'expired_publickey'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.A02'"/>
						<xsl:value-of select="func:LoggingInfo('expired_publickey =====fail decrypt=======================',$flag1)"/>
					</xsl:when>	
					<xsl:when test=" $flag2='*' "><!-- fail decrypt -->
						<dp:set-variable name="'var://context/MYVAR/valid'" value="'expired_publickey'"/>
						<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.A02'"/>
						<xsl:value-of select="func:LoggingInfo('expired_publickey =====fail decrypt=======================',$flag2)"/>
					</xsl:when>	
					<xsl:otherwise>
						<dp:accept />
						<dp:set-variable name="'var://context/MYVAR/binaryData1Base64'" value="string($binaryData1Decrypted)" />
						<xsl:value-of select="func:LoggingInfo('binaryData1Base64=binaryData1Decrypted =====success=======================',$binaryData1Decrypted)"/>
						<dp:set-variable name="'var://context/MYVAR/binaryData2Base64'" value="string($binaryData2Decrypted)" />
						<xsl:value-of select="func:LoggingInfo('binaryData2Base64=binaryData2Decrypted =====success=======================',$binaryData2Decrypted)"/>
						<dp:set-variable name="'var://context/MYVAR/binaryData1Length'" value="string-length($binaryData1Decrypted)" />
						<xsl:value-of select="func:LoggingInfo('binaryData1Decrypted =====string-length=======================',string-length($binaryData1Decrypted))"/>
						<dp:set-variable name="'var://context/MYVAR/binaryData2Length'" value="string-length($binaryData2Decrypted)" />
						<xsl:value-of select="func:LoggingInfo('binaryData2Decrypted =====string-length=======================',string-length($binaryData2Decrypted))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>							
		</xsl:choose>
			
		<xsl:copy-of select="." />
			
    </xsl:template>
</xsl:stylesheet>