<?php
/* Autoloader for dev-php/Text_Template */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    array(
		'sebastianbergmann\\template' => '/Template.php',
		'sebastianbergmann\\template\\exception' => '/exceptions/Exception.php',
		'sebastianbergmann\\template\\invalidargumentexception' => '/exceptions/InvalidArgumentException.php',
		'sebastianbergmann\\template\\runtimeexception' => '/exceptions/RuntimeException.php',
    ),
    __DIR__
);
