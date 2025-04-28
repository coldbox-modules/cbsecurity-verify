component {

	property name="sessionStorage" inject="SessionStorage@cbsecurity-verify";

	variables.LAST_VERIFY_TIMESTAMP_KEY = "cbsecurity-verify__lastVerifyTimestamp";

	function index( event, rc, prc ) secured="verify" {
		prc.lastVerifyEpoch = variables.sessionStorage.get( variables.LAST_VERIFY_TIMESTAMP_KEY, 0 );
		prc.lastVerifyTimestamp = dateAdd( "s", prc.lastVerifyEpoch, "January 1 1970 00:00:00" );
		event.setView( "secured/index" );
	}

	function custom( event, rc, prc ) secured="verify:5" {
		prc.lastVerifyEpoch = variables.sessionStorage.get( variables.LAST_VERIFY_TIMESTAMP_KEY, 0 );
		prc.lastVerifyTimestamp = dateAdd( "s", prc.lastVerifyEpoch, "January 1 1970 00:00:00" );
		event.setView( "secured/index" );
	}

}