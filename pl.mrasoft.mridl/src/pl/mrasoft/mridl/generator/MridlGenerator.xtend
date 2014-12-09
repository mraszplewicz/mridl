package pl.mrasoft.mridl.generator

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IFileSystemAccessExtension2
import org.eclipse.xtext.generator.IGenerator
import pl.mrasoft.mridl.mridl.DirectTopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.DirectTopLevelTypeReference
import pl.mrasoft.mridl.mridl.Element
import pl.mrasoft.mridl.mridl.EnumValue
import pl.mrasoft.mridl.mridl.Fault
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.ImportedTopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReference
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.Optional
import pl.mrasoft.mridl.mridl.SpecifiedMultiplicity
import pl.mrasoft.mridl.mridl.TopLevelComplexType
import pl.mrasoft.mridl.mridl.TopLevelEnumType
import pl.mrasoft.mridl.mridl.TopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.TopLevelSimpleType
import pl.mrasoft.mridl.mridl.TopLevelTypeReference
import pl.mrasoft.mridl.mridl.UnspecifiedMultiplicity
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithDigits
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithMaxLength
import pl.mrasoft.mridl.util.ResourceUtil
import pl.mrasoft.mridl.mridl.DirectTopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.ImportedTopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.TopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.Documentation

class MridlGenerator implements IGenerator {

	@Inject extension ResourceUtil

	final static val CLASSPATH_PREFIX = "classpath:/"

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val modelName = resource.URI.trimFileExtension.lastSegment;
		val model = resource.contents.head as Mridl

		val pathWithoutExtension = resource.containingFolder(fsa) + "/" + modelName

		if (model.mridlHasWsdlFile) {
			fsa.generateFile(pathWithoutExtension + ".wsdl", model.wsdlFile(modelName))
		}
		fsa.generateFile(pathWithoutExtension + ".xsd", model.xsdFile(modelName))
	}
	
	def mridlHasWsdlFile(Mridl it) {
		!operations.empty
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
		    «wsdlFileDocumentation»
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
	
	def wsdlFileDocumentation(Mridl it) '''
		«IF wsdlFileHasDocumentation»
			«documentation.wsdlDocumentation»
		«ENDIF»
	'''

	def wsdlFileHasDocumentation(Mridl it) {
		documentation != null && documentation.doc != null
	}

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
			«operationDocumentation»
			<wsdl:input message="tns:«name»" name="«name»"/>
			«IF !^void»
				<wsdl:output message="tns:«name»Response" name="«name»Response"/>
			«ENDIF»
			«FOR fault : faults»
				«fault.operationFault»
			«ENDFOR»
		</wsdl:operation>
	'''

	def operationFault(Fault it) '''
		«IF faultHasDocumentation»
			<wsdl:fault name="«type.typeName»Exception" message="tns:«type.typeName»Exception">
				«faultDocumentation»
			</wsdl:fault>
		«ELSE»
			<wsdl:fault name="«type.typeName»Exception" message="tns:«type.typeName»Exception"/>
		«ENDIF»
	'''

	def operationDocumentation(Operation it) '''
		«IF operationHasDocumentation»
			«documentation.wsdlDocumentation»
		«ENDIF»
	'''

	def operationHasDocumentation(Operation it) {
		documentation != null && documentation.doc != null
	}

	def faultDocumentation(Fault it) '''
		«IF faultHasDocumentation»
			«documentation.wsdlDocumentation»
		«ENDIF»
	'''

	def faultHasDocumentation(Fault it) {
		documentation != null && documentation.doc != null
	}

	def wsdlDocumentation(Documentation it) '''		
		<wsdl:documentation>
			«doc»
		</wsdl:documentation>
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
			«xsdFileDocumentation»
			«FOR imp : imports»
				«IF imp.importUsedInXsd(it)»«imp.importSchema»«ENDIF»
			«ENDFOR»
			«FOR operation : operations»
				«operation.operationRootElements»
			«ENDFOR»
			«FOR operation : operations»
				«operation.operationComplexTypes»
			«ENDFOR»
			«FOR typeDeclaration : typeDeclarations»				
				«typeDeclaration.typeDeclaration»
			«ENDFOR»	         								
		</xs:schema>
	'''
	
	def xsdFileDocumentation(Mridl it) '''
		«IF xsdFileHasDocumentation»
			«documentation.xsdDocumentation»
		«ENDIF»
	'''

	def xsdFileHasDocumentation(Mridl it) {
		!mridlHasWsdlFile && documentation != null && documentation.doc != null
	}

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

	def dispatch typeDeclaration(TopLevelComplexType it) '''
		«IF extends != null»
			<xs:complexType name="«name»">
				<xs:complexContent>
					<xs:extension base="«extends.typeRef»">
						 «complexTypeSequence»
					</xs:extension>
				</xs:complexContent>
			</xs:complexType>
		«ELSE»
			<xs:complexType name="«name»">
				«complexTypeSequence»
			</xs:complexType>
		«ENDIF»
	'''

	def complexTypeSequence(TopLevelComplexType it) '''
		<xs:sequence>
			«FOR element : elements»
				«element.element»
			«ENDFOR»
		</xs:sequence>
	'''

	def dispatch typeDeclaration(TopLevelSimpleType it) '''
		<xs:simpleType name="«name»">
			<xs:restriction base="«restriction.simpleType.typeRef»">
				<xs:pattern value="«restriction.pattern»"/>	    
			</xs:restriction>
		</xs:simpleType>
	'''

	def dispatch typeDeclaration(TopLevelEnumType it) '''
		<xs:simpleType name="«name»">
			<xs:restriction base="xs:string">
				«FOR value : values»
					«value.enumValue»
				«ENDFOR»	    
			</xs:restriction>
		</xs:simpleType>
	'''

	def enumValue(EnumValue it) '''
		«IF enumValueHasDocumentation»
			<xs:enumeration value="«value»">
				«documentation.xsdDocumentation»
			</xs:enumeration>
		«ELSE»
			<xs:enumeration value="«value»"/>
		«ENDIF»
	'''

	def enumValueHasDocumentation(EnumValue it) {
		documentation != null && documentation.doc != null
	}

	def element(Element it) '''
		«IF elementHasLength»
			<xs:element name="«name»"«conditionalElementMultiplicity»>
				«elementDocumentation»
				<xs:simpleType>
					<xs:restriction base="«type.typeRef»">
						<xs:maxLength value="«elementLength»"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		«ELSEIF elementHasDigits»
			<xs:element name="«name»"«conditionalElementMultiplicity»>
				«elementDocumentation»
				<xs:simpleType>
					<xs:restriction base="«type.typeRef»">
						<xs:totalDigits value="«elementTotalDigits»"/>
						<xs:fractionDigits value="«elementFractionDigits»"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		«ELSEIF elementHasDocumentation»
			<xs:element name="«name»" type="«type.typeRef»"«conditionalElementMultiplicity»>
				«documentation.xsdDocumentation»
			</xs:element>	
		«ELSE»
			<xs:element name="«name»" type="«type.typeRef»"«conditionalElementMultiplicity»/>
		«ENDIF»
	'''

	def elementDocumentation(Element it) '''
		«IF elementHasDocumentation»
			«documentation.xsdDocumentation»
		«ENDIF»
	'''

	def elementHasDocumentation(Element it) {
		documentation != null && documentation.doc != null
	}

	def xsdDocumentation(Documentation it) '''
		<xs:annotation>
			<xs:documentation>
				«doc»
			</xs:documentation>
		</xs:annotation>
	'''

	def conditionalElementMultiplicity(Element it) '''«IF multiplicity != null» «multiplicity.elementMultiplicity»«ENDIF»'''

	def elementHasLength(Element it) {
		val ref = getXsdBuiltinTypeWithMaxLength
		ref != null && ref.lengthSpec != null
	}

	def getXsdBuiltinTypeWithMaxLength(Element it) {
		if (type instanceof XsdBuiltinTypeReference) {
			val ref = (type as XsdBuiltinTypeReference).ref
			if (ref instanceof XsdBuiltinTypeWithMaxLength) {
				return ref
			}
		}
		return null
	}

	def getXsdBuiltinTypeWithDigits(Element it) {
		if (type instanceof XsdBuiltinTypeReference) {
			val ref = (type as XsdBuiltinTypeReference).ref
			if (ref instanceof XsdBuiltinTypeWithDigits) {
				return ref
			}
		}
		return null
	}

	def elementLength(Element it) {
		getXsdBuiltinTypeWithMaxLength.lengthSpec.maxLength
	}

	def elementHasDigits(Element it) {
		val ref = getXsdBuiltinTypeWithDigits
		ref != null && ref.digitsSpec != null
	}

	def elementTotalDigits(Element it) {
		getXsdBuiltinTypeWithDigits.digitsSpec.totalDigits
	}

	def elementFractionDigits(Element it) {
		getXsdBuiltinTypeWithDigits.digitsSpec.fractionDigits
	}

	def dispatch elementMultiplicity(SpecifiedMultiplicity it) '''minOccurs="«lower»" maxOccurs="«IF unbounded»unbounded«ELSE»«upper»«ENDIF»"'''

	def dispatch elementMultiplicity(UnspecifiedMultiplicity it) '''minOccurs="0" maxOccurs="unbounded"'''

	def dispatch elementMultiplicity(Optional it) '''minOccurs="0"'''

	def dispatch typeRef(XsdBuiltinTypeReference it) '''xs:«typeName»'''

	def dispatch typeRef(DirectTopLevelTypeReference it) '''tns:«typeName»'''

	def dispatch typeRef(ImportedTopLevelTypeReference it) '''«importRef.^import.nsPrefix»:«typeName»'''

	def dispatch typeRef(DirectTopLevelSimpleTypeReference it) '''tns:«typeName»'''

	def dispatch typeRef(ImportedTopLevelSimpleTypeReference it) '''«importRef.^import.nsPrefix»:«typeName»'''

	def dispatch typeRef(DirectTopLevelComplexTypeReference it) '''tns:«typeName»'''

	def dispatch typeRef(ImportedTopLevelComplexTypeReference it) '''«importRef.^import.nsPrefix»:«typeName»'''

	def dispatch typeName(XsdBuiltinTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelSimpleTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelComplexTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch referencedTypeName(XsdBuiltinTypeWithDigits it) { declaration.getName }

	def dispatch referencedTypeName(XsdBuiltinTypeWithMaxLength it) { declaration.getName }

	def dispatch referencedTypeName(TopLevelSimpleType it) { name }

	def dispatch referencedTypeName(TopLevelComplexType it) { name }

	def dispatch referencedTypeName(TopLevelEnumType it) { name }

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
		val importedTypeReferences = model.eAllContents.filter(ImportedTopLevelTypeReference);
		val thisImport = it
		val thisTypeReference = importedTypeReferences.findFirst [
			importRef.^import == thisImport && ((fileType == GeneratedFileType.WSDL && isReferenceFromWsdl) ||
				(fileType == GeneratedFileType.XSD && !isReferenceFromWsdl))
		]
		thisTypeReference != null
	}

	def isReferenceFromWsdl(ImportedTopLevelTypeReference it) {
		eContainer instanceof Fault
	}

	enum GeneratedFileType {
		WSDL,
		XSD
	}
}
