package pl.mrasoft.mridl.util

import pl.mrasoft.mridl.mridl.Mridl
import java.util.ArrayList

class MridlUtil {
	def allOperations(Mridl it) {
		val allOperations = new ArrayList(operations)
		interfaces.forall[allOperations.addAll(operations)]
		allOperations
	}
}
