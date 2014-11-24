package pl.mrasoft.mridl.conversion;

import javax.inject.Inject;

import org.eclipse.xtext.common.services.DefaultTerminalConverters;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;

public class MridlValueConverters extends DefaultTerminalConverters {

	@Inject
	private ImportMridlUriConverter uriImportMridlUriConverter;

	@ValueConverter(rule = "ImportMridlUri")
	public IValueConverter<String> getImportMridlUriConverter() {
		return uriImportMridlUriConverter;

	}
}
