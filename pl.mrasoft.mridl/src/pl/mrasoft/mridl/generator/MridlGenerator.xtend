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
import pl.mrasoft.mridl.mridl.Import
import javax.inject.Inject
import pl.mrasoft.mridl.util.ResourceUtil
import pl.mrasoft.mridl.mridl.DirectTypeReference
import pl.mrasoft.mridl.mridl.ImportedTypeReference
import pl.mrasoft.mridl.mridl.SpecifiedMultiplicity
import pl.mrasoft.mridl.mridl.UnspecifiedMultiplicity
import pl.mrasoft.mridl.mridl.Optional
import pl.mrasoft.mridl.mridl.Fault
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithDigits
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithLength
import pl.mrasoft.mridl.mridl.EnumType
import pl.mrasoft.mridl.mridl.EnumValue

class MridlGenerator implements IGenerator {

	@Inject extension ResourceUtil

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
		                  «FOR imp : imports»
		                  	«IF imp.importUsedInWsdl(it)»
		                  		«imp.importNS»
		                  	«ENDIF»
		                  «ENDFOR»
		                  targetNamespace="«nsUri»">
		    <wsdl:types>
		        <schema xmlns="http://www.w3.org/2001/XMLSchema">
		            <import namespace="«nsUri»" schemaLocation="«modelName».xsd"/>
		        </schema>
		        «FOR imp : imports»
		        	«IF imp.importUsedInWsdl(it)»«imp.importSchemaInWsdl»«ENDIF»
		        «ENDFOR»
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
		«IF !^void»
			<wsdl:message name="«name»Response">
				<wsdl:part element="tns:«name»Response" name="parameters"/>
			</wsdl:message>
		«ENDIF»
		«FOR fault : faults»
			<wsdl:message name="«fault.type.typeName»Exception">
				<wsdl:part name="«fault.type.typeName»Exception" element="«fault.type.typeRef»"/>
			</wsdl:message>
		«ENDFOR»		
	'''

	def operationInPortType(Operation it) '''
		<wsdl:operation name="«name»">
			<wsdl:input message="tns:«name»" name="«name»"/>
			«IF !^void»
				<wsdl:output message="tns:«name»Response" name="«name»Response"/>
			«ENDIF»
			«FOR fault : faults»
				<wsdl:fault name="«fault.type.typeName»Exception" message="tns:«fault.type.typeName»Exception"/>
			«ENDFOR»
		</wsdl:operation>
	'''

	def xsdFile(Mridl it, String modelName) '''
		<?xml version="1.0" encoding="utf-8"?>
		<xs:schema elementFormDefault="unqualified" 
				   xmlns:xs="http://www.w3.org/2001/XMLSchema"
				   xmlns:tns="«nsUri»"
				   «FOR imp : imports»
				   	«IF imp.importUsedInXsd(it)»«imp.importNS»«ENDIF»
				   «ENDFOR»
				   targetNamespace="«nsUri»">
			«FOR imp : imports»
				«IF imp.importUsedInXsd(it)»«imp.importSchema»«ENDIF»
			«ENDFOR»
			«FOR operation : operations»
				«operation.operationRootElements»
			«ENDFOR»
			«FOR operation : operations»
				«operation.operationComplexTypes»
			«ENDFOR»
			«FOR type : types»				
				«type.type»
			«ENDFOR»	         								
		</xs:schema>
	'''

	def operationRootElements(Operation it) '''
		<xs:element name="«name»" type="tns:«name»"/>
		«IF !^void»
			<xs:element name="«name»Response" type="tns:«name»Response"/>
		«ENDIF»
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
		«IF !^void»
			<xs:complexType name="«name»Response">
				<xs:sequence>
					«returnType.element»
				</xs:sequence>
			</xs:complexType>
		«ENDIF»
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

	def dispatch type(EnumType it) '''
		<xs:simpleType name="«name»">
			<xs:restriction base="xs:string">
				«FOR value : values»
					«value.enumValue»
				«ENDFOR»	    
			</xs:restriction>
		</xs:simpleType>
	'''

	def enumValue(EnumValue it) '''
		<xs:enumeration value="«value»"/>
	'''

	def element(Element it) '''
		«IF elementHasLength»
			<xs:element name="«name»"«conditionalElementMultiplicity»>
				<xs:simpleType>
					<xs:restriction base="«type.typeRef»">
						<xs:length value="«elementLength»"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		«ELSEIF elementHasDigits»
			<xs:element name="«name»"«conditionalElementMultiplicity»>
				<xs:simpleType>
					<xs:restriction base="«type.typeRef»">
						<xs:totalDigits value="«elementTotalDigits»"/>
						<xs:fractionDigits value="«elementFractionDigits»"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		«ELSE»
			<xs:element name="«name»" type="«type.typeRef»"«conditionalElementMultiplicity»/>
		«ENDIF»
	'''

	def conditionalElementMultiplicity(Element it) '''«IF multiplicity != null» «multiplicity.elementMultiplicity»«ENDIF»'''

	def elementHasLength(Element it) {
		type instanceof XsdBuiltinTypeWithLength && (type as XsdBuiltinTypeWithLength).lengthSpec != null
	}

	def elementLength(Element it) {
		(type as XsdBuiltinTypeWithLength).lengthSpec.len
	}

	def elementHasDigits(Element it) {
		type instanceof XsdBuiltinTypeWithDigits && (type as XsdBuiltinTypeWithDigits).digitsSpec != null
	}

	def elementTotalDigits(Element it) {
		(type as XsdBuiltinTypeWithDigits).digitsSpec.totalDigits
	}

	def elementFractionDigits(Element it) {
		(type as XsdBuiltinTypeWithDigits).digitsSpec.fractionDigits
	}

	def dispatch elementMultiplicity(SpecifiedMultiplicity it) '''minOccurs="«lower»" maxOccurs="«IF unbounded»unbounded«ELSE»«upper»«ENDIF»"'''

	def dispatch elementMultiplicity(UnspecifiedMultiplicity it) '''minOccurs="0" maxOccurs="unbounded"'''

	def dispatch elementMultiplicity(Optional it) '''minOccurs="0"'''

	def dispatch typeRef(XsdBuiltinTypeReference it) '''xs:«typeName»'''

	def dispatch typeRef(DirectTypeReference it) '''tns:«typeName»'''

	def dispatch typeRef(ImportedTypeReference it) '''«^import.nsPrefix»:«typeName»'''

	def dispatch typeName(XsdBuiltinTypeWithDigits it) '''«builtin»'''

	def dispatch typeName(XsdBuiltinTypeWithLength it) '''«builtin»'''

	def dispatch typeName(DirectTypeReference it) '''«ref.name»'''

	def dispatch typeName(ImportedTypeReference it) '''«ref.name»'''

	def importSchema(Import it) '''
		<xs:import namespace="«resolveImport.nsUri»" schemaLocation="«trimMridlExtension(importURI)».xsd"/>
	'''

	def importNS(Import it) '''
		xmlns:«nsPrefix»="«resolveImport.nsUri»"
	'''

	def importSchemaInWsdl(Import it) '''
		<schema xmlns="http://www.w3.org/2001/XMLSchema">
			<import namespace="«resolveImport.nsUri»" schemaLocation="«trimMridlExtension(importURI)».xsd"/>
		</schema>
	'''

	def importUsedInXsd(Import it, Mridl model) {
		importUsed(it, model, GeneratedFileType.XSD)
	}

	def importUsedInWsdl(Import it, Mridl model) {
		importUsed(it, model, GeneratedFileType.WSDL)
	}

	def importUsed(Import it, Mridl model, GeneratedFileType fileType) {
		val importedTypeReferences = model.eAllContents.filter(ImportedTypeReference);
		val thisImport = it
		val thisTypeReference = importedTypeReferences.findFirst [
			import == thisImport && ((fileType == GeneratedFileType.WSDL && isReferenceFromWsdl) ||
				(fileType == GeneratedFileType.XSD && !isReferenceFromWsdl))
		]
		thisTypeReference != null
	}

	def isReferenceFromWsdl(ImportedTypeReference it) {
		eContainer instanceof Fault
	}

	enum GeneratedFileType {
		WSDL,
		XSD
	}
}
