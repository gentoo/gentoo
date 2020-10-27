<?php
/* Autoloader for composer/ca-bundle and its dependencies */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once 'Fedora/Autoloader/autoload.php';
}

if (!\function_exists('React\Promise\resolve')) {
     require __DIR__.'/functions.php';
}

\Fedora\Autoloader\Autoload::addPsr4('React\\Promise\\', __DIR__);
