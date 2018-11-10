<?php
/* Autoloader for dev-php/webmozart-assert */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

Fedora\Autoloader\Autoload::addPsr4('Webmozart\\Assert\\', __DIR__);
