package pl.mrasoft.mridl.generator

import javax.inject.Inject
import pl.mrasoft.mridl.mridl.Documentation
import pl.mrasoft.mridl.mridl.Element
import pl.mrasoft.mridl.mridl.EnumValue
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.Optional
import pl.mrasoft.mridl.mridl.SpecifiedMultiplicity
import pl.mrasoft.mridl.mridl.TopLevelComplexType
import pl.mrasoft.mridl.mridl.TopLevelEnumType
import pl.mrasoft.mridl.mridl.TopLevelSimpleType
import pl.mrasoft.mridl.mridl.UnspecifiedMultiplicity
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithDigits
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithMaxLength
import pl.mrasoft.mridl.util.ResourceUtil

class XsdGenerator {

	@Inject extension ResourceUtil
	@Inject extension GeneratorCommon

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

	def importSchema(Import it) '''
		<xs:import namespace="«resolveImport.nsUri»" schemaLocation="«trimMridlExtension(importURI)».xsd"/>
	'''

	def importUsedInXsd(Import it, Mridl model) {
		importUsed(model, GeneratorCommon.GeneratedFileType.XSD)
	}

}
