<?php
/* Autoloader for dev-php/sebastian-complexity */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	[
		'sebastianbergmann\complexity\calculator' => '/Calculator.php',
		'sebastianbergmann\complexity\complexity' => '/Complexity/Complexity.php',
		'sebastianbergmann\complexity\complexitycollection' => '/Complexity/ComplexityCollection.php',
		'sebastianbergmann\complexity\complexitycollectioniterator' => '/Complexity/ComplexityCollectionIterator.php',
		'sebastianbergmann\complexity\complexitycalculatingvisitor' => '/Visitor/ComplexityCalculatingVisitor.php',
		'sebastianbergmann\complexity\cyclomaticcomplexitycalculatingvisitor' => '/Visitor/CyclomaticComplexityCalculatingVisitor.php',
		'sebastianbergmann\complexity\exception' => '/Exception/Exception.php',
		'sebastianbergmann\complexity\runtimeexception' => '/Exception/RuntimeException.php',
	],
	__DIR__
);
