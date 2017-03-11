<?php
/* Autoloader for dev-php/PHP_TokenStream */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    array(
		'php_token' => '/Token.php',
		'php_token_stream' => '/Token/Stream.php',
		'php_token_stream_cachingfactory' => '/Token/Stream/CachingFactory.php',
    ),
    __DIR__
);
