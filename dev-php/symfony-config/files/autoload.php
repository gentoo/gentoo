<?php
/* Autoloader for dev-php/symfony-config and its dependencies */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addPsr4('Symfony\\Component\\Config\\', __DIR__);

// Dependencies
$vendorDir = '/usr/share/php';
\Fedora\Autoloader\Dependencies::required(array(
	$vendorDir . '/Symfony/Component/Filesystem/autoload.php',
));
