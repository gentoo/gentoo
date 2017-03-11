<?php
/* Autoloader for dev-php/phpspec-prophecy */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

Fedora\Autoloader\Autoload::addPsr0('Prophecy\\', __DIR__);

\Fedora\Autoloader\Dependencies::required(array(
  '/usr/share/php/phpDocumentor/ReflectionDocBlock/autoload.php',
  '/usr/share/php/SebastianBergmann/Comparator/autoload.php',
  '/usr/share/php/Doctrine/Instantiator/autoload.php',
  '/usr/share/php/SebastianBergmann/RecursionContext/autoload.php',
));
