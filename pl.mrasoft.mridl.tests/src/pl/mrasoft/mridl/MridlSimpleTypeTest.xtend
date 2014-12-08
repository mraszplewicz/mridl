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
	def void simpleTypeWithRestriction() {
		val fsa = generate("d1/SimpleTypeWithRestriction.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/SimpleTypeWithRestriction.xsd"),
			getActual(fsa, "d1/SimpleTypeWithRestriction.xsd")
		)

	}
	
}
