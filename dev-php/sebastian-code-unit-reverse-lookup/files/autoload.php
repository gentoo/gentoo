<?php
/* Autoloader for dev-php/sebastian-diff */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\codeunitreverselookup\wizard' => '/Wizard.php',
	),
	__DIR__
);
