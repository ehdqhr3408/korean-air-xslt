<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    extension-element-prefixes="dp"
    exclude-result-prefixes="dp dpconfig"
>

  <xsl:output encoding="UTF-8" version="1.0" method="xml"/>

  <xsl:template match="/">

	  <xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')" /></xsl:variable>
	  <xsl:variable name="guid_length"><xsl:value-of select="string-length($guid)"/></xsl:variable>
	  <xsl:variable name="seqguid"><xsl:value-of select="substring($guid,number($guid_length)-1,2)+101"/></xsl:variable>
	  <xsl:variable name="guid"><xsl:value-of select="substring($guid,1,number($guid_length)-2)"/><xsl:value-of select="substring($seqguid,string-length($seqguid)-1,2)"/></xsl:variable>
		<dp:set-variable name="'var://context/MYVAR/guid'" value="string($guid)"/>

	  <xsl:variable name="guid"><xsl:value-of select="dp:variable('var://context/MYVAR/guid')"/></xsl:variable>
	  <xsl:variable name="requestSystem"><xsl:value-of select="dp:variable('var://context/MYVAR/requestSystem')"/></xsl:variable>
	  <xsl:variable name="employeeNo"><xsl:value-of select="dp:variable('var://context/MYVAR/employeeNo')"/></xsl:variable>
	  <xsl:variable name="lssUserId"><xsl:value-of select="dp:variable('var://context/MYVAR/lssUserId')"/></xsl:variable>
	  <xsl:variable name="officeId"><xsl:value-of select="dp:variable('var://context/MYVAR/officeId')"/></xsl:variable>
	  <xsl:variable name="dutyCode"><xsl:value-of select="dp:variable('var://context/MYVAR/dutyCode')"/></xsl:variable>
	  <xsl:variable name="wsap"><xsl:value-of select="dp:variable('var://context/MYVAR/wsap')"/></xsl:variable>
	  <xsl:variable name="interfaceId"><xsl:value-of select="dp:variable('var://context/MYVAR/IFID')" /></xsl:variable>
		<xsl:variable name="companyName"><xsl:value-of select="dp:variable('var://context/MYVAR/companyName')"/></xsl:variable><!--20130219 add-->
		<xsl:variable name="workstationId"><xsl:value-of select="dp:variable('var://context/MYVAR/workstationId')"/></xsl:variable><!--20130219 add-->
	        <xsl:variable name="procdtsndsyscd"><xsl:value-of select="dp:variable('var://context/MYVAR/procdtsndsyscd')" /></xsl:variable>
		<dp:set-http-request-header name="'X-procdtsndsyscd'" value="$procdtsndsyscd"/>	

		<dp:set-http-request-header name="'X-interfaceId'" value="$interfaceId"/>
		<dp:set-http-request-header name="'X-companyName'" value="$companyName"/><!--20130219 add-->
		<dp:set-http-request-header name="'X-workstationId'" value="$workstationId"/><!--20130219 add-->
		
		
	<xsl:copy-of select="." />
  </xsl:template>
</xsl:stylesheet>