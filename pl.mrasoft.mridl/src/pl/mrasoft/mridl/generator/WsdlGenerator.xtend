package pl.mrasoft.mridl.generator

import javax.inject.Inject
import pl.mrasoft.mridl.mridl.Documentation
import pl.mrasoft.mridl.mridl.Fault
import pl.mrasoft.mridl.mridl.Import
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.util.ResourceUtil
import pl.mrasoft.mridl.mridl.FaultElement
import pl.mrasoft.mridl.mridl.FaultElementReference
import org.eclipse.emf.common.util.EList
import pl.mrasoft.mridl.mridl.ImportedFaultElementReference
import java.util.HashSet
import java.util.ArrayList

class WsdlGenerator {

	@Inject extension ResourceUtil
	@Inject extension GeneratorCommon

	def wsdlFile(Mridl it, String modelName) '''
		<?xml version="1.0" encoding="utf-8"?>
		<wsdl:definitions name="«modelName»"
		                  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
		                  xmlns:tns="«nsUri»"
		                  «FOR imp : imports»
		                  	«IF imp.importUsedInWsdl(it)»
		                  		«imp.importNS»
		                  	«ENDIF»
		                  «ENDFOR»
		                  targetNamespace="«nsUri»">
		    «wsdlFileDocumentation»
		    <wsdl:types>
		        <schema xmlns="http://www.w3.org/2001/XMLSchema">
		            <import namespace="«nsUri»" schemaLocation="«modelName».xsd"/>
		        </schema>
		        «FOR imp : imports»
		        	«IF imp.importUsedInWsdl(it)»«imp.importSchemaInWsdl»«ENDIF»
		        «ENDFOR»
		    </wsdl:types>
			«FOR operation : operations»				
				«operation.operationMessages»
			«ENDFOR»
			«FOR faultElementReference : getUniqueFaultElementReferences(operations)»				
				«faultElementReference.faultMessage»
			«ENDFOR»		
			<wsdl:portType name="«modelName»">
				«FOR operation : operations»
					«operation.operationInPortType»
				«ENDFOR»
			</wsdl:portType>
		</wsdl:definitions>
	'''

	def importUsedInWsdl(Import it, Mridl model) {
		val thisImport = it

		val importedFaultElementReferences = model.eAllContents.filter(ImportedFaultElementReference)
		val thisFaultElementReference = importedFaultElementReferences.findFirst [
			importRef.^import == thisImport
		]

		thisFaultElementReference != null
	}

	def wsdlFileDocumentation(Mridl it) '''
		«IF wsdlFileHasDocumentation»
			«documentation.documentation»
		«ENDIF»
	'''

	def wsdlFileHasDocumentation(Mridl it) {
		documentation != null && documentation.doc != null
	}

	def operationMessages(Operation it) '''		
		<wsdl:message name="«name»">
			<wsdl:part element="tns:«name»" name="parameters"/>
		</wsdl:message>
		«IF !^void»
			<wsdl:message name="«name»Response">
				<wsdl:part element="tns:«name»Response" name="parameters"/>
			</wsdl:message>
		«ENDIF»		
	'''

	def getUniqueFaultElementReferences(EList<Operation> operations) {
		val faultElements = new HashSet<FaultElement>
		val faultElementReferences = new ArrayList<FaultElementReference>
		for (it : operations) {
			for (it : faults) {
				if (!faultElements.contains(element.ref)) {
					faultElements.add(element.ref)
					faultElementReferences.add(element)
				}
			}
		}
		faultElementReferences
	}

	def faultMessage(FaultElementReference it) '''		
		<wsdl:message name="«elementName»Exception">
			<wsdl:part name="«elementName»Exception" element="«elementRef»"/>
		</wsdl:message>
	'''

	def operationInPortType(Operation it) '''
		<wsdl:operation name="«name»">
			«operationDocumentation»
			<wsdl:input message="tns:«name»" name="«name»"/>
			«IF !^void»
				<wsdl:output message="tns:«name»Response" name="«name»Response"/>
			«ENDIF»
			«FOR fault : faults»
				«fault.operationFault»
			«ENDFOR»
		</wsdl:operation>
	'''

	def operationFault(Fault it) '''
		«IF faultHasDocumentation»
			<wsdl:fault name="«element.ref.name»Exception" message="tns:«element.ref.name»Exception">
				«faultDocumentation»
			</wsdl:fault>
		«ELSE»
			<wsdl:fault name="«element.ref.name»Exception" message="tns:«element.ref.name»Exception"/>
		«ENDIF»
	'''

	def operationDocumentation(Operation it) '''
		«IF operationHasDocumentation»
			«documentation.documentation»
		«ENDIF»
	'''

	def operationHasDocumentation(Operation it) {
		documentation != null && documentation.doc != null
	}

	def faultDocumentation(Fault it) '''
		«IF faultHasDocumentation»
			«documentation.documentation»
		«ENDIF»
	'''

	def faultHasDocumentation(Fault it) {
		documentation != null && documentation.doc != null
	}

	def documentation(Documentation it) '''		
		<wsdl:documentation>
			«doc»
		</wsdl:documentation>
	'''

	def importSchemaInWsdl(Import it) '''
		<schema xmlns="http://www.w3.org/2001/XMLSchema">
			<import namespace="«resolveImport.nsUri»" schemaLocation="«trimMridlExtension(importURI)».xsd"/>
		</schema>
	'''
}
