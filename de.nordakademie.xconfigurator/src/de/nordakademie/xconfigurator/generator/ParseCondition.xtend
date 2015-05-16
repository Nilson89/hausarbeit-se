package de.nordakademie.xconfigurator.generator

import de.nordakademie.xconfigurator.xconfigurator.AbstractCondition
import de.nordakademie.xconfigurator.xconfigurator.AbstractIfCondition
import de.nordakademie.xconfigurator.xconfigurator.Boolean
import de.nordakademie.xconfigurator.xconfigurator.Condition
import de.nordakademie.xconfigurator.xconfigurator.ElseIf
import de.nordakademie.xconfigurator.xconfigurator.IfStatement
import org.eclipse.emf.common.util.EList

/**
 * Parses an AbstractCondition into a boolean value
 * Dient hier nur als Vorlage für die JavaScript-Abstraktion,d a die Prüfung zur Laufzeit erfolgen muss
 * @author: Pascal Laub
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
	
	def boolean parse(AbstractIfCondition visible) {		
		if(parse(visible.^if.stmt)) {
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
			for (var int i = 1; i-1 < visible.type.size; i++) {
				var String type = visible.type.get(i-1)
				if (type.equals("And")) {
					result = (result && parse(visible.conditions.get(i)))
				} else if (type.equals("Or")) {
					if (result) return true
					result = parse(visible.conditions.get(i))
				}
			}
		}
		return result
	}
		
	def boolean parse(Condition condition) {
		if (condition.component.selected == null) {
			return false;
		} else {
			return condition.component.selected.value.equals(condition.check)
		}
	}
		
	def ElseIf parse(EList<ElseIf> visible) {
		if (visible.size == 0) return null;
		for (ElseIf clause : visible) {
			if (parse(clause.stmt)) return clause
		}
		return null
	}
	
	def boolean parse(Boolean visible) {
		return visible.boolean
	}
}