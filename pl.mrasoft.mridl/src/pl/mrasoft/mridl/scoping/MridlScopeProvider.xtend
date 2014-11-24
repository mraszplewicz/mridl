package pl.mrasoft.mridl.scoping

import org.eclipse.xtext.scoping.Scopes
import pl.mrasoft.mridl.mridl.Mridl
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.IScope
import pl.mrasoft.mridl.mridl.ImportedTypeReference
import pl.mrasoft.mridl.mridl.Type
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.util.ResourceUtil
import javax.inject.Inject

class MridlScopeProvider extends org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider {

	@Inject extension ResourceUtil

	def scope_Import(Mridl mridl, EReference eRef) {

		Scopes::scopeFor(mridl.imports, [QualifiedName::create(it.nsPrefix)], IScope::NULLSCOPE)

	}

	def scope_TypeReference_ref(ImportedTypeReference ref, EReference eRef) {

		createTopLevelTypeScope(ref, typeof(Type))

	}

	/**
	 * Returns a scope for a the {@code ref} cross-reference in a
	 * TopLevel<i>x</i>Reference object.
	 * 
	 * @param clazz
	 *            - the {@link Class} object corresponding to <i>x</i>; must
	 *            extend {@link TopLevelType}.
	 */
	def private createTopLevelTypeScope(ImportedTypeReference importRef, Class<? extends Type> clazz) {
		val schema = schema(importRef, importRef.^import.nsPrefix)
		Scopes::scopeFor(schema.types.filter(clazz))
	}

	def schema(EObject eObject, String prefix) {
		val thisMridl = EcoreUtil::getRootContainer(eObject) as Mridl
		for (Import importElt : thisMridl.getImports()) {
			if (importElt.nsPrefix == prefix) {
				return resolveImport(importElt)
			}
		}

		throw new IllegalArgumentException(
			"no import with prefix '" + prefix + "' in this schema"
		)
	}



}
