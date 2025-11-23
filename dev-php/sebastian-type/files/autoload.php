<?php
/* Autoloader for dev-php/sebastian-version */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    [
	'sebastianbergmann\type\callabletype' => '/CallableType.php',
	'sebastianbergmann\type\genericobjecttype' => '/GenericObjectType.php',
	'sebastianbergmann\type\iterabletype' => '/IterableType.php',
	'sebastianbergmann\type\nulltype' => '/NullType.php',
	'sebastianbergmann\type\objecttype' => '/ObjectType.php',
	'sebastianbergmann\type\simpletype' => '/SimpleType.php',
	'sebastianbergmann\type\type' => '/Type.php',
	'sebastianbergmann\type\typename' => '/TypeName.php',
	'sebastianbergmann\type\unknowntype' => '/UnknownType.php',
	'sebastianbergmann\type\voidtype' => '/VoidType.php',
	'sebastianbergmann\type\exception' => '/exception/Exception.php',
	'sebastianbergmann\type\runtimeexception' => '/exception/RuntimeException.php',
  ],
  __DIR__
);
