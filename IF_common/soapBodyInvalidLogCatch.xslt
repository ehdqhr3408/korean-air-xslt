<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    exclude-result-prefixes="dp" 
    xmlns:func="http://exslt.org/functions"
    xmlns:str="http://exslt.org/strings"
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">

<xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">   
    	<dp:set-variable name="'var://context/MYVAR/XresponseSystem'" value="dp:response-header('X-responseSystem')"/>
    	<!--1220 add-->
      <xsl:variable name="resData"><xsl:copy-of select="."/></xsl:variable>
 			<dp:set-variable name="'var://context/MYVAR/resData'" value="$resData"/>

			<dp:set-variable name="'var://context/MYVAR/faultactor'" value="string('WDP')"/>
  		<xsl:variable name="guid">
  			<xsl:value-of select="dp:variable('var://context/MYVAR/guid')"/>
  		</xsl:variable>
  		
		
		<xsl:if test=" $guid='' or $guid=' ' ">
			
		  <dp:set-variable name="'var://context/MYVAR/reqData'" value="." />
                  
		  <xsl:variable name="IFID" select="func:setIFIDDSN()"/>
      <!--LOG--><xsl:value-of select="func:LoggingInfo('ifid set',$IFID)"/>
      <!-- ims logging list add 20130816-->  
      <dp:set-variable name="'var://context/MYVAR/isEretail'" value="false()"/>
      <xsl:if test="contains($IFID,'E_Retail')">
      	<dp:set-variable name="'var://context/MYVAR/isEretail'" value="true()"/>
      </xsl:if>

      <xsl:variable name="JSESSIONID">
				<xsl:value-of select="substring-after(dp:http-request-header('Cookie'),'JSESSIONID=')"/>
			</xsl:variable>
			<xsl:variable name="Xinfoperation">
				<xsl:value-of select="dp:http-request-header('X-inf-operation')"/>
			</xsl:variable>
			<xsl:variable name="XinfflowCode">
				<xsl:value-of select="dp:http-request-header('X-inf-flowCode')"/>
			</xsl:variable>
			<xsl:variable name="Xinfatcoption">
				<xsl:value-of select="dp:http-request-header('X-inf-atcoption')"/>
			</xsl:variable>

			<dp:set-variable name="'var://context/MYVAR/JSESSIONID'" value="string($JSESSIONID)"/>
			<dp:set-variable name="'var://context/MYVAR/Xinfoperation'" value="string($Xinfoperation)"/>
			<dp:set-variable name="'var://context/MYVAR/XinfflowCode'" value="string($XinfflowCode)"/>
			<dp:set-variable name="'var://context/MYVAR/Xinfatcoption'" value="string($Xinfatcoption)"/>
			<!--LOG--><xsl:value-of select="func:LoggingInfo('JSESSIONID set',$JSESSIONID)"/>
			<!--LOG--><xsl:value-of select="func:LoggingInfo('Xinfoperation set',$Xinfoperation)"/>
			<!--LOG--><xsl:value-of select="func:LoggingInfo('XinfflowCode set',$XinfflowCode)"/>
			<!--LOG--><xsl:value-of select="func:LoggingInfo('Xinfatcoption set',$Xinfatcoption)"/>

      <!-- ims logging list add 20130816 end --> 
      
      <xsl:variable name="guid"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='guid']/text()" /></xsl:variable>			
			<xsl:variable name="requestSystem"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='requestSystem']/text()" /></xsl:variable>
			<xsl:variable name="employeeNo"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='employeeNo']/text()" /></xsl:variable>
			<xsl:variable name="lssUserId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='lssUserId']/text()" /></xsl:variable>
			<xsl:variable name="officeId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='officeId']/text()" /></xsl:variable>
			<xsl:variable name="dutyCode"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='dutyCode']/text()" /></xsl:variable>
			<xsl:variable name="wsap"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='wsap']/text()" /></xsl:variable>

			<xsl:variable name="sessionType"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionType']/text()" /></xsl:variable>
			<xsl:variable name="sessionId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionId']/text()" /></xsl:variable>
			<xsl:variable name="sequenceNumber"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sequenceNumber']/text()" /></xsl:variable>
			<xsl:variable name="securityToken"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='securityToken']/text()" /></xsl:variable>

			<xsl:variable name="procdt"><xsl:value-of select="substring(func:TimeLog(),7,2)"/></xsl:variable>		
			<xsl:variable name="procdtsndsyscd"><xsl:value-of select="concat($procdt,$requestSystem)"/></xsl:variable>	

			<dp:set-variable name="'var://context/MYVAR/procdtsndsyscd'" value="string($procdtsndsyscd)" />
			<!--LOG--><xsl:value-of select="func:LoggingInfo('func create procdtsndsyscd :',$procdtsndsyscd)"/>

  		<dp:set-variable name="'var://context/MYVAR/guid'" value="string($guid)"/>
  		<dp:set-variable name="'var://context/MYVAR/requestSystem'" value="string($requestSystem)"/>
  		<dp:set-variable name="'var://context/MYVAR/employeeNo'" value="string($employeeNo)"/>
  		<dp:set-variable name="'var://context/MYVAR/lssUserId'" value="string($lssUserId)"/>
  		<dp:set-variable name="'var://context/MYVAR/officeId'" value="string($officeId)"/>
  		<dp:set-variable name="'var://context/MYVAR/dutyCode'" value="string($dutyCode)"/>
  		<dp:set-variable name="'var://context/MYVAR/wsap'" value="string($wsap)"/>
  		<dp:set-variable name="'var://context/MYVAR/sessionType'" value="string($sessionType)"/>
  		<dp:set-variable name="'var://context/MYVAR/sessionId'" value="string($sessionId)"/>
  		<dp:set-variable name="'var://context/MYVAR/sequenceNumber'" value="string($sequenceNumber)"/>
  		<dp:set-variable name="'var://context/MYVAR/securityToken'" value="string($securityToken)"/>
	  </xsl:if>

		  <xsl:variable name="errorMsg"><xsl:value-of select="dp:variable('var://service/error-message')" /></xsl:variable>
<!-- http error,validation error check 

		  	<xsl:param name="HVI"/>
			  <xsl:param name="codeId"/>

-->       
      <xsl:variable name="codeId" select="func:CodeIdChk(string('B'))"/>
<!-- http error,validation error check -->
	
			<!--LOG--><xsl:value-of select="func:LoggingInfo('getWdpErrorCode start',$codeId)"/>
	    <xsl:variable name="ErrorCodeResult" select="func:getWdpErrorCode('PIP_ERROR_01',$codeId)"/>
	    <!--LOG--><xsl:value-of select="func:LoggingInfo('getWdpErrorCode End',$ErrorCodeResult)"/>

			<xsl:variable name="errorMsg">
						<xsl:value-of select="dp:variable('var://context/MYVAR/codeType')"/>|<xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/> ( <xsl:value-of select="$errorMsg"/> )
			</xsl:variable>		
			<xsl:variable name="customerErrorCode"><xsl:value-of select="dp:variable('var://context/MYVAR/customerErrorCode')"/></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/errorCode'" value="string($customerErrorCode)"/>
			<dp:set-variable name="'var://context/MYVAR/errorMsg'" value="string($errorMsg)"/>
			
			<xsl:copy-of select="." />

    </xsl:template>
</xsl:stylesheet>