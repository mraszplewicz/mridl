package pl.mrasoft.mridl.conversion;

import javax.inject.Inject;

import org.eclipse.xtext.common.services.DefaultTerminalConverters;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;

public class MridlValueConverters extends DefaultTerminalConverters {

	@Inject
	private DOCUMENTATION_TERMINALConverter DOCUMENTATION_TERMINALConverter;

	@ValueConverter(rule = "DOCUMENTATION_TERMINAL")
	public IValueConverter<String> getImportMridlUriConverter() {
		return DOCUMENTATION_TERMINALConverter;

	}

}
