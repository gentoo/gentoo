<?php
/* Autoloader for dev-php/symfony-cache and its dependencies */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addPsr4('Symfony\\Component\\Cache\\', __DIR__);

$vendorDir = '/usr/share/php';
\Fedora\Autoloader\Dependencies::required(array(
	$vendorDir . '/Psr/Cache/autoload.php',
	$vendorDir . '/Psr/Log/autoload.php',
));
