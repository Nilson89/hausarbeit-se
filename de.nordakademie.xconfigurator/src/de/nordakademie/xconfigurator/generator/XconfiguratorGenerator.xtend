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
		/* Generate Application-Index */
		fsa.generateFile(
			'index.html',
			application()
		)
	}
	
	/**
	 * Create Application
	 */
	def application() {
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
				                <li class="active"><a href="#step-1">
				                    <h4 class="list-group-item-heading">Step 1</h4>
				                    <p class="list-group-item-text">First step description</p>
				                </a></li>
				                <li class="disabled"><a href="#step-2">
				                    <h4 class="list-group-item-heading">Step 2</h4>
				                    <p class="list-group-item-text">Second step description</p>
				                </a></li>
				                <li class="disabled"><a href="#step-3">
				                    <h4 class="list-group-item-heading">Step 3</h4>
				                    <p class="list-group-item-text">Third step description</p>
				                </a></li>
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
}
