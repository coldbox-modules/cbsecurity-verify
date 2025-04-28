component accessors="true" extends="coldbox.system.Interceptor" {

	// DI
	property name="handlerService"       inject="coldbox:handlerService";
	property name="invalidEventHandler"  inject="coldbox:setting:invalidEventHandler";
	property name="sessionStorage"       inject="SessionStorage@cbsecurity-verify";
	property name="verifyTimeoutSeconds" inject="coldbox:setting:verifyTimeoutSeconds@cbsecurity-verify";
	property name="verifyEvent"          inject="coldbox:setting:verifyEvent@cbsecurity-verify";
	property name="verifyAction"         inject="coldbox:setting:verifyAction@cbsecurity-verify";

	variables.LAST_VERIFY_TIMESTAMP_KEY = "cbsecurity-verify__lastVerifyTimestamp";

	/**
	 * Configure the security firewall
	 */
	function configure(){
		if ( !len( variables.verifyEvent ) ) {
			throw( "You must configure a verify event to use cbsecurity-verify" );
		}

		// Coldbox version 5 (and lower) needs a little extra invalid event handler checking.
		variables.enableInvalidHandlerCheck = (
			listGetAt(
				controller.getColdboxSettings().version,
				1,
				"."
			) <= 5
		);

		log.info( "√ CBSecurity Firewall started and configured." );
	}

	/**
	 * Listen when modules are activated to load their cbSecurity capabilities
	 */
	function afterAspectsLoad( event, interceptData ){
		// Once ColdBox has loaded, load up the invalid event bean
		variables.onInvalidEventHandlerBean = javacast( "null", "" );
		if ( len( variables.invalidEventHandler ) ) {
			variables.onInvalidEventHandlerBean = variables.handlerService.getHandlerBean(
				variables.invalidEventHandler
			);
		}
	}

	/**
	 * Listens to preProcess events to check if the user needs to verify their credentials
	 */
	function preProcess( event, interceptData ){
		// Get handler bean for the current event
		var handlerBean = variables.handlerService.getHandlerBean( arguments.event.getCurrentEvent() );

		// Are we running Coldbox 5 or older?
		// is an onInvalidHandlerBean configured?
		// is the current handlerBean the configured onInvalidEventHandlerBean?
		if (
			variables.enableInvalidHandlerCheck &&
			!isNull( variables.onInvalidEventHandlerBean ) &&
			isInvalidEventHandlerBean( handlerBean )
		) {
			// ColdBox tries to detect invalid event handler loops by keeping
			// track of the last invalid event to fire.  If that invalid event
			// fires twice, it throws a hard exception to prevent infinite loops.
			// Unfortunately for us, just attempting to get a handler bean
			// starts the invalid event handling.  Here, if we got the invalid
			// event handler bean back, we reset the `_lastInvalidEvent` so
			// ColdBox can handle the invalid event properly.
			request._lastInvalidEvent = variables.invalidEventHandler;
			return;
		}

		if ( handlerBean.getHandler() == "" ) {
			return;
		}

		// If metadata is not loaded, load it
		if ( !handlerBean.isMetadataLoaded() ) {
			variables.handlerService.getHandler( handlerBean, arguments.event );
		}

		// check for secured annotation
		var handlerSecuredAnnotation = handlerBean.getHandlerMetadata( "secured", false );
		var actionSecuredAnnotation  = handlerBean.getActionMetadata( "secured", false )

		var securedAnnotation = handlerSecuredAnnotation;
		if (
			len( actionSecuredAnnotation ) > 0 && !( isBoolean( actionSecuredAnnotation ) && !actionSecuredAnnotation )
		) {
			securedAnnotation = actionSecuredAnnotation;
		}

		if ( len( securedAnnotation ) <= 0 || ( isBoolean( securedAnnotation ) && !securedAnnotation ) ) {
			// No secured annotation OR secured=false
			return true;
		}

		writeDump( var = securedAnnotation );
		writeDump( var = listFindNoCase( securedAnnotation, "verify" ) );

		var verifyAnnotations = listToArray( securedAnnotation, "," ).filter( ( permission ) => {
			return findNoCase( "verify", permission ) > 0;
		} );

		// check for `verify` inside secured annotation
		if ( verifyAnnotations.isEmpty() ) {
			// This is not verifying credentials
			return true;
		}

		var verifyAnnotation = verifyAnnotations.first();

		// check for verify session variable
		var verifyTimestamp = variables.sessionStorage.get( variables.LAST_VERIFY_TIMESTAMP_KEY, 0 );

		var timeoutSeconds = listLen( verifyAnnotation, ":" ) > 1 ? listLast( verifyAnnotation, ":" ) : variables.verifyTimeoutSeconds;

		if ( ( getCurrentUnixTimestamp() - verifyTimestamp ) < timeoutSeconds ) {
			// We are still in the timeout period
			return true;
		}

		// At this point, we need to verify the user's credentials
		saveSecuredUrl( arguments.event );
		return processVerifyAction(
			variables.verifyEvent,
			variables.verifyAction,
			arguments.event
		);
	}

	function postLogin( event, interceptData ){
		variables.sessionStorage.set( variables.LAST_VERIFY_TIMESTAMP_KEY, getCurrentUnixTimestamp() );
	}

	function postLogout( event, interceptData ){
		variables.sessionStorage.delete( variables.LAST_VERIFY_TIMESTAMP_KEY );
	}

	/********************************* PRIVATE ******************************/

	/**
	 * Process invalid actions on a rule
	 *
	 * @rule  The offending rule
	 * @event The request context
	 * @type  The invalid type: authentication or authorization
	 */
	private function processVerifyAction(
		required verifyEvent,
		required verifyAction,
		required event
	){
		switch ( arguments.verifyAction ) {
			case "redirect": {
				// Are we relocating to an event or to an http? location
				if ( reFindNoCase( "^http?:", arguments.verifyEvent ) ) {
					// Relocate now
					relocate(
						URL     = arguments.verifyEvent,
						persist = "_securedURL",
						// TODO: Chain SSL: Global, rule, request
						ssl     = arguments.event.isSSL()
					);
				} else {
					// Relocate now
					relocate(
						event   = arguments.verifyEvent,
						persist = "_securedURL",
						// TODO: Chain SSL: Global, rule, request
						ssl     = arguments.event.isSSL()
					);
				}

				break;
			}

			case "override": {
				arguments.event.overrideEvent( event = arguments.verifyEvent );
				break;
			}

			default: {
				throw(
					message = "The type [#arguments.verifyAction#] is not a valid rule action.  Valid types are [ 'redirect', 'override' ].",
					type    = "InvalidRuleActionType"
				);
			}
		}
	}

	/**
	 * Flash the incoming secured Url so we can redirect to it or use it in the next request.
	 *
	 * @event The event object
	 */
	private function saveSecuredUrl( required event ){
		var securedUrl = arguments.event.getFullUrl();

		if ( arguments.event.isSES() ) {
			securedURL = arguments.event.buildLink(
				to          = event.getCurrentRoutedURL(),
				queryString = CGI.QUERY_STRING,
				translate   = false
			);
		}

		// Flash it and place it in RC as well
		flash.put( "_securedUrl", securedUrl );
		arguments.event.setValue( "_securedUrl", securedUrl );
	}

	/**
	 * Returns true of the passed handlerBean matches Coldbox's configured invalid event handler.
	 *
	 * @handlerBean the current handler bean to check against
	 */
	private boolean function isInvalidEventHandlerBean( required handlerBean ){
		return (
			variables.onInvalidEventHandlerBean.getInvocationPath() == arguments.handlerBean.getInvocationPath() &&
			variables.onInvalidEventHandlerBean.getHandler() == arguments.handlerBean.getHandler() &&
			variables.onInvalidEventHandlerBean.getMethod() == arguments.handlerBean.getMethod() &&
			variables.onInvalidEventHandlerBean.getModule() == arguments.handlerBean.getModule()
		);
	}

	/**
	 * Gets the current UNIX timestamp.
	 *
	 * @delay The delay, in seconds, to add to the current timestamp
	 *
	 * @return int
	 */
	public numeric function getCurrentUnixTimestamp( numeric delay = 0 ){
		return createObject( "java", "java.time.Instant" ).now().getEpochSecond() + arguments.delay;
	}

}
