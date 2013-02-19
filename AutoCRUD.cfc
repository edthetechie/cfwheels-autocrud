<cfcomponent displayname="AutoCRUD" output="false" author="Andy Bellenie" support="">

	
	<!--- setup and configuation --->
	
	<cffunction name="init" output="false">
		<cfset this.version = "1.1,1.1.1,1.1.2,1.1.3,1.1.4,1.1.5,1.1.6,1.1.7,1.1.8">
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="autoCRUD" returntype="void" output="false" mixin="controller">
		<cfargument name="only" type="string" default="index,new,edit,delete,restore,expunge" hint="I am a list of actions that the autoCRUD will override.">
		<cfargument name="except" type="string" default="" hint="I am a list of actions that the autoCRUD will NOT override.">
		<cfargument name="modelName" type="string" default="#Singularize(variables.$class.name)#" hint="I am the name of the controller's default model (defaults to the singular of the controller name).">
		<cfargument name="modelVariable" type="string" default="#arguments.modelName#" hint="I am the name of the variable used to store the controller's default model (defaults to the model name).">
		<cfargument name="modelDisplayName" type="string" default="#Humanize(arguments.modelName)#" hint="I am the display name of the controller's default model (defaults to the model name).">
		<cfargument name="perPage" type="numeric" default="0" hint="The number of records to return in a automatic listing. Use zero for unlimited results (defaults to zero).">		
		<cfargument name="afterCreateKey" type="string" default="" hint="I am the location of a key to be used after a successful create (defaults to blank).">
		<cfargument name="afterCreateController" type="string" default="#variables.$class.name#" hint="I am the controller to redirect to after a successful create (defaults to current controller).">
		<cfargument name="afterCreateAction" type="string" default="" hint="I am the action to redirect to after a successful create (defaults to 'index').">
		<cfargument name="afterCreateRoute" type="string" default="" hint="I am an optional route to redirect to after a successful create (defaults to blank).">
		<cfargument name="afterCreateMessage" type="string" default="[modelDisplayName] has been successfully created." hint="I am an optional message to store in the flash after a successful create.">
		<cfargument name="afterUpdateKey" type="string" default="" hint="I am the location of a key to be used after a successful update (defaults to blank).">
		<cfargument name="afterUpdateController" type="string" default="#variables.$class.name#" hint="I am the controller to redirect to after a successful update (defaults to current controller).">
		<cfargument name="afterUpdateAction" type="string" default="" hint="I am the action to redirect to after a successful update (defaults to 'index').">
		<cfargument name="afterUpdateRoute" type="string" default="" hint="I am am optional route to redirect to after a successful update (defaults to blank).">
		<cfargument name="afterUpdateMessage" type="string" default="[modelDisplayName] has been successfully updated." hint="I am an optional message to store in the flash after a successful update.">
		<cfargument name="afterDeleteKey" type="string" default="" hint="I am the location of a key to be used after a successful delete (defaults to blank).">
		<cfargument name="afterDeleteController" type="string" default="#variables.$class.name#" hint="I am the controller to redirect to after a successful delete (defaults to the current controller).">
		<cfargument name="afterDeleteAction" type="string" default="" hint="I am the action to redirect to after a successful delete (defaults to 'index').">
		<cfargument name="afterDeleteRoute" type="string" default="" hint="I am an optional route to redirect to after a successful delete (defaults to blank).">
		<cfargument name="afterDeleteMessage" type="string" default="[modelDisplayName] has been successfully deleted." hint="I am an optional message to store in the flash after a successful delete.">
		<cfargument name="failedDeleteMessage" type="string" default="[modelDisplayName] could not be deleted." hint="I am an optional message to store in the flash after a failed delete.">
		<cfargument name="afterRestoreKey" type="string" default="" hint="I am the location of a key to be used after a successful restore (defaults to blank).">
		<cfargument name="afterRestoreController" type="string" default="#variables.$class.name#" hint="I am the controller to redirect to after a successful restore (defaults to the current controller).">
		<cfargument name="afterRestoreAction" type="string" default="" hint="I am the action to redirect to after a successful restore (defaults to 'index').">
		<cfargument name="afterRestoreRoute" type="string" default="" hint="I am an optional route to redirect to after a successful restore (defaults to blank).">
		<cfargument name="afterRestoreMessage" type="string" default="[modelDisplayName] has been successfully restored." hint="I am an optional message to store in the flash after a successful restore.">
		<cfargument name="failedRestoreMessage" type="string" default="[modelDisplayName] could not be restored." hint="I am an optional message to store in the flash after a failed restore.">
		<cfargument name="afterExpungeKey" type="string" default="" hint="I am the location of a key to be used after a successful expunge (defaults to blank).">
		<cfargument name="afterExpungeController" type="string" default="#variables.$class.name#" hint="I am the controller to redirect to after a successful expunge (defaults to the current controller).">
		<cfargument name="afterExpungeAction" type="string" default="" hint="I am the action to redirect to after a successful expunge (defaults to 'index').">
		<cfargument name="afterExpungeRoute" type="string" default="" hint="I am an optional route to redirect to after a successful expunge (defaults to blank).">
		<cfargument name="afterExpungeMessage" type="string" default="[modelDisplayName] has been permanently deleted." hint="I am an optional message to store in the flash after a successful expunge.">
		<cfargument name="failedExpungeMessage" type="string" default="[modelDisplayName] could not be permanently deleted." hint="I am an optional message to store in the flash after a failed expunge.">
		<cfargument name="controllerParams" type="string" default="" hint="I am a comma delimited list of params to be excluded when automatically populating the controller's default model from the params struct.">
		<cfset variables.$class.autoCRUD = Duplicate(arguments)>
		<cfset variables.$class.autoCRUD.controllerParams = ListAppend(variables.$class.autoCRUD.controllerParams, "route,controller,action,key")>
	</cffunction>
	
	
	<cffunction name="setOnly" returntype="void" access="public" mixin="controller">
		<cfargument name="only" type="string" required="true">
		<cfset variables.$class.autoCRUD.only = arguments.only>
	</cffunction>


	<cffunction name="setExcept" returntype="void" access="public" mixin="controller">
		<cfargument name="except" type="string" required="true">
		<cfset variables.$class.autoCRUD.except = arguments.except>
	</cffunction>


	<cffunction name="setModelName" returntype="void" access="public" mixin="controller">
		<cfargument name="modelName" type="string" required="true">
		<cfset variables.$class.autoCRUD.modelName = arguments.modelName>
	</cffunction>
	
	<cffunction name="setModelVariable" returntype="void" access="public" mixin="controller">
		<cfargument name="modelVariable" type="string" required="true">
		<cfset variables.$class.autoCRUD.modelVariable = arguments.modelVariable>
	</cffunction>

	<cffunction name="setModelDisplayName" returntype="void" access="public" mixin="controller">
		<cfargument name="modelDisplayName" type="string" required="true">
		<cfset variables.$class.autoCRUD.modelDisplayName = arguments.modelDisplayName>
	</cffunction>

	<cffunction name="setPerPage" returntype="void" access="public" mixin="controller">
		<cfargument name="perPage" type="numeric" required="true">
		<cfset variables.$class.autoCRUD.perPage = arguments.perPage>
	</cffunction>

	<cffunction name="setAfterCreateKey" returntype="void" access="public" mixin="controller">
		<cfargument name="afterCreateKey" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterCreateKey = arguments.afterCreateKey>
	</cffunction>

	<cffunction name="setAfterCreateController" returntype="void" access="public" mixin="controller">
		<cfargument name="afterCreateController" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterCreateController = arguments.afterCreateController>
	</cffunction>

	<cffunction name="setAfterCreateAction" returntype="void" access="public" mixin="controller">
		<cfargument name="afterCreateAction" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterCreateAction = arguments.afterCreateAction>
	</cffunction>

	<cffunction name="setAfterCreateRoute" returntype="void" access="public" mixin="controller">
		<cfargument name="afterCreateRoute" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterCreateRoute = arguments.afterCreateRoute>
	</cffunction>

	<cffunction name="setAfterUpdateKey" returntype="void" access="public" mixin="controller">
		<cfargument name="afterUpdateKey" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterUpdateKey = arguments.afterUpdateKey>
	</cffunction>

	<cffunction name="setAfterUpdateController" returntype="void" access="public" mixin="controller">
		<cfargument name="afterUpdateController" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterUpdateController = arguments.afterUpdateController>
	</cffunction>

	<cffunction name="setAfterUpdateAction" returntype="void" access="public" mixin="controller">
		<cfargument name="afterUpdateAction" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterUpdateAction = arguments.afterUpdateAction>
	</cffunction>

	<cffunction name="setAfterUpdateRoute" returntype="void" access="public" mixin="controller">
		<cfargument name="afterUpdateRoute" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterUpdateRoute = arguments.afterUpdateRoute>
	</cffunction>

	<cffunction name="setAfterDeleteKey" returntype="void" access="public" mixin="controller">
		<cfargument name="afterDeleteKey" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterDeleteKey = arguments.afterDeleteKey>
	</cffunction>

	<cffunction name="setAfterDeleteController" returntype="void" access="public" mixin="controller">
		<cfargument name="afterDeleteController" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterDeleteController = arguments.afterDeleteController>
	</cffunction>

	<cffunction name="setAfterDeleteAction" returntype="void" access="public" mixin="controller">
		<cfargument name="afterDeleteAction" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterDeleteAction = arguments.afterDeleteAction>
	</cffunction>

	<cffunction name="setAfterDeleteRoute" returntype="void" access="public" mixin="controller">
		<cfargument name="afterDeleteRoute" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterDeleteRoute = arguments.afterDeleteRoute>
	</cffunction>

	<cffunction name="setAfterRestoreKey" returntype="void" access="public" mixin="controller">
		<cfargument name="afterRestoreKey" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterRestoreKey = arguments.afterRestoreKey>
	</cffunction>

	<cffunction name="setAfterRestoreController" returntype="void" access="public" mixin="controller">
		<cfargument name="afterRestoreController" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterRestoreController = arguments.afterRestoreController>
	</cffunction>

	<cffunction name="setAfterRestoreAction" returntype="void" access="public" mixin="controller">
		<cfargument name="afterRestoreAction" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterRestoreAction = arguments.afterRestoreAction>
	</cffunction>

	<cffunction name="setAfterRestoreRoute" returntype="void" access="public" mixin="controller">
		<cfargument name="afterRestoreRoute" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterRestoreRoute = arguments.afterRestoreRoute>
	</cffunction>

	<cffunction name="setAfterExpungeKey" returntype="void" access="public" mixin="controller">
		<cfargument name="afterExpungeKey" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterExpungeKey = arguments.afterExpungeKey>
	</cffunction>

	<cffunction name="setAfterExpungeController" returntype="void" access="public" mixin="controller">
		<cfargument name="afterExpungeController" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterExpungeController = arguments.afterExpungeController>
	</cffunction>

	<cffunction name="setAfterExpungeAction" returntype="void" access="public" mixin="controller">
		<cfargument name="afterExpungeAction" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterExpungeAction = arguments.afterExpungeAction>
	</cffunction>

	<cffunction name="setAfterExpungeRoute" returntype="void" access="public" mixin="controller">
		<cfargument name="afterExpungeRoute" type="string" required="true">
		<cfset variables.$class.autoCRUD.afterExpungeRoute = arguments.afterExpungeRoute>
	</cffunction>

	<cffunction name="setControllerParams" returntype="void" access="public" mixin="controller">
		<cfargument name="controllerParams" type="string" required="true">
		<cfset variables.$class.autoCRUD.controllerParams = ListAppend(variables.$class.autoCRUD.controllerParams, arguments.controllerParams)>
	</cffunction>

	
	
	<!--- action overrides --->
	
	<cffunction name="index" mixin="controller">
		<cfif StructKeyExists(variables.$class, "autoCRUD") and ListFindNoCase(variables.$class.autoCRUD.only, "index") and not ListFindNoCase(variables.$class.autoCRUD.except, "index")>
			<cfset autoIndex(argumentCollection=arguments)>
		</cfif>
	</cffunction>


	<cffunction name="new" mixin="controller">
		<cfif StructKeyExists(variables.$class, "autoCRUD") and ListFindNoCase(variables.$class.autoCRUD.only, "new") and not ListFindNoCase(variables.$class.autoCRUD.except, "new")>
			<cfset autoNew(argumentCollection=arguments)>
		</cfif>
	</cffunction>


	<cffunction name="edit" mixin="controller">
		<cfif StructKeyExists(variables.$class, "autoCRUD") and ListFindNoCase(variables.$class.autoCRUD.only, "edit") and not ListFindNoCase(variables.$class.autoCRUD.except, "edit")>
			<cfset autoEdit(argumentCollection=arguments)>
		</cfif>
	</cffunction>


	<cffunction name="delete" mixin="controller">
		<cfif StructKeyExists(variables.$class, "autoCRUD") and ListFindNoCase(variables.$class.autoCRUD.only, "delete") and not ListFindNoCase(variables.$class.autoCRUD.except, "delete")>
			<cfset autoDelete(argumentCollection=arguments)>
		</cfif>
	</cffunction>

	<cffunction name="restore" mixin="controller">
		<cfif StructKeyExists(variables.$class, "autoCRUD") and ListFindNoCase(variables.$class.autoCRUD.only, "restore") and not ListFindNoCase(variables.$class.autoCRUD.except, "restore")>
			<cfset autoRestore(argumentCollection=arguments)>
		</cfif>
	</cffunction>

	<cffunction name="expunge" mixin="controller">
		<cfif StructKeyExists(variables.$class, "autoCRUD") and ListFindNoCase(variables.$class.autoCRUD.only, "expunge") and not ListFindNoCase(variables.$class.autoCRUD.except, "expunge")>
			<cfset autoExpunge(argumentCollection=arguments)>
		</cfif>
	</cffunction>


	<!--- autoCRUD actions --->

	<cffunction name="autoIndex" mixin="controller">
		<cfargument name="modelName" type="string" default="#variables.$class.autoCRUD.modelName#" hint="I am the name of the action's model (defaults to the controller's default model name).">
		<cfargument name="modelVariable" type="string" default="#arguments.modelName#" hint="I am the name of the variable used to store the action's default model (defaults to the actions model name).">
		<cfargument name="modelDisplayName" type="string" default="#Humanize(arguments.modelName)#" hint="I am the display name of the action's default model (defaults to the humanized action's model name).">
		<cfargument name="page" type="numeric" default="1" hint="Passed through to the findAll() method for pagination.">
		<cfargument name="perPage" type="numeric" default="#variables.$class.autoCRUD.perPage#" hint="Passed through to the findAll() method for pagination.">
		<cfargument name="template" type="string" default="index" hint="I am the name of this action's template file.">
		<cfset variables.$autoCRUD = Duplicate(arguments)>
		 
		<cfif IsDefined("params.showdeleted")>
			<cfif arguments.perPage gt 0>
				<cfset variables[Pluralize(arguments.modelVariable)] = model(arguments.modelName).findAll(page=arguments.page, perPage=arguments.perPage, includeSoftDeletes='true')>	
			<cfelse>
				<cfset variables[Pluralize(arguments.modelVariable)] = model(arguments.modelName).findAll(where='#get("softDeleteProperty")# IS NOT NULL', includeSoftDeletes='true')>
			</cfif>
		<cfelse>
			<cfif arguments.perPage gt 0>
				<cfset variables[Pluralize(arguments.modelVariable)] = model(arguments.modelName).findAll(page=arguments.page, perPage=arguments.perPage)>	
			<cfelse>
				<cfset variables[Pluralize(arguments.modelVariable)] = model(arguments.modelName).findAll()>
			</cfif>
		</cfif>
		<cfset renderPage(template=arguments.template)>
	</cffunction>


	<cffunction name="autoNew" mixin="controller">
		<cfargument name="modelName" type="string" default="#variables.$class.autoCRUD.modelName#" hint="I am the name of the action's model (defaults to the controller's default model name).">
		<cfargument name="modelVariable" type="string" default="#arguments.modelName#" hint="I am the name of the variable used to store the action's default model (defaults to the actions model name).">
		<cfargument name="modelDisplayName" type="string" default="#Humanize(arguments.modelName)#" hint="I am the display name of the action's default model (defaults to the humanized action's model name).">
		<cfargument name="afterCreateKey" type="string" default="#variables.$class.autoCRUD.afterCreateKey#" hint="I am the location of a key to be used after a successful create (defaults to blank).">
		<cfargument name="afterCreateController" type="string" default="#variables.$class.autoCRUD.afterCreateController#" hint="I am the controller to redirect to after a successful create (defaults to current controller).">
		<cfargument name="afterCreateAction" type="string" default="#variables.$class.autoCRUD.afterCreateAction#" hint="I am the action to redirect to after a successful create (defaults to 'index').">
		<cfargument name="afterCreateRoute" type="string" default="#variables.$class.autoCRUD.afterCreateRoute#" hint="I am an optional route to redirect to after a successful create (defaults to blank).">
		<cfargument name="afterCreateMessage" type="string" default="#variables.$class.autoCRUD.afterCreateMessage#" hint="I am an optional message to store in the flash after a successful create.">
		<cfargument name="template" type="string" default="edit" hint="I am the name of the new action's template file.">
		<cfset variables.$autoCRUD = Duplicate(arguments)>
		<cfif not StructKeyExists(variables, arguments.modelVariable)>
			<cfset variables[arguments.modelVariable] = model(arguments.modelName).new($cleanUpParams(variables.params))>
		</cfif>
		<cfif StructKeyExists(params, arguments.modelVariable)>
			<cfset variables[arguments.modelVariable].setProperties(params[arguments.modelVariable])>
			<cfif variables[arguments.modelVariable].save()>
				<cfif Len(arguments.afterCreateMessage)>
					<cfset flashInsert(success=Replace(arguments.afterCreateMessage, "[modelDisplayName]", Humanize(arguments.modelName), "all"))>
				</cfif>
				<cfset arguments.actionType = "create">
				<cfset redirectTo(argumentCollection=$getRedirectArguments(argumentCollection=arguments))>
			</cfif>
		</cfif>
		<cfset renderPage(template=arguments.template)>
	</cffunction>
	

	<cffunction name="autoEdit" mixin="controller">
		<cfargument name="modelName" type="string" default="#variables.$class.autoCRUD.modelName#" hint="I am the name of the action's model (defaults to the controller's default model name).">
		<cfargument name="modelVariable" type="string" default="#arguments.modelName#" hint="I am the name of the variable used to store the action's default model (defaults to the actions model name).">
		<cfargument name="modelDisplayName" type="string" default="#Humanize(arguments.modelName)#" hint="I am the display name of the action's default model (defaults to the humanized action's model name).">
		<cfargument name="afterUpdateKey" type="string" default="#variables.$class.autoCRUD.afterCreateKey#" hint="I am the location of a key to be used after a successful update (defaults to blank).">
		<cfargument name="afterUpdateController" type="string" default="#variables.$class.autoCRUD.afterUpdateController#" hint="I am the controller to redirect to after a successful update (defaults to current controller).">
		<cfargument name="afterUpdateAction" type="string" default="#variables.$class.autoCRUD.afterUpdateAction#" hint="I am the action to redirect to after a successful update (defaults to 'index').">
		<cfargument name="afterUpdateRoute" type="string" default="#variables.$class.autoCRUD.afterUpdateRoute#" hint="I am an optional route to redirect to after a successful update (defaults to blank).">
		<cfargument name="afterUpdateMessage" type="string" default="#variables.$class.autoCRUD.afterUpdateMessage#" hint="I am an optional message to store in the flash after a successful update.">
		<cfargument name="template" type="string" default="edit" hint="I am the name of the edit action's template file.">
		<cfset variables.$autoCRUD = Duplicate(arguments)>
		<cfif not StructKeyExists(variables, arguments.modelVariable)>
			<cfset variables[arguments.modelVariable] = $loadModel(argumentCollection=arguments)>
		</cfif>
		<cfif IsObject(variables[arguments.modelVariable]) and StructKeyExists(params, arguments.modelVariable) and variables[arguments.modelVariable].update(properties=params[arguments.modelVariable])>
			<cfif Len(arguments.afterUpdateMessage)>
				<cfset flashInsert(success=Replace(arguments.afterUpdateMessage, "[modelDisplayName]", Humanize(arguments.modelName), "all"))>
			</cfif>
			<cfset arguments.actionType = "update">
			<cfset redirectTo(argumentCollection=$getRedirectArguments(argumentCollection=arguments))>
		</cfif>
		<cfset renderPage(template=arguments.template)>
	</cffunction>
	

	<cffunction name="autoDelete" mixin="controller">
		<cfargument name="modelName" type="string" default="#variables.$class.autoCRUD.modelName#" hint="I am the name of the action's model (defaults to the controller's default model name).">
		<cfargument name="modelVariable" type="string" default="#arguments.modelName#" hint="I am the name of the variable used to store the action's default model (defaults to the actions model name).">
		<cfargument name="modelDisplayName" type="string" default="#Humanize(arguments.modelName)#" hint="I am the display name of the action's default model (defaults to the humanized action's model name).">
		<cfargument name="afterDeleteKey" type="string" default="#variables.$class.autoCRUD.afterDeleteKey#" hint="I am the location of a key to be used after a successful delete (defaults to blank).">
		<cfargument name="afterDeleteController" type="string" default="#variables.$class.autoCRUD.afterDeleteController#" hint="I am the controller to redirect to after a successful delete (defaults to current controller).">
		<cfargument name="afterDeleteAction" type="string" default="#variables.$class.autoCRUD.afterDeleteAction#" hint="I am the action to redirect to after a successful delete (defaults to 'index').">
		<cfargument name="afterDeleteRoute" type="string" default="#variables.$class.autoCRUD.afterDeleteRoute#" hint="I am an optional route to redirect to after a successful delete (defaults to blank).">
		<cfargument name="afterDeleteMessage" type="string" default="#variables.$class.autoCRUD.afterDeleteMessage#" hint="I am an optional message to store in the flash after a successful delete.">
		<cfargument name="failedDeleteMessage" type="string" default="#variables.$class.autoCRUD.failedDeleteMessage#" hint="I am an optional message to store in the flash if a delete is unsuccessful.">
		<cfset variables.$autoCRUD = Duplicate(arguments)>
		<cfif not StructKeyExists(variables, arguments.modelVariable)>
			<cfset variables[arguments.modelVariable] = $loadModel(argumentCollection=arguments)>
		</cfif>
		<cfif IsObject(variables[arguments.modelVariable]) and variables[arguments.modelVariable].delete()>
			<cfif Len(arguments.afterDeleteMessage)>
				<cfset flashInsert(success=Replace(arguments.afterDeleteMessage, "[modelDisplayName]", Humanize(arguments.modelName), "all"))>
			</cfif>
		<cfelse>	
			<cfif Len(arguments.failedDeleteMessage)>
				<cfset flashInsert(error=Replace(arguments.failedDeleteMessage, "[modelDisplayName]", Humanize(arguments.modelName), "all"))>
			</cfif>
		</cfif>
		<cfset arguments.actionType = "delete">
		<cfif IsAjax()>
			<cfset renderNothing()>
		<cfelse>
			<cfset redirectTo(argumentCollection=$getRedirectArguments(argumentCollection=arguments))>
		</cfif>
	</cffunction>


	<cffunction name="autoRestore" mixin="controller">
		<cfargument name="modelName" type="string" default="#variables.$class.autoCRUD.modelName#" hint="I am the name of the action's model (defaults to the controller's default model name).">
		<cfargument name="modelVariable" type="string" default="#arguments.modelName#" hint="I am the name of the variable used to store the action's default model (defaults to the actions model name).">
		<cfargument name="modelDisplayName" type="string" default="#Humanize(arguments.modelName)#" hint="I am the display name of the action's default model (defaults to the humanized action's model name).">
		<cfargument name="afterRestoreKey" type="string" default="#variables.$class.autoCRUD.afterRestoreKey#" hint="I am the location of a key to be used after a successful restore (defaults to blank).">
		<cfargument name="afterRestoreController" type="string" default="#variables.$class.autoCRUD.afterRestoreController#" hint="I am the controller to redirect to after a successful restore (defaults to current controller).">
		<cfargument name="afterRestoreAction" type="string" default="#variables.$class.autoCRUD.afterRestoreAction#" hint="I am the action to redirect to after a successful restore (defaults to 'index').">
		<cfargument name="afterRestoreRoute" type="string" default="#variables.$class.autoCRUD.afterRestoreRoute#" hint="I am an optional route to redirect to after a successful restore (defaults to blank).">
		<cfargument name="afterRestoreMessage" type="string" default="#variables.$class.autoCRUD.afterRestoreMessage#" hint="I am an optional message to store in the flash after a successful restore.">
		<cfargument name="failedRestoreMessage" type="string" default="#variables.$class.autoCRUD.failedRestoreMessage#" hint="I am an optional message to store in the flash if a restore is unsuccessful.">
		<cfargument name="showdeleted" type="string" default="true" hint="I tell the $loadModel() method to return deleted entries otherwise there's no object to restore.">
		<cfset variables.$autoCRUD = Duplicate(arguments)>
		<cfif not StructKeyExists(variables, arguments.modelVariable)>
			<cfset variables[arguments.modelVariable] = $loadModel(argumentCollection=arguments)>
		</cfif>
		<cfset updatePropertiesStruct = {}>
		<cfset updatePropertiesStruct[get("softDeleteProperty")] = 'NULL'>
		<cfif IsObject(variables[arguments.modelVariable]) and variables[arguments.modelVariable].update(properties=updatePropertiesStruct)>
			<cfif Len(arguments.afterRestoreMessage)>
				<cfset flashInsert(success=Replace(arguments.afterRestoreMessage, "[modelDisplayName]", Humanize(arguments.modelName), "all"))>
			</cfif>
		<cfelse>	
			<cfif Len(arguments.failedRestoreMessage)>
				<cfset flashInsert(error=Replace(arguments.failedRestoreMessage, "[modelDisplayName]", Humanize(arguments.modelName), "all"))>
			</cfif>
		</cfif>
		<cfset arguments.actionType = "restore">
		<cfif IsAjax()>
			<cfset renderNothing()>
		<cfelse>
			<cfset redirectTo(argumentCollection=$getRedirectArguments(argumentCollection=arguments))>
		</cfif>
	</cffunction>



	<cffunction name="autoExpunge" mixin="controller">
		<cfargument name="modelName" type="string" default="#variables.$class.autoCRUD.modelName#" hint="I am the name of the action's model (defaults to the controller's default model name).">
		<cfargument name="modelVariable" type="string" default="#arguments.modelName#" hint="I am the name of the variable used to store the action's default model (defaults to the actions model name).">
		<cfargument name="modelDisplayName" type="string" default="#Humanize(arguments.modelName)#" hint="I am the display name of the action's default model (defaults to the humanized action's model name).">
		<cfargument name="afterExpungeKey" type="string" default="#variables.$class.autoCRUD.afterExpungeKey#" hint="I am the location of a key to be used after a successful expunge (defaults to blank).">
		<cfargument name="afterExpungeController" type="string" default="#variables.$class.autoCRUD.afterExpungeController#" hint="I am the controller to redirect to after a successful expunge (defaults to current controller).">
		<cfargument name="afterExpungeAction" type="string" default="#variables.$class.autoCRUD.afterExpungeAction#" hint="I am the action to redirect to after a successful expunge (defaults to 'index').">
		<cfargument name="afterExpungeRoute" type="string" default="#variables.$class.autoCRUD.afterExpungeRoute#" hint="I am an optional route to redirect to after a successful expunge (defaults to blank).">
		<cfargument name="afterExpungeMessage" type="string" default="#variables.$class.autoCRUD.afterExpungeMessage#" hint="I am an optional message to store in the flash after a successful expunge.">
		<cfargument name="failedExpungeMessage" type="string" default="#variables.$class.autoCRUD.failedExpungeMessage#" hint="I am an optional message to store in the flash if a expunge is unsuccessful.">
		<cfargument name="showdeleted" type="string" default="true" hint="I tell the $loadModel() method to return deleted entries otherwise there's no object to restore.">
		<cfset variables.$autoCRUD = Duplicate(arguments)>
		<cfif not StructKeyExists(variables, arguments.modelVariable)>
			<cfset variables[arguments.modelVariable] = $loadModel(argumentCollection=arguments)>
		</cfif>
		<cfif IsObject(variables[arguments.modelVariable]) and variables[arguments.modelVariable].delete(includeSoftDeletes="true", softDelete="false")>
			<cfif Len(arguments.afterExpungeMessage)>
				<cfset flashInsert(success=Replace(arguments.afterExpungeMessage, "[modelDisplayName]", Humanize(arguments.modelName), "all"))>
			</cfif>
		<cfelse>	
			<cfif Len(arguments.failedExpungeMessage)>
				<cfset flashInsert(error=Replace(arguments.failedExpungeMessage, "[modelDisplayName]", Humanize(arguments.modelName), "all"))>
			</cfif>
		</cfif>
		<cfset arguments.actionType = "expunge">
		<cfif IsAjax()>
			<cfset renderNothing()>
		<cfelse>
			<cfset redirectTo(argumentCollection=$getRedirectArguments(argumentCollection=arguments))>
		</cfif>
	</cffunction>

	<!--- internal helper methods --->

	<cffunction name="$loadModel" returntype="any" output="false" mixin="controller">
		<cfargument name="modelName" type="string" default="#variables.$class.autoCRUD.modelName#" hint="I am the name of the model (defaults to the controller's default model name).">
		<cfif StructKeyExists(variables.params, "key")>
			<cfset arguments.key = variables.params.key>
			<cfif IsDefined("arguments.showdeleted")>
				<cfset arguments.includeSoftDeletes = true>
				<cfreturn model(arguments.modelName).findByKey(argumentCollection=arguments)>
			<cfelse>
				<cfreturn model(arguments.modelName).findByKey(argumentCollection=arguments)>
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>


	<cffunction name="$getRedirectArguments" returntype="struct" output="false" mixin="controller">
		<cfargument name="actionType" type="string" required="true">
		<cfargument name="afterCreateKey" type="string" default="">
		<cfargument name="afterCreateController" type="string" default="">
		<cfargument name="afterCreateAction" type="string" default="">
		<cfargument name="afterCreateRoute" type="string" default="">
		<cfargument name="afterUpdateKey" type="string" default="">
		<cfargument name="afterUpdateController" type="string" default="">
		<cfargument name="afterUpdateAction" type="string" default="">
		<cfargument name="afterUpdateRoute" type="string" default="">
		<cfargument name="afterDeleteKey" type="string" default="">
		<cfargument name="afterDeleteController" type="string" default="">
		<cfargument name="afterDeleteAction" type="string" default="">
		<cfargument name="afterDeleteRoute" type="string" default="">
		<cfargument name="afterRestoreKey" type="string" default="">
		<cfargument name="afterRestoreController" type="string" default="">
		<cfargument name="afterRestoreAction" type="string" default="">
		<cfargument name="afterRestoreRoute" type="string" default="">

		<cfset var redirectArgs = StructNew()>
		
		<cfswitch expression="#arguments.actionType#">
			<cfcase value="create">
				<cfif Len(arguments.afterCreateRoute)>
					<cfset redirectArgs.route = arguments.afterCreateRoute>
				<cfelse>
					<cfset redirectArgs.controller = arguments.afterCreateController>
					<cfset redirectArgs.action = arguments.afterCreateAction>
				</cfif>
				<cfif Len(arguments.afterCreateKey) and IsDefined(arguments.afterCreateKey)>
					<cfset redirectArgs.key = Evaluate(arguments.afterCreateKey)>
				</cfif>
			</cfcase>
			<cfcase value="update">
				<cfif Len(arguments.afterUpdateRoute)>
					<cfset redirectArgs.route = arguments.afterUpdateRoute>
				<cfelse>
					<cfset redirectArgs.controller = arguments.afterUpdateController>
					<cfset redirectArgs.action = arguments.afterUpdateAction>
				</cfif>
				<cfif Len(arguments.afterUpdateKey) and IsDefined(arguments.afterUpdateKey)>
					<cfset redirectArgs.key = Evaluate(arguments.afterUpdateKey)>
				</cfif>
			</cfcase>
			<cfcase value="delete">
				<cfif Len(arguments.afterDeleteRoute)>
					<cfset redirectArgs.route = arguments.afterDeleteRoute>
				<cfelse>
					<cfset redirectArgs.controller = arguments.afterDeleteController>
					<cfset redirectArgs.action = arguments.afterDeleteAction>
				</cfif>
				<cfif Len(arguments.afterDeleteKey) and IsDefined(arguments.afterDeleteKey)>
					<cfset redirectArgs.key = Evaluate(arguments.afterDeleteKey)>
				</cfif>
			</cfcase>
			<cfcase value="restore">
				<cfif Len(arguments.afterRestoreRoute)>
					<cfset redirectArgs.route = arguments.afterRestoreRoute>
				<cfelse>
					<cfset redirectArgs.controller = arguments.afterRestoreController>
					<cfset redirectArgs.action = arguments.afterRestoreAction>
				</cfif>
				<cfif Len(arguments.afterRestoreKey) and IsDefined(arguments.afterRestoreKey)>
					<cfset redirectArgs.key = Evaluate(arguments.afterRestoreKey)>
				</cfif>
			</cfcase>
		</cfswitch>
		
		<cfif StructKeyExists(redirectArgs, "key") and not StructKeyExists(redirectArgs, "action")>
			<cfset redirectArgs.action = "index">
		</cfif>

		<cfif StructKeyExists(redirectArgs, "action") and not StructKeyExists(redirectArgs, "controller")>
			<cfset redirectArgs.action = variables.params.controller>
		</cfif>
		
		<cfreturn redirectArgs>
	</cffunction>


	<cffunction name="$cleanUpParams" returntype="struct" output="false" mixin="controller">
		<cfargument name="params" type="struct" required="true">
		<cfset var newParams = Duplicate(arguments.params)>
		<cfset var param = "">
		<cfloop list="#variables.$class.autoCRUD.controllerParams#" index="param">
			<cfset StructDelete(newParams, param)>
		</cfloop>
		<cfreturn newParams>
	</cffunction>
	

</cfcomponent>
