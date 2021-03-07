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
		'sebastianbergmann\diff\parser' => '/Parser.php',
		'sebastianbergmann\diff\lcs\longestcommonsubsequence' => '/LCS/LongestCommonSubsequence.php',
                'sebastianbergmann\diff\lcs\memoryefficientimplementation' => '/LCS/MemoryEfficientLongestCommonSubsequenceImplementation.php',
		'sebastianbergmann\diff\lcs\timeefficientimplementation' => '/LCS/TimeEfficientLongestCommonSubsequenceImplementation.php',
	),
	__DIR__
);
