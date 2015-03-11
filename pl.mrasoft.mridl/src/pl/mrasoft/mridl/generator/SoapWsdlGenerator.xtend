package pl.mrasoft.mridl.generator

import java.util.List
import pl.mrasoft.mridl.mridl.Fault
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.Operation

class SoapWsdlGenerator {

	def soapWsdlFile(Mridl it, String modelName) '''
		<?xml version="1.0" encoding="utf-8"?>
		<wsdl:definitions name="«modelName»"
		                  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
		                  xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
		                  xmlns:tns="«nsUri»"
		                  targetNamespace="«nsUri»">
			<wsdl:import namespace="«nsUri»" location="«modelName».wsdl"/>
			«binding(modelName, operations)»
			«FOR inter : interfaces»
				«binding(inter.name, inter.operations)»
			«ENDFOR»
			«service(modelName)»
			«FOR inter : interfaces»
				«service(inter.name)»
			«ENDFOR»
		</wsdl:definitions>
	'''

	def binding(String name, List<Operation> operations) '''		
		<wsdl:binding name="«name»SOAPBinding" type="tns:«name»">
			<soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
			«FOR operation : operations»
				«operation.operationBinding»
			«ENDFOR»
		</wsdl:binding>
	'''

	def service(String name) '''		
		<wsdl:service name="«name»Service">
			<wsdl:port name="«name»" binding="tns:«name»SOAPBinding">
				<soap:address location="http://localhost/«name»"/>
			</wsdl:port>
		</wsdl:service>
	'''

	def operationBinding(Operation it) '''
		<wsdl:operation name="«name»">
			<soap:operation style="document"/>
			<wsdl:input name="«name»">
				<soap:body use="literal"/>
			</wsdl:input>
			«IF !^void»
				<wsdl:output name="«name»Response">
					<soap:body use="literal"/>
				</wsdl:output>
			«ENDIF»
			«FOR fault : faults»
				«fault.operationFault»
			«ENDFOR»
		</wsdl:operation>
	'''

	def operationFault(Fault it) '''
		<wsdl:fault name="«element.ref.name»Exception">
			<soap:fault name="«element.ref.name»Exception" use="literal"/>
		</wsdl:fault>
	'''
}
