<?php
/**
 * Autoloader for justinrainbow/json-schema and its dependencies
 */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addPsr4('JsonSchema\\', __DIR__);
