package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlSimpleTypeTest extends BaseMridlTest {

	new() {
		super("MridlSimpleTypeTest");
	}

	@Test
	def void simpleType() {
		val fsa = generate("d1/SimpleType.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/SimpleType.xsd"),
			getActual(fsa, "d1/SimpleType.xsd")
		)

	}
	
	@Test
	def void simpleTypeWithRestrictionImportedType() {
		val fsa = generate("d1/SimpleTypeWithRestrictionImportedType.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/SimpleTypeWithRestrictionImportedType.xsd"),
			getActual(fsa, "d1/SimpleTypeWithRestrictionImportedType.xsd")
		)

	}
	
	@Test
	def void simpleTypeNoPattern() {
		val fsa = generate("d1/SimpleTypeNoPattern.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/SimpleTypeNoPattern.xsd"),
			getActual(fsa, "d1/SimpleTypeNoPattern.xsd")
		)

	}
}
