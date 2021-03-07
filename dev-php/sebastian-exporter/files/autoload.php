<?php
/* Autoloader for dev-php/sebastian-exporter */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\exporter\exporter' => '/Exporter.php',
	),
	__DIR__
);

\Fedora\Autoloader\Dependencies::required(array(
  '/usr/share/php/SebastianBergmann/RecursionContext/autoload.php',
));
