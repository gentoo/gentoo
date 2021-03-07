<?php
/* Autoloader for dev-php/sebastian-global-state */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\globalstate\blacklist' => '/Blacklist.php',
		'sebastianbergmann\globalstate\codeexporter' => '/CodeExporter.php',
		'sebastianbergmann\globalstate\exception' => '/Exception.php',
		'sebastianbergmann\globalstate\restorer' => '/Restorer.php',
		'sebastianbergmann\globalstate\runtimeexception' => '/RuntimeException.php',
		'sebastianbergmann\globalstate\snapshot' => '/Snapshot.php',
	),
	__DIR__
);
