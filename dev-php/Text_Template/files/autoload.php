<?php
/* Autoloader for dev-php/Text_Template */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    array(
		'text_template' => '/Template.php',
    ),
    __DIR__
);
