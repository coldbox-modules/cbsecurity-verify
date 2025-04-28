<cfoutput>
    <h3>Verify your password</h3>
    <hr />
    <cfif prc.errors.keyExists( "login" )>
        <p class="alert alert-danger">#prc.errors.login#</p>
    </cfif>
    <form method="POST" action="#event.buildLink( "login" )#">
        <input type="hidden" name="_token" value="#csrfGenerateToken()#" />
		<input name="email" type="hidden" class="form-control" id="email" value="#prc.user.getEmail()#" />
        <div class="form-group">
            <label for="password">Password:</label>
            <input name="password" type="password" class="form-control" id="password" />
            <cfif prc.errors.keyExists( "password" )>
                <small class="form-text text-danger">
                    <cfloop array="#prc.errors.password#" index="error">
                        <p>#error.message#</p>
                    </cfloop>
                </small>
            </cfif>
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary">Verify</button>
        </div>
    </form>
</cfoutput>