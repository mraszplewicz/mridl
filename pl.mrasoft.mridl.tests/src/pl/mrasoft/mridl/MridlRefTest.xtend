package pl.mrasoft.mridl

import org.junit.Test
import pl.mrasoft.mridl.util.BaseMridlTest

import static org.junit.Assert.*

class MridlRefTest extends BaseMridlTest {

	new() {
		super("MridlRefTest");
	}

	@Test
	def void refUnspecifiedMultiplicity() {
		val fsa = generate("d1/RefUnspecifiedMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/RefUnspecifiedMultiplicity.xsd"),
			getActual(fsa, "d1/RefUnspecifiedMultiplicity.xsd")
		)
	}

	@Test
	def void refUnboundedSpecifiedMultiplicity() {
		val fsa = generate("d1/RefUnboundedSpecifiedMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/RefUnboundedSpecifiedMultiplicity.xsd"),
			getActual(fsa, "d1/RefUnboundedSpecifiedMultiplicity.xsd")
		)
	}

	@Test
	def void refNoMultiplicity() {
		val fsa = generate("d1/RefNoMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/RefNoMultiplicity.xsd"),
			getActual(fsa, "d1/RefNoMultiplicity.xsd")
		)
	}

	@Test
	def void refMultiplicityMaxNotMoreThanOne() {
		val fsa = generate("d1/RefMultiplicityMaxNotMoreThanOne.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/RefMultiplicityMaxNotMoreThanOne.xsd"),
			getActual(fsa, "d1/RefMultiplicityMaxNotMoreThanOne.xsd")
		)
	}
	
	@Test
	def void refOptionalMultiplicity() {
		val fsa = generate("d1/RefOptionalMultiplicity.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/RefOptionalMultiplicity.xsd"),
			getActual(fsa, "d1/RefOptionalMultiplicity.xsd")
		)
	}
	
	@Test
	def void refImportedType() {
		val fsa = generate("d1/RefImportedType.mridl")

		assertEquals(1, fsa.allFiles.size)

		assertEquals(
			getExpected("d1/RefImportedType.xsd"),
			getActual(fsa, "d1/RefImportedType.xsd")
		)
	}

}
