<?php
/* Autoloader for symfony-polyfill-mbstring and its dependencies */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addPsr4('Symfony\\Polyfill\\Mbstring\\', __DIR__);

$vendorDir = '/usr/share/php';

// Dependencies
\Fedora\Autoloader\Dependencies::required(array(
  $vendorDir . '/Symfony/Polyfill/Mbstring/bootstrap.php',
));
