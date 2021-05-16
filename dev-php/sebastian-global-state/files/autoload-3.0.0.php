<?php
/* Autoloader for dev-php/sebastian-global-state */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	[
		'sebastianbergmann\globalstate\blacklist' => '/Blacklist.php',
		'sebastianbergmann\globalstate\codeexporter' => '/CodeExporter.php',
		'sebastianbergmann\globalstate\exception' => '/exceptions/Exception.php',
		'sebastianbergmann\globalstate\restorer' => '/Restorer.php',
		'sebastianbergmann\globalstate\runtimeexception' => '/exceptions/RuntimeException.php',
		'sebastianbergmann\globalstate\snapshot' => '/Snapshot.php',
	],
	__DIR__
);

// Required dependencies.
\Fedora\Autoloader\Dependencies::required([
  __DIR__."/../ObjectReflector/autoload.php",
  __DIR__."/../RecursionContext/autoload.php",
]);

