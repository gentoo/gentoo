<?php
/* Autoloader for dev-php/PHP_Timer */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    [
		'sebastianbergmann\timer\duration' => '/Duration.php',
		'sebastianbergmann\timer\exception' => '/exceptions/Exception.php',
		'sebastianbergmann\timer\noactivetimerexception' => '/exceptions/NoActiveTimerException.php',
		'sebastianbergmann\timer\resourceusageformatter' => '/ResourceUsageFormatter.php',
		'sebastianbergmann\timer\timer' => '/Timer.php',
		'sebastianbergmann\timer\timesincestartofrequestnotavailableexception' => '/exceptions/TimeSinceStartOfRequestNotAvailableException.php',
    ],
    __DIR__
);
