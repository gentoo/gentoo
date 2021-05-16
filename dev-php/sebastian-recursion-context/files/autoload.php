<?php
/* Autoloader for dev-php/sebastian-recursion-context */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\recursioncontext\context' => '/Context.php',
		'sebastianbergmann\recursioncontext\exception' => '/Exception.php',
		'sebastianbergmann\recursioncontext\invalidargumentexception' => '/InvalidArgumentException.php',
	),
	__DIR__
);
