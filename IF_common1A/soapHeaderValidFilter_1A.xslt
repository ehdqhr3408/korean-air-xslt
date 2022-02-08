<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp">
    <xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">
     <dp:set-variable name="'var://context/MYVAR/reqData'" value="." />

		<xsl:variable name="IFID" select="func:setIFIDDSN()"/>
    <xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('ifid set',$IFID)"/>
			
		<!-- check validation -->
	  <!-- addressing tag validation -->
		<xsl:variable name="BooleanTo"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='To'])" /></xsl:variable>
		<xsl:variable name="BooleanFrom"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='From']/*[local-name()='Address'])" /></xsl:variable>
		<xsl:variable name="BooleanAction"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Action'])" /></xsl:variable>
		<xsl:variable name="BooleanMessageID"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='MessageID'])" /></xsl:variable>
		<!--xsl:variable name="BooleanSession"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session'])" /></xsl:variable>
		<xsl:variable name="BooleanAMA_SecurityHostedUser"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='AMA_SecurityHostedUser'])" /></xsl:variable-->
	  <!-- addressing value validation -->
		<xsl:variable name="headerTo"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='To']/text()" /></xsl:variable>
		<xsl:variable name="headerFrom"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='From']/*[local-name()='Address']/text()" /></xsl:variable>
		<xsl:variable name="headerAction"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Action']/text()" /></xsl:variable>
		<xsl:variable name="headerMessageID"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='MessageID']/text()" /></xsl:variable>
		<xsl:variable name="headerSessionId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SessionId']/text()" /></xsl:variable>
		<xsl:variable name="headerSequenceNumber"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SequenceNumber']/text()" /></xsl:variable>
		<xsl:variable name="headerSecurityToken"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SecurityToken']/text()" /></xsl:variable>
		<xsl:variable name="headerSecurityHostedUser"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='AMA_SecurityHostedUser']/*[local-name()='UserID']/*[local-name()='RequestorID']/*[local-name()='CompanyName']/text()" /></xsl:variable>

<xsl:variable name="requestSystem"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Security']/*[local-name()='UsernameToken']/*[local-name()='Username']/text()" /></xsl:variable>
<xsl:variable name="procdt"><xsl:value-of select="substring(func:TimeLog(),7,2)"/></xsl:variable>		
<xsl:variable name="procdtsndsyscd"><xsl:value-of select="concat($procdt,$requestSystem)"/></xsl:variable>	

<dp:set-variable name="'var://context/MYVAR/procdtsndsyscd'" value="string($procdtsndsyscd)" />
<xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('func create procdtsndsyscd :',$procdtsndsyscd)"/>
		
    <!-- context set variable  -->
  		<dp:set-variable name="'var://context/MYVAR/wsaTo'" value="string($headerTo)"/>
  		<dp:set-variable name="'var://context/MYVAR/wsaFrom'" value="string($headerFrom)"/>
  		<dp:set-variable name="'var://context/MYVAR/wsaAction'" value="string($headerAction)"/>
  		<dp:set-variable name="'var://context/MYVAR/guid'" value="string($headerMessageID)"/>
  		<dp:set-variable name="'var://context/MYVAR/headerSessionId'" value="string($headerSessionId)"/>
  		<dp:set-variable name="'var://context/MYVAR/headerSequenceNumber'" value="string($headerSequenceNumber)"/>
  		<dp:set-variable name="'var://context/MYVAR/headerSecurityToken'" value="string($headerSecurityToken)"/>
  		<dp:set-variable name="'var://context/MYVAR/headerSecurityHostedUser'" value="string($headerSecurityHostedUser)"/>
		
		<!-- 1A header -->
		
<!-- tag validation --> 		
		<xsl:choose>
			<xsl:when test=" $BooleanTo='false' "><!-- 20130208 add -->
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_To'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
				<dp:xreject reason="'Common Soap Header tag To is missing'"/>
			</xsl:when>
			<xsl:when test=" $BooleanFrom='false' "><!-- 20130208 add -->
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_From'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
				<dp:xreject reason="'Common Soap Header tag From is missing'"/>
			</xsl:when>
			<xsl:when test=" $BooleanAction='false' "><!-- 20130208 add -->
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_Action'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
				<dp:xreject reason="'Common Soap Header tag Action is missing'"/>
			</xsl:when>
			<xsl:when test=" $BooleanMessageID='false' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'missing_MessageID'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V02'"/>
				<dp:xreject reason="'Common Soap Header tag MessageID is missing'"/>
			</xsl:when>
			
<!-- value validation -->
			<xsl:when test=" $headerTo='' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_headerTo'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
				<dp:xreject reason="'Common Soap Header To is empty value'"/>
			</xsl:when>	
			<xsl:when test=" $headerFrom='' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_headerFrom'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
				<dp:xreject reason="'Common Soap Header From is empty value'"/>
			</xsl:when>					
			<xsl:when test=" $headerAction='' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_headerAction'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
				<dp:xreject reason="'Common Soap Header Action is empty value'"/>
			</xsl:when>	
			<xsl:when test=" $headerMessageID='' ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'empty_MessageID'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
				<dp:xreject reason="'Common Soap Header MessageID is empty value'"/>
			</xsl:when>
			<xsl:when test=" string-length($headerMessageID) &gt; 35 ">
				<dp:set-variable name="'var://context/MYVAR/valid'" value="'wrong_length_MessageID'"/>
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="'PIP.V01'"/>
				<dp:xreject reason="'Common Soap Header MessageID Length is worng'"/>
			</xsl:when>			
			<xsl:otherwise>
				<dp:accept />
				<dp:set-variable name="'var://context/MYVAR/codeId'" value="' '"/>
	    		<xsl:copy-of select="." />
			</xsl:otherwise>
		</xsl:choose>	
				
	
    </xsl:template>
</xsl:stylesheet>