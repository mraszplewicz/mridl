package pl.mrasoft.mridl.scoping

import javax.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import pl.mrasoft.mridl.mridl.DirectTopLevelTypeReference
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReference
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.TopLevelTypeReference
import pl.mrasoft.mridl.util.ResourceUtil

class MridlScopeProvider extends AbstractDeclarativeScopeProvider {

	@Inject extension ResourceUtil

	def scope_Import(Mridl mridl, EReference eRef) {

		Scopes::scopeFor(mridl.imports, [QualifiedName::create(it.nsPrefix)], IScope::NULLSCOPE)

	}

	def scope_TopLevelTypeReference_ref(TopLevelTypeReference ref, EReference eRef) {
		createTopLevelTypeScope(ref)
	}
	
	def dispatch createTopLevelTypeScope(DirectTopLevelTypeReference ref) {
		val model = getRootModel(ref)
		Scopes::scopeFor(model.typeDeclarations) 
	}
	

	def dispatch createTopLevelTypeScope(ImportedTopLevelTypeReference importedRef) {
		val model = getImportedModel(importedRef, importedRef.importRef.^import.nsPrefix)
		Scopes::scopeFor(model.typeDeclarations) 
	}

	def getImportedModel(EObject eObject, String prefix) {
		val thisMridl = getRootModel(eObject)
		for (Import importElt : thisMridl.getImports()) {
			if (importElt.nsPrefix == prefix) {
				return resolveImport(importElt)
			}
		}

		throw new IllegalArgumentException(
			"no import with prefix '" + prefix + "' in this schema"
		)
	}

	def getRootModel(EObject eObject) {
		EcoreUtil::getRootContainer(eObject) as Mridl
	}


}
