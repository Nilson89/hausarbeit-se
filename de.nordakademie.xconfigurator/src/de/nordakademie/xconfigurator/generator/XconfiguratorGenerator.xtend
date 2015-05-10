/*
 * generated by Xtext
 */
package de.nordakademie.xconfigurator.generator

import de.nordakademie.xconfigurator.xconfigurator.AbstractVisible
import de.nordakademie.xconfigurator.xconfigurator.Component
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
			)
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
			steps.add(step)
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
 	
 	def boolean isVisible(Component component) {
 		var boolean result = true
 		var EList<AbstractVisible> visibility = component.visibility
 			for(AbstractVisible visible : visibility) {
		result = (result && parseCondition.parse(visible.condition))
 		}
 		return result
 	}

//	 TODO Demo s.u.
	def displaySteps(ArrayList<Step> orderedStepList){
	 	var stepIndex=1
	 	return '''
		«FOR step: orderedStepList»
			<li class="«IF stepIndex == 1»
						active
						«ELSE»
						disabled
						«ENDIF»">
				<a href="#step-«stepIndex++»">
			    <h4 class="list-group-item-heading">«step.name»</h4>
			    <p class="list-group-item-text">«step.name»</p>
«««			    TODO DEMO
			    «FOR component : step.elements»
			    <p class="list-group-item-text">«component.component.name» " is visible: " «isVisible(component.component)»</p>
			    «ENDFOR»
			   	</a>
			</li>
		«ENDFOR»
			    	        	
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
			       <a class="navbar-brand" href="#">XConfigurator</a>
			     </div>
			     
			     <div class="collapse navbar-collapse" id="xconfigurator-navbar">
			     		  <ul class="nav navbar-nav">
			     		    <li>
			     		      <a href="#">Home</a>
			     		    </li>
			     		  </ul>
			     		</div>
			      </div>
			    </nav>
			    
			    <div class="container">
			    	
			    	<div class="row">
			    	    <div class="col-xs-12">
			    			<h1>Konfiguration</h1>
			    			<p class="text-left">
			    				Lorem ipsum dolor sit amet, consetetur sadipscing elitr, 
			    				sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, 
			    				sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. 
			    				Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. 
			    				Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt 
			    				ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo 
			    				duo dolores et ea rebum. Stet clita kasd gubergren, 
			    				no sea takimata sanctus est Lorem ipsum dolor sit amet.
			    			</p>
			    		</div>
			    	</div>
			    	
			    	<!-- Configurator -->
			    	<div class="row form-group">
			    	    <div class="col-xs-12">
			    	        <ul class="nav nav-pills nav-justified thumbnail setup-panel">
«««			    	        «FOR step: xconf.steps»
								«generateStepHierarchy(xconf)»
«««			    	        «ENDFOR»
«««			    	            <li class="active"><a href="#step-1">
«««			    	                <h4 class="list-group-item-heading">Step 10</h4>
«««			    	                <p class="list-group-item-text">First step description</p>
«««			    	            </a></li>
«««			    	            <li class="disabled"><a href="#step-2">
«««			    	                <h4 class="list-group-item-heading">Step 2</h4>
«««			    	                <p class="list-group-item-text">Second step description</p>
«««			    	            </a></li>
«««			    	            <li class="disabled"><a href="#step-3">
«««			    	                <h4 class="list-group-item-heading">Step 3</h4>
«««			    	                <p class="list-group-item-text">Third step description</p>
«««			    	            </a></li>
			    	        </ul>
			    	    </div>
			  </div>
			     <div class="row setup-content" id="step-1">
			         <div class="col-xs-12">
			             <div class="col-md-12 well text-center">
			                 <h1> STEP 1</h1>
			                 <button id="activate-step-2" class="btn btn-primary btn-lg">Activate Step 2</button>
			             </div>
			         </div>
			     </div>
			     <div class="row setup-content" id="step-2">
			         <div class="col-xs-12">
			             <div class="col-md-12 well">
			                 <h1 class="text-center"> STEP 2</h1>
			             </div>
			         </div>
			     </div>
			     <div class="row setup-content" id="step-3">
			         <div class="col-xs-12">
			             <div class="col-md-12 well">
			                 <h1 class="text-center"> STEP 3</h1>
			             </div>
			         </div>
			     </div>
			    </div>
			
			    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
			    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
			    <!-- Include all compiled plugins (below), or include individual files as needed -->
			    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
			    
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
					    
					    // DEMO ONLY //
					    $('#activate-step-2').on('click', function(e) {
					        $('ul.setup-panel li:eq(1)').removeClass('disabled');
					        $('ul.setup-panel li a[href="#step-2"]').trigger('click');
					        $(this).remove();
					    })    
					});
					  </script>
					  
					</body>
			</html>
		'''
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
