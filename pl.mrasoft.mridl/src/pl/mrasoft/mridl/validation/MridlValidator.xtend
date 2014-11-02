package pl.mrasoft.mridl.validation

import org.eclipse.xtext.validation.Check
import pl.mrasoft.mridl.mridl.MridlPackage
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.mridl.OperationParameter

class MridlValidator extends AbstractMridlValidator {

	@Check
	def void checkOperationParameterNameIsUnique(OperationParameter parameter) {

		val operation = parameter.eContainer as Operation
		val parameterName = parameter.name

		for (opParam : operation.params) {
			if (opParam != parameter && parameterName.equals(opParam.name)) {
				error("Duplicate parameter '" + parameter.name + "'",
					MridlPackage.Literals::OPERATION_PARAMETER__NAME);
				return
			}
		}

	}
	
}
