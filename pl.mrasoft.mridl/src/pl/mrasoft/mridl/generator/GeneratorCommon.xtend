package pl.mrasoft.mridl.generator

import javax.inject.Inject
import pl.mrasoft.mridl.mridl.DirectTopLevelElementReference
import pl.mrasoft.mridl.mridl.DirectTopLevelTypeReferenceBase
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.ImportedTopLevelElementReference
import pl.mrasoft.mridl.mridl.ImportedTopLevelTypeReferenceBase
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.TopLevelComplexTypeReference
import pl.mrasoft.mridl.mridl.TopLevelElementReference
import pl.mrasoft.mridl.mridl.TopLevelSimpleTypeReference
import pl.mrasoft.mridl.mridl.TopLevelType
import pl.mrasoft.mridl.mridl.TopLevelTypeReference
import pl.mrasoft.mridl.mridl.XsdBuiltinType
import pl.mrasoft.mridl.mridl.XsdBuiltinTypeReference
import pl.mrasoft.mridl.util.ResourceUtil

class GeneratorCommon {

	@Inject extension ResourceUtil

	def mridlHasWsdlFile(Mridl it) {
		!operations.empty
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

	def elementName(TopLevelElementReference it) '''«ref.name»'''

	def dispatch elementRef(DirectTopLevelElementReference it) '''tns:«elementName»'''

	def dispatch elementRef(ImportedTopLevelElementReference it) '''«importRef.^import.nsPrefix»:«elementName»'''

	enum GeneratedFileType {
		WSDL,
		XSD
	}

}
