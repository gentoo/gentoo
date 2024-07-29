<?php
/* Autoloader for dev-php/sebastian-diff */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
	require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
	array(
		'sebastianbergmann\diff\chunk' => '/Chunk.php',
		'sebastianbergmann\diff\diff' => '/Diff.php',
		'sebastianbergmann\diff\differ' => '/Differ.php',
		'sebastianbergmann\diff\line' => '/Line.php',
		'sebastianbergmann\diff\longestcommonsubsequencecalculator' => '/LongestCommonSubsequenceCalculator.php',
		'sebastianbergmann\diff\memoryefficientlongestcommonsubsequencecalculator' => '/MemoryEfficientLongestCommonSubsequenceCalculator.php',
		'sebastianbergmann\diff\parser' => '/Parser.php',
		'sebastianbergmann\diff\timeefficientlongestcommonsubsequencecalculator' => '/TimeEfficientLongestCommonSubsequenceCalculator.php',
		'sebastianbergmann\diff\configurationexception' => '/Exception/ConfigurationException.php',
                'sebastianbergmann\diff\exception' => '/Exception/Exception.php',
                'sebastianbergmann\diff\invalidargumentexception' => '/Exception/InvalidArgumentException.php',
		'sebastianbergmann\diff\output\abstractchunkoutputbuilder' => '/Output/AbstractChunkOutputBuilder.php',
		'sebastianbergmann\diff\output\diffonlyoutputbuilder' => '/Output/DiffOnlyOutputBuilder.php',
		'sebastianbergmann\diff\output\diffoutputbuilderinterface' => '/Output/DiffOutputBuilderInterface.php',
		'sebastianbergmann\diff\output\strictunifieddiffoutputbuilder' => '/Output/StrictUnifiedDiffOutputBuilder.php',
		'sebastianbergmann\diff\output\unifieddiffoutputbuilder' => '/Output/UnifiedDiffOutputBuilder.php',
	),
	__DIR__
);
