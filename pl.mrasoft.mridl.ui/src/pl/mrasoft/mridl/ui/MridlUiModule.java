package pl.mrasoft.mridl.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;

import pl.mrasoft.mridl.ui.highlighting.MridlHighlightingConfiguration;
import pl.mrasoft.mridl.ui.highlighting.MridlTokenScanner;

/**
 * Use this class to register components to be used within the IDE.
 */
public class MridlUiModule extends pl.mrasoft.mridl.ui.AbstractMridlUiModule {
	public MridlUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}

	public Class<? extends IHighlightingConfiguration> bindIHighlightingConfiguration() {
		return MridlHighlightingConfiguration.class;
	}
	
	public Class<? extends AbstractAntlrTokenToAttributeIdMapper> bindAbstractAntlrTokenToAttributeIdMapper() {
		return MridlTokenScanner.class;
	}
}
