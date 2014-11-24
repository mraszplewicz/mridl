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
		val importResource = EcoreUtil2::getResource(resource, uri)
		importResource.contents.head as Mridl
	}
	
	def trimMridlExtension(String uri) {
		uri.substring(0, uri.length - 6)
	}
}
