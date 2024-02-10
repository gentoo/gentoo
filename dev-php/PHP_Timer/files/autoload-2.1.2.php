<?php
/* Autoloader for dev-php/PHP_Timer */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    [
		'sebastianbergmann\timer\exception' => '/Exception.php',
		'sebastianbergmann\timer\runtimeexception' => '/RuntimeException.php',
		'sebastianbergmann\timer\timer' => '/Timer.php',
    ],
    __DIR__
);
