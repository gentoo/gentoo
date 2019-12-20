<?php
/* Autoloader for dev-php/PHP_CodeCoverage */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addPsr4('SebastianBergmann\\CodeCoverage\\', __DIR__);

\Fedora\Autoloader\Dependencies::required(array(
	'/usr/share/php/File/Iterator/autoload.php',
	'/usr/share/php/PHP/Token/autoload.php',
	'/usr/share/php/SebastianBergmann/Version/autoload.php',
	'/usr/share/php/SebastianBergmann/Environment/autoload.php',
	'/usr/share/php/SebastianBergmann/CodeUnitReverseLookup/autoload.php',
	'/usr/share/php/Text/Template/autoload.php',
));
