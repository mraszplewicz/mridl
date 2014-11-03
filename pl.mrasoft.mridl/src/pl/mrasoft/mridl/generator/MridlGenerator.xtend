package pl.mrasoft.mridl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IFileSystemAccessExtension2
import org.eclipse.xtext.generator.IGenerator
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.Element
import pl.mrasoft.mridl.mridl.ComplexType
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeReference
import pl.mrasoft.mridl.mridl.SimpleType

class MridlGenerator implements IGenerator {

	final static val CLASSPATH_PREFIX = "classpath:/"

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val modelName = resource.URI.trimFileExtension.lastSegment;
		val model = resource.contents.head as Mridl

		val pathWithoutExtension = resource.containingFolder(fsa) + "/" + modelName

		if (!model.operations.empty) {
			fsa.generateFile(pathWithoutExtension + ".wsdl", model.wsdlFile(modelName))
		}
		fsa.generateFile(pathWithoutExtension + ".xsd", model.xsdFile(modelName))
	}

	def containingFolder(Resource it, IFileSystemAccess fsa) {
		val filePath = URI.trimSegments(1).toString

		if (filePath.startsWith(CLASSPATH_PREFIX)) {

			//for unit testing
			filePath.replaceFirst(CLASSPATH_PREFIX, "/")
		} else {

			//implementacja jest tak na prawde bledna, ale nie widze lepszego sposobu
			val srcGenURI = (fsa as IFileSystemAccessExtension2).getURI(".")
			val projectPath = srcGenURI.trimSegments(1).toString

			val pathWithSrc = filePath.replaceFirst(projectPath, "");
			pathWithSrc.substring(pathWithSrc.indexOf('/', 1) + 1)
		}
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
				«IF operation instanceof Operation»
					«(operation as Operation).operationRootElements»
				«ENDIF»
			«ENDFOR»
			«FOR operation : operations»
				«IF operation instanceof Operation»
					«(operation as Operation).operationComplexTypes»
				«ENDIF»
			«ENDFOR»
			«FOR type : types»				
				«type.type»
			«ENDFOR»	         								
		</xs:schema>
	'''

	def operationRootElements(Operation it) '''
		<xs:element name="«name»" type="tns:«name»"/>
		<xs:element name="«name»Response" type="tns:«name»Response"/>
	'''

	//TODO zmiana complextype na jeden szablon?
	def operationComplexTypes(Operation it) '''
		<xs:complexType name="«name»">
			<xs:sequence>
				«FOR param : params»
					«param.element»
				«ENDFOR»
			</xs:sequence>
		</xs:complexType>
		<xs:complexType name="«name»Response">
			<xs:sequence>
				«returnType.element»
			</xs:sequence>
		</xs:complexType>
	'''

	def dispatch type(ComplexType it) '''
		<xs:complexType name="«name»">
			<xs:sequence>
				«FOR element : elements»
					«element.element»
				«ENDFOR»
			</xs:sequence>
		</xs:complexType>
	'''

	def dispatch type(SimpleType it) '''

	'''

	def element(Element it) '''
		<xs:element name="«name»" type="«type.typeRef»"/>
	'''

	def dispatch typeRef(XsdBuiltinTypeReference it) '''xs:«builtin»'''

	def dispatch typeRef(ComplexType it) '''tns:«name»'''
}
