<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes="dp" 
    xmlns:func="http://exslt.org/functions"
    xmlns:exslt="http://exslt.org/common"
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    

<xsl:output encoding="UTF-8" version="1.0" method="xml"/>    
<xsl:include href="local:///IF_common/LoggingUtil.xsl"/>

		<xsl:param name="dpquery:hopCount" />
    
    <xsl:template match="/">  
         
      <xsl:variable name="requestData"><xsl:copy-of select="."/></xsl:variable>
      <xsl:variable name="requestHeader"><xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Header']" /></xsl:variable>  
    	<xsl:variable name="requestBody"><xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']" /></xsl:variable>  
	    <xsl:variable name="hopCount"><xsl:value-of select="$dpquery:hopCount" /></xsl:variable>
      <!-- LOG --><xsl:value-of select="func:LoggingInfo('Logging start hopCount ',$hopCount)"/>
      
	      <xsl:if test=" $hopCount='01' ">
	 	   			<dp:set-variable name="'var://context/MYVAR/requestData'" value="$requestData"/>
	    	   <dp:set-variable name="'var://context/MYVAR/requestHeader'" value="$requestHeader"/>
	    	   <dp:set-variable name="'var://context/MYVAR/requestBody'" value="$requestBody"/>
				</xsl:if>
				<xsl:if test=" $hopCount='06' ">
	    	   <dp:set-variable name="'var://context/MYVAR/resData'" value="$requestData"/>
	    	   <dp:set-variable name="'var://context/MYVAR/resHeader'" value="$requestHeader"/>
	    	   <dp:set-variable name="'var://context/MYVAR/resBody'" value="$requestBody"/>
	      </xsl:if>

    	<xsl:variable name="ImsLogLevel" select="func:ImsLogLevel()"/>
    	
      <!--LOG--><xsl:value-of select="func:LoggingInfo('ImsLogLevel ',$ImsLogLevel)"/>

      <xsl:variable name="HBinfo" select="func:HBinfo($hopCount,$ImsLogLevel)"/>
     
      <!--LOG--><xsl:value-of select="func:LoggingInfo('HBinfo ',$HBinfo)"/>

     <xsl:if test=" $ImsLogLevel != 'ERROR' and $HBinfo != 'N_N' ">
      	
		  <xsl:variable name="ServerID"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='TransactionFlowLink']/*[local-name()='Receiver']/*[local-name()='ServerID']/text()" /></xsl:variable>
	   	<dp:set-variable name="'var://context/MYVAR/ServerID'" value="string($ServerID)" />

      <xsl:variable name="isECommerce"><xsl:value-of select="dp:variable('var://context/MYVAR/isECommerce')" /></xsl:variable>
      <!--ims logging list add 20130816 -->
      <xsl:variable name="isEretail"><xsl:value-of select="dp:variable('var://context/MYVAR/isEretail')" /></xsl:variable>


      <xsl:variable name="ifid"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')" /></xsl:variable>
      <xsl:variable name="ifid"><xsl:value-of select="substring($ifid,1,124)" /><xsl:value-of select="str:padding(124-number(string-length($ifid)), ' ')" /></xsl:variable><!--20130219 add-->
      
      <xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')" /></xsl:variable>
      <xsl:variable name="guid"><xsl:value-of select="substring($guid,1,33)" /></xsl:variable><!--20130123 modify-->
      <xsl:variable name="guid"><xsl:value-of select="substring($guid,1,35)" /><xsl:value-of select="str:padding(35-number(string-length($guid)), ' ')" /></xsl:variable>

      
      <xsl:variable name="hopCount"><xsl:value-of select="substring($hopCount,1,2)" /><xsl:value-of select="str:padding(2-number(string-length($hopCount)), ' ')" /></xsl:variable>
			
      <xsl:variable name="pipServiceName">
      	<xsl:value-of select="dp:variable('var://context/MYVAR/IFID')" />
      </xsl:variable>
      <xsl:variable name="pipServiceName"><xsl:value-of select="substring($pipServiceName,1,124)" /><xsl:value-of select="str:padding(124-number(string-length($pipServiceName)), ' ')" /></xsl:variable><!--20130219 add-->
			<!-- ims logging list add 20130816 add -->
			<xsl:variable name="destServiceName">
				<xsl:choose>
					<xsl:when test="$isEretail='true'">
						<xsl:value-of select="dp:variable('var://context/MYVAR/Xinfoperation')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="boolean(dp:variable('var://context/MYVAR/PIP_xsdVersion'))">
								<xsl:value-of select="dp:variable('var://context/MYVAR/PIP_xsdVersion')" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="dp:variable('var://context/MYVAR/destServiceName')" />
							</xsl:otherwise>
							</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
	    </xsl:variable>
		  <!-- ims logging list add end-->
    	
    	<xsl:variable name="destServiceName"><xsl:value-of select="substring($destServiceName,1,118)" /><xsl:value-of select="str:padding(118-number(string-length($destServiceName)),' ')" /></xsl:variable>

			<!-- LOG --><xsl:value-of select="func:LoggingDebug('destServiceName ======== ',$destServiceName)"/>
			<!-- serial-number+pipModuleName+transaction-id -->
      <xsl:variable name="ident" select="dp:variable('var://service/system/ident')" />
			<xsl:variable name="sn" select="$ident/identification/serial-number" />	
			<xsl:variable name="trn" select="dp:variable('var://service/transaction-rule-name')" />	
				
      <xsl:variable name="pipModuleName">
      	<xsl:value-of select="concat($sn,'|',$trn)" />
      </xsl:variable>
      <xsl:variable name="pipModuleName"><xsl:value-of select="substring($pipModuleName,1,50)" /><xsl:value-of select="str:padding(50-number(string-length($pipModuleName)),' ')" /></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/pipModuleName'" value="string($pipModuleName)"/>
			<!--LOG--><xsl:value-of select="func:LoggingDebug('pipModuleName ======== ',$pipModuleName)"/>
		  <!-- pipmodulename end -->
			<xsl:variable name="systemTime" select="func:TimeLog()"/>
      <xsl:variable name="systemTime"><xsl:value-of select="substring($systemTime,1,17)" /><xsl:value-of select="str:padding(17-number(string-length($systemTime)),' ')" /></xsl:variable>
      <!-- procd,sndsyscd,recvscd -->
      <xsl:variable name="endpointurl">
      	<xsl:value-of select="dp:variable('var://service/routing-url')"/>
      </xsl:variable> 
      <!-- set response System -->
      <xsl:variable name="XresponseSystem">
		<xsl:choose>
			<xsl:when test=" contains ($pipModuleName,$CommonPSGAUTEXEPI01) ">
				<xsl:value-of select="$CommonIMSSOSYS"/>
			</xsl:when>
			<xsl:when test=" contains ($pipModuleName,$CommonPSGAUTEXEPI02)">
				<xsl:value-of select="$CommonPIPSYS"/>
			</xsl:when>
			<xsl:when test=" dp:variable('var://context/MYVAR/XresponseSystem') = '' 
			                or dp:variable('var://context/MYVAR/XresponseSystem') = ' '">
				<xsl:value-of select="dp:variable('var://context/MYVAR/PIP_recvsystem')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="dp:variable('var://context/MYVAR/XresponseSystem')" />			  
			</xsl:otherwise>
		</xsl:choose>
      </xsl:variable>    
      
      <!-- LOG --><xsl:value-of select="func:LoggingInfo('XresponseSystem  ',$XresponseSystem)"/>    
      <xsl:variable name="procdtsndsyscd">
        <xsl:value-of select="substring(dp:variable('var://context/MYVAR/procdtsndsyscd'),1,5)" />
        <xsl:value-of select="str:padding(5-number(string-length(dp:variable('var://context/MYVAR/procdtsndsyscd'))),' ')" />    	
			<xsl:value-of select="$XresponseSystem"/>   
      </xsl:variable>
      <!-- LOG --><xsl:value-of select="func:LoggingInfo('endpointurl  ',$endpointurl)"/>
      <!-- LOG --><xsl:value-of select="func:LoggingInfo('X-responseSystem  ',dp:response-header('X-responseSystem'))"/>
      <!-- LOG --><xsl:value-of select="func:LoggingInfo('procdtsndsyscd  ',$procdtsndsyscd)"/>
      <xsl:variable name="procdtsndsyscd"><xsl:value-of select="substring($procdtsndsyscd,1,10)" /><xsl:value-of select="str:padding(10-number(string-length($procdtsndsyscd)),' ')" /></xsl:variable>

      <xsl:variable name="systemCode">WDP<xsl:value-of select="str:padding(2,' ')" /></xsl:variable>
      
      <!-- 01:req,06:res -->
			<xsl:variable name="errSystemCode">
				<xsl:choose>
					<xsl:when test=" $hopCount = '01' ">
						<xsl:value-of select="func:getReqSize()" />
					</xsl:when>
				  <xsl:otherwise>
						<xsl:value-of select="func:getResSize()" />
					</xsl:otherwise>
				</xsl:choose>	
			</xsl:variable>	
					
			<xsl:variable name="errSystemCode">
				<xsl:value-of select="substring($errSystemCode,1,5)" /><xsl:value-of select="str:padding(5-number(string-length($errSystemCode)), ' ')" />
			</xsl:variable>
      <!-- errsystemcode end -->
      
      <xsl:variable name="userInfo"><xsl:value-of select="dp:variable('var://context/MYVAR/employeeNo')" /></xsl:variable>
      <xsl:variable name="userInfo"><xsl:value-of select="substring($userInfo,1,20)" /><xsl:value-of select="str:padding(20-number(string-length($userInfo)),' ')" /></xsl:variable>

			<xsl:variable name="sesionIDBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionId'])" /></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/sesionIDBoolean'" value="string($sesionIDBoolean)"/>

			<xsl:choose>
				<xsl:when test=" $sesionIDBoolean = 'true' ">
					<dp:set-variable name="'var://context/MYVAR/sessionId'" value="string(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionId']/text())"/>
					<dp:set-variable name="'var://context/MYVAR/sequenceNumber'" value="string(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sequenceNumber']/text())"/>
					<dp:set-variable name="'var://context/MYVAR/securityToken'" value="string(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='securityToken']/text())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test=" $isECommerce = 'true' ">
							<dp:set-variable name="'var://context/MYVAR/sessionId'" value="dp:variable('var://context/MYVAR/sessionId')"/>
							<dp:set-variable name="'var://context/MYVAR/sequenceNumber'" value="dp:variable('var://context/MYVAR/sequenceNumber')"/>
							<dp:set-variable name="'var://context/MYVAR/securityToken'" value="dp:variable('var://context/MYVAR/securityToken')"/>
						</xsl:when>
						<xsl:otherwise>
							<dp:set-variable name="'var://context/MYVAR/sessionId'" value="string(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SessionId']/text())"/>
							<dp:set-variable name="'var://context/MYVAR/sequenceNumber'" value="string(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SequenceNumber']/text())"/>
							<dp:set-variable name="'var://context/MYVAR/securityToken'" value="string(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SecurityToken']/text())"/>
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:otherwise>
			</xsl:choose>	
			<!-- ims logging list add 20130816 add -->
			<xsl:variable name="sesionID">
				<xsl:choose>
					<xsl:when test="$isEretail='true'">
						<xsl:value-of select="dp:variable('var://context/MYVAR/JSESSIONID')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="dp:variable('var://context/MYVAR/sessionId')" />
					</xsl:otherwise>
				</xsl:choose>
	    </xsl:variable>
		  <!-- ims logging list add end-->
      <xsl:variable name="sesionID"><xsl:value-of select="substring($sesionID,1,24)" /><xsl:value-of select="str:padding(24-number(string-length($sesionID)),' ')" /></xsl:variable>

      <xsl:variable name="seqNumber"><xsl:value-of select="dp:variable('var://context/MYVAR/sequenceNumber')" /></xsl:variable>
      <xsl:variable name="seqNumber"><xsl:value-of select="substring($seqNumber,1,5)" /><xsl:value-of select="str:padding(5-number(string-length($seqNumber)),' ')" /></xsl:variable>

      <xsl:variable name="securityToken"><xsl:value-of select="dp:variable('var://context/MYVAR/securityToken')" /></xsl:variable>
      <xsl:variable name="securityToken"><xsl:value-of select="substring($securityToken,1,26)" /><xsl:value-of select="str:padding(26-number(string-length($securityToken)),' ')" /></xsl:variable>

      <xsl:variable name="wsap"><xsl:value-of select="dp:variable('var://context/MYVAR/wsap')" /></xsl:variable>
      <xsl:variable name="wsap"><xsl:value-of select="substring($wsap,1,10)" /><xsl:value-of select="str:padding(10-number(string-length($wsap)),' ')" /></xsl:variable>

      <xsl:variable name="lssUserId"><xsl:value-of select="dp:variable('var://context/MYVAR/lssUserId')" /></xsl:variable>
      <xsl:variable name="lssUserId"><xsl:value-of select="substring($lssUserId,1,10)" /><xsl:value-of select="str:padding(10-number(string-length($lssUserId)),' ')" /></xsl:variable>

      <xsl:variable name="officeId"><xsl:value-of select="dp:variable('var://context/MYVAR/officeId')" /></xsl:variable>
      <xsl:variable name="officeId"><xsl:value-of select="substring($officeId,1,10)" /><xsl:value-of select="str:padding(10-number(string-length($officeId)),' ')" /></xsl:variable>

      <xsl:variable name="sid">
      	<xsl:value-of select="dp:variable('var://context/MYVAR/XinfflowCode')" />
      	<xsl:value-of select="string('|')" />
      	<xsl:value-of select="dp:variable('var://context/MYVAR/Xinfatcoption')" />
      </xsl:variable>
      
      <xsl:variable name="sid"><xsl:value-of select="substring($sid,1,20)" /><xsl:value-of select="str:padding(20-number(string-length($sid)),' ')" /></xsl:variable>

      <xsl:variable name="rtncd">0</xsl:variable>

      <xsl:variable name="ErrorCode"><xsl:value-of select="str:padding(10,' ')" /></xsl:variable>

      <xsl:variable name="ErrorContents"><xsl:value-of select="str:padding(100,' ')" /></xsl:variable>
      
      <xsl:variable name="ErrorReason">
      	<xsl:if test=" $hopCount='01' ">
      		  <xsl:value-of select="concat('Transaction-id : ',dp:variable('var://service/transaction-id'))" />
		      	<xsl:value-of select="concat(' | Accept-Encoding :',dp:request-header('Accept-Encoding'))" />
						<xsl:value-of select="concat(' | Content-Type :',dp:request-header('Content-Type'))" />
						<xsl:value-of select="concat(' | SOAPAction :',dp:request-header('SOAPAction'))" />
						<xsl:value-of select="concat(' | Content-Length :',dp:request-header('Content-Length'))" />
						<xsl:value-of select="concat(' | X-Client-IP :',dp:request-header('X-Client-IP'))" />
						<xsl:value-of select="concat(' | Xinfoperation :',dp:request-header('X-inf-operation'))"/>
						<xsl:value-of select="concat(' | XinfflowCode :',dp:request-header('X-inf-flowCode'))"/>
						<xsl:value-of select="concat(' | Xinfatcoption :',dp:request-header('X-inf-atcoption'))"/>
				</xsl:if>
      </xsl:variable>
      <xsl:variable name="ErrorReason"><xsl:value-of select="substring($ErrorReason,1,300)" /><xsl:value-of select="str:padding(300-number(string-length($ErrorReason)),' ')" /></xsl:variable>

      <xsl:variable name="NoMsg" select="func:NoMsg()"/> 
      <!--LOG--><xsl:value-of select="func:LoggingDebug('NoMsg ===================',$NoMsg)"/>
      
      <xsl:variable name="Message" select="func:ImsLogging(func:HBinfo($hopCount,$ImsLogLevel),$NoMsg,$requestData,$requestHeader,$requestBody)"/>


      <!--LOG--><xsl:value-of select="func:LoggingDebug('response message size end ============================',dp:variable('var://service/mpgw/response-size'))"/>

          <!-- LOG --><xsl:value-of select="func:LoggingInfo('result node-set Message msg  ',$Message)"/>
          <!-- LOG --><xsl:value-of select="func:LoggingInfo('result ifid msg info============================',$ifid)"/>
          <!-- LOG --><xsl:value-of select="func:LoggingError('result ifid msg Error============================',$ifid)"/>
          <!-- LOG --><xsl:value-of select="func:LoggingDebug('result ifid msg Debug============================',$ifid)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result guid msg ============================',$guid)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result ifid msg ============================',$ifid)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result guid msg ============================',$guid)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result hopCount msg ============================',$hopCount)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result pipServiceName msg ============================',$pipServiceName)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result destServiceName msg ============================',$destServiceName)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result pipModuleName msg ============================',$pipModuleName)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result systemTime msg ============================',$systemTime)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result procdtsndsyscd msg ============================',$procdtsndsyscd)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result systemCode msg ============================',$systemCode)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result errSystemCode msg ============================',$errSystemCode)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result userInfo msg ============================',$userInfo)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result sesionID msg ============================',$sesionID)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result seqNumber msg ============================',$seqNumber)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result securityToken msg ============================',$securityToken)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result lssUserId msg ============================',$lssUserId)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result sid msg ============================',$sid)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result rtncd msg ============================',$rtncd)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result ErrorCode msg ============================',$ErrorCode)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result ErrorContents msg ============================',$ErrorContents)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('result ErrorReason msg ============================',$ErrorReason)"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('req size ============================',func:getReqSize())"/>
					<!-- LOG --><xsl:value-of select="func:LoggingDebug('res size ============================',func:getResSize())"/>
	 			
					<xsl:variable name="wholeMessage">
					<xsl:value-of select="$ifid" />
					<xsl:value-of select="$guid" />
					<xsl:value-of select="$hopCount" />
					<xsl:value-of select="$pipServiceName" />
					<xsl:value-of select="$destServiceName" />
					<xsl:value-of select="$pipModuleName" />
					<xsl:value-of select="$systemTime" />
					<xsl:value-of select="$procdtsndsyscd" />
					<xsl:value-of select="$systemCode" />
					<xsl:value-of select="$errSystemCode" />
					<xsl:value-of select="$userInfo" />
					<xsl:value-of select="$sesionID" />
					<xsl:value-of select="$seqNumber" />
					<xsl:value-of select="$securityToken" />
					<xsl:value-of select="$wsap" />
					<xsl:value-of select="$lssUserId" />
					<xsl:value-of select="$officeId" />
					<xsl:value-of select="$sid" />
					<xsl:value-of select="$rtncd" />
					<xsl:value-of select="$ErrorCode" />
					<xsl:value-of select="$ErrorContents" />
					<xsl:value-of select="$ErrorReason" />
					<xsl:copy-of  select="$Message" />
					</xsl:variable>
      

 			  			   
		    <xsl:variable name="newMQMDStr">
		    	<MQMD>
			  		<Format>MQSTR</Format>
		      </MQMD>
		    </xsl:variable>
		    <xsl:variable name="mqmdStr">
		    	<dp:serialize select="$newMQMDStr"/>
		    </xsl:variable> 
		    <xsl:variable name="finalHeader">
			    <header name="MQMD">
		    	  <xsl:value-of select="$mqmdStr"/>
		      </header>
		    </xsl:variable>
		
	      <!-- LOG --><xsl:value-of select="func:LoggingDebug('targetURL===================start',$NoMsg)"/>
        <xsl:variable name="targetURL" select="func:getMQUrl()"/>
        <!-- LOG --><xsl:value-of select="func:LoggingInfo('result targetURL ',$targetURL)"/>
        
		    <xsl:variable name="urlOpenResult">
					<dp:url-open target="{$targetURL}"  http-headers="$finalHeader" response="ignore" timeout="1">
						<dp:serialize select="$wholeMessage" omit-xml-decl="yes"/>
					</dp:url-open>
		    </xsl:variable>

		    
		    <!-- LOG --><xsl:value-of select="func:LoggingDebug('result Message msg  ',$urlOpenResult)"/>
		    
      </xsl:if>

    <!-- LOG --><xsl:value-of select="func:LoggingInfo('Logging end hopCount ',$hopCount)"/>  
    <xsl:copy-of select="." />

    </xsl:template>
</xsl:stylesheet>