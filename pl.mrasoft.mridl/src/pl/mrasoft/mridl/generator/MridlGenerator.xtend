package pl.mrasoft.mridl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.OperationParameter

class MridlGenerator implements IGenerator {

	static final val DSL_EXTENSION = "mridl"

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val modelName = fileNameWithoutExtension(resource.URI.lastSegment)
		val model = resource.contents.head as Mridl

		fsa.generateFile(modelName + ".wsdl", model.wsdlFile(modelName))
		fsa.generateFile(modelName + ".xsd", model.xsdFile(modelName))
	}

	def fileNameWithoutExtension(String fileName) {
		fileName.substring(0, fileName.length - DSL_EXTENSION.length - 1)
	}

	def wsdlFile(Mridl it, String modelName) '''
		<?xml version="1.0" encoding="utf-8"?>
		<wsdl:definitions name="«modelName»"
		                  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
		                  xmlns:tns="«nsUri»"
		                  targetNamespace="«nsUri»">		
		    <wsdl:types>
		        <schema xmlns="http://www.w3.org/2001/XMLSchema">
		            <import namespace="«nsUri»" schemaLocation="«modelName».xsd"/>
		        </schema>
		    </wsdl:types>
			«FOR operation : operations»
				«operation.operationMessages»
			«ENDFOR»		
			<wsdl:portType name="«modelName»">
				«FOR operation : operations»
					«operation.operationInPortType»
				«ENDFOR»
			</wsdl:portType>
		</wsdl:definitions>
	'''

	def operationMessages(Operation it) '''		
		<wsdl:message name="«name»">
			<wsdl:part element="tns:«name»" name="parameters"/>
		</wsdl:message>	
		<wsdl:message name="«name»Response">
			<wsdl:part element="tns:«name»Response" name="parameters"/>
		</wsdl:message>		    
	'''

	def operationInPortType(Operation it) '''
		<wsdl:operation name="«name»">
			<wsdl:input message="tns:«name»" name="«name»"/>
			<wsdl:output message="tns:«name»Response" name="«name»Response"/>
		</wsdl:operation>		    
	'''

	def xsdFile(Mridl it, String modelName) '''
		<?xml version="1.0" encoding="utf-8"?>
		<xs:schema elementFormDefault="unqualified" 
				   xmlns:xs="http://www.w3.org/2001/XMLSchema"
				         xmlns:tns="«nsUri»"
				         targetNamespace="«nsUri»">
			«FOR operation : operations»
				«operation.operationRootElements»
			«ENDFOR»
			«FOR operation : operations»
				«operation.operationComplexTypes»
			«ENDFOR»	         								
		</xs:schema>
	'''

	def operationRootElements(Operation it) '''
		<xs:element name="«name»" type="tns:«name»"/>
		<xs:element name="«name»Response" type="tns:«name»Response"/>
	'''

	def operationComplexTypes(Operation it) '''
		<xs:complexType name="«name»">
			<xs:sequence>
				«FOR param : params»
					«param.paramElement»
				«ENDFOR»
			</xs:sequence>
		</xs:complexType>
		<xs:complexType name="«name»Response">
			<xs:sequence>
				«returnType.paramElement»
			</xs:sequence>
		</xs:complexType>
	'''

	def paramElement(OperationParameter it) '''
		<xs:element name="«name»" type="xs:«type»"/>
	'''
}
