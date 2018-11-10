<?php
/* Autoloader for dev-php/PHP_CodeCoverage */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
    array(
		'sebastianbergmann\codecoverage\codecoverage' => '/CodeCoverage.php',
		'sebastianbergmann\codecoverage\filter' => '/Filter.php',
		'sebastianbergmann\codecoverage\util' => '/Util.php',
		'sebastianbergmann\codecoverage\driver\driver' => '/Driver/Driver.php',
		'sebastianbergmann\codecoverage\driver\hhvm' => '/Driver/HHVM.php',
		'sebastianbergmann\codecoverage\driver\phpdbg' => '/Driver/PHPDBG.php',
		'sebastianbergmann\codecoverage\driver\xdebug' => '/Driver/Xdebug.php',
		'sebastianbergmann\codecoverage\exception\coveredcodenotexecutedexception' => '/Exception/CoveredCodeNotExecutedException.php',
		'sebastianbergmann\codecoverage\exception\exception' => '/Exception/Exception.php',
		'sebastianbergmann\codecoverage\exception\invalidargumentexception' => '/Exception/InvalidArgumentException.php',
		'sebastianbergmann\codecoverage\exception\missingcoversannotationexception' => '/Exception/MissingCoversAnnotationException.php',
		'sebastianbergmann\codecoverage\exception\runtimeexception' => '/Exception/RuntimeException.php',
		'sebastianbergmann\codecoverage\exception\unintentiallycoveredcodeexception' => '/Exception/UnintentionallyCoveredCodeException.php',
		'sebastianbergmann\codecoverage\node\abstractnode' => '/Node/AbstractNode.php',
		'sebastianbergmann\codecoverage\node\builder' => '/Node/Builder.php',
		'sebastianbergmann\codecoverage\node\directory' => '/Node/Directory.php',
		'sebastianbergmann\codecoverage\node\file' => '/Node/File.php',
		'sebastianbergmann\codecoverage\node\iterator' => '/Node/iterator.php',
		'sebastianbergmann\codecoverage\report\clover' => '/Report/Clover.php',
		'sebastianbergmann\codecoverage\report\crap4j' => '/Report/Crap4j.php',
		'sebastianbergmann\codecoverage\report\php' => '/Report/PHP.php',
		'sebastianbergmann\codecoverage\report\text' => '/Report/Text.php',
		'sebastianbergmann\codecoverage\report\html\facade' => '/Report/HTML/Facade.php',
		'sebastianbergmann\codecoverage\report\html\renderer' => '/Report/HTML/Renderer.php',
		'sebastianbergmann\codecoverage\report\html\renderer\dashboard' => '/Report/HTML/Renderer/Dashboard.php',
		'sebastianbergmann\codecoverage\report\html\renderer\directory' => '/Report/HTML/Renderer/Directory.php',
		'sebastianbergmann\codecoverage\report\html\renderer\file' => '/Report/HTML/Renderer/File.php',
		'sebastianbergmann\codecoverage\report\xml\coverage' => '/Report/XML/Coverage.php',
		'sebastianbergmann\codecoverage\report\xml\directory' => '/Report/XML/Directory.php',
		'sebastianbergmann\codecoverage\report\xml\facade' => '/Report/XML/Facade.php',
		'sebastianbergmann\codecoverage\report\xml\file' => '/Report/XML/File.php',
		'sebastianbergmann\codecoverage\report\xml\method' => '/Report/XML/Method.php',
		'sebastianbergmann\codecoverage\report\xml\node' => '/Report/XML/Node.php',
		'sebastianbergmann\codecoverage\report\xml\project' => '/Report/XML/Project.php',
		'sebastianbergmann\codecoverage\report\xml\report' => '/Report/XML/Report.php',
		'sebastianbergmann\codecoverage\report\xml\tests' => '/Report/XML/Tests.php',
		'sebastianbergmann\codecoverage\report\xml\totals' => '/Report/XML/Totals.php',
		'sebastianbergmann\codecoverage\report\xml\unit' => '/Report/XML/Unit.php',
    ),
    __DIR__
);

\Fedora\Autoloader\Dependencies::required(array(
	'/usr/share/php/File/Iterator/autoload.php',
	'/usr/share/php/PHP/Token/autoload.php',
	'/usr/share/php/SebastianBergmann/Version/autoload.php',
	'/usr/share/php/SebastianBergmann/Environment/autoload.php',
	'/usr/share/php/SebastianBergmann/CodeUnitReverseLookup/autoload.php',
	'/usr/share/php/Text/Template/autoload.php',
));
