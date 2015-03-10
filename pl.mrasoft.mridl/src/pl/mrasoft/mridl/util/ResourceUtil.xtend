package pl.mrasoft.mridl.util

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import pl.mrasoft.mridl.mridl.DirectTopLevelTypeReferenceBase
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReferenceBase
import pl.mrasoft.mridl.mridl.Mridl

class ResourceUtil {

	def dispatch resolveNamespace(DirectTopLevelTypeReferenceBase typeReference) {
		val model = typeReference.eResource.contents.head as Mridl
		model.nsUri
	}

	def dispatch resolveNamespace(ImportedTopLevelTypeReferenceBase typeReference) {
		resolveImportNamespace(typeReference.importRef.import)
	}

	def resolveImportNamespace(Import importElt) {
		val model = resolveImport(importElt)
		model.nsUri
	}

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
