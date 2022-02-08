<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="dp"
    exclude-result-prefixes="dp" 
    xmlns:dpfunc="http://www.datapower.com/extensions/functions"
    xmlns:func="http://exslt.org/functions"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:regexp="http://exslt.org/regular-expressions"
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"> 
 <!--
       common variable
       CommonCertAlice : ssl proxy profile name
       CommonMsgSize   : substring message size
      
    -->
        <!-- Cert object name -->
		<xsl:variable name="CommonCertAlice" select="string('FSH_SSL_Crypto_Cert')"/>
		<!-- key object name -->
		<xsl:variable name="CommonKeyAlice" select="string('FSH_SSL_Crypto_Key')"/>
		<!-- 1APID session type 1 signout not use  -->
		<xsl:variable name="CommonSignOut" select="string('Security_SignOut_04_1_V1_01')"/>

		<!-- w/s proxy name -->
		<xsl:variable name="CommonPSG1ABEXEPI01" select="string('PSG1ABEXEPI01')"/>
		<xsl:variable name="CommonPSG1AREXSPI01" select="string('PSG1AREXSPI01')"/>
		<xsl:variable name="CommonPSG1AWINCCA01" select="string('PSG1AWINCCA01')"/>
		<xsl:variable name="CommonPSG1AWINCCA02" select="string('PSG1AWINCCA02')"/>
		<xsl:variable name="CommonPSG1AWINECA01" select="string('PSG1AWINECA01')"/>
		<xsl:variable name="CommonPSG1AWINSPI01" select="string('PSG1AWINSPI01')"/>
		<xsl:variable name="CommonPSGAUTEXEPI01" select="string('PSGAUTEXEPI01')"/>
		<xsl:variable name="CommonPSGAUTEXEPI02" select="string('PSGAUTEXEPI02')"/>
		<xsl:variable name="CommonPSGODWINSPI01" select="string('PSGODWINSPI01')"/>
		<xsl:variable name="CommonPSGPIWEXSPI01" select="string('PSGPIWEXSPI01')"/>
		<xsl:variable name="CommonPSGPIWINSPI01" select="string('PSGPIWINSPI01')"/>
		<xsl:variable name="CommonPSGSKYEXSPI01" select="string('PSGSKYEXSPI01')"/>		
		<xsl:variable name="CommonPSGAUTEXEPI" select="string('PSGAUTEXEPI')"/>
		<!-- IMSSO system code-->
		<xsl:variable name="CommonIMSSOSYS" select="string('SEC')"/>
		<!-- SKYLINK system code -->
		<xsl:variable name="CommonSSAM" select="string('SSAM')"/>
		
		<xsl:variable name="CommonWESB" select="string('WESB')"/>
		<xsl:variable name="CommonWDP" select="string('WDP')"/>

		<!-- PIP system -->
		<xsl:variable name="CommonPIPSYS" select="string('PIP')"/>

		<!-- ims logging max soap message size -->
		<xsl:variable name="CommonMsgSize" select="1948000"/>
		<!-- MIG,SKL SYSTEM name -->
        <xsl:variable name="CommonMIG" select="string('MIG')"/>
        <xsl:variable name="CommonSKL" select="string('SKL')"/>
        
		<!-- wdp error code -->
		<xsl:variable name="Common0x01d30002" select="string('0x01d30002')"/>
		<xsl:variable name="Common0x01d30001" select="string('0x01d30001')"/>
		<xsl:variable name="Common0x01130011" select="string('0x01130011')"/>
		
		<!-- PIP error code -->
		<xsl:variable name="CommonPIPA01" select="string('PIP.A01')"/>
		<xsl:variable name="CommonPIPA02" select="string('PIP.A02')"/>
		<xsl:variable name="CommonPIPI02" select="string('PIP.I02')"/>
		<xsl:variable name="CommonPIPE02" select="string('PIP.E02')"/>
		<xsl:variable name="CommonPIPT01" select="string('PIP.T01')"/>
		<xsl:variable name="CommonPIPV03" select="string('PIP.V03')"/>
		<xsl:variable name="CommonPIPI99" select="string('PIP.I99')"/>
		<xsl:variable name="CommonPIPI01" select="string('PIP.I01')"/>
		<!-- HTTP response code -->
		<xsl:variable name="CommonHTTPC404" select="string('404')"/>
		<xsl:variable name="CommonHTTPC500" select="string('500')"/>
		<xsl:variable name="CommonHTTPC503" select="string('503')"/>
		<!-- 1abypass tscode -->
		<xsl:variable name="CommonStart" select="string('Start')"/>
		<xsl:variable name="CommonEnd" select="string('End')"/>
					
	
					
	
    <!--
       get wsrr searching Xquery String 
       input:
            Systemcode : IBE,KALis,GPS
            IFID :  interface id
       return string

    -->
	<func:function name="func:getXquery">
		<xsl:param name="Systemcode"/>
		<xsl:param name="ifid"/>								
				<!-- xquery mapping file -->
       	<xsl:variable name="WDPXqueryMappings" select="document('local:///IF_common/WDPXqueryMappings.xml')"/>
       	
       	<!-- bx before xquery -->    
        <xsl:variable name="bx">
        	<xsl:value-of select="$WDPXqueryMappings//*[local-name()=$Systemcode]/*[local-name()='bxquery']/text()"/>
        </xsl:variable>
        <!-- ax after xquery -->
       <xsl:variable name="ax">
        	<xsl:value-of select="$WDPXqueryMappings//*[local-name()=$Systemcode]/*[local-name()='axquery']/text()"/>
        </xsl:variable>
        
        <!-- xquery = before xquery + ifid + after xquery -->
				<xsl:variable name="xquery">
					<xsl:value-of select="concat($bx,$ifid,$ax)"/>
				</xsl:variable>
				
        <func:result select="string($xquery)" />
     </func:function>
    <!--
       get Response message size 
       return string(KB) 
       
       service variable
       var://service/mpgw/request-size
       var://service/mpgw/response-size
    -->

	<func:function name="func:getResSize">
		<xsl:variable name="ResSize">
			<!-- get response size for service variable -->
			<xsl:value-of select="dp:variable('var://service/mpgw/response-size')"/>
		</xsl:variable>	
		<xsl:variable name="ResSize">
			<xsl:value-of select="round($ResSize div 1024)"/>
		</xsl:variable>		
		<func:result select="string($ResSize)" />
     </func:function>
				      
    <!--
       get Request message size 
       return string(KB) 
       
       service variable
       var://service/mpgw/request-size
       var://service/mpgw/response-size
    -->

		<func:function name="func:getReqSize">
			<xsl:variable name="ReqSize">
				<xsl:value-of select="dp:variable('var://service/mpgw/request-size')"/>
			</xsl:variable>		
			<xsl:variable name="ReqSize">
				<xsl:value-of select="round($ReqSize div 1024)"/>
			</xsl:variable>	
			<func:result select="string($ReqSize)" />
	    </func:function>
				      
       <!--
         http header info logging
         wdp error-message logging
         
         return ErrorReason
      -->
      <xsl:variable name="CRLF"  select="'&#13;&#10;'"/>  
		  <func:function name="func:MakeErrorReason">
<!-- request -->	
            <xsl:variable name="transactionid" select="dp:variable('var://service/transaction-id')" />						
			<xsl:variable name="ReqAcceptEncoding"><xsl:value-of select="dp:request-header('Accept-Encoding')" /></xsl:variable>
			<xsl:variable name="ReqContentType"><xsl:value-of select="dp:request-header('Content-Type')" /></xsl:variable>
			<xsl:variable name="ReqSOAPAction"><xsl:value-of select="dp:request-header('SOAPAction')" /></xsl:variable>
			<xsl:variable name="ReqContentLength"><xsl:value-of select="dp:request-header('Content-Length')" /></xsl:variable>
			<xsl:variable name="ReqTransferEncoding"><xsl:value-of select="dp:request-header('Transfer-Encoding')" /></xsl:variable>
			<xsl:variable name="ReqXClientIP"><xsl:value-of select="dp:request-header('X-Client-IP')" /></xsl:variable>
			<xsl:variable name="ReqXinfoperation"><xsl:value-of select="dp:request-header('X-inf-operation')"/></xsl:variable>
			<xsl:variable name="ReqXinfflowCode"><xsl:value-of select="dp:request-header('X-inf-flowCode')"/></xsl:variable>
			<xsl:variable name="ReqXinfatcoption"><xsl:value-of select="dp:request-header('X-inf-atcoption')"/></xsl:variable>
<!-- response -->
			<xsl:variable name="HttpResponseCode"><xsl:value-of select="dp:response-header('x-dp-response-code')"/></xsl:variable>
			<xsl:variable name="ResAcceptEncoding"><xsl:value-of select="dp:response-header('Accept-Encoding')" /></xsl:variable>
			<xsl:variable name="ResContentType"><xsl:value-of select="dp:response-header('Content-Type')" /></xsl:variable>
			<xsl:variable name="ResSOAPAction"><xsl:value-of select="dp:response-header('SOAPAction')" /></xsl:variable>
			<xsl:variable name="ResContentLength"><xsl:value-of select="dp:response-header('Content-Length')" /></xsl:variable>
			<xsl:variable name="XresponseSystem"><xsl:value-of select="dp:response-header('X-responseSystem')"/></xsl:variable>
			
	        <xsl:variable name="WDPErrorMessage">
	        	<xsl:value-of select="dp:variable('var://service/error-message')" />
	        </xsl:variable>
	
			<xsl:variable name="ErrorReason">
				<xsl:value-of select="concat(' | Transaction-id :',$transactionid)" />
			   		<xsl:if test=" $ReqAcceptEncoding != '' or $ReqAcceptEncoding != ' '">      	
	     	 			<xsl:value-of select="concat(' | Accept-Encoding :',$ReqAcceptEncoding)" />
	     	 		</xsl:if> 
				   <xsl:if test=" $ReqContentType != '' or $ReqContentType != ' '">				
				   	<xsl:value-of select="concat(' | Content-Type :',$ReqContentType)" />
				   </xsl:if> 
				   <xsl:if test=" $ReqSOAPAction != '' or $ReqSOAPAction != ' '">				
				   	<xsl:value-of select="concat(' | SOAPAction :',$ReqSOAPAction)" />
				   </xsl:if> 
				   <xsl:if test=" $ReqContentLength != '' or $ReqContentLength != ' '">				
				   	<xsl:value-of select="concat(' | Content-Length :',$ReqContentLength)" />
				   </xsl:if>
				   <xsl:if test=" $ReqTransferEncoding != '' or $ReqTransferEncoding != ' '">				
				   	<xsl:value-of select="concat(' | Transfer-Encoding :',$ReqTransferEncoding)" />
				   </xsl:if> 
				   <xsl:if test=" $ReqXClientIP != '' or $ReqXClientIP != ' '">				
				   	<xsl:value-of select="concat(' | X-Client-IP :',$ReqXClientIP)" />
				   </xsl:if> 
				   <xsl:if test=" $ReqXinfoperation != '' or $ReqXinfoperation != ' '">				
				   	<xsl:value-of select="concat(' | Xinfoperation :',$ReqXinfoperation)"/>
				   </xsl:if> 
				   <xsl:if test=" $ReqXinfflowCode != '' or $ReqXinfflowCode != ' '">				
				   	<xsl:value-of select="concat(' | XinfflowCode :',$ReqXinfflowCode)"/>
				   </xsl:if> 
				   <xsl:if test=" $ReqXinfatcoption != '' or $ReqXinfatcoption != ' '">				
				   	<xsl:value-of select="concat(' | Xinfatcoption :',$ReqXinfatcoption)"/>
				   </xsl:if> 

<!-- Http Response -->
		 		   <xsl:value-of select="concat(' | Http Response Code :',$HttpResponseCode)"/>
  				   <xsl:if test=" $ResAcceptEncoding != '' or $ResAcceptEncoding != ' '">				
				   	<xsl:value-of select="concat(' | ResAcceptEncoding :',$ResAcceptEncoding)"/>
				   </xsl:if>
  					 <xsl:if test=" $ResContentType != '' or $ResContentType != ' '">				
				   	<xsl:value-of select="concat(' | ResContentType :',$ResContentType)"/>
				   </xsl:if>
  					 <xsl:if test=" $ResSOAPAction != '' or $ResSOAPAction != ' '">				
				   	<xsl:value-of select="concat(' | ResSOAPAction :',$ResSOAPAction)"/>
				   </xsl:if>
  					 <xsl:if test=" $ResContentLength != '' or $ResContentLength != ' '">				
				   	<xsl:value-of select="concat(' | ResContentLength :',$ResContentLength)"/>
				   </xsl:if>	
  					 <xsl:if test=" $XresponseSystem != '' or $XresponseSystem != ' '">				
				   	<xsl:value-of select="concat(' | XresponseSystem :',$XresponseSystem)"/>
				   </xsl:if>							   							   							 
<!-- wdp error message -->								 
				   <xsl:if test=" $WDPErrorMessage != '' or $WDPErrorMessage != ' '">				
				   	<xsl:value-of select="concat(' | WDPErrorMessage :',$WDPErrorMessage)"/>
				   </xsl:if> 
				</xsl:variable>
							
		      <func:result select="string($ErrorReason)" />
      </func:function>
          
       <!--
         ERROR(http error code) codeId check 
         return  codeId(PIP.I01)
      -->
		  <func:function name="func:CodeIdChk">
		  	<xsl:param name="HBI"/>

		      <xsl:variable name="httprc" select="normalize-space(dp:response-header('x-dp-response-code'))" />
		      <dp:set-variable name="'var://context/MYVAR/httprc'" value="$httprc"/>
					<xsl:variable name="subcode">
						<xsl:value-of select="dp:variable('var://service/error-subcode')"/>
					</xsl:variable>
					<xsl:variable name="codeId">
						<xsl:value-of select="dp:variable('var://context/MYVAR/codeId')"/>
					</xsl:variable>		
          <xsl:variable name="error-code">
          	<xsl:value-of select="dp:variable('var://service/error-code')"/>
          </xsl:variable> 
          <xsl:variable name="WebServiceProxy">
          	<xsl:value-of select="dp:variable('var://service/processor-name')"/>
          </xsl:variable>  
          
			<xsl:variable name="codeId">
				<xsl:choose>
					<xsl:when test=" $subcode = $Common0x01d30002 ">
						<xsl:value-of select="$CommonPIPA01" />
					</xsl:when>
					<xsl:when test=" $subcode = $Common0x01d30001 ">
						<xsl:value-of select="CommonPIPA02" />
					</xsl:when>
					<xsl:when test=" contains ($httprc,$CommonHTTPC404) 
									or contains ($httprc,$CommonHTTPC500) 
									or contains ($httprc,$CommonHTTPC503) 
									or $error-code = $Common0x01130011 ">
						<xsl:choose>
							<xsl:when test=" contains ($WebServiceProxy,$CommonPSG1AWINCCA01) 
											or contains ($WebServiceProxy,$CommonPSG1AWINCCA02)
											or contains ($WebServiceProxy,$CommonPSG1AWINECA01)
											or contains ($WebServiceProxy,$CommonPSGPIWEXSPI01)
											or contains ($WebServiceProxy,$CommonPSGSKYEXSPI01)">
								<xsl:value-of select="$CommonPIPE02" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$CommonPIPI02" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test=" $codeId = '' or $codeId = ' '">
								<xsl:choose>
									<xsl:when test=" $HBI = 'B' ">
										<xsl:value-of select="$CommonPIPV03" />
									</xsl:when>
									<xsl:when test=" $HBI = 'I' ">
										<xsl:value-of select="$CommonPIPI99" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$CommonPIPI01" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="string($codeId)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
	    </xsl:variable>
		      <func:result select="string($codeId)" />
      </func:function>      
      
       <!--
        1abypass longtext upper case
         return  MESSAGE
      -->

		  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
		  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
		  <func:function name="func:Uppercase">
		   <xsl:param name="changeString"/>
		      <xsl:variable name="changeString">
                <xsl:value-of select="translate($changeString,$smallcase,$uppercase)" />
          </xsl:variable>
		      <func:result select="string($changeString)" />
      </func:function>
      
       <!--
        1abypass longtext validation
         return  message
      -->
		
      <func:function name="func:ValidLongText">
      	<xsl:param name="LongTextString"/>
      	<xsl:param name="tscode"/>
          <xsl:variable name="LongTextString">
          	<xsl:value-of select="regexp:replace($LongTextString,' ','g','')"/>
          </xsl:variable>		
          
			<xsl:variable name="TextString">
				<xsl:choose>
					<xsl:when test=" $tscode = $CommonStart or $tscode = $CommonEnd ">
						<xsl:value-of select="$LongTextString"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($LongTextString,1,2)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>	
									
          <dp:set-variable name="'var://context/MYVAR/ValidLongText'" value="string('false')" />
          
	       	<xsl:variable name="PSG1ABEXEPI01Config" select="document('local:///IF_1Abypass/PSG1ABEXEPI01Config.xml',PSG1ABEXEPI01Config)"/> 
	       	
			    <xsl:for-each select="$PSG1ABEXEPI01Config//*[local-name()=$tscode]/*[local-name()='Command']">
						<xsl:variable name="CmdValue">
							<xsl:value-of select="."/>
						</xsl:variable>		


			   		<xsl:if test=" $TextString = $CmdValue">
						 		<dp:set-variable name="'var://context/MYVAR/ValidLongText'" value="string('true')" />
						</xsl:if>
						  
	    	  </xsl:for-each>
          <xsl:variable name="ValidLongText"><xsl:value-of select="dp:variable('var://context/MYVAR/ValidLongText')"/></xsl:variable>  
            	  
			    <func:result select="string($ValidLongText)" />
      </func:function>

       <!--
         get MQ target url
         return  URL
      -->
      <func:function name="func:getMQUrl">
       <xsl:variable name="WsProxyName"><xsl:value-of select="dp:variable('var://service/processor-name')" /></xsl:variable>	
       <xsl:variable name="WdpMQConnURLConfig" select="document('local:///IF_common/WdpMQConnUrlConfig.xml',WdpMQConnURLConfig)"/> 
		   <xsl:variable name="URL"><xsl:value-of select="$WdpMQConnURLConfig//*[local-name()=$WsProxyName]/*[local-name()='URL']/text()"/></xsl:variable>   
		      <func:result select="string($URL)" />
      </func:function>
     <!--
     		create 1abypass IFID,destServiceName
     -->
        <func:function name="func:set1ABIFID">
      		<xsl:param name="ENTERKE"/>
          <xsl:param name="bodyLongText"/>
          <xsl:variable name="bodyLongText">
          	<xsl:value-of select="regexp:replace($bodyLongText,' ','g','')"/>
          </xsl:variable>
		<xsl:variable name="preIFID"><xsl:value-of select="substring-after(dp:http-request-header('SOAPAction'), '//')"/></xsl:variable>
		<xsl:variable name="preIFID"><xsl:value-of select="substring-after($preIFID, '/')"/></xsl:variable>
		<xsl:variable name="preIFID"><xsl:value-of select="substring($preIFID,1,number(string-length($preIFID))-1)"/></xsl:variable>
		<xsl:variable name="urlIn"><xsl:value-of select="dp:variable('var://service/URL-in')"/></xsl:variable>			
		<xsl:variable name="version"><xsl:value-of select="substring-after($urlIn, '//')"/></xsl:variable>			
		<xsl:variable name="version"><xsl:value-of select="substring-after($version, '/')"/></xsl:variable>			
		<xsl:variable name="version"><xsl:value-of select="substring-after($version, '/')"/></xsl:variable>	
		<xsl:choose>
			<xsl:when test=" $bodyLongText=$ENTERKE ">
				<dp:set-variable name="'var://context/MYVAR/middleIFID'" value="string($bodyLongText)"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/MYVAR/middleIFID'" value="substring($bodyLongText,1,2)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="IFID"><xsl:value-of select="$preIFID"/>_<xsl:value-of select="dp:variable('var://context/MYVAR/middleIFID')"/>_<xsl:value-of select="$version"/></xsl:variable>
		<dp:set-variable name="'var://context/MYVAR/IFID'" value="string($IFID)" />
	

 		<xsl:variable name="IFID"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')"/></xsl:variable>
 		<xsl:variable name="destServiceName"><xsl:value-of select="substring($IFID,1,number(string-length($IFID))-6)" /></xsl:variable>
		<xsl:variable name="destServiceName"><xsl:value-of select="substring($destServiceName,1,118)" /><xsl:value-of select="str:padding(118-number(string-length($destServiceName)),' ')" /></xsl:variable><!--20130219 add-->
		<dp:set-variable name="'var://context/MYVAR/destServiceName'" value="string($destServiceName)"/>

		<func:result select="string($IFID)" />
      </func:function>

    <!--
       context variable set IFID
       context variable set destServiceName 
    -->

		<func:function name="func:setIFIDDSN">
			<xsl:variable name="preIFID"><xsl:value-of select="substring-after(dp:http-request-header('SOAPAction'), '//')"/></xsl:variable>
			<xsl:variable name="preIFID"><xsl:value-of select="substring-after($preIFID, '/')"/></xsl:variable>
			<xsl:variable name="preIFID"><xsl:value-of select="substring($preIFID,1,number(string-length($preIFID))-1)"/></xsl:variable>			
			<xsl:variable name="urlIn"><xsl:value-of select="dp:variable('var://service/URL-in')"/></xsl:variable>			
			<xsl:variable name="version"><xsl:value-of select="substring-after($urlIn, '//')"/></xsl:variable>			
			<xsl:variable name="version"><xsl:value-of select="substring-after($version, '/')"/></xsl:variable>			
			<xsl:variable name="version"><xsl:value-of select="substring-after($version, '/')"/></xsl:variable>		
			<dp:set-variable name="'var://context/MYVAR/version'" value="string($version)" />
			<xsl:variable name="IFID"><xsl:value-of select="$preIFID"/>_<xsl:value-of select="$version"/></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/IFID'" value="string($IFID)" />

			<!-- go to validation -->		
			<xsl:variable name="destServiceName"><xsl:value-of select="substring($IFID,1,number(string-length($IFID))-6)" /></xsl:variable>
			<xsl:variable name="destServiceName"><xsl:value-of select="substring($destServiceName,1,118)" /><xsl:value-of select="str:padding(118-number(string-length($destServiceName)),' ')" /></xsl:variable><!--20130219 add-->
			<dp:set-variable name="'var://context/MYVAR/destServiceName'" value="string($destServiceName)"/>		

		<func:result select="$IFID" />
      </func:function>

         <!--
     		set error message
     -->
           <func:function name="func:setErrorMsg">
				<xsl:param name="valid"/>
				<xsl:variable name="errorreason">
					<xsl:value-of select="dp:variable('var://service/error-message')" />
				</xsl:variable>
				<xsl:variable name="codeDesc">
					<xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test=" contains ($valid,'missing') 
									or contains ($valid,'empty')
 									or contains ($valid,'wrong')
 									or contains ($valid,'Invalid')">
						<xsl:variable name="codeDesc"><xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/></xsl:variable>
						<xsl:variable name="codeDesc"><xsl:value-of select="substring-before($codeDesc, '(s)')"/>(<xsl:value-of select="$errorreason"/>)<xsl:value-of select="substring-after($codeDesc, '(s)')"/></xsl:variable>					
						<xsl:variable name="codeDesc"><xsl:value-of select="substring-before($codeDesc, 'Request System')"/><xsl:value-of select="dp:variable('var://context/MYVAR/requestSystem')"/></xsl:variable>					
						<dp:set-variable name="'var://context/MYVAR/codeDesc'" value="string($codeDesc)" />					
					</xsl:when>	
					<xsl:when test=" $valid = 'notFound_WSRRInfo' ">
						<xsl:variable name="codeDesc"><xsl:value-of select="substring-before($codeDesc, '%')"/><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')"/><xsl:value-of select="substring-after($codeDesc, '%')"/></xsl:variable>					
						<dp:set-variable name="'var://context/MYVAR/codeDesc'" value="string($codeDesc)" />
					</xsl:when>	
	            </xsl:choose>
				<xsl:variable name="codeDesc">
					<xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/>
				</xsl:variable>
			    <func:result select="string($codeDesc)" />
         </func:function>

      <!--
         get WdpErrorCode
         return  WdpErrorCode
      -->
      <func:function name="func:getWdpErrorCode">
      	<xsl:param name="GROUPCODEID"/>
      	<xsl:param name="CODEID"/>
	       <xsl:variable name="WdpErrorCode" select="document('local:///IF_common/WdpErrorCode.xml',WdpErrorCode)"/> 
       
				<xsl:variable name="customerErrorCode"><xsl:value-of select="$WdpErrorCode//*[local-name()=$GROUPCODEID]/*[local-name()=$CODEID]/*[local-name()='CUSTOMER_ERROR_CODE']/text()"/></xsl:variable>
				<dp:set-variable name="'var://context/MYVAR/customerErrorCode'" value="string($customerErrorCode)" />
				
				<xsl:variable name="codeName"><xsl:value-of select="$WdpErrorCode//*[local-name()=$GROUPCODEID]/*[local-name()=$CODEID]/*[local-name()='CODE_NM']/text()"/></xsl:variable>
				<dp:set-variable name="'var://context/MYVAR/codeName'" value="string($codeName)" />
				
				<xsl:variable name="codeDesc"><xsl:value-of select="$WdpErrorCode//*[local-name()=$GROUPCODEID]/*[local-name()=$CODEID]/*[local-name()='CODE_DESC']/text()"/></xsl:variable>
				<dp:set-variable name="'var://context/MYVAR/codeDesc'" value="string($codeDesc)" />
				
				<xsl:variable name="codeType"><xsl:value-of select="$WdpErrorCode//*[local-name()=$GROUPCODEID]/*[local-name()=$CODEID]/*[local-name()='CODE_TYPE']/text()"/></xsl:variable>
				<dp:set-variable name="'var://context/MYVAR/codeType'" value="string($codeType)" />
  
			    <func:result select="string($codeDesc)" />
      </func:function>
      


     <!--
         generate uuid
         return  tranid
      -->
      <func:function name="func:getTranid">
      	
      	<xsl:variable name="BooleanTranid"><xsl:value-of select="boolean(dp:variable('var://context/MYVAR/Tranid'))" /></xsl:variable>
      	  <xsl:if test=" $BooleanTranid='false' ">
      			<xsl:variable name="Tranid" select="dp:generate-uuid()"/> 
      			<dp:set-variable name="'var://context/MYVAR/Tranid'" value="$Tranid" />
      	  </xsl:if> 
      	  
      	  <xsl:variable name="tid"><xsl:value-of select="dp:variable('var://context/MYVAR/Tranid')" /></xsl:variable> 
		      <func:result select="string($tid)" />
      </func:function>
      
      
     <!--
         lss hybrid config file get EncryptionToken
         return  EncryptionToken
      -->
      <func:function name="func:getEncryptionToken">
       <xsl:variable name="Config" select="document('local:///IF_common/PSGAUTEXEPIConfig.xml',PSGAUTEXEPIConfig)"/> 
		   <xsl:variable name="EncryptionToken"><xsl:value-of select="$Config//*[local-name()='EncryptionToken']/text()"/></xsl:variable>   
		      <func:result select="string($EncryptionToken)" />
      </func:function>
      
     <!--
         1a bypass config file read enterke
         return  enterke
      -->
      <func:function name="func:BodyLongText">
       <xsl:variable name="WsProxyName"><xsl:value-of select="dp:variable('var://service/processor-name')" /></xsl:variable>	
       <xsl:variable name="Config" select="document('local:///IF_1Abypass/PSG1ABEXEPI01Config.xml',PSG1ABEXEPI01Config)"/> 
		   <xsl:variable name="bodyLongText"><xsl:value-of select="$Config//*[local-name()=$WsProxyName]/*[local-name()='bodyLongText']/text()"/></xsl:variable>   
		      <func:result select="string($bodyLongText)" />
      </func:function>

     <!--
         logconfig file read loglevel
         return  loglevel
      -->
      <func:function name="func:LogLevel">
       <xsl:variable name="WsProxyName"><xsl:value-of select="dp:variable('var://service/processor-name')" /></xsl:variable>	
       <xsl:variable name="WdpLoglevelConfig" select="document('local:///IF_common/WdpLoglevelConfig.xml',WdpLoglevelConfig)"/> 
		   <xsl:variable name="LLevel"><xsl:value-of select="$WdpLoglevelConfig//*[local-name()=$WsProxyName]/*[local-name()='LogLevel']/text()"/></xsl:variable>   
		      <func:result select="string($LLevel)" />
      </func:function>
      
           <!--
         logconfig file read imsloglevel
         return  loglevel
      -->
      <func:function name="func:ImsLogLevel">
       <xsl:variable name="WsProxyName"><xsl:value-of select="dp:variable('var://service/processor-name')" /></xsl:variable>	
       <xsl:variable name="WdpLoglevelConfig" select="document('local:///IF_common/WdpLoglevelConfig.xml',WdpLoglevelConfig)"/> 
		   <xsl:variable name="ILLevel"><xsl:value-of select="$WdpLoglevelConfig//*[local-name()=$WsProxyName]/*[local-name()='ImsLogLevel']/text()"/></xsl:variable>   
		      <func:result select="string($ILLevel)" />
      </func:function>
      
       <!--
         logconfig file read imsloglevel
         return  loglevel
      -->
      <func:function name="func:NoMsg">
       <xsl:variable name="WsProxyName"><xsl:value-of select="dp:variable('var://service/processor-name')" /></xsl:variable>	
       <xsl:variable name="WdpLoglevelConfig" select="document('local:///IF_common/WdpLoglevelConfig.xml',WdpLoglevelConfig)"/> 
		   <xsl:variable name="NoMsg"><xsl:value-of select="$WdpLoglevelConfig//*[local-name()=$WsProxyName]/*[local-name()='NoMsg']/text()"/></xsl:variable>   
		      <func:result select="string($NoMsg)" />
      </func:function>
      
     <!--
         logconfig file read HBinfo
         return  loglevel
      -->
      <func:function name="func:HBinfo">
      	<xsl:param name="hopcnt"/>
      	<xsl:param name="ImsLogLevel"/>
       <xsl:variable name="WsProxyName"><xsl:value-of select="dp:variable('var://service/processor-name')" /></xsl:variable>
       <xsl:variable name="HopCount"><xsl:value-of select="string('HopCnt')" /><xsl:value-of select="$hopcnt" /></xsl:variable>
       <xsl:variable name="WdpLoglevelConfig" select="document('local:///IF_common/WdpLoglevelConfig.xml',WdpLoglevelConfig)"/> 
		   <xsl:variable name="HB"><xsl:value-of select="$WdpLoglevelConfig//*[local-name()=$WsProxyName]/*[local-name()=$ImsLogLevel]/*[local-name()=$HopCount]/*[local-name()='HBInfo']/text()"/></xsl:variable>   
		      <func:result select="string($HB)" />
      </func:function>      
     <!--
         function name: TimeLog
                         
         return  timestamp
      -->      
      <func:function name="func:TimeLog">
      	  <xsl:variable name="time-value"><xsl:value-of select="dp:time-value()" /></xsl:variable>
		    	<xsl:variable name="millisecond"><xsl:value-of select="substring($time-value,11,3)" /></xsl:variable>
		      <xsl:variable name="date-time"><xsl:value-of select="date:date-time()"/></xsl:variable>
		      <xsl:variable name="format-date"><xsl:value-of select="date:format-date($date-time,'yyyyMMddHHmmss')" /></xsl:variable>
		      <xsl:variable name="systemTime"><xsl:value-of select="$format-date" /><xsl:value-of select="$millisecond" /></xsl:variable>
		      
		      <func:result select="string($systemTime)" />
      </func:function>
      
     <!--
         function name: LoggingDebug
                        Debug mode logging
         return  none
      -->       
      <func:function name="func:LoggingDebug">

        <xsl:param name="VarName"/>
        <xsl:param name="NameValue"/>
        
        <xsl:variable name="WebServiceProxy"><xsl:value-of select="dp:variable('var://service/processor-name')"/></xsl:variable>
        <xsl:variable name="transactionid"><xsl:value-of select="dp:variable('var://service/transaction-id')"/></xsl:variable>
        <xsl:variable name="ifid"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')"/></xsl:variable>
        <xsl:variable name="LogLevel"><xsl:value-of select="func:LogLevel()"/></xsl:variable>

				<xsl:variable name="WebServiceProxy">
					<xsl:choose>
						<xsl:when test=" contains ($domain,$CommonMIG) ">
							<xsl:value-of select="concat($WebServiceProxy,$CommonMIG)" />
						</xsl:when>
						<xsl:when test=" contains ($domain,$CommonSKL) ">
							<xsl:value-of select="concat($WebServiceProxy,$CommonSKL)" />
						</xsl:when>
					  <xsl:otherwise>
							<xsl:value-of select="$WebServiceProxy" />
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:variable>	
				        
				<xsl:message terminate="no" dp:type="{$WebServiceProxy}" dp:priority="debug">
CLog: <xsl:value-of select="func:TimeLog()"/>:(tid)<xsl:value-of select="$transactionid"/> :<xsl:value-of select="$ifid"/>: <xsl:value-of select="$VarName"/> : <xsl:value-of select="$NameValue"/>
				</xsl:message>
 			   
      </func:function>
      <!--
         function name: LoggingError
                        Error mode logging
         return  none
      -->        
      <func:function name="func:LoggingError">
        <xsl:param name="VarName"/>
        <xsl:param name="NameValue"/>
        <xsl:variable name="WebServiceProxy"><xsl:value-of select="dp:variable('var://service/processor-name')"/></xsl:variable>
        <xsl:variable name="transactionid"><xsl:value-of select="dp:variable('var://service/transaction-id')"/></xsl:variable>
        <xsl:variable name="ifid"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')"/></xsl:variable>        

				<xsl:variable name="WebServiceProxy">
					<xsl:choose>
						<xsl:when test=" contains ($domain,$CommonMIG) ">
							<xsl:value-of select="concat($WebServiceProxy,$CommonMIG)" />
						</xsl:when>
						<xsl:when test=" contains ($domain,$CommonSKL) ">
							<xsl:value-of select="concat($WebServiceProxy,$CommonSKL)" />
						</xsl:when>
					    <xsl:otherwise>
							<xsl:value-of select="$WebServiceProxy" />
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:variable>	
				
				<xsl:message terminate="no" dp:type="{$WebServiceProxy}" dp:priority="error">
CLog: <xsl:value-of select="func:TimeLog()"/> :(tid)<xsl:value-of select="$transactionid"/> :<xsl:value-of select="$ifid"/>: <xsl:value-of select="$VarName"/> : <xsl:value-of select="$NameValue"/>
				</xsl:message>

      </func:function>
      <!--
         function name: LoggingInfo
                        Info mode logging
                        dp:type : logtarget name defined in wdp.
         input : string,string
         return  none
      -->      
      <func:function name="func:LoggingInfo">
        <xsl:param name="VarName"/>
        <xsl:param name="NameValue"/>
        
        <!-- Get the value of the service variable WDP -->
        <xsl:variable name="WebServiceProxy"><xsl:value-of select="dp:variable('var://service/processor-name')"/></xsl:variable>
        <xsl:variable name="transactionid"><xsl:value-of select="dp:variable('var://service/transaction-id')"/></xsl:variable>
        <xsl:variable name="domain"><xsl:value-of select="dp:variable('var://service/domain-name')"/></xsl:variable>
        <xsl:variable name="ifid"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')"/></xsl:variable>  
        <!--
            dp:type
            Web Service Proxy name + 3 digit domain name. (MIG/SKL)
            WDP equipment used in the case of two or more domains.
         -->
				<xsl:variable name="WebServiceProxy">
					<xsl:choose>
						<xsl:when test=" contains ($domain,$CommonMIG) ">
							<xsl:value-of select="concat($WebServiceProxy,$CommonMIG)" />
						</xsl:when>
						<xsl:when test=" contains ($domain,$CommonSKL) ">
							<xsl:value-of select="concat($WebServiceProxy,$CommonSKL)" />
						</xsl:when>
					  <xsl:otherwise>
							<xsl:value-of select="$WebServiceProxy" />
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:variable>	        
        <!-- 
        Set output format message.  
        func:TimeLog() : output message time.
        tid : WDP transaction ID
        IFID : Interfaceid
        -->
				<xsl:message terminate="no" dp:type="{$WebServiceProxy}" dp:priority="info">
CLog: <xsl:value-of select="func:TimeLog()"/>:(tid)<xsl:value-of select="$transactionid"/> :<xsl:value-of select="$ifid"/>: <xsl:value-of select="$VarName"/> : <xsl:value-of select="$NameValue"/>
				</xsl:message>

      </func:function>
      <!--
         function name: ImsLogging
                        Ims loglevel logging
                        Substring of the surface response message over the 2MB
         input : HBinfo : header_body message flag
                 NoMsg  : no message flag Y/N
                 SoapMessage : all the soap message.
                 Header      : header message
                 Body        : body message
                 nomessage   : empty message
         
         return  
      -->
      <func:function name="func:ImsLogging">
      	<xsl:param name="HBinfo"/>
      	<xsl:param name="NoMsg"/>
        <xsl:param name="SoapMessage"/>
        <xsl:param name="Header"/>
        <xsl:param name="Body"/>
        <xsl:param name="nomessage"/>

         <xsl:variable name="nomessage" select="string('')"/>
         
			   <xsl:if test=" $NoMsg='Y' ">
			   	<func:result select="$nomessage" />
			   </xsl:if>                
 			   <xsl:if test=" $HBinfo='Y_Y' ">
      <!-- Substring of the surface response message over the 2MB -->
				<xsl:variable name="SoapMessage">
					<dp:serialize select="$SoapMessage"/>
				</xsl:variable> 
			     <xsl:variable name="SoapMessage">
					<xsl:choose>
						<xsl:when test="dp:variable('var://service/mpgw/response-size') &gt; $CommonMsgSize ">
							<xsl:value-of disable-output-escaping="yes" select="substring($SoapMessage,1,$CommonMsgSize)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of disable-output-escaping="yes" select="$SoapMessage" />
						</xsl:otherwise>
					</xsl:choose>
				 </xsl:variable>
 			   	<func:result select="$SoapMessage" />
			   </xsl:if>
			   <xsl:if test=" $HBinfo='Y_N' ">
			   	<func:result select="$Header" />
			   </xsl:if>
			   <xsl:if test=" $HBinfo='N_Y' ">
			   	<func:result select="$Body" />
			   </xsl:if>
      </func:function>
</xsl:stylesheet>