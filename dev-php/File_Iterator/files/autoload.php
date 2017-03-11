<?php
/* Autoloader for dev-php/File_Iterator */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    array(
		'file_iterator' => '/Iterator.php',
		'file_iterator_facade' => '/Facade.php',
		'file_iterator_factory' => '/Factory.php',
    ),
    __DIR__
);
