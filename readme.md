<p align="center">
	<img src="https://www.ortussolutions.com/__media/coldbox-185-logo.png">
	<br>
	<img src="https://www.ortussolutions.com/__media/wirebox-185.png" height="125">
	<img src="https://www.ortussolutions.com/__media/cachebox-185.png" height="125" >
	<img src="https://www.ortussolutions.com/__media/logbox-185.png"  height="125">
</p>

<p align="center">
	Copyright Since 2005 ColdBox Platform by Luis Majano and Ortus Solutions, Corp
	<br>
	<a href="https://www.coldbox.org">www.coldbox.org</a> |
	<a href="https://www.ortussolutions.com">www.ortussolutions.com</a>
</p>

----

# cbSecurity Verify

A cbSecurity add-on to verify the current logged-in user for certain routes.

## Use Case

Use this module when you want to secure a part of your site requiring users to verify their password again
even if they are already logged in.  Examples may include settings screen, changing passwords or two-factor
authentication settings, or other sensitive areas of your site.

There are no models to use with this module.  It operates off of Interceptors.

There are four settings available to configure:

```cfc
settings = {
	"verifyTimeoutSeconds" : 15 * 60, // 15 minutes, in seconds
	"verifyEvent"          : "", // required setting
	"verifyAction"         : "redirect",
	"sessionStorage"       : "SessionStorage@cbstorages"
};
```

The `verifyEvent` should point to an event that shows a form for the user to enter their password again.
The form can `POST` anywhere you'd like, but it needs to log in the user again since this module sets
the verify timestamp based on the `postLogin` event from `cbauth`.

## Welcome to ColdBox

ColdBox *Hierarchical* MVC is the de-facto enterprise-level [HMVC](https://en.wikipedia.org/wiki/Hierarchical_model%E2%80%93view%E2%80%93controller) framework for ColdFusion (CFML) developers. It's professionally backed, conventions-based, modular, highly extensible, and productive. Getting started with ColdBox is quick and painless.  ColdBox takes the pain out of development by giving you a standardized methodology for modern ColdFusion (CFML) development with features such as:

* [Conventions instead of configuration](https://coldbox.ortusbooks.com/getting-started/conventions)
* [Modern URL routing](https://coldbox.ortusbooks.com/the-basics/routing)
* [RESTFul APIs](https://coldbox.ortusbooks.com/the-basics/event-handlers/rendering-data)
* [A hierarchical approach to MVC using ColdBox Modules](https://coldbox.ortusbooks.com/hmvc/modules)
* [Event-driven programming](https://coldbox.ortusbooks.com/digging-deeper/interceptors)
* [Async and Parallel programming constructs](https://coldbox.ortusbooks.com/digging-deeper/promises-async-programming)
* [Integration & Unit Testing](https://coldbox.ortusbooks.com/testing/testing-coldbox-applications)
* [Included dependency injection](https://wirebox.ortusbooks.com)
* [Caching engine and API](https://cachebox.ortusbooks.com)
* [Logging engine](https://logbox.ortusbooks.com)
* [An extensive eco-system](https://forgebox.io)
* Much More

## Learning ColdBox

ColdBox is the defacto standard for building modern ColdFusion (CFML) applications.  It has the most extensive [documentation](https://coldbox.ortusbooks.com) of all modern web application frameworks.


If you don't like reading so much, then you can try our video learning platform: [CFCasts (www.cfcasts.com)](https://www.cfcasts.com)

## Ortus Sponsors

ColdBox is a professional open-source project and it is completely funded by the [community](https://patreon.com/ortussolutions) and [Ortus Solutions, Corp](https://www.ortussolutions.com).  Ortus Patreons get many benefits like a cfcasts account, a FORGEBOX Pro account and so much more.  If you are interested in becoming a sponsor, please visit our patronage page: [https://patreon.com/ortussolutions](https://patreon.com/ortussolutions)

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
