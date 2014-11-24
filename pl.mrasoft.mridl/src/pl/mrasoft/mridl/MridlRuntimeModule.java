package pl.mrasoft.mridl;

import pl.mrasoft.mridl.conversion.MridlValueConverters;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class MridlRuntimeModule extends pl.mrasoft.mridl.AbstractMridlRuntimeModule {
	
	@Override
	public Class<? extends org.eclipse.xtext.conversion.IValueConverterService> bindIValueConverterService() {
		return MridlValueConverters.class;
	}
}
