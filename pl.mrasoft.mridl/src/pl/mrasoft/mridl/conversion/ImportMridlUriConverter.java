package pl.mrasoft.mridl.conversion;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

public class ImportMridlUriConverter implements IValueConverter<String> {

	@Override
	public String toValue(String string, INode node)
			throws ValueConverterException {
		if (string != null && string.startsWith("\"") && string.endsWith("\"")) {
			string = string.substring(1, string.length() - 1);
		}
		return string;
	}

	@Override
	public String toString(String value) throws ValueConverterException {
		return value;
	}

}
