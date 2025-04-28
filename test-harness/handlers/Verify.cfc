component {

	function new( event, rc, prc ) {
		param rc._securedUrl = flash.get( "_securedUrl", "/" );
		flash.put( "_securedUrl", rc._securedUrl );
		param prc.errors = flash.get( "login_form_errors", {} );
		prc.user = cbsecure().getUser();
		event.setView( "verify/new" );
	}

}