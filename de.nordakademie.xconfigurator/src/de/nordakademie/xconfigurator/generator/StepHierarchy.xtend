package de.nordakademie.xconfigurator.generator

import org.eclipse.emf.common.util.EList
import de.nordakademie.xconfigurator.xconfigurator.Step

/**
 * Generates the step hierarchy
 * @author Julian Kondoch, Pascal Laub, Niklas Rothe
 * 
 */
class StepHierarchy {
	
	/**
	 * @author Julian Kondoch, Pascal Laub, Niklas Rothe
	 */	
	 def Step getFirstStep(EList<Step> steps){
	 	if (steps.length > 0){
	 		for(Step step: steps){
	 			if (step.predecessor.isEmpty){
	 				return step
	 			}
	 		}
	 		return null
	 	}
	 }
	 
	 /**
	 * @author Julian Kondoch, Pascal Laub, Niklas Rothe
	 */
	 def Step getSuccessor(EList<Step> steps,Step predecessor){
	 	for (Step step: steps){
	 		if (step.predecessor.size > 0){
	 			if (step.predecessor.get(0).step.identityEquals(predecessor)){
				return step
	 			}
	 		}
	 	}
	 	return null
 	}
}