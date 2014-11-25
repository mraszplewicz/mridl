package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlImportTest extends BaseMridlTest {

	new() {
		super("MridlImportTest");
	}

	@Test
	def void importNoQuotes() {
		val fsa = generate("d1/ImportNoQuotes.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/ImportNoQuotes.xsd"),
			getActual(fsa, "d1/ImportNoQuotes.xsd")
		)
	}
	
	@Test
	def void importDifferentDir() {
		val fsa = generate("d1/ImportDifferentDir.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/ImportDifferentDir.xsd"),
			getActual(fsa, "d1/ImportDifferentDir.xsd")
		)

	}

	@Test
	def void importWithQuotes() {
		val fsa = generate("d1/ImportWithQuotes.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/ImportWithQuotes.xsd"),
			getActual(fsa, "d1/ImportWithQuotes.xsd")
		)

	}
	
	@Test
	def void importInOperation() {
		val fsa = generate("d1/ImportInOperation.mridl")

		assertEquals(2, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/ImportInOperation.xsd"),
			getActual(fsa, "d1/ImportInOperation.xsd")
		)
		
		assertEquals(
			getExpected("d1/ImportInOperation.wsdl"),
			getActual(fsa, "d1/ImportInOperation.wsdl")
		)

	}	
	
	@Test
	def void unusedImport() {
		val fsa = generate("d1/UnusedImport.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/UnusedImport.xsd"),
			getActual(fsa, "d1/UnusedImport.xsd")
		)		

	}

}
