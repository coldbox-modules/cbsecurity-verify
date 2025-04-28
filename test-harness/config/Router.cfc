component {

	function configure(){
		// Set Full Rewrites
		setFullRewrites( true );

		route( "secure-zone-handler-and-action-custom" ).to( "SecuredCustom.custom" );
		route( "secure-zone-handler-and-action" ).to( "SecuredCustom.index" );
		route( "secure-zone-custom" ).to( "Secured.custom" );
		route( "secure-zone" ).to( "Secured.index" );

		route( "/login" ).withHandler( "sessions" ).toAction( { "GET" : "new", "POST" : "create" } );

		route( "/logout", "sessions.delete" );

		resources( resource = "registrations", only = [ "new", "create" ] );

		// Conventions based routing
		route( ":handler/:action?" ).end();
	}

}