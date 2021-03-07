<?php
/* Autoloader for dev-php/sebastian-resource-operations */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\resourceoperations\resourceoperations' => '/ResourceOperations.php',
	),
	__DIR__
);
