package pl.mrasoft.mridl.validation

import org.eclipse.xtext.validation.Check
import pl.mrasoft.mridl.mridl.MridlPackage
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.Element
import java.util.List
import pl.mrasoft.mridl.mridl.TopLevelComplexType
import org.eclipse.emf.ecore.EObject
import pl.mrasoft.mridl.mridl.EnumValue
import pl.mrasoft.mridl.mridl.TopLevelEnumType
import pl.mrasoft.mridl.mridl.TopLevelType
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.FaultElement
import pl.mrasoft.mridl.mridl.Fault

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
	def void checkFaultElementNameIsUnique(FaultElement faultElement) {

		val faultElementName = faultElement.name
		val model = faultElement.eContainer as Mridl

		for (containerFaultElement : model.faultElements) {
			if (containerFaultElement != faultElement && faultElementName.equals(containerFaultElement.name)) {
				error("Duplicate element '" + faultElementName + "'", MridlPackage.Literals::ABSTRACT_ELEMENT__NAME);
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

	def void checkElementNameIsUnique(EObject container, Element element) {

		val elementName = element.name

		val List<Element> containerElements = getContainerElements(container, element)

		if (container instanceof TopLevelComplexType) {
			checkElementNameIsUniqueInSuperTypes(container, element)
		}

		for (containerElement : containerElements) {
			if (containerElement != element && elementName.equals(containerElement.name)) {
				error("Duplicate element '" + elementName + "'", MridlPackage.Literals::ABSTRACT_ELEMENT__NAME);
				return
			}
		}

	}

	def dispatch List<Element> getContainerElements(Operation container, Element element) {
		container.params
	}

	def dispatch List<Element> getContainerElements(TopLevelComplexType container, Element element) {
		container.elements
	}

	def void checkElementNameIsUniqueInSuperTypes(TopLevelComplexType container, Element element) {

		if (container.^extends != null) {
			checkElementNameIsUnique(container.^extends.ref, element)
		}

	}

}
