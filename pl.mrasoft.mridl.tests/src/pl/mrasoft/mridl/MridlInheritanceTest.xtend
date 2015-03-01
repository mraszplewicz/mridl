package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlInheritanceTest extends BaseMridlTest {

	new() {
		super("MridlInheritanceTest");
	}

	@Test
	def void inheritance() {
		val fsa = generate("d1/Inheritance.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/Inheritance.xsd"),
			getActual(fsa, "d1/Inheritance.xsd")
		)

	}
	
	@Test
	def void inheritanceImportedType() {
		val fsa = generate("d1/InheritanceImportedType.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/InheritanceImportedType.xsd"),
			getActual(fsa, "d1/InheritanceImportedType.xsd")
		)

	}
	
	
}
