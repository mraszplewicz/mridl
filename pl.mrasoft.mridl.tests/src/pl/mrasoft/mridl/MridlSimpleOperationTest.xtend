package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlSimpleOperationTest extends BaseMridlTest {

	new() {
		super("MridlSimpleOperationTest");
	}

	@Test
	def void oneOperationManyParameters() {
		val fsa = generate("hello/Hello.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/Hello.xsd"),
			getActual(fsa, "hello/Hello.xsd")
		)

		assertEquals(
			getExpected("hello/Hello.wsdl"),
			getActual(fsa, "hello/Hello.wsdl")
		)
	}

	@Test
	def void oneOperationParameterLess() {
		val fsa = generate("hello/HelloParameterLess.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/HelloParameterLess.xsd"),
			getActual(fsa, "hello/HelloParameterLess.xsd")
		)

		assertEquals(
			getExpected("hello/HelloParameterLess.wsdl"),
			getActual(fsa, "hello/HelloParameterLess.wsdl")
		)
	}
	
	@Test
	def void moreThanOneOperation() {
		val fsa = generate("hello/HelloMoreThanOneOperation.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/HelloMoreThanOneOperation.xsd"),
			getActual(fsa, "hello/HelloMoreThanOneOperation.xsd")
		)

		assertEquals(
			getExpected("hello/HelloMoreThanOneOperation.wsdl"),
			getActual(fsa, "hello/HelloMoreThanOneOperation.wsdl")
		)
	}

	@Test
	def void checkOperationParameterNameIsUnique() {
		val issues = testFile("hello/HelloDuplicateOperationParamName.mridl")

		assertConstraints(
			issues.inLine(3)
			      .allOfThemContain("Duplicate parameter 'text'")
				  
		)
	}

}
