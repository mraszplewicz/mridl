package pl.mrasoft.mridl.util

import pl.mrasoft.mridl.mridl.Import

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import pl.mrasoft.mridl.mridl.Mridl

class ResourceUtil {
	def resolveImport(Import importElt) {
		resolveImport(importElt.eResource, importElt.importURI)
	}

	def resolveImport(Resource resource, String uri) {
		val importResource = EcoreUtil2::getResource(resource, removeImportQuotation(uri))
		importResource.contents.head as Mridl
	}

	def trimMridlExtension(String uri) {
		uri.substring(0, uri.length - 6)
	}

	def removeImportQuotation(String importURI) {
		if (importURI.startsWith("\"") && importURI.endsWith("\"")) {
			importURI.substring(1, importURI.length() - 1)
		} else {
			importURI
		}
	}
}
