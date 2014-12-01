package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlRestrictionsTest extends BaseMridlTest {

	new() {
		super("MridlRestrictionsTest");
	}

	@Test
	def void decimalWithDigits() {
		val fsa = generate("d1/DecimalWithDigits.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/DecimalWithDigits.xsd"),
			getActual(fsa, "d1/DecimalWithDigits.xsd")
		)

	}
	
	@Test
	def void stringArrayWithLength() {
		val fsa = generate("d1/StringArrayWithLength.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/StringArrayWithLength.xsd"),
			getActual(fsa, "d1/StringArrayWithLength.xsd")
		)

	}
	
	@Test
	def void stringWithLength() {
		val fsa = generate("d1/StringWithLength.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/StringWithLength.xsd"),
			getActual(fsa, "d1/StringWithLength.xsd")
		)

	}

}
