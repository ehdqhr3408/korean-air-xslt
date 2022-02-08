<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:dpfunc="http://www.datapower.com/extensions/functions"
    xmlns:dpquery="http://www.datapower.com/param/query"
    xmlns:dpconfig="http://www.datapower.com/param/config"
    xmlns:dpxacml="urn:ibm:names:datapower:xacml:2.0"
    xmlns:func="http://exslt.org/functions"
    xmlns:dyn="http://exslt.org/dynamic"
    xmlns:xacml="urn:oasis:names:tc:xacml:2.0:policy:schema:os"
    xmlns:xacml-context="urn:oasis:names:tc:xacml:2.0:context:schema:os"
    exclude-result-prefixes="dp dpfunc dpquery dpconfig dpxacml func dyn xacml xacml-context"
    extension-element-prefixes="dp dpfunc"
    version="1.0">
    
    <xsl:include href="store:///utilities.xsl"/>
    <xsl:include href="store:///dp/aaa-xacml-context.xsl"/>
    
    <xsl:template match="/">

				<xsl:variable name="subcode"><xsl:value-of select="dp:variable('var://service/error-subcode')"/></xsl:variable>
				<xsl:if test=" $subcode = '0x01d30001' ">
					<dp:xreject reason="'The user authentication is failed.'"/>
				</xsl:if>
	
        <Request
            xmlns="urn:oasis:names:tc:xacml:2.0:context:schema:os"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
            xsi:schemaLocation="urn:oasis:names:tc:xacml:2.0:context:schema:os access_control-xacml-2.0-context-schema-os.xsd">
          
            <Subject>
                <Attribute
                    AttributeId="urn:oasis:names:tc:xacml:1.0:subject:subject-id"
                    DataType="http://www.w3.org/2001/XMLSchema#string">
                    <AttributeValue><xsl:value-of select="/*[local-name()='Envelope']/*[local-name()='Header']/*[local-name()='Security']/*[local-name()='UsernameToken']/*[local-name()='Username']/text()"/></AttributeValue>
                </Attribute>
            </Subject>
          
            <xsl:message dp:priority="debug">IBM XACML PEP $dpxacml:resource : <dp:serialize select="$dpxacml:resource"/></xsl:message>
            
            <Resource>
                <Attribute
                    AttributeId="urn:oasis:names:tc:xacml:1.0:resource:resource-id"
                    DataType="http://www.w3.org/2001/XMLSchema#string">
                    <AttributeValue><xsl:value-of select="$dpxacml:resource/item/text()"/></AttributeValue>
                </Attribute>
            </Resource>
          
            <Action>
                <Attribute
                    AttributeId="urn:oasis:names:tc:xacml:1.0:action:action-id"
                    DataType="http://www.w3.org/2001/XMLSchema#string">
                    <AttributeValue>execute</AttributeValue>
                </Attribute>
            </Action>
          
        	  <Environment/>
        </Request>
        
    </xsl:template>
</xsl:stylesheet>

