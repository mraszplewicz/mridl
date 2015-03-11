package pl.mrasoft.mridl.generator

import javax.inject.Inject
import pl.mrasoft.mridl.mridl.Fault
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.mridl.Operation
import pl.mrasoft.mridl.util.MridlUtil

class SoapWsdlGenerator {

	@Inject extension MridlUtil

	def soapWsdlFile(Mridl it, String modelName) '''
		<?xml version="1.0" encoding="utf-8"?>
		<wsdl:definitions name="«modelName»"
		                  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
		                  xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
		                  xmlns:tns="«nsUri»"
		                  targetNamespace="«nsUri»">
		    <wsdl:import namespace="«nsUri»" location="«modelName».wsdl"/>
		    <wsdl:binding name="«modelName»SOAPBinding" type="tns:«modelName»">
		    	<soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
				«FOR operation : allOperations»				
					«operation.operationBindings»
				«ENDFOR»
			</wsdl:binding>
			<wsdl:service name="«modelName»Service">
			     <wsdl:port name="«modelName»" binding="tns:«modelName»SOAPBinding">
			         <soap:address location="http://localhost/«modelName»"/>
			     </wsdl:port>
			 </wsdl:service>
		</wsdl:definitions>
	'''

	def operationBindings(Operation it) '''
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
