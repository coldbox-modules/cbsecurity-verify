component accessors="true" {

	property name="id";
	property name="email";
	property name="password";

	this.memento = { "defaultExcludes" : [ "id" ], "neverInclude" : [ "password" ] };

	public boolean function hasPermission( required string permission ){
		return true;
	}

	public boolean function isValidCredentials( required string email, required string password ){
		return arguments.email == "john@example.com" && arguments.password == "password";
	}

	public User function retrieveUserByUsername( required string email ){
		if ( arguments.email != "john@example.com" ) {
			throw( type = "EntityNotFound", message = "User not found" );
		}

		setId( 1 );
		setEmail( "john@example.com" );
		setPassword( "password" );
		return this;
	}

	public User function retrieveUserById( required numeric id ){
		if ( arguments.id != 1 ) {
			throw( type = "EntityNotFound", message = "User not found" );
		}

		setId( 1 );
		setEmail( "john@example.com" );
		setPassword( "password" );
		return this;
	}

}