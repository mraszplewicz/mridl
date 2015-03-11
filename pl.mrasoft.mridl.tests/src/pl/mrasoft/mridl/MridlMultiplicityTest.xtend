package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlMultiplicityTest extends BaseMridlTest {

	new() {
		super("MridlMultiplicityTest");
	}

	@Test
	def void intSpecifiedMultiplicity() {
		val fsa = generate("d1/IntSpecifiedMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/IntSpecifiedMultiplicity.xsd"),
			getActual(fsa, "d1/IntSpecifiedMultiplicity.xsd")
		)
	}

	@Test
	def void unspecifiedMultiplicity() {
		val fsa = generate("d1/UnspecifiedMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/UnspecifiedMultiplicity.xsd"),
			getActual(fsa, "d1/UnspecifiedMultiplicity.xsd")
		)
	}

	@Test
	def void unboundedSpecifiedMultiplicity() {
		val fsa = generate("d1/UnboundedSpecifiedMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/UnboundedSpecifiedMultiplicity.xsd"),
			getActual(fsa, "d1/UnboundedSpecifiedMultiplicity.xsd")
		)
	}

	@Test
	def void optional() {
		val fsa = generate("d1/Optional.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/Optional.xsd"),
			getActual(fsa, "d1/Optional.xsd")
		)
	}

	@Test
	def void intMinOneSpecifiedMultiplicity() {
		val fsa = generate("d1/IntMinOneSpecifiedMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/IntMinOneSpecifiedMultiplicity.xsd"),
			getActual(fsa, "d1/IntMinOneSpecifiedMultiplicity.xsd")
		)
	}

	@Test
	def void intMaxOneSpecifiedMultiplicity() {
		val fsa = generate("d1/IntMaxOneSpecifiedMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/IntMaxOneSpecifiedMultiplicity.xsd"),
			getActual(fsa, "d1/IntMaxOneSpecifiedMultiplicity.xsd")
		)
	}

	@Test
	def void intMinOneMaxOneSpecifiedMultiplicity() {
		val fsa = generate("d1/IntMinOneMaxOneSpecifiedMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/IntMinOneMaxOneSpecifiedMultiplicity.xsd"),
			getActual(fsa, "d1/IntMinOneMaxOneSpecifiedMultiplicity.xsd")
		)
	}

}
