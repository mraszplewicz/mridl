package pl.mrasoft.mridl.util;

import org.eclipse.xtext.junit4.InjectWith;
import org.eclipselabs.xtext.utils.unittesting.XtextTest;
import org.junit.runner.RunWith;
import pl.mrasoft.mridl.MridlInjectorProvider
import org.eclipselabs.xtext.utils.unittesting.XtextRunner2
import org.junit.Before
import javax.inject.Inject
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.eclipse.xtext.generator.IFileSystemAccess

@InjectWith(MridlInjectorProvider)
@RunWith(XtextRunner2)
class BaseMridlTest extends XtextTest {

	@Inject
	IGenerator generator
	
	String resourceRootNoClasspathPrefix

	new(String resourceRoot) {
		super(resourceRoot)
		resourceRootNoClasspathPrefix = resourceRoot
	}
	
	@Before
	def void setUp() {
		ignoreFormattingDifferences();
	}
	
	def generate(String fileToTest, String... referencedResources) {
		val resource = testFile(fileToTest, referencedResources).resource;
		val fsa = new InMemoryFileSystemAccess()
		generator.doGenerate(resource, fsa)
		fsa
	}

	def getExpected(String filename) {
		loadFileContents(null, "expected/" + filename)
	}	
	
	def getActual(InMemoryFileSystemAccess fsa, String filename) {
		fsa.allFiles.get(IFileSystemAccess::DEFAULT_OUTPUT + "/" + resourceRootNoClasspathPrefix + "/" + filename).toString
	}

}
