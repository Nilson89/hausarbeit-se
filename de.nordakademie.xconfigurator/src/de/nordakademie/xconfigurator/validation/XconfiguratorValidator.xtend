/*
 * generated by Xtext
 */
package de.nordakademie.xconfigurator.validation

import org.eclipse.xtext.validation.Check
import de.nordakademie.xconfigurator.xconfigurator.XconfiguratorPackage
import de.nordakademie.xconfigurator.xconfigurator.Step

//import org.eclipse.xtext.validation.Check

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class XconfiguratorValidator extends AbstractXconfiguratorValidator {

	@Check
	def checkNoCycleInStepHierarchy(Step step) {
		
	}
}
