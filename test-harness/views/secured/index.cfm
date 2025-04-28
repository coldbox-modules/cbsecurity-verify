<cfoutput>
	<h1>Secured Route</h1>
	<p>Last Verified: #prc.lastVerifyEpoch# (#dateTimeFormat(prc.lastVerifyTimestamp, "yyyy-mm-dd HH:mm:ss")#)</p>
	<hr />
	<ul>
		<li><a href="#event.buildLink( "main.index" )#">Go home</a></li>
		<li><a href="#event.buildLink( "main.index", { "reset": true } )#">Go home and reset last verified</a></li>
	</ul>

</cfoutput>