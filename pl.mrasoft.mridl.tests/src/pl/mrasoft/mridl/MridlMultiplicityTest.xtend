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

}
