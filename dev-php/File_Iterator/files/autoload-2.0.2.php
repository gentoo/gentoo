<?php
/* Autoloader for dev-php/File_Iterator */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    [
		'sebastianbergmann\\fileiterator\\facade' => '/Facade.php',
		'sebastianbergmann\\fileiterator\\factory' => '/Factory.php',
		'sebastianbergmann\\fileiterator\\iterator' => '/Iterator.php',
    ],
    __DIR__
);
