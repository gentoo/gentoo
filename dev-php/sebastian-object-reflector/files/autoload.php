<?php
/* Autoloader for dev-php/sebastian-object-reflector */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\objectreflector\reflector' => '/Reflector.php',
		'sebastianbergmann\objectreflector\exception' => '/Exception.php',
		'sebastianbergmann\objectreflector\invalidargumentexception' => '/InvalidArgumentException.php',
	),
	__DIR__
);
