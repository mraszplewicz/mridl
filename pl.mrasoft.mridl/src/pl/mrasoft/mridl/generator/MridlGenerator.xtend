package pl.mrasoft.mridl.generator

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IFileSystemAccessExtension2
import org.eclipse.xtext.generator.IGenerator
import pl.mrasoft.mridl.mridl.Mridl
import pl.mrasoft.mridl.util.ResourceUtil

class MridlGenerator implements IGenerator {

	@Inject WsdlGenerator wsdlGenerator
	@Inject SoapWsdlGenerator soapWsdlGenerator
	@Inject XsdGenerator xsdGenerator
	@Inject GeneratorCommon common
	@Inject extension ResourceUtil

	final static val CLASSPATH_PREFIX = "classpath:/"

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val modelName = resource.modelName
		val model = resource.contents.head as Mridl

		val pathWithoutExtension = resource.containingFolder(fsa) + "/" + modelName

		if (common.mridlHasWsdlFile(model)) {
			fsa.generateFile(pathWithoutExtension + ".wsdl", wsdlGenerator.wsdlFile(model, modelName))
			fsa.generateFile(pathWithoutExtension + "-soap.wsdl", soapWsdlGenerator.soapWsdlFile(model, modelName))
		}
		fsa.generateFile(pathWithoutExtension + ".xsd", xsdGenerator.xsdFile(model, modelName))
	}
	
	

	def containingFolder(Resource it, IFileSystemAccess fsa) {
		val filePath = URI.trimSegments(1).toString

		if (filePath.startsWith(CLASSPATH_PREFIX)) {

			//for unit testing
			filePath.replaceFirst(CLASSPATH_PREFIX, "/")
		} else {

			//implementacja jest tak na prawde bledna, ale nie widze lepszego sposobu
			val srcGenURI = (fsa as IFileSystemAccessExtension2).getURI(".")
			val projectPath = srcGenURI.trimSegments(1).toString

			val pathWithSrc = filePath.replaceFirst(projectPath, "");
			pathWithSrc.substring(pathWithSrc.indexOf('/', 1) + 1)
		}
	}

}
