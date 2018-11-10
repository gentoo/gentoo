<?php
/* Autoloader for dev-php/phpdocumentor-reflection-common */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

Fedora\Autoloader\Autoload::addPsr4('phpDocumentor\\Reflection\\', __DIR__);

\Fedora\Autoloader\Dependencies::required(array(
  '/usr/share/php/phpDocumentor/TypeResolver/autoload.php',
  '/usr/share/php/phpDocumentor/ReflectionCommon/autoload.php',
  '/usr/share/php/Webmozart/Assert/autoload.php',
));
