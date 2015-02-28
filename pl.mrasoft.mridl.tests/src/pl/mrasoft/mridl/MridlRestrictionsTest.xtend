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
		val fsa = generate("d1/StringArrayWithMaxLength.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/StringArrayWithMaxLength.xsd"),
			getActual(fsa, "d1/StringArrayWithMaxLength.xsd")
		)

	}
	
	@Test
	def void stringWithLength() {
		val fsa = generate("d1/StringWithMaxLength.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/StringWithMaxLength.xsd"),
			getActual(fsa, "d1/StringWithMaxLength.xsd")
		)

	}
	
	@Test
	def void enumeration() {
		val fsa = generate("d1/Enum.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/Enum.xsd"),
			getActual(fsa, "d1/Enum.xsd")
		)

	}

}
