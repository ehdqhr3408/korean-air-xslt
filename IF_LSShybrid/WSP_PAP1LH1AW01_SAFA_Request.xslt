<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    extension-element-prefixes="dp"
xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp dpconfig"
>

 <xsl:include href="local:///IF_common/LoggingUtil.xsl"/> 
<xsl:output encoding="UTF-8" version="1.0" method="xml"/>
  <xsl:output method="xml"/>
  
  <xsl:template match="/">

         <xsl:variable name="LoopTest" select="document('local:///IF_LSShybrid/LoopTest.xml',LoopTest)"/>  
<xsl:variable name="LOGGINGPRINT" select="func:LoggingDebug('for-each start          ===========================>  ')"/>

  	      <xsl:for-each select="$LoopTest//*[local-name()='COUNT']">
   					<xsl:variable name="count" select="COUNT"/>
				<xsl:variable name="LOGGINGPRINT" select="func:LoggingDebug('count=============>  ',$count)"/>


      <!--xsl:variable name="urlOpenResult">
		   
		    	<dp:url-open target="dpmq://AKE1T.PIP.ETC/?ReplyQueue=RMS.LQ;SyncPut=true" response="xml" timeout="4"/>

      </xsl:variable-->



    	      </xsl:for-each>


<xsl:variable name="LOGGINGPRINT" select="func:LoggingDebug('for-each stop ==========================================>  ')"/>

  	 <xsl:variable name="codeId"><xsl:value-of select="dp:variable('var://context/MYVAR/codeId')" /></xsl:variable>
    	 <xsl:choose>
    	 	<xsl:when test=" $codeId = ' '">  	 	  	 			  	 			  	 			
  	 			<dp:set-http-request-header name="'SOAPAction'" value="string('http://securityauthenticate/securityAuthenticate')"/>    	 	
    	 		
    	 		<xsl:variable name="count"><xsl:value-of select="dp:variable('var://context/MYVAR/countInformation')" /></xsl:variable>
    	 		<xsl:choose>
	    	 		<xsl:when test=" $count = '1'">
		    	 		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:ses="http://xml.amadeus.com/2010/06/Session_v3" xmlns:sec="http://xml.amadeus.com/2010/06/Security_v1" xmlns:typ="http://xml.amadeus.com/2010/06/Types_v1" xmlns:iat="http://www.iata.org/IATA/2007/00/IATA2010.1" xmlns:app="http://xml.amadeus.com/2010/06/AppMdw_CommonTypes_v3" xmlns:sec1="http://xml.amadeus.com/Security_AuthenticateFromAmadeus_12_1_1A">		
							<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']" />
				    		<soapenv:Body  xmlns="http://xml.amadeus.com/Security_AuthenticateFromAmadeus_12_1_1A" xmlns:hsf="http://xml.amadeus.com/HSFREQ_07_3_1A">
				    			<Security_AuthenticateFromAmadeus>
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='userIdentifier']" />
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='dutyCode']" />
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='systemDetails']" />
									<passwordInformation>
										<passwordDetails>
											<encryptionDetails>
												<algorithmType>BASE64</algorithmType>
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='timestamp']" />
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken']" />
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='suplementaryEncryptionToken']" />
											</encryptionDetails>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='passwordDetails']/*[local-name()='passwordType']" />
										</passwordDetails>
										<password>
											<dataLength><xsl:value-of select="dp:variable('var://context/MYVAR/binaryData1Length')" /></dataLength>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='password']/*[local-name()='dataType']" />
											<binaryData><xsl:value-of select="dp:variable('var://context/MYVAR/binaryData1Base64')" /></binaryData>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation']/*[local-name()='password']/*[local-name()='compressType']" />
										</password>
									</passwordInformation>	
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='fullLocationInfo']" />
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='applicationId']" />
								</Security_AuthenticateFromAmadeus>
					    	</soapenv:Body>
				    	</soapenv:Envelope>	
	    	 		</xsl:when> 	
	    	 		<xsl:when test=" $count = '2'">
		    	 		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:ses="http://xml.amadeus.com/2010/06/Session_v3" xmlns:sec="http://xml.amadeus.com/2010/06/Security_v1" xmlns:typ="http://xml.amadeus.com/2010/06/Types_v1" xmlns:iat="http://www.iata.org/IATA/2007/00/IATA2010.1" xmlns:app="http://xml.amadeus.com/2010/06/AppMdw_CommonTypes_v3" xmlns:sec1="http://xml.amadeus.com/Security_AuthenticateFromAmadeus_12_1_1A">		
							<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']" />
				    		<soapenv:Body  xmlns="http://xml.amadeus.com/Security_AuthenticateFromAmadeus_12_1_1A" xmlns:hsf="http://xml.amadeus.com/HSFREQ_07_3_1A">
				    			<Security_AuthenticateFromAmadeus>
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='userIdentifier']" />
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='dutyCode']" />
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='systemDetails']" />			
									<passwordInformation>
										<passwordDetails>
											<encryptionDetails>
												<algorithmType>BASE64</algorithmType>
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='timestamp']" />
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken']" />
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='suplementaryEncryptionToken']" />
											</encryptionDetails>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='passwordDetails']/*[local-name()='lifetime']" />
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='passwordDetails']/*[local-name()='passwordType']" />
										</passwordDetails>
										<password>
											<dataLength><xsl:value-of select="dp:variable('var://context/MYVAR/binaryData1Length')" /></dataLength>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='password']/*[local-name()='dataType']" />
											<binaryData><xsl:value-of select="dp:variable('var://context/MYVAR/binaryData1Base64')" /></binaryData>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][1]/*[local-name()='password']/*[local-name()='compressType']" />
										</password>
									</passwordInformation>															
									<passwordInformation>
										<passwordDetails>
											<encryptionDetails>
												<algorithmType>BASE64</algorithmType>
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='timestamp']" />
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='encryptionToken']" />
												<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='passwordDetails']/*[local-name()='encryptionDetails']/*[local-name()='suplementaryEncryptionToken']" />
											</encryptionDetails>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='passwordDetails']/*[local-name()='lifetime']" />
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='passwordDetails']/*[local-name()='passwordType']" />
										</passwordDetails>
										<password>
											<dataLength><xsl:value-of select="dp:variable('var://context/MYVAR/binaryData2Length')" /></dataLength>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='password']/*[local-name()='dataType']" />
											<binaryData><xsl:value-of select="dp:variable('var://context/MYVAR/binaryData2Base64')" /></binaryData>
											<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='passwordInformation'][2]/*[local-name()='password']/*[local-name()='compressType']" />
										</password>
									</passwordInformation>						
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='fullLocationInfo']" />
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeus']/*[local-name()='applicationId']" />
								</Security_AuthenticateFromAmadeus>
					    	</soapenv:Body>
				    	</soapenv:Envelope>	
	    	 		</xsl:when> 
	    	 		<xsl:otherwise>
	    	 			<xsl:copy-of select="." />
	    	 		</xsl:otherwise>	
    	 		</xsl:choose>    	 		    	 		
    	 	</xsl:when>
    	 	<!-- PIP.V06 : body data invalid.  -->
    	 	<xsl:when test=" $codeId = 'PIP.A02' or $codeId = 'PIP.V05' or $codeId = 'PIP.A03' or $codeId = 'PIP.V01' or $codeId = 'PIP.V02' or $codeId = 'PIP.V06'">
 		<xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('getWdpErrorCode start',$codeId)"/>
    <xsl:variable name="ErrorCodeResult" select="func:getWdpErrorCode('PIP_ERROR_01',$codeId)"/>
    <xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('getWdpErrorCode End',$ErrorCodeResult)"/>
			
				<dp:set-variable name="'var://service/routing-url'" value="string('http://localhost:8090/loopBack')" />
				<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:awss="http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd" xmlns:awsl="http://wsdl.amadeus.com/2010/06/ws/Link_v1">		
					<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']" />
		    		<soapenv:Body>
						<ns0:Security_AuthenticateFromAmadeusReply xmlns:ns0="http://xml.amadeus.com/Security_AuthenticateFromAmadeusReply_12_1_1A">
							<ns0:processStatus>
								<ns0:responseType>A</ns0:responseType>
								<ns0:statusCode>X</ns0:statusCode>
							</ns0:processStatus>
							<ns0:errorGroup>
								<ns0:errorOrWarningCodeDetails>
									<ns0:errorDetails>
										<ns0:errorCode><xsl:value-of select="dp:variable('var://context/MYVAR/customerErrorCode')"/></ns0:errorCode>
										<ns0:errorCategory>EC</ns0:errorCategory>
										<ns0:errorCodeOwner>1A</ns0:errorCodeOwner>
									</ns0:errorDetails>
								</ns0:errorOrWarningCodeDetails>
								<ns0:errorWarningDescription>
									<ns0:freeTextDetails>
										<ns0:textSubjectQualifier>1</ns0:textSubjectQualifier>
										<ns0:informationType>1</ns0:informationType>
										<ns0:language>1</ns0:language>
										<ns0:source>1</ns0:source>
										<ns0:encoding>1</ns0:encoding>
									</ns0:freeTextDetails>
									<ns0:freeText><xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/></ns0:freeText>
								</ns0:errorWarningDescription>
							</ns0:errorGroup>
						</ns0:Security_AuthenticateFromAmadeusReply>
			    	</soapenv:Body>
		    	</soapenv:Envelope>
    	 	</xsl:when>
    	 </xsl:choose>
  	
  </xsl:template>
</xsl:stylesheet>