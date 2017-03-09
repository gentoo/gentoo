<?php
/* Autoloader for dev-php/sebastian-comparator */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\comparator\arraycomparator' => '/ArrayComparator.php',
		'sebastianbergmann\comparator\comparator' => '/Comparator.php',
		'sebastianbergmann\comparator\comparisonfailure' => '/ComparisonFailure.php',
		'sebastianbergmann\comparator\domnodecomparator' => '/DOMNodeComparator.php',
		'sebastianbergmann\comparator\datetimecomparator' => '/DateTimeComparator.php',
		'sebastianbergmann\comparator\doublecomparator' => '/DoubleComparator.php',
		'sebastianbergmann\comparator\exceptioncomparator' => '/ExceptionComparator.php',
		'sebastianbergmann\comparator\factory' => '/Factory.php',
		'sebastianbergmann\comparator\mockobjectcomparator' => '/MockObjectComparator.php',
		'sebastianbergmann\comparator\numericcomparator' => '/NumericComparator.php',
		'sebastianbergmann\comparator\objectcomparator' => '/ObjectComparator.php',
		'sebastianbergmann\comparator\resourcecomparator' => '/ResourceComparator.php',
		'sebastianbergmann\comparator\scalarcomparator' => '/ScalarComparator.php',
		'sebastianbergmann\comparator\splobjectstoragecomparator' => '/SplObjectStorageComparator.php',
		'sebastianbergmann\comparator\typecomparator' => '/TypeComparator.php',
	),
	__DIR__
);

\Fedora\Autoloader\Dependencies::required(array(
  '/usr/share/php/SebastianBergmann/Diff/autoload.php',
  '/usr/share/php/SebastianBergmann/Exporter/autoload.php',
));
