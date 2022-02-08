<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:str="http://exslt.org/strings"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp">

<xsl:include href="local:///IF_common/LoggingUtil.xsl"/> 
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">
      <xsl:variable name="reqData"><xsl:copy-of select="."/></xsl:variable>
 			<dp:set-variable name="'var://context/MYVAR/reqData'" value="$reqData"/>

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
      
			<xsl:variable name="guidBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='guid'])" /></xsl:variable>
			<xsl:variable name="requestSystemBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='requestSystem'])" /></xsl:variable>
			<xsl:variable name="employeeNoBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='employeeNo'])" /></xsl:variable>
			<xsl:variable name="lssUserIdBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='lssUserId'])" /></xsl:variable>
			<xsl:variable name="officeIdBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='officeId'])" /></xsl:variable>
			<xsl:variable name="dutyCodeBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='dutyCode'])" /></xsl:variable>
			<xsl:variable name="wsapBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='wsap'])" /></xsl:variable>
			<xsl:variable name="sessionTypeBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionType'])" /></xsl:variable>

			<xsl:variable name="guid"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='guid']/text()" /></xsl:variable>
			<xsl:variable name="requestSystem"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='requestSystem']/text()" /></xsl:variable>
			<xsl:variable name="employeeNo"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='employeeNo']/text()" /></xsl:variable>
			<xsl:variable name="lssUserId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='lssUserId']/text()" /></xsl:variable>
			<xsl:variable name="officeId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='officeId']/text()" /></xsl:variable>
			<xsl:variable name="dutyCode"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='dutyCode']/text()" /></xsl:variable>
			<xsl:variable name="wsap"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='wsap']/text()" /></xsl:variable>
			<!--20130219 add-->	
		  <xsl:variable name="companyName"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='companyName']/text()"/></xsl:variable>
		  <xsl:variable name="workstationId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='workstationId']/text()"/></xsl:variable>

			<xsl:variable name="sessionType"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionType']/text()" /></xsl:variable>
			<xsl:variable name="sessionId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionId']/text()" /></xsl:variable>
			<xsl:variable name="sequenceNumber"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sequenceNumber']/text()" /></xsl:variable>
			<xsl:variable name="securityToken"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='securityToken']/text()" /></xsl:variable>

<xsl:variable name="procdt"><xsl:value-of select="substring(func:TimeLog(),7,2)"/></xsl:variable>		
<xsl:variable name="procdtsndsyscd"><xsl:value-of select="concat($procdt,$requestSystem)"/></xsl:variable>	

<dp:set-variable name="'var://context/MYVAR/procdtsndsyscd'" value="string($procdtsndsyscd)" />
<xsl:value-of select="func:LoggingInfo('func create procdtsndsyscd :',$procdtsndsyscd)"/>

  		<dp:set-variable name="'var://context/MYVAR/guid'" value="string($guid)"/>
<xsl:value-of select="func:LoggingInfo('soapHeaderValidFilter start',string($guid))"/>
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
		<dp:set-variable name="'var://context/MYVAR/companyName'" value="string($companyName)"/><!--20130219 add-->
		<dp:set-variable name="'var://context/MYVAR/workstationId'" value="string($workstationId)"/><!--20130219 add-->


			<xsl:choose>
				<!--xsl:when test=" $guid='NaN' or $guidSequence='NaN' "-->
				<xsl:when test=" $guidBoolean='false' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_guid'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
					<dp:xreject reason="'Common Soap Header tag guid is missing'"/>
					<!--dp:reject /-->
				</xsl:when>
				<xsl:when test=" $requestSystemBoolean='false' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_requestSystem'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
					<dp:xreject reason="'Common Soap Header tag requestSystem is missing'"/>
					<!--dp:reject /-->
				</xsl:when>
				<!--20130305 xsl:when test=" $employeeNoBoolean='false' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_employeeNo'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
					<dp:xreject reason="'Common Soap Header tag employeeNo is missing'"/>
				</xsl:when-->
				<xsl:when test=" $lssUserIdBoolean='false' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_lssUserId'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
					<dp:xreject reason="'Common Soap Header tag lssUserId is missing'"/>
				</xsl:when>
				<xsl:when test=" $officeIdBoolean='false' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_officeId'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
					<dp:xreject reason="'Common Soap Header tag officeId is missing'"/>
				</xsl:when>
				<xsl:when test=" $dutyCodeBoolean='false' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_dutyCode'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
					<dp:xreject reason="'Common Soap Header tag dutyCode is missing'"/>
				</xsl:when>
				<xsl:when test=" $wsapBoolean='false' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_wsap'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
					<dp:xreject reason="'Common Soap Header tag wsap is missing'"/>
				</xsl:when>
				<xsl:when test=" $sessionTypeBoolean='false' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_sessionType'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
					<dp:xreject reason="'Common Soap Header tag sessionType is missing'"/>
					<!--dp:reject /-->
				</xsl:when>
				<xsl:when test=" $guid='' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_guid'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
					<dp:xreject reason="'Common Soap Header guid is empty value'"/>
					<!--dp:reject /-->
				</xsl:when>
				<xsl:when test=" string-length($guid)!=35 ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'wrong_length_guid'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
					<dp:xreject reason="'Common Soap Header guid length is wrong'"/>
				</xsl:when>
				<xsl:when test=" $requestSystem='' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_requestSystem'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
					<dp:xreject reason="'Common Soap Header requestSystem is empty value'"/>
					<!--dp:reject /-->
				</xsl:when>
				<!--20130305 xsl:when test=" $employeeNo='' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_employeeNo'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
					<dp:xreject reason="'Common Soap Header employeeNo is empty value'"/>
				</xsl:when-->
				<xsl:when test=" $wsap='' and $sessionType = '3' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_wsap'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
					<dp:xreject reason="'Common Soap Header wsap is empty value or sessionType is not 3'"/>
				</xsl:when>
				<xsl:when test=" $sessionType='' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_sessionType'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
					<dp:xreject reason="'Common Soap Header sessionType is empty value'"/>
					<!--dp:reject /-->
				</xsl:when>
				<xsl:when test=" $sessionType != '0' and $sessionType != '1' and $sessionType != '2' and $sessionType != '3' ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'sessionTypeInvalid'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
					<dp:xreject reason="'A sessionType of Common Soap Header is Invalid. Check the Value 0 to 3'"/>
				</xsl:when>
				<xsl:when test=" $sessionType = '1' and $IFID = $CommonSignOut ">
					<dp:set-variable name="'var://context/MYVAR/valid'" value="'sessionTypeInvalid'"/>
					<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
					<dp:xreject reason="'SessionType 1 is SignOut not to use.'"/>
				</xsl:when>
				<xsl:otherwise>
					<dp:accept />
	      	<xsl:copy-of select="." />
				</xsl:otherwise>
			</xsl:choose>	
<xsl:value-of select="func:LoggingInfo('soapHeaderValidFilter End',string($guid))"/>

    </xsl:template>
</xsl:stylesheet>