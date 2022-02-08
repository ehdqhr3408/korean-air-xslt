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
      
    

      <!-- ims logging list add 20130816 end --> 
      
			<xsl:variable name="requestSystem"><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='ProcessingFlow']/*[local-name()='requestSystem']/text()" /></xsl:variable>

			<xsl:variable name="procdt"><xsl:value-of select="substring(func:TimeLog(),7,2)"/></xsl:variable>		
			<xsl:variable name="procdtsndsyscd"><xsl:value-of select="concat($procdt,$requestSystem)"/></xsl:variable>	

			<dp:set-variable name="'var://context/MYVAR/procdtsndsyscd'" value="string($procdtsndsyscd)" />
			<xsl:value-of select="func:LoggingInfo('func create procdtsndsyscd :',$procdtsndsyscd)"/>

      <!--
      
      Message creation date.(8)YYYYMMDD
			Message creation system(12) GUID
			Message creation time.(9) HHmmssSSS
			serial number(4) 0 ~ 9999
			Digit serial number.(4)
			Number in progress(2) 01
      -->
      
      <xsl:variable name="daytime">
      	<xsl:value-of select="func:TimeLog()"/>
      </xsl:variable>
	
      <xsl:variable name="ident" select="dp:variable('var://service/system/ident')" />
			<xsl:variable name="sn" select="$ident/identification/serial-number" />	
			
			<xsl:variable name="guid">
                                <xsl:value-of select="substring($daytime,1,8)"/>
				<xsl:value-of select="string('wdp0')" />
				<xsl:value-of select="substring($sn,1,7)" />
                                <xsl:value-of select="substring($daytime,9,9)"/>
				<xsl:value-of select="str:padding(7-number(string-length($sn)),'0')" />
				<xsl:value-of select="substring(dp:random-bytes(20),1,4)"/>
				<xsl:value-of select="string('401')"/>
			</xsl:variable>
      
  		<dp:set-variable name="'var://context/MYVAR/guid'" value="string($guid)"/>

 <!--LOG--><xsl:value-of select="func:LoggingInfo('guid : ',$guid)"/>

			<xsl:choose>

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
				<xsl:otherwise>
					<dp:accept />
	      	<xsl:copy-of select="." />
				</xsl:otherwise>
			</xsl:choose>	
<xsl:value-of select="func:LoggingInfo('soapHeaderValidFilter End',string($guid))"/>

    </xsl:template>
</xsl:stylesheet>