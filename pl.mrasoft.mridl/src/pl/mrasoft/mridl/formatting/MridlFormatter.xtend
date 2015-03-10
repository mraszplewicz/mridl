package pl.mrasoft.mridl.formatting

import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig
import javax.inject.Inject
import pl.mrasoft.mridl.services.MridlGrammarAccess

class MridlFormatter extends AbstractDeclarativeFormatter {

	@Inject extension MridlGrammarAccess

	override protected void configureFormatting(FormattingConfig c) {

		c.setAutoLinewrap(100)

		for (pair : findKeywordPairs("(", ")")) {
			c.setNoSpace().before(pair.first)
			c.setNoSpace().after(pair.first)
			c.setNoSpace().before(pair.second)
		}

		for (comma : findKeywords(",")) {
			c.setNoSpace().before(comma)
		}

		for (colon : findKeywords(":")) {
			c.setNoSpace().before(colon)
			c.setNoSpace().after(colon)
		}

		c.setLinewrap(1, 1, 3).around(importRule)
		c.setLinewrap(1, 1, 3).around(operationRule)
		c.setLinewrap(1, 1, 3).around(topLevelComplexTypeRule)
		c.setLinewrap(1, 1, 3).around(topLevelSimpleTypeRule)
		c.setLinewrap(1, 1, 3).around(topLevelEnumTypeRule)
		c.setLinewrap(1, 1, 3).around(topLevelElementRule)

		c.setLinewrap(0, 1, 1).around(documentationRule)

		c.setIndentationIncrement().after(topLevelComplexTypeAccess.leftCurlyBracketKeyword_4)
		c.setIndentationDecrement().before(topLevelComplexTypeAccess.rightCurlyBracketKeyword_6)
		c.setLinewrap().after(topLevelComplexTypeAccess.leftCurlyBracketKeyword_4)
		c.setLinewrap().after(topLevelComplexTypeAccess.rightCurlyBracketKeyword_6)
		c.setLinewrap(1, 1, 3).around(topLevelComplexTypeAccess.elementsAssignment_5)

		c.setIndentationIncrement().after(topLevelEnumTypeAccess.leftCurlyBracketKeyword_2)
		c.setIndentationDecrement().before(topLevelEnumTypeAccess.rightCurlyBracketKeyword_4)
		c.setLinewrap().after(topLevelEnumTypeAccess.leftCurlyBracketKeyword_2)
		c.setLinewrap().after(topLevelEnumTypeAccess.rightCurlyBracketKeyword_4)
		c.setLinewrap(1, 1, 3).around(topLevelEnumTypeAccess.valuesAssignment_3)

		c.setIndentationIncrement().after(simpleTypeBodyAccess.leftCurlyBracketKeyword_0)
		c.setLinewrap().after(simpleTypeBodyAccess.leftCurlyBracketKeyword_0)
		c.setIndentationDecrement().before(simpleTypeBodyAccess.rightCurlyBracketKeyword_4)
		c.setLinewrap().after(simpleTypeBodyAccess.rightCurlyBracketKeyword_4)
		c.setLinewrap(1, 1, 3).before(simpleTypeBodyAccess.baseKeyword_1)
		c.setLinewrap(1, 1, 3).after(simpleTypeBodyAccess.baseAssignment_2)
		c.setLinewrap(1, 1, 3).before(simpleTypeBodyAccess.patternRestrictionAssignment_3)
		c.setLinewrap(1, 1, 3).after(simpleTypeBodyAccess.patternRestrictionAssignment_3)

		c.setIndentationIncrement().after(operationAccess.operationKeyword_1)
		c.setIndentationDecrement().after(operationRule)

		c.setLinewrap(0, 1, 1).before(operationAccess.throwsKeyword_7_0)

		c.setNoSpace().before(multiplicityRule)
		c.setNoSpace().after(specifiedMultiplicityAccess.leftSquareBracketKeyword_1)
		c.setNoSpace().before(specifiedMultiplicityAccess.rightSquareBracketKeyword_4)
		c.setNoSpace().after(specifiedMultiplicityAccess.lowerAssignment_2_0)
		c.setNoSpace().before(specifiedMultiplicityAccess.upperAssignment_3_0)
		c.setNoSpace().before(specifiedMultiplicityAccess.unboundedAsteriskKeyword_3_1_0)

		c.setLinewrap(0, 1, 2).before(SL_COMMENTRule)
		c.setLinewrap(0, 1, 2).before(ML_COMMENTRule)
		c.setLinewrap(0, 1, 1).after(ML_COMMENTRule)
	}
}
