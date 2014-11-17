package pl.mrasoft.mridl.scoping;

import org.eclipse.xtext.generator.scoping.AbstractScopingFragment;
import org.eclipse.xtext.scoping.IGlobalScopeProvider;
import org.eclipse.xtext.scoping.IScopeProvider;
import org.eclipse.xtext.scoping.impl.SimpleLocalScopeProvider;

public class MridlScopingFragment extends AbstractScopingFragment {

	@Override
	protected Class<? extends IScopeProvider> getLocalScopeProvider() {
		return SimpleLocalScopeProvider.class;
	}

	@Override
	protected Class<? extends IGlobalScopeProvider> getGlobalScopeProvider() {
		return MridlGlobalScopeProvider.class;
	}

}
