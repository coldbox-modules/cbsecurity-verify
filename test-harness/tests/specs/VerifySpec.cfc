component extends="coldbox.system.testing.BaseTestCase" appMapping="root" {

	property name="sessionStorage" inject="SessionStorage@cbsecurity-verify";
	property name="cbsecure"       inject="cbSecurity@cbsecurity";

	variables.LAST_VERIFY_TIMESTAMP_KEY = "cbsecurity-verify__lastVerifyTimestamp";

	function beforeAll(){
		super.beforeAll();
		getWireBox().autowire( this );
	}

	function run(){
		describe( "cbsecurity-verify", () => {
			beforeEach( () => setup() );
			afterEach( () => variables.cbsecure.getAuthService().quietLogout() );

			it( "redirects the user to verify their password if the user has not verified lately", () => {
				var john = getInstance( "User" ).retrieveUserById( 1 );
				variables.cbsecure.getAuthService().login( john );
				var twentyMinutesAgo = getCurrentUnixTimestamp( -1 * 20 * 60 );
				variables.sessionStorage.set( variables.LAST_VERIFY_TIMESTAMP_KEY, twentyMinutesAgo );

				var event = get( "/secure-zone" );
				var rc    = event.getCollection();
				expect( rc ).toHaveKey( "relocate_EVENT" );
				expect( rc.relocate_EVENT ).toBe( "Verify.new" );
			} );

			it( "does not redirect the user to verify their password if the user has verified lately", () => {
				var john = getInstance( "User" ).retrieveUserById( 1 );
				variables.cbsecure.getAuthService().login( john );
				var tenMinutesAgo = getCurrentUnixTimestamp( -1 * 10 * 60 );
				variables.sessionStorage.set( variables.LAST_VERIFY_TIMESTAMP_KEY, tenMinutesAgo );

				var event = get( "/secure-zone" );
				var rc    = event.getCollection();
				expect( rc ).notToHaveKey( "relocate_EVENT" );
			} );

			it( "redirects to the login event if the user is not logged in", () => {
				variables.sessionStorage.delete( variables.LAST_VERIFY_TIMESTAMP_KEY );

				var event = get( "/secure-zone" );
				var rc    = event.getCollection();
				expect( rc ).toHaveKey( "relocate_EVENT" );
				expect( rc.relocate_EVENT ).toBe( "sessions.new" );
			} );

			it( "can set a custom timeout in minutes in the annotation", () => {
				var john = getInstance( "User" ).retrieveUserById( 1 );
				variables.cbsecure.getAuthService().login( john );
				var tenMinutesAgo = getCurrentUnixTimestamp( -1 * 10 * 60 );
				variables.sessionStorage.set( variables.LAST_VERIFY_TIMESTAMP_KEY, tenMinutesAgo );

				var event = get( "/secure-zone-custom" );
				var rc    = event.getCollection();
				expect( rc ).toHaveKey( "relocate_EVENT" );
				expect( rc.relocate_EVENT ).toBe( "Verify.new" );
			} );

			it( "can verify an entire handler", () => {
				var john = getInstance( "User" ).retrieveUserById( 1 );
				variables.cbsecure.getAuthService().login( john );
				var twentyMinutesAgo = getCurrentUnixTimestamp( -1 * 20 * 60 );
				variables.sessionStorage.set( variables.LAST_VERIFY_TIMESTAMP_KEY, twentyMinutesAgo );

				var event = get( "/secure-zone-handler-and-action" );
				var rc    = event.getCollection();
				expect( rc ).toHaveKey( "relocate_EVENT" );
				expect( rc.relocate_EVENT ).toBe( "Verify.new" );
			} );

			it( "checks the action for annotations even if the handler has an annotation", () => {
				var john = getInstance( "User" ).retrieveUserById( 1 );
				variables.cbsecure.getAuthService().login( john );
				var tenMinutesAgo = getCurrentUnixTimestamp( -1 * 10 * 60 );
				variables.sessionStorage.set( variables.LAST_VERIFY_TIMESTAMP_KEY, tenMinutesAgo );

				var event = get( "/secure-zone-handler-and-action-custom" );
				var rc    = event.getCollection();
				expect( rc ).toHaveKey( "relocate_EVENT" );
				expect( rc.relocate_EVENT ).toBe( "Verify.new" );
			} );
		} );
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
