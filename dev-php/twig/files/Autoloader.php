<?php
/* Autoloader for dev-php/twig */

if (!class_exists('Twig_Autoloader', false)) {
    // polyfill for old code
    class Twig_Autoloader {
          public static function register(){}
          public static function autoload(){}
    }
}

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addPsr0('Twig_', __DIR__.'/lib');
\Fedora\Autoloader\Autoload::addPsr4('Twig\\', __DIR__.'/src');

