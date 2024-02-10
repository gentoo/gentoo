<?php
/* Autoloader for dev-php/SabreAMF */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

Fedora\Autoloader\Autoload::addPsr0('SabreAMF_', __DIR__.'/..');
