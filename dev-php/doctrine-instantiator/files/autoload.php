<?php
/* Autoloader for dev-php/doctrine-instantiator */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

Fedora\Autoloader\Autoload::addPsr4('Doctrine\\Instantiator\\', __DIR__);
