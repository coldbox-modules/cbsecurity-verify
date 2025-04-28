/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component {

	// Module Properties
	this.title       = "cbSecurity Verify";
	this.author      = "Ortus Solutions";
	this.webURL      = "https://www.ortussolutions.com";
	this.description = "A cbSecurity add-on to verify the current logged-in user for certain routes.";
	this.version     = "@build.version@+@build.number@";

	// Model Namespace
	this.modelNamespace = "cbsecurity-verify";

	// CF Mapping
	this.cfmapping = "cbsecurity-verify";

	// Dependencies
	this.dependencies = [ "cbsecurity", "cbstorages" ];

	/**
	 * Configure Module
	 */
	function configure(){
		settings = {
			"verifyTimeoutSeconds" : 15 * 60, // 15 minutes, in seconds
			"verifyEvent"          : "",
			"verifyAction"         : "redirect",
			"sessionStorage"       : "SessionStorage@cbstorages"
		};

		binder.map( "SessionStorage@cbsecurity-verify" ).toDSL( settings.sessionStorage );

		interceptors = [
			{
				"class"      : "#moduleMapping#.interceptors.VerifyInterceptor",
				"properties" : {}
			}
		];
	}

}
