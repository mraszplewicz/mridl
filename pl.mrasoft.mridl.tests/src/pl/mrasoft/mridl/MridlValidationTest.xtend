package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

class MridlValidationTest extends BaseMridlTest {

	new() {
		super("MridlValidationTest");
	}

	@Test
	def void checkOperationParameterNameIsUnique() {
		val issues = testFile("d1/DuplicateOperationParamName.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain("Duplicate element 'text'")
		)
	}

	@Test
	def void checkComplexTypeElementNameIsUnique() {
		val issues = testFile("d1/DuplicateFieldInComplexType.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(5).allOfThemContain("Duplicate element 'a'")
		)

		assertConstraints(
			issues.inLine(6).allOfThemContain("Duplicate element 'a'")
		)
	}

	@Test
	def void checkInheritedComplexTypeElementNameIsUnique() {
		val issues = testFile("d1/DuplicateFieldInInheritedComplexType.mridl")

		assertConstraints(
			issues.sizeIs(1)
		)

		assertConstraints(
			issues.inLine(11).allOfThemContain("Duplicate element 'a'")
		)
	}

	@Test
	def void checkComplexTypeElementNameIsUniqueInInheritanceHierarchy() {
		val issues = testFile("d1/DuplicateFieldInInheritanceHierarchy.mridl")

		assertConstraints(
			issues.sizeIs(1)
		)

		assertConstraints(
			issues.inLine(17).allOfThemContain("Duplicate element 'a'")
		)
	}

	@Test
	def void checkEnumValueIsUnique() {
		val issues = testFile("d1/DuplicateEnumValue.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(5).allOfThemContain("Duplicate enum value 'ENUM1'")
		)

		assertConstraints(
			issues.inLine(6).allOfThemContain("Duplicate enum value 'ENUM1'")
		)
	}

	@Test
	def void checkComplexTypeNameIsUnique() {
		val issues = testFile("d1/DuplicateComplexTypeName.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain("Duplicate type 'TestComplex'")
		)

		assertConstraints(
			issues.inLine(9).allOfThemContain("Duplicate type 'TestComplex'")
		)
	}

	@Test
	def void checkComplexTypeNameAndEnumTypeIsUnique() {
		val issues = testFile("d1/DuplicateComplexAndEnumTypeName.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain("Duplicate type 'TestType'")
		)

		assertConstraints(
			issues.inLine(9).allOfThemContain("Duplicate type 'TestType'")
		)
	}

	@Test
	def void checkComplexTypeNameAndSimpleTypeIsUnique() {
		val issues = testFile("d1/DuplicateComplexAndSimpleTypeName.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain("Duplicate type 'TestType'")
		)

		assertConstraints(
			issues.inLine(9).allOfThemContain("Duplicate type 'TestType'")
		)
	}

	@Test
	def void checkImportedDuplicateComplexTypeName() {
		val issues = testFile("d1/DuplicateImportedComplexTypeName.mridl")

		assertConstraints(
			issues.sizeIs(0)
		)
	}

	@Test
	def void checkFaultElementNameIsUnique() {
		val issues = testFile("d1/DuplicateFaultElementName.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain("Duplicate element 'TestFault'")
		)

		assertConstraints(
			issues.inLine(9).allOfThemContain("Duplicate element 'TestFault'")
		)
	}

	@Test
	def void checkOperationFaultNameIsUnique() {
		val issues = testFile("d1/DuplicateOperationFaultName.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain("Duplicate fault 'TestFault'")
		)
	}

	@Test
	def void checkRefElementIsComplexType() {
		val issues = testFile("d1/RefNonComplexType.mridl")

		assertConstraints(
			issues.sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).allOfThemContain("Reference to non complex type")
		)
	}

	@Test
	def void checkRefElementTypeHasID() {
		val issues = testFile("d1/RefTypeWithoutID.mridl")

		assertConstraints(
			issues.sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).allOfThemContain("Reference to type without ID")
		)
	}

	@Test
	def void checkRefElementTypeHasIDInInheritanceHierarchy() {
		val issues = testFile("d1/RefTypeWithoutIDInInheritanceHierarchy.mridl")

		assertConstraints(
			issues.sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).allOfThemContain("Reference to type without ID")
		)
	}

	@Test
	def void checkRefElementTypeHasIDInInheritanceHierarchyOK() {
		val issues = testFile("d1/RefTypeWithIDInInheritanceHierarchy.mridl")

		assertConstraints(
			issues.sizeIs(0)
		)
	}

	@Test
	def void checkRefMultiplicityUpperNotMoreThanOne() {
		val issues = testFile("d1/RefMultiplicityUpperMoreThanOne.mridl")

		assertConstraints(
			issues.sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).allOfThemContain("Only reference to unbounded elements collection is allowed")
		)
	}

	@Test
	def void checkRefMultiplicityLowerNotMoreThanOne() {
		val issues = testFile("d1/RefMultiplicityLowerMoreThanOne.mridl")

		assertConstraints(
			issues.sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).sizeIs(1)
		)

		assertConstraints(
			issues.inLine(4).allOfThemContain("Only reference to minimum 0 or 1 elements collection is allowed")
		)
	}

	@Test
	def void checkOperationNameIsUnique() {
		val issues = testFile("d1/DuplicateOperationName.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain("Duplicate operation 'op1'")
		)
		
		assertConstraints(
			issues.inLine(5).allOfThemContain("Duplicate operation 'op1'")
		)
	}

	@Test
	def void checkInterfaceNameIsUnique() {
		val issues = testFile("d1/DuplicateInterfaceName.mridl")

		assertConstraints(
			issues.sizeIs(2)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain("Duplicate interface 'Interface1'")
		)

		assertConstraints(
			issues.inLine(7).allOfThemContain("Duplicate interface 'Interface1'")
		)
	}

	@Test
	def void checkInterfaceNameDifferentThanModelName() {
		val issues = testFile("d1/InterfaceNameSameAsModelName.mridl")

		assertConstraints(
			issues.sizeIs(1)
		)

		assertConstraints(
			issues.inLine(3).sizeIs(1)
		)

		assertConstraints(
			issues.inLine(3).allOfThemContain(
				"Named interface 'InterfaceNameSameAsModelName' should have different name than file")
		)
	}

}
