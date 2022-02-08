<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    extension-element-prefixes="dp"
    exclude-result-prefixes="dp dpconfig awsl wsa awss"
    xmlns:func="http://exslt.org/functions"
>
<xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
  <xsl:output encoding="UTF-8" version="1.0" method="xml"/>

  <xsl:template match="/">
<xsl:variable name="LOGGINGPRINT" select="func:LoggingInfo('response message   ','start')"/>
	  <xsl:variable name="ServerID"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='TransactionFlowLink']/*[local-name()='Receiver']/*[local-name()='ServerID']/text()" /></xsl:variable>
   	<dp:set-variable name="'var://context/MYVAR/ServerID'" value="string($ServerID)" />
 
	  <xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')"/></xsl:variable>
	  <xsl:variable name="requestSystem"><xsl:value-of select="dp:variable('var://context/MYVAR/requestSystem')"/></xsl:variable>
	  <xsl:variable name="employeeNo"><xsl:value-of select="dp:variable('var://context/MYVAR/employeeNo')"/></xsl:variable>
	  <xsl:variable name="lssUserId"><xsl:value-of select="dp:variable('var://context/MYVAR/lssUserId')"/></xsl:variable>
	  <xsl:variable name="officeId"><xsl:value-of select="dp:variable('var://context/MYVAR/officeId')"/></xsl:variable>
	  <xsl:variable name="dutyCode"><xsl:value-of select="dp:variable('var://context/MYVAR/dutyCode')"/></xsl:variable>
	  <xsl:variable name="wsap"><xsl:value-of select="dp:variable('var://context/MYVAR/wsap')"/></xsl:variable>
	  <xsl:variable name="companyName"><xsl:value-of select="dp:variable('var://context/MYVAR/companyName')"/></xsl:variable><!--20130219 add-->
	  <xsl:variable name="workstationId"><xsl:value-of select="dp:variable('var://context/MYVAR/workstationId')"/></xsl:variable><!--20130219 add-->

	  <xsl:variable name="sessionType"><xsl:value-of select="dp:variable('var://context/MYVAR/sessionType')"/></xsl:variable>
	  <xsl:variable name="sessionId"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SessionId']/text()"/></xsl:variable>
	  <xsl:variable name="sequenceNumber"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SequenceNumber']/text()"/></xsl:variable>
	  <xsl:variable name="securityToken"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='SecurityToken']/text()"/></xsl:variable>

		<xsl:variable name="wsaTo"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='To']/text()"/></xsl:variable>
		<xsl:variable name="wsaFrom"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='From']/*[local-name()='Address']/text()"/></xsl:variable>

    <!--xsl:copy-of select="."/-->
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pip="http://PIP_Service_Library/PIP_Processing" xmlns:pips="http://PIP_Service_Library/PIP_Session" xmlns:wsa="http://www.w3.org/2005/08/addressing">

			<soapenv:Header>				
				<pip:ProcessingFlow>
						<pip:guid><xsl:value-of select="$guid" /></pip:guid>
						<pip:requestSystem><xsl:value-of select="$requestSystem" /></pip:requestSystem>
						<pip:employeeNo><xsl:value-of select="$employeeNo" /></pip:employeeNo>
						<pip:lssUserId><xsl:value-of select="$lssUserId" /></pip:lssUserId>
						<pip:officeId><xsl:value-of select="$officeId" /></pip:officeId>
						<pip:dutyCode><xsl:value-of select="$dutyCode" /></pip:dutyCode>
						<pip:wsap><xsl:value-of select="$wsap" /></pip:wsap>
						<pip:companyName><xsl:value-of select="$companyName" /></pip:companyName><!--20130219 add-->
						<pip:workstationId><xsl:value-of select="$workstationId" /></pip:workstationId><!--20130219 add-->
				</pip:ProcessingFlow>
	      <pips:Session>
	         <pips:sessionType><xsl:value-of select="$sessionType" /></pips:sessionType>
	         <pips:sessionId><xsl:value-of select="$sessionId" /></pips:sessionId>
	         <pips:sequenceNumber><xsl:value-of select="$sequenceNumber" /></pips:sequenceNumber>
	         <pips:securityToken><xsl:value-of select="$securityToken" /></pips:securityToken>
	      </pips:Session>
   		</soapenv:Header>
    	<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']" exclude-result-prefixes="awsl wsa awss"/>
		</soapenv:Envelope>
  </xsl:template>

</xsl:stylesheet>