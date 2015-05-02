/*
 * generated by Xtext
 */
package de.nordakademie.xconfigurator.validation

import de.nordakademie.xconfigurator.xconfigurator.Step
import de.nordakademie.xconfigurator.xconfigurator.XconfiguratorPackage
import org.eclipse.xtext.validation.Check
import de.nordakademie.xconfigurator.xconfigurator.Predecessor
import de.nordakademie.xconfigurator.xconfigurator.Successor
import de.nordakademie.xconfigurator.xconfigurator.Xconfigurator

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class XconfiguratorValidator extends AbstractXconfiguratorValidator {

	@Check
	def checkMaxOneSuccessor(Step step) {
		if (step.successor.size > 1) {
			warning('A Step contains at most one successor!', XconfiguratorPackage.Literals.STEP__SUCCESSOR)
		}
	}

	@Check
	def checkMaxOnePredecessor(Step step) {
		if (step.predecessor.size > 1) {
			warning('A Step contains at most one predecessor!', XconfiguratorPackage.Literals.STEP__PREDECESSOR)
		}
	}

	@Check
	def checkStepForPredecessorSuccessorExists(Xconfigurator xconf){
		
	}
	
	@Check
	def checkSuccessorUniqueInCollecion(Xconfigurator xconf){
		
	}
	
	@Check
	def checkPredecessorUniqueInCollecion(Xconfigurator xconf){
		
	}

	@Check
	def checkNoCycleInStepSuccessor(Step step) {
		if (!step.successor.empty) {
			for (Successor succ : step.successor) {
				if (succ.step.identityEquals(step)) {
					error(
						'Cycle in relation Step <-> Successor',
						XconfiguratorPackage.Literals.STEP__SUCCESSOR
					)
				}
			}
		}
	}

	@Check
	def checkNoCycleInStepPredecessor(Step step) {
		if (!step.predecessor.empty) {
			for (Predecessor pred : step.predecessor) {
				if (pred.step.identityEquals(step)) {

					//<->eContainer!?
					error(
						'Cycle in relation Step <-> Predecessor',
						XconfiguratorPackage.Literals.STEP__PREDECESSOR
					)
				}
			}
		}
	}

	@Check
	def checkComponentUniqueIdentifierInStep(Step step) {
		if (!step.elements.empty) {
			//iterate through elements container and check names
		}
	}

	//	@Check
	//def checkStepUniqueIdentifier(Xconfigurator xconfigurator){
	//	if (!xconfigurator.steps.empty){
	//		for(Step step: xconfigurator.steps){
	//			var a = xconfigurator.steps.toMap[step]
	//		}
	//	}
	//}
	
	@Check
	def checkNoCycleInSuccessorPredecessor(Step step) {
		if (!step.successor.empty && !step.predecessor.empty) {
			for (Successor succ : step.successor) {
				for (Predecessor pred : step.predecessor) {
					if (succ.step.identityEquals(pred.step)) {
						error(
							'Cycle in relation Successor <-> Predecessor',
							XconfiguratorPackage.Literals.STEP__SUCCESSOR
						)
						error(
							'Cycle in relation Successor <-> Predecessor',
							XconfiguratorPackage.Literals.STEP__PREDECESSOR
						)
					}
				}
			}
		}
	}
}
