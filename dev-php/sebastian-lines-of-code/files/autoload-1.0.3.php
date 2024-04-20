<?php
/* Autoloader for dev-php/sebastian-linesofcode */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	[
		'sebastianbergmann\linesofcode\linesofcode' => '/LinesOfCode.php',
		'sebastianbergmann\linesofcode\linecountingvisitor' => '/LineCountingVisitor.php',
		'sebastianbergmann\linesofcode\counter' => '/Counter.php',
		'sebastianbergmann\linesofcode\exception' => '/Exception/Exception.php',
		'sebastianbergmann\linesofcode\illogicalvaluesexception' => '/Exception/IllogicalValuesException.php',
		'sebastianbergmann\linesofcode\negativevalueexception' => '/Exception/NegativeValueException.php',
		'sebastianbergmann\linesofcode\runtimeexception' => '/Exception/RuntimeException.php',
	],
	__DIR__
);
