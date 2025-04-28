<cfoutput>
<h1>cbSecurity Verify</h1>

<p>Last Verified: #prc.lastVerifyEpoch# (#dateTimeFormat(prc.lastVerifyTimestamp, "yyyy-mm-dd HH:mm:ss")#)</p>

<ul>
	<li><a href="#event.buildLink( "secure-zone" )#">Access secure zone</a></li>
	<li><a href="#event.buildLink( "main.index", { "reset": true }, false )#">Reset last verified</a></li>
	<li><a href="#event.buildLink( "logout" )#">Log out</a></li>
</ul>
</cfoutput>