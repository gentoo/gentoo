<?php
/* Autoloader for dev-php/sebastian-environment */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	[
		'sebastianbergmann\environment\console' => '/src/Console.php',
		'sebastianbergmann\environment\operatingsystem' => '/src/OperatingSystem.php',
		'sebastianbergmann\environment\runtime' => '/src/Runtime.php',
	],
	dirname(__DIR__)
);
