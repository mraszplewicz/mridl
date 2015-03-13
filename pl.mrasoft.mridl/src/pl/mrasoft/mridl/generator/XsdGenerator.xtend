package pl.mrasoft.mridl.generator

import javax.inject.Inject
import pl.mrasoft.mridl.mridl.AbstractElement
import pl.mrasoft.mridl.mridl.Documentation
import pl.mrasoft.mridl.mridl.EnumValue
import pl.mrasoft.mridl.mridl.FractionDigitsSpecification
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReference
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.Optional
import pl.mrasoft.mridl.mridl.SimpleTypeBody
import pl.mrasoft.mridl.mridl.SpecifiedMultiplicity
import pl.mrasoft.mridl.mridl.TopLevelComplexType
import pl.mrasoft.mridl.mridl.TopLevelEnumType
import pl.mrasoft.mridl.mridl.TopLevelSimpleType
import pl.mrasoft.mridl.mridl.TotalAndFractionDigitsSpecification
import pl.mrasoft.mridl.mridl.TotalDigitsSpecification
import pl.mrasoft.mridl.mridl.UnspecifiedMultiplicity
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithDigits
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithMaxLength
import pl.mrasoft.mridl.util.ResourceUtil
import pl.mrasoft.mridl.mridl.NonRefElement
import pl.mrasoft.mridl.mridl.TopLevelElement
import pl.mrasoft.mridl.mridl.RefElement
import pl.mrasoft.mridl.util.URIParserUtil
import pl.mrasoft.mridl.util.MridlUtil

class XsdGenerator {

	@Inject extension ResourceUtil
	@Inject extension GeneratorCommon
	@Inject extension MridlUtil

	def xsdFile(Mridl it, String modelName) '''
		<?xml version="1.0" encoding="utf-8"?>
		<xs:schema elementFormDefault="unqualified" 
				   xmlns:xs="http://www.w3.org/2001/XMLSchema"
				   xmlns:tns="«nsUri»"
				   «FOR imp : imports»
				   	«IF imp.importUsedInXsd(it)»«imp.importNS»«ENDIF»
				   «ENDFOR»
				   «IF hasRefElement»jaxb:version="2.1"
				   xmlns:jaxb="http://java.sun.com/xml/ns/jaxb"«ENDIF»
				   targetNamespace="«nsUri»">
			«xsdFileDocumentation»
			«FOR imp : imports»
				«IF imp.importUsedInXsd(it)»«imp.importSchema»«ENDIF»
			«ENDFOR»
			«FOR operation : allOperations»
				«operation.operationRootElements»
			«ENDFOR»
			«FOR topLevelElement : topLevelElements»				
				«topLevelElement.element»
			«ENDFOR»
			«FOR operation : allOperations»
				«operation.operationComplexTypes»
			«ENDFOR»		
			«FOR typeDeclaration : typeDeclarations»				
				«typeDeclaration.typeDeclaration»
			«ENDFOR»
		</xs:schema>
	'''

	def importSchema(Import it) '''
		<xs:import namespace="«resolveImport.nsUri»" schemaLocation="«importedSchemaFilename(importURI)»"/>
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
		<xs:complexType«IF abstract» abstract="true"«ENDIF» name="«name»">
			«IF extends != null»
				<xs:complexContent>
					<xs:extension base="«extends.typeRef»">
						 «complexTypeSequence»
					</xs:extension>
				</xs:complexContent>
			«ELSE»			
				«complexTypeSequence»
			«ENDIF»
		</xs:complexType>
	'''

	def dispatch typeDeclaration(TopLevelSimpleType it) '''
		<xs:simpleType name="«name»">
			«body.simpleTypeBody»
		</xs:simpleType>
	'''

	def simpleTypeBody(SimpleTypeBody it) '''
		«IF simpleTypeHasPatternRestriction»
			<xs:restriction base="«base.typeRef»">
				<xs:pattern value="«patternRestriction.pattern»"/>
			</xs:restriction>
		«ELSE»
			<xs:restriction base="«base.typeRef»"/>
		«ENDIF»
	'''

	def simpleTypeHasPatternRestriction(SimpleTypeBody it) {
		patternRestriction != null
	}

	def dispatch typeDeclaration(TopLevelEnumType it) '''
		<xs:simpleType name="«name»">
			<xs:restriction base="xs:string">
				«FOR value : values»
					«value.enumValue»
				«ENDFOR»	    
			</xs:restriction>
		</xs:simpleType>
	'''

	def complexTypeSequence(TopLevelComplexType it) '''
		<xs:sequence>
			«FOR element : elements»
				«element.element»
			«ENDFOR»
		</xs:sequence>
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

	def dispatch element(NonRefElement it) { nonRefElement }

	def dispatch element(TopLevelElement it) { nonRefElement }

	def dispatch element(RefElement it) { refElement }

	def nonRefElement(AbstractElement it) '''
		«IF elementHasClosingTag»
			«elementWithClosingTag»
		«ELSE»
			<xs:element name="«name»" type="«typeDeclaration.type.typeRef»"«conditionalElementMultiplicity»/>
		«ENDIF»
	'''

	def refElement(RefElement it) '''
		<xs:element name="«name»"«IF !elementHasSimpleTypeRestriction» type="«refElementType»"«ENDIF»«refConditionalElementMultiplicity»>
			«IF elementHasDocumentation»
				«documentation.xsdDocumentation»
			«ENDIF»
			<xs:appinfo>
				<jaxb:property>
					<jaxb:baseType name="«refElementBaseType»"/>
				</jaxb:property>
			</xs:appinfo>
		</xs:element>
	'''

	def refElementType(RefElement it) {
		if (refElementIsUnbounded) {
			return "xs:IDREFS"
		} else {
			return "xs:IDREF"
		}
	}

	def refElementIsUnbounded(RefElement it) {
		if (typeDeclaration.multiplicity == null) {
			return false
		}
		typeDeclaration.multiplicity.refElementMultiplicityIsUnbounded
	}

	def dispatch refElementMultiplicityIsUnbounded(Optional it) { false }

	def dispatch refElementMultiplicityIsUnbounded(UnspecifiedMultiplicity it) { true }

	def dispatch refElementMultiplicityIsUnbounded(SpecifiedMultiplicity it) {
		if (unbounded) {
			return true
		}
		if (upper <= 1) {
			return false
		}
		true
	}

	def refElementBaseType(RefElement it) {
		val nsUri = resolveNamespace(typeDeclaration.type)
		val packageName = URIParserUtil.getPackageName(nsUri)
		return packageName + "." + typeDeclaration.type.typeName
	}

	def elementHasClosingTag(AbstractElement it) {
		elementHasLength || elementHasDigits || elementHasDocumentation
	}

	def elementWithClosingTag(AbstractElement it) '''
		<xs:element name="«name»"«IF !elementHasSimpleTypeRestriction» type="«typeDeclaration.type.typeRef»"«ENDIF»«conditionalElementMultiplicity»>
			«IF elementHasDocumentation»
				«documentation.xsdDocumentation»
			«ENDIF»
			«IF elementHasLength»
				<xs:simpleType>
					<xs:restriction base="«typeDeclaration.type.typeRef»">
						<xs:maxLength value="«elementLength»"/>
					</xs:restriction>
				</xs:simpleType>
			«ELSEIF elementHasDigits»
				<xs:simpleType>
					<xs:restriction base="«typeDeclaration.type.typeRef»">
						«IF elementHasTotalDigits»
							<xs:totalDigits value="«elementTotalDigits»"/>
						«ENDIF»
						«IF elementHasFractionDigits»
							<xs:fractionDigits value="«elementFractionDigits»"/>
						«ENDIF»
					</xs:restriction>
				</xs:simpleType>
			«ENDIF»
		</xs:element>
	'''

	def elementHasDocumentation(AbstractElement it) {
		documentation != null && documentation.doc != null
	}

	def elementHasSimpleTypeRestriction(AbstractElement it) {
		elementHasLength || elementHasDigits
	}

	def elementHasTotalDigits(AbstractElement it) {
		elementHasDigits && getXsdBuiltinTypeWithDigits.digitsSpec.digitsSpecHasTotalDigits
	}

	def dispatch digitsSpecHasTotalDigits(TotalAndFractionDigitsSpecification it) { true }

	def dispatch digitsSpecHasTotalDigits(TotalDigitsSpecification it) { true }

	def dispatch digitsSpecHasTotalDigits(FractionDigitsSpecification it) { false }

	def elementHasFractionDigits(AbstractElement it) {
		elementHasDigits && getXsdBuiltinTypeWithDigits.digitsSpec.digitsSpecHasFractionDigits
	}

	def dispatch digitsSpecHasFractionDigits(TotalAndFractionDigitsSpecification it) { true }

	def dispatch digitsSpecHasFractionDigits(TotalDigitsSpecification it) { false }

	def dispatch digitsSpecHasFractionDigits(FractionDigitsSpecification it) { true }

	def xsdDocumentation(Documentation it) '''
		<xs:annotation>
			<xs:documentation>
				«doc»
			</xs:documentation>
		</xs:annotation>
	'''

	def conditionalElementMultiplicity(AbstractElement it) '''«IF typeDeclaration.multiplicity != null»«typeDeclaration.
		multiplicity.elementMultiplicity»«ENDIF»'''

	def refConditionalElementMultiplicity(AbstractElement it) '''«IF typeDeclaration.multiplicity != null»«typeDeclaration.
		multiplicity.refElementMultiplicity»«ENDIF»'''

	def elementHasLength(AbstractElement it) {
		val ref = getXsdBuiltinTypeWithMaxLength
		ref != null && ref.lengthSpec != null
	}

	def getXsdBuiltinTypeWithMaxLength(AbstractElement it) {
		if (typeDeclaration.type instanceof XsdBuiltinTypeReference) {
			val ref = (typeDeclaration.type as XsdBuiltinTypeReference).ref
			if (ref instanceof XsdBuiltinTypeWithMaxLength) {
				return ref
			}
		}
		return null
	}

	def getXsdBuiltinTypeWithDigits(AbstractElement it) {
		if (typeDeclaration.type instanceof XsdBuiltinTypeReference) {
			val ref = (typeDeclaration.type as XsdBuiltinTypeReference).ref
			if (ref instanceof XsdBuiltinTypeWithDigits) {
				return ref
			}
		}
		return null
	}

	def elementLength(AbstractElement it) {
		getXsdBuiltinTypeWithMaxLength.lengthSpec.maxLength
	}

	def elementHasDigits(AbstractElement it) {
		val ref = getXsdBuiltinTypeWithDigits
		ref != null && ref.digitsSpec != null
	}

	def elementTotalDigits(AbstractElement it) {
		getXsdBuiltinTypeWithDigits.digitsSpec.digitsSpecTotalDigits
	}

	def dispatch digitsSpecTotalDigits(TotalAndFractionDigitsSpecification it) { totalDigits }

	def dispatch digitsSpecTotalDigits(TotalDigitsSpecification it) { totalDigits }

	def elementFractionDigits(AbstractElement it) {
		getXsdBuiltinTypeWithDigits.digitsSpec.digitsSpecFractionDigits
	}

	def dispatch digitsSpecFractionDigits(TotalAndFractionDigitsSpecification it) { fractionDigits }

	def dispatch digitsSpecFractionDigits(FractionDigitsSpecification it) { fractionDigits }

	def dispatch elementMultiplicity(SpecifiedMultiplicity it) '''«multiplicityMinOccurs»«multiplicityMaxOccurs»'''

	def multiplicityMinOccurs(SpecifiedMultiplicity it) '''«IF lower != 1» minOccurs="«lower»"«ENDIF»'''

	def multiplicityMaxOccurs(SpecifiedMultiplicity it) '''«IF upper != 1» maxOccurs="«IF unbounded»unbounded«ELSE»«upper»«ENDIF»"«ENDIF»'''

	def multiplicityHasMin(SpecifiedMultiplicity it) { lower != 1 }

	def multiplicityHasMax(SpecifiedMultiplicity it) { upper != 1 }

	def dispatch elementMultiplicity(UnspecifiedMultiplicity it) ''' minOccurs="0" maxOccurs="unbounded"'''

	def dispatch elementMultiplicity(Optional it) ''' minOccurs="0"'''

	def dispatch refElementMultiplicity(SpecifiedMultiplicity it) '''«multiplicityMinOccurs»'''

	def dispatch refElementMultiplicity(UnspecifiedMultiplicity it) ''' minOccurs="0"'''

	def dispatch refElementMultiplicity(Optional it) ''' minOccurs="0"'''

	def importUsedInXsd(Import it, Mridl model) {
		val thisImport = it

		val importedTypeReferences = model.eAllContents.filter(ImportedTopLevelTypeReference)
		val thisTypeReference = importedTypeReferences.findFirst [
			importRef.^import == thisImport && elementIsNotRef
		]
		thisTypeReference != null
	}

	def elementIsNotRef(ImportedTopLevelTypeReference it) {
		(eContainer == null || eContainer.eContainer == null || !(eContainer.eContainer instanceof RefElement))
	}

	def hasRefElement(Mridl it) {
		val refElements = eAllContents.filter(RefElement)
		refElements.size > 0
	}

}
