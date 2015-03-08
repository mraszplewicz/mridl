package pl.mrasoft.mridl.ui.highlighting;

import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultAntlrTokenToAttributeIdMapper;

public class MridlTokenScanner extends DefaultAntlrTokenToAttributeIdMapper {
	
	@Override
	protected String calculateId(String tokenName, int tokenType) {		
		if("RULE_DOCUMENTATION_TERMINAL".equals(tokenName)) {
			return MridlHighlightingConfiguration.DOCUMENTATION_ID;
		}
		return super.calculateId(tokenName, tokenType);
	}

}
