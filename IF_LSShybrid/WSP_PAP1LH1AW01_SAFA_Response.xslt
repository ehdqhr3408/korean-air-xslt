<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    extension-element-prefixes="dp"
    exclude-result-prefixes="dp dpconfig awsl wsa awss"
>

 <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
<xsl:template match="/">

	  <!--xsl:variable name="ServerID"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='TransactionFlowLink']/*[local-name()='Receiver']/*[local-name()='ServerID']/text()" /></xsl:variable>
   	<dp:set-variable name="'var://context/MYVAR/ServerID'" value="string($ServerID)" /-->
 
	  <xsl:variable name="wsaTo"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaTo')"/></xsl:variable>
	  <xsl:variable name="wsaFrom"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaFrom')"/></xsl:variable>
	  <xsl:variable name="wsaAction"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaAction')"/></xsl:variable>
	  <!--xsl:variable name="wsaMessageID"><xsl:value-of select="dp:variable('var://context/MYVAR/wsaMessageID')"/></xsl:variable-->
	  <xsl:variable name="wsguid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')"/></xsl:variable>
	  
	  <xsl:variable name="BooleanSession"><xsl:value-of select="dp:variable('var://context/MYVAR/BooleanSession')"/></xsl:variable>
	  <xsl:variable name="BooleanSecurityHostedUser"><xsl:value-of select="dp:variable('var://context/MYVAR/BooleanSecurityHostedUser')"/></xsl:variable>
	  
	  <xsl:variable name="headerSessionId"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSessionId')"/></xsl:variable>
	  <xsl:variable name="headerSequenceNumber"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSequenceNumber')"/></xsl:variable>
	  <xsl:variable name="headerSecurityToken"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSecurityToken')"/></xsl:variable>
    <xsl:variable name="headerSecurityHostedUser"><xsl:value-of select="dp:variable('var://context/MYVAR/headerSecurityHostedUser')"/></xsl:variable>
	  <!-- 
	    20130320 lsshybrid 
	  -->
	  
		 <!--<xsl:variable name="BooleanMessageID"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='MessageID'])" /></xsl:variable>
	 
	  <xsl:variable name="requestSystem"><xsl:value-of select="dp:variable('var://context/MYVAR/requestSystem')"/></xsl:variable>
	  <xsl:variable name="employeeNo"><xsl:value-of select="dp:variable('var://context/MYVAR/employeeNo')"/></xsl:variable>
	  <xsl:variable name="lssUserId"><xsl:value-of select="dp:variable('var://context/MYVAR/lssUserId')"/></xsl:variable>
	  <xsl:variable name="officeId"><xsl:value-of select="dp:variable('var://context/MYVAR/officeId')"/></xsl:variable>
	  <xsl:variable name="dutyCode"><xsl:value-of select="dp:variable('var://context/MYVAR/dutyCode')"/></xsl:variable>
	  <xsl:variable name="wsap"><xsl:value-of select="dp:variable('var://context/MYVAR/wsap')"/></xsl:variable>
    -->
	  
    <xsl:variable name="CompanyName"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='AMA_SecurityHostedUser']/*[local-name()='UserID']/*[local-name()='RequestorID']/*[local-name()='CompanyName']/text()"/></xsl:variable>

      <!-- response-->
		 <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:pip="http://xml.amadeus.com/2010/06/Session_v3" xmlns:pip1="http://xml.amadeus.com/2010/06/Security_v1" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns0="http://xml.amadeus.com/Security_AuthenticateFromAmadeus_12_1_1A">
			<env:Header>
				<wsa:To><xsl:value-of select="string('http://www.w3.org/2005/08/addressing/anonymous')" /></wsa:To>
				<wsa:From>
					<wsa:Address><xsl:value-of select="$wsaTo" /></wsa:Address>
				</wsa:From>
				<wsa:Action><xsl:value-of select="$wsaAction" /></wsa:Action>	
				
				<xsl:choose>
					<xsl:when test=" $BooleanSession='true' ">						
			      <pip:Session xmlns:pip="http://xml.amadeus.com/2010/06/Session_v3">	         
			         <pip:sessionId><xsl:value-of select="$headerSessionId" /></pip:sessionId>
			         <pip:sequenceNumber><xsl:value-of select="$headerSequenceNumber" /></pip:sequenceNumber>
			         <pip:securityToken><xsl:value-of select="$headerSecurityToken" /></pip:securityToken>
			      </pip:Session>
		      </xsl:when>
	      </xsl:choose>
	      <xsl:choose>
		      <xsl:when test=" $BooleanSecurityHostedUser='true' ">
			      <pip1:AMA_SecurityHostedUser xmlns:pip1="http://xml.amadeus.com/2010/06/Security_v1">
			         <pip1:UserID >
			            <pip1:RequestorID >
			               <pip1:CompanyName><xsl:value-of select="$headerSecurityHostedUser" /></pip1:CompanyName>
			            </pip1:RequestorID>
			         </pip1:UserID>
			      </pip1:AMA_SecurityHostedUser>
		      </xsl:when>
	      </xsl:choose>	  
	      
	      <wsa:MessageID><xsl:value-of select="substring(dp:generate-uuid(),1,35)" /></wsa:MessageID>
	      <wsa:RelatesTo RelationshipType="http://www.w3.org/2005/08/addressing/reply"><xsl:value-of select="$wsguid" /></wsa:RelatesTo>
   		</env:Header>
 		<env:Body xmlns:ns1="http://xml.amadeus.com/Security_AuthenticateFromAmadeusReply_12_1_1A">
  			<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Security_AuthenticateFromAmadeusReply']" />
 		</env:Body>
	</env:Envelope>

  </xsl:template>

</xsl:stylesheet>

		<!--xsl:variable name="aaa" disable-output-escaping="yes"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='securityAuthenticateResponseElement']/*[local-name()='result']"  /></xsl:variable-->
		<!--xsl:variable name="aaa"><xsl:value-of select="/*[local-name()='Security_Authenticate']/text()" /></xsl:variable>
		<xsl:variable name="dataSerialized"><dp:serialize select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='securityAuthenticateResponseElement']/*[local-name()='result']" omit-xml-decl="yes"/></xsl:variable>						    	 		
		<xsl:variable name="aaa"><xsl:value-of select="substring-after($dataSerialized,'Security_Authenticate>')" /></xsl:variable-->

		<!--soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:awss="http://xml.amadeus.com/ws/2009/01/WBS_Session-2.0.xsd">		
			<soapenv:Header/>
    		<soapenv:Body>
				<Security_AuthenticateFromAmadeusReply>
           		<xsl:value-of select="$v_CdataContent" disable-output-escaping="yes"/>
				</Security_AuthenticateFromAmadeusReply>
    		</soapenv:Body>
    	</soapenv:Envelope-->



				
