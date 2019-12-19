<?php
/* Autoloader for dev-php/sebastian-version */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    [
	'sebastianbergmann\objectreflector\exception' => '/Exception.php',
	'sebastianbergmann\objectreflector\invalidargumentexception' => '/InvalidArgumentException.php',
	'sebastianbergmann\objectreflector\objectreflector' => '/ObjectReflector.php',
  ],
  __DIR__
);
