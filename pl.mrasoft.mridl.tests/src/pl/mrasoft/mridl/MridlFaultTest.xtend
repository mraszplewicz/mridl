package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlFaultTest extends BaseMridlTest {

	new() {
		super("MridlFaultTest");
	}	
	
	@Test
	def void simpleFault() {
		val fsa = generate("d1/SimpleFault.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/SimpleFault.xsd"),
			getActual(fsa, "d1/SimpleFault.xsd")
		)
		
		assertEquals(
			getExpected("d1/SimpleFault.wsdl"),
			getActual(fsa, "d1/SimpleFault.wsdl")
		)

	}
	
	@Test
	def void importedFault() {
		val fsa = generate("d1/ImportedFault.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/ImportedFault.xsd"),
			getActual(fsa, "d1/ImportedFault.xsd")
		)
		
		assertEquals(
			getExpected("d1/ImportedFault.wsdl"),
			getActual(fsa, "d1/ImportedFault.wsdl")
		)

	}
	
	@Test
	def void importedFaultAndXsdImport() {
		val fsa = generate("d1/ImportedFaultAndXsdImport.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/ImportedFaultAndXsdImport.xsd"),
			getActual(fsa, "d1/ImportedFaultAndXsdImport.xsd")
		)
		
		assertEquals(
			getExpected("d1/ImportedFaultAndXsdImport.wsdl"),
			getActual(fsa, "d1/ImportedFaultAndXsdImport.wsdl")
		)

	}	
	
	@Test
	def void sameFaultInManyOperations() {
		val fsa = generate("d1/SameFaultInManyOperations.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/SameFaultInManyOperations.xsd"),
			getActual(fsa, "d1/SameFaultInManyOperations.xsd")
		)
		
		assertEquals(
			getExpected("d1/SameFaultInManyOperations.wsdl"),
			getActual(fsa, "d1/SameFaultInManyOperations.wsdl")
		)

	}
}
