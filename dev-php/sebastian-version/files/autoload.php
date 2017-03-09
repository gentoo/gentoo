<?php
/* Autoloader for dev-php/sebastian-version */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    array(
	'sebastianbergmann\version' => '/../Version.php',
  ),
  __DIR__
);
