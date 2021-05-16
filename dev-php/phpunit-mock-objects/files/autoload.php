<?php
/* Autoloader for dev-php/sebastian-diff */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'phpunit_framework_mockobject_badmethodcallexception' => '/Exception/BadMethodCallException.php',
		'phpunit_framework_mockobject_builder_identity' => '/Builder/Identity.php',
		'phpunit_framework_mockobject_builder_invocationmocker' => '/Builder/InvocationMocker.php',
		'phpunit_framework_mockobject_builder_match' => '/Builder/Match.php',
		'phpunit_framework_mockobject_builder_methodnamematch' => '/Builder/MethodNameMatch.php',
		'phpunit_framework_mockobject_builder_namespace' => '/Builder/Namespace.php',
		'phpunit_framework_mockobject_builder_parametersmatch' => '/Builder/ParametersMatch.php',
		'phpunit_framework_mockobject_builder_stub' => '/Builder/Stub.php',
		'phpunit_framework_mockobject_exception' => '/Exception/Exception.php',
		'phpunit_framework_mockobject_generator' => '/Generator.php',
		'phpunit_framework_mockobject_invocation' => '/Invocation.php',
		'phpunit_framework_mockobject_invocationmocker' => '/InvocationMocker.php',
		'phpunit_framework_mockobject_invocation_object' => '/Invocation/Object.php',
		'phpunit_framework_mockobject_invocation_static' => '/Invocation/Static.php',
		'phpunit_framework_mockobject_invokable' => '/Invokable.php',
		'phpunit_framework_mockobject_matcher' => '/Matcher.php',
		'phpunit_framework_mockobject_matcher_anyinvokedcount' => '/Matcher/AnyInvokedCount.php',
		'phpunit_framework_mockobject_matcher_anyparameters' => '/Matcher/AnyParameters.php',
		'phpunit_framework_mockobject_matcher_consecutiveparameters' => '/Matcher/ConsecutiveParameters.php',
		'phpunit_framework_mockobject_matcher_invocation' => '/Matcher/Invocation.php',
		'phpunit_framework_mockobject_matcher_invokedatindex' => '/Matcher/InvokedAtIndex.php',
		'phpunit_framework_mockobject_matcher_invokedatleastcount' => '/Matcher/InvokedAtLeastCount.php',
		'phpunit_framework_mockobject_matcher_invokedatleastonce' => '/Matcher/InvokedAtLeastOnce.php',
		'phpunit_framework_mockobject_matcher_invokedatmostcount' => '/Matcher/InvokedAtMostCount.php',
		'phpunit_framework_mockobject_matcher_invokedcount' => '/Matcher/InvokedCount.php',
		'phpunit_framework_mockobject_matcher_invokedrecorder' => '/Matcher/InvokedRecorder.php',
		'phpunit_framework_mockobject_matcher_methodname' => '/Matcher/MethodName.php',
		'phpunit_framework_mockobject_matcher_parameters' => '/Matcher/Parameters.php',
		'phpunit_framework_mockobject_matcher_statelessinvocation' => '/Matcher/StatelessInvocation.php',
		'phpunit_framework_mockobject_mockbuilder' => '/MockBuilder.php',
		'phpunit_framework_mockobject_mockobject' => '/MockObject.php',
		'phpunit_framework_mockobject_runtimeexception' => '/Exception/RuntimeException.php',
		'phpunit_framework_mockobject_stub' => '/Stub.php',
		'phpunit_framework_mockobject_stub_consecutivecalls' => '/Stub/ConsecutiveCalls.php',
		'phpunit_framework_mockobject_stub_exception' => '/Stub/Exception.php',
		'phpunit_framework_mockobject_stub_matchercollection' => '/Stub/MatcherCollection.php',
		'phpunit_framework_mockobject_stub_return' => '/Stub/Return.php',
		'phpunit_framework_mockobject_stub_returnargument' => '/Stub/ReturnArgument.php',
		'phpunit_framework_mockobject_stub_returncallback' => '/Stub/ReturnCallback.php',
		'phpunit_framework_mockobject_stub_returnreference' => '/Stub/ReturnReference.php',
		'phpunit_framework_mockobject_stub_returnself' => '/Stub/ReturnSelf.php',
		'phpunit_framework_mockobject_stub_returnvaluemap' => '/Stub/ReturnValueMap.php',
		'phpunit_framework_mockobject_verifiable' => '/Verifiable.php',
	),
	__DIR__
);

\Fedora\Autoloader\Dependencies::required(array(
  '/usr/share/php/Doctrine/Instantiator/autoload.php',
  '/usr/share/php/SebastianBergmann/Exporter/autoload.php',
  '/usr/share/php/Text/Template/autoload.php',
));
