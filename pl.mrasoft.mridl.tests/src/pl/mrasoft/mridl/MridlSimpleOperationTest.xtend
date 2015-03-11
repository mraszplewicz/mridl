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

		assertEquals(3, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/Hello.xsd"),
			getActual(fsa, "hello/Hello.xsd")
		)

		assertEquals(
			getExpected("hello/Hello.wsdl"),
			getActual(fsa, "hello/Hello.wsdl")
		)
		
		assertEquals(
			getExpected("hello/Hello-soap.wsdl"),
			getActual(fsa, "hello/Hello-soap.wsdl")
		)
	}

	@Test
	def void oneOperationParameterLess() {
		val fsa = generate("hello/HelloParameterLess.mridl")

		assertEquals(3, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/HelloParameterLess.xsd"),
			getActual(fsa, "hello/HelloParameterLess.xsd")
		)

		assertEquals(
			getExpected("hello/HelloParameterLess.wsdl"),
			getActual(fsa, "hello/HelloParameterLess.wsdl")
		)
		
		assertEquals(
			getExpected("hello/HelloParameterLess-soap.wsdl"),
			getActual(fsa, "hello/HelloParameterLess-soap.wsdl")
		)
	}
	
	@Test
	def void moreThanOneOperation() {
		val fsa = generate("hello/HelloMoreThanOneOperation.mridl")

		assertEquals(3, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/HelloMoreThanOneOperation.xsd"),
			getActual(fsa, "hello/HelloMoreThanOneOperation.xsd")
		)

		assertEquals(
			getExpected("hello/HelloMoreThanOneOperation.wsdl"),
			getActual(fsa, "hello/HelloMoreThanOneOperation.wsdl")
		)
		
		assertEquals(
			getExpected("hello/HelloMoreThanOneOperation-soap.wsdl"),
			getActual(fsa, "hello/HelloMoreThanOneOperation-soap.wsdl")
		)
	}
	
	@Test
	def void voidOperation() {
		val fsa = generate("hello/VoidOperation.mridl")

		assertEquals(3, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/VoidOperation.xsd"),
			getActual(fsa, "hello/VoidOperation.xsd")
		)

		assertEquals(
			getExpected("hello/VoidOperation.wsdl"),
			getActual(fsa, "hello/VoidOperation.wsdl")
		)
		
		assertEquals(
			getExpected("hello/VoidOperation-soap.wsdl"),
			getActual(fsa, "hello/VoidOperation-soap.wsdl")
		)
	}
	
	@Test
	def void inAndOutInterfaceOperation() {
		val fsa = generate("hello/InAndOutInterfaceOperation.mridl")

		assertEquals(3, fsa.allFiles.size)

		assertEquals(
			getExpected("hello/InAndOutInterfaceOperation.xsd"),
			getActual(fsa, "hello/InAndOutInterfaceOperation.xsd")
		)

		assertEquals(
			getExpected("hello/InAndOutInterfaceOperation.wsdl"),
			getActual(fsa, "hello/InAndOutInterfaceOperation.wsdl")
		)
		
		assertEquals(
			getExpected("hello/InAndOutInterfaceOperation-soap.wsdl"),
			getActual(fsa, "hello/InAndOutInterfaceOperation-soap.wsdl")
		)
	}

}
