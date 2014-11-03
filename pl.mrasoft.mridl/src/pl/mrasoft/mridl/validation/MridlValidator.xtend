package pl.mrasoft.mridl.validation

import org.eclipse.xtext.validation.Check
import pl.mrasoft.mridl.mridl.MridlPackage
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.Element

class MridlValidator extends AbstractMridlValidator {

	@Check
	def void checkOperationParameterNameIsUnique(Element parameter) {

		if (parameter.eContainer instanceof Operation) {
			val operation = parameter.eContainer as Operation
			val element = parameter as Element
			val parameterName = element.name

			for (opParam : operation.params) {
				val opParamElement = opParam as Element
				if (opParam != parameter && parameterName.equals(opParamElement.name)) {
					error("Duplicate parameter '" + parameterName + "'", MridlPackage.Literals::ELEMENT__NAME);
					return
				}
			}
		}
	}

}
