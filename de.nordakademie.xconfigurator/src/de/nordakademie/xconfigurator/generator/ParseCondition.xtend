package de.nordakademie.xconfigurator.generator

import de.nordakademie.xconfigurator.xconfigurator.AbstractCondition
import de.nordakademie.xconfigurator.xconfigurator.AbstractIfCondition
import de.nordakademie.xconfigurator.xconfigurator.Boolean
import de.nordakademie.xconfigurator.xconfigurator.Condition
import de.nordakademie.xconfigurator.xconfigurator.ElseIf
import de.nordakademie.xconfigurator.xconfigurator.IfStatement
import org.eclipse.emf.common.util.EList
import de.nordakademie.xconfigurator.xconfigurator.Component
import java.util.ArrayList
import java.util.List

/**
 * Parses an AbstractCondition into a boolean value
 * @author Pascal Laub
 * 
 */
class ParseCondition {

	def boolean parse(AbstractCondition visible) {
		if (visible instanceof Boolean) {
			return parse(visible as Boolean)
		} else if (visible instanceof AbstractIfCondition) {
			return parse(visible as AbstractIfCondition)
		} else {
			return false
		}
	}


	def List<Component> getComponentsByAbstractCondition(AbstractCondition visible) {
		var List<Component> components = new ArrayList<Component>()
		var List<Condition> conditions = getConditions(visible)
		if (conditions != null) {
			for (Condition condition : conditions) {
				components.add(condition.component)
			}
		}
		return components
	}

	def List<Condition> getConditions(AbstractCondition visible) {
		var List<Condition> conditions = new ArrayList<Condition>
		if (visible instanceof AbstractIfCondition) {
			conditions.addAll(getConditions(visible.^if.stmt))
			conditions.addAll(getConditions(visible.elseif))
			return conditions
		}
		return null
	}

	def List<Condition> getConditions(EList<ElseIf> visible) {
		var List<Condition> conditions = new ArrayList<Condition>()
		if (visible != null) {
			for (ElseIf clause : visible) {
				conditions.addAll(getConditions(clause.stmt))
			}
		}
		return conditions
	}

	def EList<Condition> getConditions(IfStatement visible) {
		return visible.conditions
	}

	def boolean parse(AbstractIfCondition visible) {
		if (parse(visible.^if.stmt)) {
			return parse(visible.^if.stmt.^return)
		} else if (visible.getElseif.size > 0) {
			var ElseIf clause = parse(visible.elseif)
			if (clause != null) {
				return parse(clause.stmt.^return)
			}
		} else {
			return parse(visible.^else.^return)
		}
	}

	def boolean parse(IfStatement visible) {
		var boolean result = parse(visible.conditions.get(0))
		if (visible.type.size > 0) {
			for (var int i = 1; i - 1 < visible.type.size; i++) {
				var String type = visible.type.get(i - 1)
				if (type.equals("And")) {
					result = (result && parse(visible.conditions.get(i)))
				} else if (type.equals("Or")) {
					if(result) return true
					result = parse(visible.conditions.get(i))
				}
			}
		}
		return result
	}

	/**
	 * Hier nur als Dummy, da der Check zur Laufzeit erfolgen muss.
	 * Dies ist bei HTML nun in JavaScript gelöst.
	 * Diese Parser kann aber genutzt werden, wenn bspw. ein Java-Applet mit Hilfe
	 * eines modifizierten bzw. zusätzlichen Generators generiert wird, was einen
	 * Laufzeitcheck mit Java ermöglichen würde.
	 */
	def boolean parse(Condition condition) {
		return false;
	}

	def ElseIf parse(EList<ElseIf> visible) {
		if(visible.size == 0) return null;
		for (ElseIf clause : visible) {
			if(parse(clause.stmt)) return clause
		}
		return null
	}

	def boolean parse(Boolean visible) {
		return visible.boolean
	}
}