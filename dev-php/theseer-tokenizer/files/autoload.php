<?php
/* Autoloader for dev-php/theseer-tokenizer */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once 'Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
   [
		'theseer\\tokenizer\\exception' => '/Exception.php',
		'theseer\\tokenizer\\namespaceuri' => '/NamespaceUri.php',
		'theseer\\tokenizer\\namespaceuriexception' => '/NamespaceUriException.php',
		'theseer\\tokenizer\\token' => '/Token.php',
		'theseer\\tokenizer\\tokencollection' => '/TokenCollection.php',
		'theseer\\tokenizer\\tokencollectionexception' => '/TokenCollectionException.php',
		'theseer\\tokenizer\\tokenizer' => '/Tokenizer.php',
		'theseer\\tokenizer\\xmlserializer' => '/XMLSerializer.php',
	],
	__DIR__
);
