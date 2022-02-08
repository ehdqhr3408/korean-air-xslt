<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    extension-element-prefixes="dp"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:func="http://exslt.org/functions"
    exclude-result-prefixes="dp" 
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">

    <xsl:include href="local:///IF_common/LoggingUtil.xsl"/>
    
    <xsl:output encoding="UTF-8" version="1.0" method="xml"/>    
    <xsl:template match="/">   

		  <xsl:variable name="isServer"><xsl:value-of select="contains(dp:variable('var://service/formatted-error-message'), ':Server')"/></xsl:variable>
			<xsl:choose>
				<xsl:when test=" $isServer='true' ">
					<dp:set-variable name="'var://context/MYVAR/faultCode'" value="'soapenv:Server'"/>
				</xsl:when>
				<xsl:otherwise>
					<dp:set-variable name="'var://context/MYVAR/faultCode'" value="'soapenv:Client'"/>
				</xsl:otherwise>
			</xsl:choose>	

		<!-- Set faultactor -->	
          <xsl:variable name="RecvSystem">
          	<xsl:value-of select="dp:variable('var://context/MYVAR/PIP_recvsystem')"/>
          </xsl:variable>
           <xsl:value-of select="dp:variable('var://context/MYVAR/XresponseSystem')" />
          <xsl:variable name="faultActor">
          		<xsl:choose>
					<xsl:when test=" dp:variable('var://context/MYVAR/errorCode') = $CommonPIPE02 
					                or dp:variable('var://context/MYVAR/errorCode') = $CommonPIPT01
					                or dp:variable('var://context/MYVAR/errorCode') = $CommonPIPI02" >
					                
		          		<xsl:choose>
							<xsl:when test=" $RecvSystem = '' or $RecvSystem = ' ' ">
								<xsl:value-of select="$CommonSSAM"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$RecvSystem"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$CommonWDP"/>
					</xsl:otherwise>
				</xsl:choose>
          </xsl:variable>
          <!-- LOG --><xsl:value-of select="func:LoggingDebug('faultActor  ',$faultActor)"/>			
		  			
		  <xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')"/></xsl:variable>
		  <xsl:variable name="requestSystem"><xsl:value-of select="dp:variable('var://context/MYVAR/requestSystem')"/></xsl:variable>
		  <xsl:variable name="employeeNo"><xsl:value-of select="dp:variable('var://context/MYVAR/employeeNo')"/></xsl:variable>
		  <xsl:variable name="lssUserId"><xsl:value-of select="dp:variable('var://context/MYVAR/lssUserId')"/></xsl:variable>
		  <xsl:variable name="officeId"><xsl:value-of select="dp:variable('var://context/MYVAR/officeId')"/></xsl:variable>
		  <xsl:variable name="dutyCode"><xsl:value-of select="dp:variable('var://context/MYVAR/dutyCode')"/></xsl:variable>
		  <xsl:variable name="wsap"><xsl:value-of select="dp:variable('var://context/MYVAR/wsap')"/></xsl:variable>
		  <xsl:variable name="companyName"><xsl:value-of select="dp:variable('var://context/MYVAR/companyName')"/></xsl:variable>
		  <xsl:variable name="workstationId"><xsl:value-of select="dp:variable('var://context/MYVAR/workstationId')"/></xsl:variable>
      
      <dp:set-response-header name="'X-guid'" value="$guid"/>
      
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pip="http://PIP_Service_Library/PIP_Processing" xmlns:pips="http://PIP_Service_Library/PIP_Session">
				<soapenv:Header>
				
 				</soapenv:Header>
				<soapenv:Body>
					<soapenv:Fault>
							<faultcode><xsl:value-of select="dp:variable('var://context/MYVAR/faultCode')"/></faultcode>
							<faultstring><xsl:value-of select="dp:variable('var://context/MYVAR/errorCode')" />|<xsl:value-of select="dp:variable('var://context/MYVAR/errorMsg')" /></faultstring>
							<faultactor><xsl:value-of select="$faultActor" /></faultactor>
					</soapenv:Fault>			  		
				</soapenv:Body>
			</soapenv:Envelope>

    </xsl:template>
</xsl:stylesheet>