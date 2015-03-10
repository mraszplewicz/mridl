package pl.mrasoft.mridl.validation

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.validation.Check
import pl.mrasoft.mridl.mridl.Element
import pl.mrasoft.mridl.mridl.EnumValue
import pl.mrasoft.mridl.mridl.Fault
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.MridlPackage
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.TopLevelComplexType
import pl.mrasoft.mridl.mridl.TopLevelElement
import pl.mrasoft.mridl.mridl.TopLevelEnumType
import pl.mrasoft.mridl.mridl.TopLevelType
import pl.mrasoft.mridl.mridl.RefElement
import pl.mrasoft.mridl.mridl.SpecifiedMultiplicity
import pl.mrasoft.mridl.mridl.TopLevelTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeDeclaration

class MridlValidator extends AbstractMridlValidator {

	@Check
	def void checkElementNameIsUnique(Element element) {

		checkElementNameIsUnique(element.eContainer, element)

	}

	@Check
	def void checkEnumValueNameIsUnique(EnumValue enumValue) {

		val enumValueName = enumValue.value
		val ^enum = enumValue.eContainer as TopLevelEnumType

		for (containerEnumValue : ^enum.values) {
			if (containerEnumValue != enumValue && enumValueName.equals(containerEnumValue.value)) {
				error("Duplicate enum value '" + enumValueName + "'", MridlPackage.Literals::ENUM_VALUE__VALUE);
				return
			}
		}

	}

	@Check
	def void checkTypeNameIsUnique(TopLevelType topLevelType) {

		val topLevelTypeName = topLevelType.name
		val model = topLevelType.eContainer as Mridl

		for (containerTopLevelType : model.typeDeclarations) {
			if (containerTopLevelType != topLevelType && topLevelTypeName.equals(containerTopLevelType.name)) {
				error("Duplicate type '" + topLevelTypeName + "'", MridlPackage.Literals::TOP_LEVEL_TYPE__NAME);
				return
			}
		}

	}

	@Check
	def void checkFaultElementNameIsUnique(TopLevelElement topLevelElement) {

		val topLevelElementName = topLevelElement.name
		val model = topLevelElement.eContainer as Mridl

		for (containerTopLevelElement : model.topLevelElements) {
			if (containerTopLevelElement != topLevelElement && topLevelElementName.equals(containerTopLevelElement.name)) {
				error("Duplicate element '" + topLevelElementName + "'", MridlPackage.Literals::ABSTRACT_ELEMENT__NAME);
				return
			}
		}

	}

	@Check
	def void checkOperationFaultNameIsUnique(Fault fault) {

		val faultName = fault.element.ref.name
		val operation = fault.eContainer as Operation

		for (containerFault : operation.faults) {
			if (containerFault != fault && faultName.equals(containerFault.element.ref.name)) {
				error("Duplicate fault '" + faultName + "'", MridlPackage.Literals::FAULT__ELEMENT);
				return
			}
		}

	}

	@Check
	def void checkRefElementIsComplexType(RefElement element) {
		if (!element.refElementIsComplexType) {
			error("Reference to non complex type", MridlPackage.Literals::ABSTRACT_ELEMENT__TYPE_DECLARATION);
		}
	}

	@Check
	def void checkRefElementTypeHasID(RefElement element) {

		val refElementType = element.getRefElementType

		if (refElementType != null && !refElementType.topLevelComplexTypeHasID) {
			error("Reference to type without ID", MridlPackage.Literals::ABSTRACT_ELEMENT__TYPE_DECLARATION);
		}

	}

	@Check
	def void checkRefMultiplicityUpperNotMoreThanOne(RefElement element) {
		if (element.elementHasSpecifiedMultiplicity) {
			val multiplicity = element.getSpecifiedMultiplicity
			if (!multiplicity.unbounded && multiplicity.upper > 1) {
				error("Only reference to unbounded elements collection is allowed",
					MridlPackage.Literals::ABSTRACT_ELEMENT__TYPE_DECLARATION);
			}
		}
	}

	@Check
	def void checkRefMultiplicityLowerNotMoreThanOne(RefElement element) {
		if (element.elementHasSpecifiedMultiplicity) {
			val multiplicity = element.getSpecifiedMultiplicity
			if (multiplicity.lower > 1) {
				error("Only reference to minimum 0 or 1 elements collection is allowed",
					MridlPackage.Literals::ABSTRACT_ELEMENT__TYPE_DECLARATION);
			}
		}
	}

	def refElementIsComplexType(RefElement it) {
		if (typeDeclaration.type instanceof TopLevelTypeReference) {
			val typeReference = typeDeclaration.type as TopLevelTypeReference
			return typeReference.ref instanceof TopLevelComplexType
		}
		false
	}

	def getRefElementType(RefElement it) {
		if (refElementIsComplexType) {
			val typeReference = typeDeclaration.type as TopLevelTypeReference
			return typeReference.ref as TopLevelComplexType
		}
	}

	def elementHasSpecifiedMultiplicity(RefElement it) {
		typeDeclaration.multiplicity != null && typeDeclaration.multiplicity instanceof SpecifiedMultiplicity
	}

	def getSpecifiedMultiplicity(RefElement it) {
		typeDeclaration.multiplicity as SpecifiedMultiplicity
	}

	def void checkElementNameIsUnique(EObject container, Element element) {

		val elementName = element.name

		val List<Element> containerElements = getContainerElements(container)

		if (container instanceof TopLevelComplexType) {
			checkElementNameIsUniqueInSuperTypes(container, element)
		}

		for (containerElement : containerElements) {
			if (containerElement != element && elementName.equals(containerElement.name)) {
				error("Duplicate element '" + elementName + "'",
					MridlPackage.Literals::ABSTRACT_ELEMENT__TYPE_DECLARATION);
				return
			}
		}

	}

	def boolean topLevelComplexTypeHasID(TopLevelComplexType type) {

		for (element : type.elements) {
			if (element.typeDeclaration.type instanceof XsdBuiltinTypeReference) {
				val elementType = element.typeDeclaration.type as XsdBuiltinTypeReference
				if (elementType.ref.declaration == XsdBuiltinTypeDeclaration.ID) {
					return true
				}

			}
		}

		if (type.^extends != null) {
			return topLevelComplexTypeHasID(type.^extends.ref)
		}
		false

	}

	def dispatch List<Element> getContainerElements(Operation container) {
		container.params
	}

	def dispatch List<Element> getContainerElements(TopLevelComplexType container) {
		container.elements
	}

	def void checkElementNameIsUniqueInSuperTypes(TopLevelComplexType container, Element element) {

		if (container.^extends != null) {
			checkElementNameIsUnique(container.^extends.ref, element)
		}

	}

}
