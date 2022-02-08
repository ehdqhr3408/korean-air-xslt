<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    exclude-result-prefixes="dp" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>
    <xsl:template match="/">   

			<xsl:variable name="faultactorBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultactor'])" /></xsl:variable>
			<xsl:variable name="detailBoolean"><xsl:value-of select="boolean(/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='detail'])" /></xsl:variable>

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
		  
		  <xsl:variable name="sessionId">
		  	<xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sessionId']/text()"/>
		  </xsl:variable>
		  <xsl:variable name="sequenceNumber">
		  	<xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='sequenceNumber']/text()"/>
		  </xsl:variable>
		  <xsl:variable name="securityToken">
		  	<xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Session']/*[local-name()='securityToken']/text()"/>
		  </xsl:variable>

		  <xsl:variable name="isECommerce"><xsl:value-of select="dp:variable('var://context/MYVAR/isECommerce')"/></xsl:variable>

			<xsl:choose>
				<xsl:when test=" $isECommerce='true' ">
					<dp:set-variable name="'var://service/soap-fault-response'" value="'1'"/>

				  <xsl:variable name="sessionId"><xsl:value-of select="dp:variable('var://context/MYVAR/sessionId')"/></xsl:variable>
				  <xsl:variable name="sequenceNumber"><xsl:value-of select="dp:variable('var://context/MYVAR/sequenceNumber')"/></xsl:variable>
				  <xsl:variable name="securityToken"><xsl:value-of select="dp:variable('var://context/MYVAR/securityToken')"/></xsl:variable>
				</xsl:when>
			</xsl:choose>	


			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pip="http://PIP_Service_Library/PIP_Processing" xmlns:pips="http://PIP_Service_Library/PIP_Session">
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
				<soapenv:Body>
					<soapenv:Fault>
							<faultcode><xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultcode']/text()" /></faultcode>
							<faultstring><xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultstring']/text()" /></faultstring>
							<xsl:choose>
								<xsl:when test=" $faultactorBoolean = 'true' ">
									<faultactor><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='faultactor']/text()"/></faultactor>
								</xsl:when>
							</xsl:choose>	
							<xsl:choose>
								<xsl:when test=" $detailBoolean = 'true' ">
									<xsl:copy-of select="/*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='Fault']/*[local-name()='detail']/text()"/>
								</xsl:when>
							</xsl:choose>	
					</soapenv:Fault>			  		
				</soapenv:Body>
			</soapenv:Envelope>

    </xsl:template>
</xsl:stylesheet>