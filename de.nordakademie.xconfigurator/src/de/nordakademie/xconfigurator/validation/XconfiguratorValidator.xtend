/*
 * generated by Xtext
 */
package de.nordakademie.xconfigurator.validation

import de.nordakademie.xconfigurator.generator.ParseCondition
import de.nordakademie.xconfigurator.xconfigurator.Component
import de.nordakademie.xconfigurator.xconfigurator.Predecessor
import de.nordakademie.xconfigurator.xconfigurator.Step
import de.nordakademie.xconfigurator.xconfigurator.Successor
import de.nordakademie.xconfigurator.xconfigurator.Xconfigurator
import de.nordakademie.xconfigurator.xconfigurator.XconfiguratorPackage
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.validation.Check

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 * @author Julian Kondoch
 */
class XconfiguratorValidator extends AbstractXconfiguratorValidator {

	var ParseCondition parseCondition = new ParseCondition()

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
	def checkSuccessorUniqueInCollection(Xconfigurator xconf) {
		var int i
		var int j

		for (i = 0; i < xconf.steps.length; i++) {
			for (j = i + 1; j < xconf.steps.length; j++) {
				var EList<Successor> succList1 = xconf.steps.get(i).successor
				var EList<Successor> succList2 = xconf.steps.get(j).successor

				if (!succList1.isEmpty && !succList2.isEmpty) {
					if (succList1.get(0).step.identityEquals(succList2.get(0).step)) {
						error(
							'Successor ' + succList1.get(0).step.name + ' is used several times. Allowed at most one!',
							XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
						)
					}
				}
			}
		}
	}

	@Check
	def checkPredecessorUniqueInCollection(Xconfigurator xconf) {
		var int i
		var int j

		for (i = 0; i < xconf.steps.length; i++) {
			for (j = i + 1; j < xconf.steps.length; j++) {
				var EList<Predecessor> predList1 = xconf.steps.get(i).predecessor
				var EList<Predecessor> predList2 = xconf.steps.get(j).predecessor

				if (!predList1.isEmpty && !predList2.isEmpty) {
					if (predList1.get(0).step.identityEquals(predList2.get(0).step)) {
						error(
							'Predecessor ' + predList1.get(0).step.name + ' is used several times. Allowed at most one!',
							XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
						)
					}
				}
			}
		}
	}

	@Check
	def checkStepUniqueIdentifier(Xconfigurator xconfigurator) {
		var int i
		var int j

		if (!xconfigurator.steps.empty) {
			for (i = 0; i < xconfigurator.steps.length; i++) {
				for (j = i + 1; j < xconfigurator.steps.length; j++) {
					if (xconfigurator.steps.get(i).identityEquals(xconfigurator.steps.get(j))) {
						error(
							'Name of Step ' + xconfigurator.steps.get(i).name +
								' is used several times. Allowed at most one!',
							XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
						)
					}
				}
			}
		}
	}

	@Check
	def checkOnlyOneStepWithoutPredecessor(Xconfigurator xconf) {
		//Startpoint
		var int i = 0
		for (Step step : xconf.steps) {
			if (step.predecessor.isEmpty) {
				i++
				if (i > 1) {
					error(
						'Multiple Steps without predecessor. Allowed at most one!',
						XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
					)
				}
			}
		}
	}
	
	@Check
	def checkFirstStepHasVisibleElement(Xconfigurator xconf) {
		var int i
		var boolean hasVisibleElement = false

		for (Step step : xconf.steps) {
			if (step.predecessor.isEmpty) {
				for (i = 0; i < step.elements.length; i++) {
					var Component component
					component = step.elements.get(i).component
					if (parseCondition.parse(component.visibility.condition)) {
						hasVisibleElement = true
					}
				}
			}
		}
		if (!hasVisibleElement) {
			error(
				'First Step needs at least one visible element!',
				XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
			)
		}
	}
	
	@Check
	def checkOnlyOneStepWithoutSuccessor(Xconfigurator xconf) {

		//Endpoint
		var int i = 0
		for (Step step : xconf.steps) {
			if (step.successor.isEmpty) {
				i++
				if (i > 1) {
					error(
						'Multiple Steps without successor. Allowed at most one!',
						XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
					)
				}
			}
		}
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
			var int i
			var int j

			for (i = 0; i < step.elements.length; i++) {
				for (j = i + 1; j < step.elements.length; j++) {
					if (step.elements.get(i).identityEquals(step.elements.get(j))) {
						error(
							'Name of Component ' + step.elements.get(i).component.name +
								' in ' + step.name + ' is used several times. Allowed at most one!',
							XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
						)
					}
				}
		}
			
		}
	}

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
	
	@Check
	def checkComponentContainedInFollowedSteps(Xconfigurator xconf){
		//prüfe jeden Step
		//prüfe bei jeder visibility if-Abfrage, ob die enthaltenen Komponenten in einem späteren Step vorhanden sind
		//notwendig hierfür ist die Hierarchie 
		
		
	}
}
