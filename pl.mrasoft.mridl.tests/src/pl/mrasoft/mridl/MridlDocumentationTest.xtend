package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlDocumentationTest extends BaseMridlTest {

	new() {
		super("MridlDocumentationTest");
	}

	@Test
	def void elementDocumentation() {
		val fsa = generate("d1/ElementDocumentation.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/ElementDocumentation.xsd"),
			getActual(fsa, "d1/ElementDocumentation.xsd")
		)

	}

	@Test
	def void enumValueDocumentation() {
		val fsa = generate("d1/EnumValueDocumentation.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/EnumValueDocumentation.xsd"),
			getActual(fsa, "d1/EnumValueDocumentation.xsd")
		)

	}

	@Test
	def void multilineDocumentation() {
		val fsa = generate("d1/MultilineDocumentation.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/MultilineDocumentation.xsd"),
			getActual(fsa, "d1/MultilineDocumentation.xsd")
		)

	}

	@Test
	def void operationDocumentation() {
		val fsa = generate("d1/OperationDocumentation.mridl")

		assertEquals(3, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/OperationDocumentation.xsd"),
			getActual(fsa, "d1/OperationDocumentation.xsd")
		)

		assertEquals(
			getExpected("d1/OperationDocumentation.wsdl"),
			getActual(fsa, "d1/OperationDocumentation.wsdl")
		)

		assertEquals(
			getExpected("d1/OperationDocumentation-soap.wsdl"),
			getActual(fsa, "d1/OperationDocumentation-soap.wsdl")
		)

	}

	@Test
	def void faultDocumentation() {
		val fsa = generate("d1/FaultDocumentation.mridl")

		assertEquals(3, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/FaultDocumentation.xsd"),
			getActual(fsa, "d1/FaultDocumentation.xsd")
		)

		assertEquals(
			getExpected("d1/FaultDocumentation.wsdl"),
			getActual(fsa, "d1/FaultDocumentation.wsdl")
		)

		assertEquals(
			getExpected("d1/FaultDocumentation-soap.wsdl"),
			getActual(fsa, "d1/FaultDocumentation-soap.wsdl")
		)

	}

	@Test
	def void wsdlFileDocumentation() {
		val fsa = generate("d1/WsdlFileDocumentation.mridl")

		assertEquals(3, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/WsdlFileDocumentation.xsd"),
			getActual(fsa, "d1/WsdlFileDocumentation.xsd")
		)

		assertEquals(
			getExpected("d1/WsdlFileDocumentation.wsdl"),
			getActual(fsa, "d1/WsdlFileDocumentation.wsdl")
		)

		assertEquals(
			getExpected("d1/WsdlFileDocumentation-soap.wsdl"),
			getActual(fsa, "d1/WsdlFileDocumentation-soap.wsdl")
		)

	}

	@Test
	def void xsdFileDocumentation() {
		val fsa = generate("d1/XsdFileDocumentation.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/XsdFileDocumentation.xsd"),
			getActual(fsa, "d1/XsdFileDocumentation.xsd")
		)

	}

	@Test
	def void topLevelElementDocumentation() {
		val fsa = generate("d1/TopLevelElementDocumentation.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/TopLevelElementDocumentation.xsd"),
			getActual(fsa, "d1/TopLevelElementDocumentation.xsd")
		)

	}

}
