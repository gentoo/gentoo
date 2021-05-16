<?php
/* Autoloader for dev-php/sebastian-environment */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\environment\console' => '/Console.php',
		'sebastianbergmann\environment\runtime' => '/Runtime.php',
	),
	__DIR__
);
