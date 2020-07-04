<?php
/* Autoloader for dev-php/sebastian-object-enumerator */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	[
		'sebastianbergmann\objectenumerator\enumerator' => '/Enumerator.php',
		'sebastianbergmann\objectenumerator\exception' => '/Exception.php',
		'sebastianbergmann\objectenumerator\invalidargumentexception' => '/InvalidArgumentException.php',
	],
	__DIR__
);

\Fedora\Autoloader\Dependencies::required([
  __DIR__.'/../ObjectReflector/autoload.php',
  __DIR__.'/../RecursionContext/autoload.php',
]);
