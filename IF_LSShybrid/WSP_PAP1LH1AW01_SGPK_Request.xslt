<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    
    <xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/> 

    <xsl:template match="/"> 
       
       <xsl:variable name="EncryptionToken" select="dp:get-cert-serial(concat('name:',$CommonCertAlice))"/>
    	 
			 <xsl:value-of  select="func:LoggingInfo('EncryptionToken============================',$EncryptionToken)"/>
      
			 
    	 <xsl:variable name="codeId">
    	 	<xsl:value-of select="dp:variable('var://context/MYVAR/codeId')" />
    	 </xsl:variable>
    	 
    	 <xsl:choose>
    	 	<!-- normal case -->
    	 	<xsl:when test=" $codeId = ' ' ">
		    	<xsl:variable name="certPIP" select="dp:get-cert-details(concat('name:',$CommonCertAlice))"/>
		    	<dp:set-variable name="'var://context/MYVAR/acertPIP'" value="$certPIP" />
		    	<xsl:variable name="modulus" select="$certPIP//*[local-name()='Modulus']"/> 
		    	<dp:set-variable name="'var://context/MYVAR/modulus'" value="$modulus" /> 
		    	<xsl:variable name="exponent" select="$certPIP//*[local-name()='Exponent']"/> 
		    	<dp:set-variable name="'var://context/MYVAR/exponent'" value="$exponent" />
		    	
		    	<!-- modulus size -->
		    	<xsl:variable name="base64-modulus-len"      select="string-length($modulus)"/>
          <xsl:variable name="base64-mnum01" select="(($base64-modulus-len * 6) div 64)"/>
          <xsl:variable name="modulus-len"  select="round((($base64-mnum01 - ($base64-mnum01 mod 8)) * 8))"/>
          
          <!-- exponent size -->
		    	<xsl:variable name="base64-exponent-len"      select="string-length($exponent)"/>
          <xsl:variable name="base64-enum01" select="(($base64-exponent-len * 6) div 64)"/>
          <xsl:variable name="exponent-len"  select="round(($base64-enum01 * 8))"/>
		    			 			    	
		    	<xsl:variable name="certPIP">
		    		<xsl:value-of select="substring($certPIP,1,1)" />
		    	</xsl:variable>
		    	
		    	<xsl:choose>
		    		<xsl:when test="$certPIP= '*' ">
		    			<dp:set-variable name="'var://context/MYVAR/valid'" value="'expired_publickey'"/>
		    			<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.K01'"/>
						<dp:xreject reason="'Public key cannot be found or is expired'"/>		    		
		    		</xsl:when>
		    		<xsl:otherwise>
				    	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:awss="http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd" xmlns:awsl="http://wsdl.amadeus.com/2010/06/ws/Link_v1">		
							
							<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']" />						
			   		
				    	<soapenv:Body>
							<ns0:Security_GetPublicKeyReply xmlns:ns0="http://xml.amadeus.com/VRSARR_10_3_1A">
								<ns0:passwordGroup>
									<ns0:externalConversationID>
										<ns0:uniqueReference><xsl:value-of select="$EncryptionToken"/></ns0:uniqueReference>
									</ns0:externalConversationID>
									<ns0:publickeyN>
										<ns0:dataLength><xsl:value-of select="$modulus-len"/></ns0:dataLength>
										<ns0:dataType>B</ns0:dataType>
										<ns0:binaryData><xsl:value-of select="$modulus" /></ns0:binaryData>
									</ns0:publickeyN>
									<ns0:publickeyE>
										<ns0:dataLength><xsl:value-of select="$exponent-len"/></ns0:dataLength>
										<ns0:dataType>B</ns0:dataType>
										<ns0:binaryData><xsl:value-of select="$exponent" /></ns0:binaryData>
									</ns0:publickeyE>
								</ns0:passwordGroup>
							</ns0:Security_GetPublicKeyReply>
				    	</soapenv:Body>
			    	</soapenv:Envelope>
		    		</xsl:otherwise>
		    	</xsl:choose>    	
    	 	</xsl:when>
    	 	
    	 	<!-- error case but 200 OK -->
    	 	<xsl:when test=" $codeId = 'PIP.V04' ">	<!-- PIP.V04 : invalid request data. -->	
    	 				<xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('getWdpErrorCode start',$codeId)"/>
    <xsl:variable name="ErrorCodeResult" select="func:getWdpErrorCode('PIP_ERROR_01',$codeId)"/>
    <xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('getWdpErrorCode End',$ErrorCodeResult)"/>
				
    	 		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:awss="http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd" xmlns:awsl="http://wsdl.amadeus.com/2010/06/ws/Link_v1">		
					<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']" />
			    	<soapenv:Body>
						<ns1:Security_GetPublicKeyReply xmlns:ns1="http://xml.amadeus.com/Security_GetPublicKeyReply_10_3_1A">
			         <ns1:errorGroup>
			            <ns1:errorOrWarningCodeDetails>
			               <ns1:errorDetails>
			                  <ns1:errorCode><xsl:value-of select="dp:variable('var://context/MYVAR/customerErrorCode')"/></ns1:errorCode>
			                  <ns1:errorCategory>EC</ns1:errorCategory>
			                  <ns1:errorCodeOwner>1A</ns1:errorCodeOwner>
			               </ns1:errorDetails>
			            </ns1:errorOrWarningCodeDetails>
			            <ns1:errorWarningDescription>
			               <ns1:freeTextDetails>
			                  <ns1:textSubjectQualifier>1</ns1:textSubjectQualifier>
			                  <ns1:informationType>1</ns1:informationType>
			                  <ns1:language>EN</ns1:language>
			                  <ns1:source>1</ns1:source>
			                  <ns1:encoding>67</ns1:encoding>
			               </ns1:freeTextDetails>
			               <ns1:freeText><xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/></ns1:freeText>
			            </ns1:errorWarningDescription>
			         </ns1:errorGroup>
						</ns1:Security_GetPublicKeyReply>
			    	</soapenv:Body>
	    		</soapenv:Envelope>
    	 	</xsl:when>
    	 	
    	 	<xsl:otherwise>  
	    		<xsl:copy-of select="." />
    	 	</xsl:otherwise>
    	 </xsl:choose>
   		    	
    </xsl:template>
</xsl:stylesheet>