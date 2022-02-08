<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    exclude-result-prefixes="dp" 
    xmlns:func="http://exslt.org/functions"
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">

<xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">   
    	<!--1220 add-->
		<dp:set-variable name="'var://context/MYVAR/faultactor'" value="string('WDP')"/>
		
		<xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')"/></xsl:variable>
		<xsl:choose>
			<xsl:when test=" $guid='' ">
<dp:set-variable name="'var://context/MYVAR/reqData'" value="." omit-xml-decl="yes"/>

<xsl:variable name="ENTERKE" select="func:BodyLongText()"/>
<xsl:variable name="ifid" select="func:set1ABIFID($ENTERKE)"/>

				<xsl:variable name="wsaTo"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='To']/text()" /></xsl:variable>
				<xsl:variable name="wsaFrom"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='From']/*[local-name()='Address']/text()" /></xsl:variable>
				<xsl:variable name="wsaAction"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Action']/text()" /></xsl:variable>
				<xsl:variable name="wsaMessageID"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='MessageID']/text()" /></xsl:variable>

				<xsl:variable name="headerSessionId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SessionId']/text()" /></xsl:variable>
				<xsl:variable name="headerSequenceNumber"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SequenceNumber']/text()" /></xsl:variable>
				<xsl:variable name="headerSecurityToken"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SecurityToken']/text()" /></xsl:variable>
				<xsl:variable name="headerSecurityHostedUser"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='AMA_SecurityHostedUser']/*[local-name()='UserID']/*[local-name()='RequestorID']/*[local-name()='CompanyName']/text()" /></xsl:variable>
				<!--requestsystem id ,procdt -->
				<xsl:variable name="requestSystem"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Security']/*[local-name()='UsernameToken']/*[local-name()='Username']/text()" /></xsl:variable>
				<xsl:variable name="procdt"><xsl:value-of select="substring(func:TimeLog(),7,2)"/></xsl:variable>		
				<xsl:variable name="procdtsndsyscd"><xsl:value-of select="concat($procdt,$requestSystem)"/></xsl:variable>	
				
				<dp:set-variable name="'var://context/MYVAR/procdtsndsyscd'" value="string($procdtsndsyscd)" />
				<xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('func create procdtsndsyscd :',$procdtsndsyscd)"/>
				
				<!-- context set variable  -->			
				<dp:set-variable name="'var://context/MYVAR/wsaTo'" value="string($wsaTo)"/>
				<dp:set-variable name="'var://context/MYVAR/wsaFrom'" value="string($wsaFrom)"/>
				<dp:set-variable name="'var://context/MYVAR/wsaAction'" value="string($wsaAction)"/>
				<dp:set-variable name="'var://context/MYVAR/guid'" value="string($wsaMessageID)"/>
				
				<dp:set-variable name="'var://context/MYVAR/BooleanSession'" value="string($BooleanSession)"/>
				<dp:set-variable name="'var://context/MYVAR/BooleanSecurityHostedUser'" value="string($BooleanSecurityHostedUser)"/>
				<dp:set-variable name="'var://context/MYVAR/headerSessionId'" value="string($headerSessionId)"/>
				<dp:set-variable name="'var://context/MYVAR/headerSequenceNumber'" value="string($headerSequenceNumber)"/>
				<dp:set-variable name="'var://context/MYVAR/headerSecurityToken'" value="string($headerSecurityToken)"/>
				<dp:set-variable name="'var://context/MYVAR/headerSecurityHostedUser'" value="string($headerSecurityHostedUser)"/>
			</xsl:when>
		</xsl:choose>
		
		<xsl:variable name="errorMsg"><xsl:value-of select="dp:variable('var://service/error-message')" /></xsl:variable>
<!-- http error,validation error check 

		  	<xsl:param name="HVI"/>
			  <xsl:param name="codeId"/>

-->       
      <xsl:variable name="codeId" select="func:CodeIdChk(string('B'))"/>
<!-- http error,validation error check -->
      <xsl:value-of select="func:LoggingDebug('get WdpErrorCode start',$codeId)"/>
      <xsl:variable name="ErrorCodeResult" select="func:getWdpErrorCode('PIP_ERROR_01',$codeId)"/>
      <xsl:value-of select="func:LoggingDebug('get WdpErrorCode',$ErrorCodeResult)"/>
			

			<xsl:variable name="errorMsg"><xsl:value-of select="dp:variable('var://context/MYVAR/codeType')"/>|<xsl:value-of select="dp:variable('var://context/MYVAR/codeDesc')"/> ( <xsl:value-of select="$errorMsg"/> )</xsl:variable>
			<xsl:variable name="customerErrorCode"><xsl:value-of select="dp:variable('var://context/MYVAR/customerErrorCode')"/></xsl:variable>
			<dp:set-variable name="'var://context/MYVAR/errorCode'" value="string($customerErrorCode)"/>
			<dp:set-variable name="'var://context/MYVAR/errorMsg'" value="string($errorMsg)"/>
			
			<xsl:copy-of select="." />

    </xsl:template>
</xsl:stylesheet>