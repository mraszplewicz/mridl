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

}
