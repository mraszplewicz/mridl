package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlBasicComplexTypeTest extends BaseMridlTest {

	new() {
		super("MridlBasicComplexTypeTest");
	}

	@Test
	def void basicComplexTypeNoOperation() {
		val fsa = generate("hello/Hello.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/Hello.xsd"),
			getActual(fsa, "hello/Hello.xsd")
		)
	}
	
	@Test
	def void operationWithComplexTypeParameter() {
		val fsa = generate("hello/HelloOperationComplexTypeParam.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/HelloOperationComplexTypeParam.xsd"),
			getActual(fsa, "hello/HelloOperationComplexTypeParam.xsd")
		)

		assertEquals(
			getExpected("hello/HelloOperationComplexTypeParam.wsdl"),
			getActual(fsa, "hello/HelloOperationComplexTypeParam.wsdl")
		)
	}
	
	@Test
	def void complexTypeWithComplexTypeElement() {
		val fsa = generate("hello/HelloComplexTypeElement.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/HelloComplexTypeElement.xsd"),
			getActual(fsa, "hello/HelloComplexTypeElement.xsd")
		)
	}

}
