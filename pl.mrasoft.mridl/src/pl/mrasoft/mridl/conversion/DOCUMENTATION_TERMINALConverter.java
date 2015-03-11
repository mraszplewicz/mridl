package pl.mrasoft.mridl.conversion;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

public class DOCUMENTATION_TERMINALConverter implements IValueConverter<String> {

	private static final String DOCUMENTATION_TERMINAL_LEFT = "(*";
	private static final String DOCUMENTATION_TERMINAL_RIGHT = "*)";

	@Override
	public String toValue(String string, INode node)
			throws ValueConverterException {

		return string.substring(DOCUMENTATION_TERMINAL_LEFT.length(),
				string.length() - DOCUMENTATION_TERMINAL_RIGHT.length());

	}

	@Override
	public String toString(String value) throws ValueConverterException {

		return DOCUMENTATION_TERMINAL_LEFT + value
				+ DOCUMENTATION_TERMINAL_RIGHT;

	}

}
