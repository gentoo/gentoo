<?php
/* Autoloader for dev-php/myclabs-deepcopy */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

Fedora\Autoloader\Autoload::addPsr4('DeepCopy\\', __DIR__);
