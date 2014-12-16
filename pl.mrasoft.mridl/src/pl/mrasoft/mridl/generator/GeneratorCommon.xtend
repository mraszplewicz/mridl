package pl.mrasoft.mridl.generator

import javax.inject.Inject
import pl.mrasoft.mridl.mridl.DirectTopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.DirectTopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.DirectTopLevelTypeReference
import pl.mrasoft.mridl.mridl.Fault
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.ImportedTopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.ImportedTopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReference
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.TopLevelComplexType
import pl.mrasoft.mridl.mridl.TopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.TopLevelEnumType
import pl.mrasoft.mridl.mridl.TopLevelSimpleType
import pl.mrasoft.mridl.mridl.TopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.TopLevelTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithDigits
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeWithMaxLength
import pl.mrasoft.mridl.util.ResourceUtil

class GeneratorCommon {
	
	@Inject extension ResourceUtil

	def mridlHasWsdlFile(Mridl it) {
		!operations.empty
	}

	def importUsed(Import it, Mridl model, GeneratedFileType fileType) {
		val importedTypeReferences = model.eAllContents.filter(ImportedTopLevelTypeReference);
		val thisImport = it
		val thisTypeReference = importedTypeReferences.findFirst [
			importRef.^import == thisImport && ((fileType == GeneratedFileType.WSDL && isReferenceFromWsdl) ||
				(fileType == GeneratedFileType.XSD && !isReferenceFromWsdl))
		]
		thisTypeReference != null
	}

	def isReferenceFromWsdl(ImportedTopLevelTypeReference it) {
		eContainer instanceof Fault
	}
	
	def importNS(Import it) '''
		xmlns:«nsPrefix»="«resolveImport.nsUri»"
	'''
	
	def dispatch typeName(XsdBuiltinTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelSimpleTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelComplexTypeReference it) '''«ref.referencedTypeName»'''
	
	def dispatch typeRef(XsdBuiltinTypeReference it) '''xs:«typeName»'''

	def dispatch typeRef(DirectTopLevelTypeReference it) '''tns:«typeName»'''

	def dispatch typeRef(ImportedTopLevelTypeReference it) '''«importRef.^import.nsPrefix»:«typeName»'''

	def dispatch typeRef(DirectTopLevelSimpleTypeReference it) '''tns:«typeName»'''

	def dispatch typeRef(ImportedTopLevelSimpleTypeReference it) '''«importRef.^import.nsPrefix»:«typeName»'''

	def dispatch typeRef(DirectTopLevelComplexTypeReference it) '''tns:«typeName»'''

	def dispatch typeRef(ImportedTopLevelComplexTypeReference it) '''«importRef.^import.nsPrefix»:«typeName»'''	

	def dispatch referencedTypeName(XsdBuiltinTypeWithDigits it) { declaration.getName }

	def dispatch referencedTypeName(XsdBuiltinTypeWithMaxLength it) { declaration.getName }

	def dispatch referencedTypeName(TopLevelSimpleType it) { name }

	def dispatch referencedTypeName(TopLevelComplexType it) { name }

	def dispatch referencedTypeName(TopLevelEnumType it) { name }

	enum GeneratedFileType {
		WSDL,
		XSD
	}

}
