/*
 * generated by Xtext
 */
package de.nordakademie.xconfigurator.validation

import de.nordakademie.xconfigurator.generator.ParseCondition
import de.nordakademie.xconfigurator.generator.StepHierarchy
import de.nordakademie.xconfigurator.xconfigurator.Component
import de.nordakademie.xconfigurator.xconfigurator.Predecessor
import de.nordakademie.xconfigurator.xconfigurator.Step
import de.nordakademie.xconfigurator.xconfigurator.Successor
import de.nordakademie.xconfigurator.xconfigurator.Xconfigurator
import de.nordakademie.xconfigurator.xconfigurator.XconfiguratorPackage
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.validation.Check
import java.util.List

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 * @author Julian Kondoch
 */
class XconfiguratorValidator extends AbstractXconfiguratorValidator {

	var ParseCondition parseCondition = new ParseCondition()
	var StepHierarchy stepHierarchy = new StepHierarchy()

//	@Check
//	def checkMaxOneSuccessor(Step step) {
//		if (step.successor.size > 1) {
//			warning('A Step contains at most one successor!', XconfiguratorPackage.Literals.STEP__SUCCESSOR)
//		}
//	}
//
//	@Check
//	def checkMaxOnePredecessor(Step step) {
//		if (step.predecessor.size > 1) {
//			warning('A Step contains at most one predecessor!', XconfiguratorPackage.Literals.STEP__PREDECESSOR)
//		}
//	}
	@Check
	def checkSuccessorUniqueInCollection(Xconfigurator xconf) {
		var int i
		var int j

		for (i = 0; i < xconf.steps.length; i++) {
			for (j = i + 1; j < xconf.steps.length; j++) {
				var Successor successor1 = xconf.steps.get(i).successor
				var Successor successor2 = xconf.steps.get(j).successor

				if (successor1 != null && successor2 != null) {
					if (successor1.step.identityEquals(successor2.step)) {
						error(
							'Successor ' + successor1.step.name + ' is used several times. Allowed at most one!',
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
				var Predecessor predList1 = xconf.steps.get(i).predecessor
				var Predecessor predList2 = xconf.steps.get(j).predecessor

				if (predList1 != null && predList2 != null) {
					if (predList1.step.identityEquals(predList2.step)) {
						error(
							'Predecessor ' + predList1.step.name + ' is used several times. Allowed at most one!',
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

		// Startpoint
		var int i = 0
		for (Step step : xconf.steps) {
			if (step.predecessor == null) {
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
	def checkOnlyOneStepWithoutSuccessor(Xconfigurator xconf) {

		// Endpoint
		var int i = 0
		for (Step step : xconf.steps) {
			if (step.successor == null) {
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
	def checkFirstStepHasVisibleElement(Xconfigurator xconf) {
		var int i
		var boolean hasVisibleElement = false

		for (Step step : xconf.steps) {
			if (step.predecessor == null) {
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
				'First Step needs at least one visible component!',
				XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
			)
		}
	}

	@Check
	def checkNoCycleInStepSuccessor(Step step) {
		if (step.successor != null) {
			if (step.successor.step.identityEquals(step)) {
				error(
					'Cycle in relation Step <-> Successor',
					XconfiguratorPackage.Literals.STEP__SUCCESSOR
				)
			}
		}
	}

	@Check
	def checkNoCycleInStepPredecessor(Step step) {
		if (step.predecessor != null) {
			if (step.predecessor.step.identityEquals(step)) {

				// <->eContainer!?
				error(
					'Cycle in relation Step <-> Predecessor',
					XconfiguratorPackage.Literals.STEP__PREDECESSOR
				)
			}
		}
	}

	@Check
	def checkComponentUniqueIdentifierInStep(Step step) {
		if (!step.elements.empty) {

			// iterate through elements container and check names
			var int i
			var int j

			for (i = 0; i < step.elements.length; i++) {
				for (j = i + 1; j < step.elements.length; j++) {
					if (step.elements.get(i).identityEquals(step.elements.get(j))) {
						error(
							'Name of Component ' + step.elements.get(i).component.name + ' in ' + step.name +
								' is used several times. Allowed at most one!',
							XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
						)
					}
				}
			}
		}
	}

	@Check
	def checkComponentGlobalUniqueIdentifier(Xconfigurator xconf) {
		var int i
		var int j
		var String componentName

		for (i = 0; i < xconf.component.length; i++) {
			componentName = xconf.component.get(i).name

			for (j = i + 1; j < xconf.component.length; j++) {
				if (componentName == xconf.component.get(j).name) {
					error(
						'Every component should be unique. Component ' + componentName + ' is declared at least twice!',
						XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
					)
				}
			}
		}
	}

	@Check
	def checkNoCycleInSuccessorPredecessor(Step step) {
		if (step.successor != null && step.predecessor != null) {
			if (step.successor.step.identityEquals(step.predecessor.step)) {
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

	@Check
	def checkFirstStepIsUsedAsSuccessor(Xconfigurator xconf) {
		if (xconf.steps.length > 0) {
			var Step firstStep
			firstStep = stepHierarchy.getFirstStep(xconf.steps)

			for (Step step : xconf.steps) {
				if (step.successor.step.identityEquals(firstStep)) {
					error(
						'It is not allowed to use first step ' + step.successor.step.name + ' as successor!',
						XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
					)
				}
			}
		}
	}

	@Check
	def checkLastStepIsUsedAsPredecessor(Xconfigurator xconf) {
		if (xconf.steps.length > 0) {
			var Step lastStep
			lastStep = stepHierarchy.getLastStep(xconf.steps)

			for (Step step : xconf.steps) {
				if (step.predecessor.step.identityEquals(lastStep)) {
					error(
						'It is not allowed to use last step ' + step.predecessor.step.name + ' as predecessor!',
						XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
					)
				}
			}
		}
	}

	@Check
	def checkEveryStepContainsComponents(Xconfigurator xconf) {
		if (xconf.steps.length > 0) {
			for (Step step : xconf.steps) {
				if (step.elements.length == 0) {
					error(
						'Steps must contain at least one element. Step ' + step.name + ' has 0!',
						XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
					)
				}
			}
		}
	}

	@Check
	def checkEveryComponentContainsValues(Xconfigurator xconf) {
		var int i
		var Component component

		for (i = 0; i < xconf.component.length; i++) {
			component = xconf.component.get(i)

			if (component.values.values.empty) {
				error('Every component must contain at least one value. Value of component ' + component.name +
					' is null!', XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS)
			}
		}
	}

	@Check
	def checkComponentContainedInFollowedSteps(Xconfigurator xconf) {
		var List<Step> orderedSteps
		var int i
		var int j
		var int k
		var int l
		orderedSteps = stepHierarchy.getOrderedStepList(xconf)

		for (i = 0; i < orderedSteps.length; i++) {
			for (j = 0; j < orderedSteps.get(i).elements.length; j++) {
				var List<Component> componentList

				componentList = parseCondition.getComponentsByAbstractCondition(
					orderedSteps.get(i).elements.get(j).component.visibility.condition)

				for (Component component : componentList) {
					for (k = i + 1; k < orderedSteps.length; k++) {
						for (l = 0; l < orderedSteps.get(k).elements.length; l++) {
							if (component.identityEquals(orderedSteps.get(k).elements.get(l).component)) {
								error(
									'Step ' + orderedSteps.get(i).name + ' has a reference to component ' +
										component.name + ' that belongs to the future step ' +
										orderedSteps.get(k).name + '!',
									XconfiguratorPackage.Literals.XCONFIGURATOR__STEPS
								)
							}
						}
					}
				}
			}
		}
	}
}
