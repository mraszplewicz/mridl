package pl.mrasoft.mridl.scoping

import javax.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.TopLevelTypeReference
import pl.mrasoft.mridl.util.ResourceUtil
import pl.mrasoft.mridl.mridl.TopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.TopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.TopLevelSimpleType
import pl.mrasoft.mridl.mridl.TopLevelComplexType
import pl.mrasoft.mridl.mridl.TopLevelType
import pl.mrasoft.mridl.mridl.DirectTopLevelTypeReferenceBase
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReferenceBase
import pl.mrasoft.mridl.mridl.FaultElementReference
import pl.mrasoft.mridl.mridl.FaultElement
import pl.mrasoft.mridl.mridl.ImportedFaultElementReference
import pl.mrasoft.mridl.mridl.DirectFaultElementReference

class MridlScopeProvider extends AbstractDeclarativeScopeProvider {

	@Inject extension ResourceUtil

	def scope_Import(Mridl mridl, EReference eRef) {

		Scopes::scopeFor(mridl.imports, [QualifiedName::create(it.nsPrefix)], IScope::NULLSCOPE)

	}

	def scope_TopLevelTypeReference_ref(TopLevelTypeReference ref, EReference eRef) {
		createTopLevelTypeScope(ref, TopLevelType)
	}
	
	def scope_TopLevelSimpleTypeReference_ref(TopLevelSimpleTypeReference ref, EReference eRef) {
		createTopLevelTypeScope(ref, TopLevelSimpleType)
	}
	
	def scope_TopLevelComplexTypeReference_ref(TopLevelComplexTypeReference ref, EReference eRef) {
		createTopLevelTypeScope(ref, TopLevelComplexType)
	}
	
	def scope_FaultElementReference_ref(FaultElementReference ref, EReference eRef) {
		createFaultElementScope(ref, FaultElement)
	}
	
	def dispatch createTopLevelTypeScope(DirectTopLevelTypeReferenceBase ref, Class<? extends TopLevelType> clazz) {
		val model = getRootModel(ref)
		Scopes::scopeFor(model.typeDeclarations.filter(clazz)) 
	}
	
	def dispatch createTopLevelTypeScope(ImportedTopLevelTypeReferenceBase importedRef, Class<? extends TopLevelType> clazz) {
		val model = getImportedModel(importedRef, importedRef.importRef.^import.nsPrefix)
		Scopes::scopeFor(model.typeDeclarations.filter(clazz)) 
	}
	
	def dispatch createFaultElementScope(DirectFaultElementReference ref, Class<? extends FaultElement> clazz) {
		val model = getRootModel(ref)
		Scopes::scopeFor(model.faultElements.filter(clazz)) 
	}	

	def dispatch createFaultElementScope(ImportedFaultElementReference importedRef, Class<? extends FaultElement> clazz) {
		val model = getImportedModel(importedRef, importedRef.importRef.^import.nsPrefix)
		Scopes::scopeFor(model.faultElements.filter(clazz)) 
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
