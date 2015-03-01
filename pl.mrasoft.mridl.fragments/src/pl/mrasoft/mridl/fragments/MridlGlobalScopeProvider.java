package pl.mrasoft.mridl.fragments;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.scoping.impl.AbstractGlobalScopeProvider;

import com.google.common.base.Predicate;

public class MridlGlobalScopeProvider extends AbstractGlobalScopeProvider {

	@Override
	protected IScope getScope(Resource resource, boolean ignoreCase, EClass type, Predicate<IEObjectDescription> filter) {
		return IScope.NULLSCOPE;
	}

}
