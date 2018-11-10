<?php
/* Autoloader for composer/ca-bundle and its dependencies */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once 'Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addPsr4('Composer\\Semver\\', __DIR__);
