package pl.mrasoft.mridl.generator

import javax.inject.Inject
import pl.mrasoft.mridl.mridl.DirectTopLevelTypeReferenceBase
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReference
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReferenceBase
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.TopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.TopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.TopLevelType
import pl.mrasoft.mridl.mridl.TopLevelTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinType
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeReference
import pl.mrasoft.mridl.util.ResourceUtil
import pl.mrasoft.mridl.mridl.FaultElementReference
import pl.mrasoft.mridl.mridl.DirectFaultElementReference
import pl.mrasoft.mridl.mridl.ImportedFaultElementReference

class GeneratorCommon {

	@Inject extension ResourceUtil

	def mridlHasWsdlFile(Mridl it) {
		!operations.empty
	}

	def importUsed(Import it, Mridl model, GeneratedFileType fileType) {
		importUsedInXsd(model, fileType) || importUsedInWsdl(model, fileType)
	}

	def importUsedInXsd(Import it, Mridl model, GeneratedFileType fileType) {
		val thisImport = it

		val importedTypeReferences = model.eAllContents.filter(ImportedTopLevelTypeReference)
		val thisTypeReference = importedTypeReferences.findFirst [
			importRef.^import == thisImport && fileType == GeneratedFileType.XSD
		]
		thisTypeReference != null
	}

	def importUsedInWsdl(Import it, Mridl model, GeneratedFileType fileType) {
		val thisImport = it

		val importedFaultElementReferences = model.eAllContents.filter(ImportedFaultElementReference)
		val thisFaultElementReference = importedFaultElementReferences.findFirst [
			importRef.^import == thisImport && fileType == GeneratedFileType.WSDL
		]

		thisFaultElementReference != null
	}

	def importNS(Import it) '''
		xmlns:«nsPrefix»="«resolveImport.nsUri»"
	'''

	def dispatch typeName(XsdBuiltinTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelSimpleTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeName(TopLevelComplexTypeReference it) '''«ref.referencedTypeName»'''

	def dispatch typeRef(XsdBuiltinTypeReference it) '''xs:«typeName»'''

	def dispatch typeRef(DirectTopLevelTypeReferenceBase it) '''tns:«typeName»'''

	def dispatch typeRef(ImportedTopLevelTypeReferenceBase it) '''«importRef.^import.nsPrefix»:«typeName»'''

	def dispatch referencedTypeName(XsdBuiltinType it) { declaration.getName }

	def dispatch referencedTypeName(TopLevelType it) { name }

	def elementName(FaultElementReference it) '''«ref.name»'''

	def dispatch elementRef(DirectFaultElementReference it) '''tns:«elementName»'''

	def dispatch elementRef(ImportedFaultElementReference it) '''«importRef.^import.nsPrefix»:«elementName»'''

	enum GeneratedFileType {
		WSDL,
		XSD
	}

}
