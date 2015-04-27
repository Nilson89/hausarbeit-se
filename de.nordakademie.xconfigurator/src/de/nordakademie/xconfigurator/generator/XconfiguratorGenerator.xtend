/*
 * generated by Xtext
 */
package de.nordakademie.xconfigurator.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class XconfiguratorGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
//		fsa.generateFile('greetings.txt', 'People to greet: ' + 
//			resource.allContents
//				.filter(typeof(Greeting))
//				.map[name]
//				.join(', '))
	}
	
	def toHtml(Step s) '''
		<xhtml>
			<head>
				<title>Konfigurator</title>
			</head>
			<body>
				<h3>Auswahl:</h3>
				
					<ul>
						<li>Option 1</li>
						<li>Option 2</li>
					</ul>
				<h3>weiter</h3>		
				<h3>zurueck</h3>
			</body>
		</xhtml>
	'''
}
