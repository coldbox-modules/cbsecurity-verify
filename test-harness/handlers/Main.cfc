component {

	property name="sessionStorage" inject="SessionStorage@cbsecurity-verify";

	variables.LAST_VERIFY_TIMESTAMP_KEY = "cbsecurity-verify__lastVerifyTimestamp";

	function index( event,rc, prc ) secured {
		if ( event.getValue( "reset", false ) ) {
			variables.sessionStorage.delete( variables.LAST_VERIFY_TIMESTAMP_KEY );
		}

		prc.lastVerifyEpoch = variables.sessionStorage.get( variables.LAST_VERIFY_TIMESTAMP_KEY, 0 );
		prc.lastVerifyTimestamp = dateAdd( "s", prc.lastVerifyEpoch, "January 1 1970 00:00:00" );
	}

}