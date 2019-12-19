<?php
/* Autoloader for dev-php/PHP_Timer */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    [
		'sebastianBergmann\timer\exception' => '/Exception.php',
		'sebastianBergmann\timer\runtimeexception' => '/RuntimeException.php',
		'sebastianBergmann\timer\timer' => '/Timer.php',
    ],
    __DIR__
);
