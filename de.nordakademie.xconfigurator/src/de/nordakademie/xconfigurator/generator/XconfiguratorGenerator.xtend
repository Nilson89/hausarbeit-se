/*
 * generated by Xtext
 */
package de.nordakademie.xconfigurator.generator

import de.nordakademie.xconfigurator.xconfigurator.AbstractCondition
import de.nordakademie.xconfigurator.xconfigurator.AbstractIfCondition
import de.nordakademie.xconfigurator.xconfigurator.Boolean
import de.nordakademie.xconfigurator.xconfigurator.Component
import de.nordakademie.xconfigurator.xconfigurator.ComponentReference
import de.nordakademie.xconfigurator.xconfigurator.Condition
import de.nordakademie.xconfigurator.xconfigurator.IfStatement
import de.nordakademie.xconfigurator.xconfigurator.Step
import de.nordakademie.xconfigurator.xconfigurator.Xconfigurator
import java.util.ArrayList
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class XconfiguratorGenerator implements IGenerator {
		
	var ParseCondition parseCondition = new ParseCondition()
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {

		/* Generate Application-Index */
		for (xconf : resource.contents.filter(Xconfigurator)) {
			fsa.generateFile(
				'index.html',
				application(xconf)
			);
			
			fsa.generateFile(
				'configurationlist.html',
				myConfigurations()
			);
		}
	}

	/**
	 * Create Application
	 */
	 
	 def generateStepHierarchy(Xconfigurator xconfig){
	 	//generates the step hierarchy
	 	//commits ordered ArrayList to displayHTML method
	 	
	 	var ArrayList<Step> steps
	 	var Step step = getFirstStep(xconfig.steps)
	 	steps = new ArrayList<Step>
	
		while (step != null) {
			//if (stepHasVisibleElements(step)){
			steps.add(step)
			//}
			step = getSuccessor(xconfig.steps, step)
		}
		displaySteps(steps)
	}	
				 
	 // TODO: Wenn kein erster Step gefunden wurde -> throw exception	 
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
 	
 	def boolean stepHasVisibleElements (Step step){
		//var boolean returnValue
		
		if (step.elements.length > 0){
			var int i
			for (i = 0;i < step.elements.length; i++){
				if (isVisible(step.elements.get(i).component)){
					return true
				}
			}	
		}
		return false
	}
 	
 	def boolean isVisible(Component component) {
		return parseCondition.parse(component.visibility.condition);
 	}

	def displaySteps(ArrayList<Step> orderedStepList){
	 	var stepIndex=1
	 	return '''
		«FOR step: orderedStepList»
			<li class="«IF stepIndex == 1»active«ELSE»disabled«ENDIF»">
				<a href="#step-«stepIndex++»">
			    	<h4 class="list-group-item-heading">«step.name»</h4>
			   	</a>
			</li>
		«ENDFOR»
		«showContent(orderedStepList)»	    	        	
		'''
	 }
	 
	 
	def showContent(ArrayList<Step> steps) {
		var stepIndex=1
		var backButtonName = "go-back-button"
		var nextButtonName = "save-button"
		return '''
		<form id="xconfigurator-form">
			«FOR step:steps»
				<div class="row setup-content" id="step-«stepIndex++»">
					<div class="col-xs-12">
				    	<div class="col-md-12 well text-center">
				        	 <h1> STEP «step.name»</h1>
	        	 			 «showComponents(step)»
			            	 <p align="right">
			            	 «IF !step.successor.isEmpty»
				            	 <button id="«nextButtonName»«stepIndex»" class="btn btn-primary btn-lg">Weiter</button>
				            	 «generateButtonScript(stepIndex, nextButtonName)»
			            	 «ENDIF»
			            	 </p><p align="left">
			            	 «IF !step.predecessor.isEmpty»
								 <button id="«backButtonName»«stepIndex-2»" class="btn btn-primary btn-lg">Zurueck</button>
								 «generateButtonScript(stepIndex-2, backButtonName)»
							 «ENDIF»
							 </p>
				        </div>
				    </div>
				</div>
			«ENDFOR»
		</form>
		'''
	}
	
	def showComponents(Step step) {
		return '''
		«FOR component : step.elements»
			«showComponent(component)»
		«ENDFOR»
		'''
	}
	
	def showComponent(ComponentReference reference) {
		return '''
		
		    <div class="form-group">
				<label for="#component-«reference.component.name»" class="pull-left">
					«reference.component.label»
				</label>
				<select class="form-control" id="component-«reference.component.name»">
					«FOR value : reference.component.values.values»
						<option>«value.value»</option>
					«ENDFOR»
				</select>
				«IF reference.component.description != null»
					<p class="help-block text-left">«reference.component.description.value»</p>
				«ENDIF»
				«generateComponentScript(reference.component)»
		    </div>
		'''
	}
	
	
	
	def generateButtonScript(int i, String buttonName) {
		return '''			    
		    <!-- Custom JS-Logic -->
		    <script type="text/javascript">
		        $(document).ready(function() {
	      			var navListItems = $('ul.setup-panel li a'),
		          	allWells = $('.setup-content');
				
				    allWells.hide();
				
				    navListItems.click(function(e)
				    {
				        e.preventDefault();
				        var $target = $($(this).attr('href')),
				            $item = $(this).closest('li');
				        
				        if (!$item.hasClass('disabled')) {
				            navListItems.closest('li').removeClass('active');
				            $item.addClass('active');
				            allWells.hide();
				            $target.show();
				        }
				    });
				    
				    $('ul.setup-panel li.active a').trigger('click');
				    
				    $('#«buttonName»«i»').on('click', function(e) {
				        $('ul.setup-panel li:eq(«i-1»)').removeClass('disabled');
				        $('ul.setup-panel li a[href="#step-«i»"]').trigger('click');
				        $(this).remove();
				    })    
				});
		  	</script>
		'''
	}

	def generateComponentScript(Component component) {
		return '''
			<script type="text/javascript">
				$(document).ready(function() {
					/* Create Component-Object */
					var component_«component.name»_visible = «parseComponentVisible(component.visibility.condition)»;
					var component_«component.name» = new $.XComponent('#component-«component.name»', component_«component.name»_visible);
					component_«component.name».changeVisibility();
					
					// Event-Handler for form-onChange */
					$('#xconfigurator-form').change(function() {
						component_«component.name».changeVisibility();
					});
				});
			</script>
		'''
	}
	
	def parseComponentVisible(AbstractCondition visible) {
		return '''
			«IF visible instanceof Boolean»
				«parseComponentVisibleBoolean(visible as Boolean)»
			«ELSEIF visible instanceof AbstractIfCondition»
				«parseComponentVisibleAbstractIf(visible as AbstractIfCondition)»
			«ELSE»
				false
			«ENDIF»
		'''
	}
	
	def parseComponentVisibleBoolean(Boolean visible) {
		return visible.boolean;
	}
	
	def parseComponentVisibleAbstractIf(AbstractIfCondition visible) {
		return '''
			function() {
				if («parseComponentVisibleIfStatement(visible.^if.stmt)») {
					return «parseComponentVisible(visible.^if.stmt.^return)»;
				}
				«IF visible.getElseif.size > 0»
					«FOR statement : visible.elseif»
						else if («parseComponentVisibleIfStatement(statement.stmt)») {
							return «parseComponentVisible(statement.stmt.^return)»;
						}
					«ENDFOR»
				«ENDIF»
				else {
					return «parseComponentVisible(visible.^else.^return)»;
				}
			}
		'''
	}
	
	def parseComponentVisibleIfStatement(IfStatement visible) {
		var conditionIndex = 1;
		
		return '''
			«parseComponentVisibleCondition(visible.conditions.get(0))»
			«IF visible.type.size > 0»
				«FOR t : visible.type»
					«IF t.equals("And")»
						&& «parseComponentVisibleCondition(visible.conditions.get(conditionIndex))»
					«ELSEIF t.equals("Or")»
						|| «parseComponentVisibleCondition(visible.conditions.get(conditionIndex))»
					«ENDIF»
					«{ conditionIndex++; "" }»
				«ENDFOR»
			«ENDIF»
		'''
	}
	
	def parseComponentVisibleCondition(Condition condition) {
		return '''
			(
				$('#component-«condition.component.name»').val() == '«condition.check»'
				&& $('#component-«condition.component.name»').parent('.form-group').css('display') == 'block'
			)
		'''
	}
	
	def jqueryComponentClass() {
		return '''
			<script type="text/javascript">
				(function ($) {
					/* Constructor */
					$.XComponent = function(element, visibleCondition) {
						this.element = (element instanceof $) ? element : $(element);
						this.elementContainer = this.element.parent('.form-group');
						this.visibleCondition = visibleCondition;
						
						/* Hide on Init */
						this.elementContainer.hide();
					};
					
					/* Methods */
					$.XComponent.prototype = {
						changeVisibility: function() {
							var visible = this.checkCondition();
							
							if (visible) {
								this.elementContainer.show();
							} else {
								this.elementContainer.hide();
							}
						},
						checkCondition: function() {
							if (typeof this.visibleCondition === 'boolean') {
								return this.visibleCondition;
							} else if (typeof this.visibleCondition === 'function') {
								return this.visibleCondition();
							} else {
								return false;
							}
						},
						isVisible: function() {
							return this.checkCondition();
						}
					};
					
					/* Options */
					$.XComponent.defaultOptions = {
					};
				}(jQuery));
			</script>
		'''
	}
		 
	def application(Xconfigurator xconf) {
		return '''
			<!DOCTYPE html>
			<html lang="en">
			  <head>
			    <meta charset="utf-8">
			    <meta http-equiv="X-UA-Compatible" content="IE=edge">
			    <meta name="viewport" content="width=device-width, initial-scale=1">
			    <title>XConfigurator</title>
			
			    <!-- Bootstrap -->
			    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" rel="stylesheet">
			    
			
			    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
			    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
			    <!--[if lt IE 9]>
			      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
			      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
			    <![endif]-->
			    
			    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
			    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
			    <!-- Include all compiled plugins (below), or include individual files as needed -->
			    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
			    «jqueryComponentClass()»
			  </head>
			  <body>
			    <nav class="navbar navbar-default">
			      <div class="container">
			        <div class="navbar-header">
			       <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#xconfigurator-navbar">
			         <span class="sr-only">Toggle navigation</span>
			         <span class="icon-bar"></span>
			         <span class="icon-bar"></span>
			         <span class="icon-bar"></span>
			       </button>
			       <a class="navbar-brand" href="index.html">XConfigurator</a>
			     </div>
			     
			     <div class="collapse navbar-collapse" id="xconfigurator-navbar">
			     		  <ul class="nav navbar-nav">
			     		    <li>
			     		      <a href="index.html">Home</a>
			     		    </li>
			     		    <li>
			     		      <a href="#">Meine Konfigurationen</a>
			     		    </li>
			     		  </ul>
			     		</div>
			      </div>
			    </nav>
			    
			    <div class="container">
			    	
			    	<div class="row">
			    	    <div class="col-xs-12">
			    			<h1>Konfiguration</h1>
			    		</div>
			    	</div>
			    	
			    	<!-- Configurator -->
			    	<div class="row form-group">
			    	    <div class="col-xs-12">
			    	        <ul class="nav nav-pills nav-justified thumbnail setup-panel">
								«generateStepHierarchy(xconf)»
							</ul>
						</div>
					</div>
			    </div>
			    			  
			</body>
		</html>
		'''
	}
	
	def myConfigurations() {
		return '''
			<!DOCTYPE html>
			<html lang="en">
			  <head>
			    <meta charset="utf-8">
			    <meta http-equiv="X-UA-Compatible" content="IE=edge">
			    <meta name="viewport" content="width=device-width, initial-scale=1">
			    <title>XConfigurator</title>
			
			    <!-- Bootstrap -->
			    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" rel="stylesheet">
			    
			
			    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
			    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
			    <!--[if lt IE 9]>
			      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
			      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
			    <![endif]-->
			    
			    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
			    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
			    <!-- Include all compiled plugins (below), or include individual files as needed -->
			    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
			    «jqueryComponentClass()»
			  </head>
			  <body>
			    <nav class="navbar navbar-default">
			      <div class="container">
			        <div class="navbar-header">
			       <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#xconfigurator-navbar">
			         <span class="sr-only">Toggle navigation</span>
			         <span class="icon-bar"></span>
			         <span class="icon-bar"></span>
			         <span class="icon-bar"></span>
			       </button>
			       <a class="navbar-brand" href="index.html">XConfigurator</a>
			     </div>
			     
			     <div class="collapse navbar-collapse" id="xconfigurator-navbar">
			     		  <ul class="nav navbar-nav">
			     		    <li>
			     		      <a href="index.html">Home</a>
			     		    </li>
			     		    <li>
			     		      <a href="#">Meine Konfigurationen</a>
			     		    </li>
			     		  </ul>
			     		</div>
			      </div>
			    </nav>
			    
			    <div class="container">
			    	<h1>Meine Konfigurationen</h1>
			    	
			    	<p>#ToDo</p>
			    </div>
			</body>
		</html>
		'''
	}


}
