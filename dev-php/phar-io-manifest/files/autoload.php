<?php

require_once 'Fedora/Autoloader/autoload.php';

\Fedora\Autoloader\Autoload::addClassMap(
   [
		'phario\\manifest\\manifestdocumentmapper' => '/ManifestDocumentMapper.php',
		'phario\\manifest\\manifestloader' => '/ManifestLoader.php',
		'phario\\manifest\\manifestserializer' => '/ManifestSerializer.php',
		'phario\\manifest\\exception' => '/exceptions/Exception.php',
		'phario\\manifest\\invalidapplicationnameexception' => '/exceptions/InvalidApplicationNameException.php',
		'phario\\manifest\\invalidemailexception' => '/exceptions/InvalidEmailException.php',
		'phario\\manifest\\invalidurlexception' => '/exceptions/InvalidUrlException.php',
		'phario\\manifest\\manifestdocumentexception' => '/exceptions/ManifestDocumentException.php',
		'phario\\manifest\\manifestdocumentmapperexception' => '/exceptions/ManifestDocumentMapperException.php',
		'phario\\manifest\\manifestelementexception' => '/exceptions/ManifestElementException.php',
		'phario\\manifest\\manifestloaderexception' => '/exceptions/ManifestLoaderException.php',
		'phario\\manifest\\application' => '/values/Application.php',
		'phario\\manifest\\applicationname' => '/values/ApplicationName.php',
		'phario\\manifest\\author' => '/values/Author.php',
		'phario\\manifest\\authorcollection' => '/values/AuthorCollection.php',
		'phario\\manifest\\authorcollectioniterator' => '/values/AuthorCollectionIterator.php',
		'phario\\manifest\\bundledcomponent' => '/values/BundledComponent.php',
		'phario\\manifest\\bundledcomponentcollection' => '/values/BundledComponentCollection.php',
		'phario\\manifest\\bundledcomponentcollectioniterator' => '/values/BundledComponentCollectionIterator.php',
		'phario\\manifest\\copyrightinformation' => '/values/CopyrightInformation.php',
		'phario\\manifest\\email' => '/values/Email.php',
		'phario\\manifest\\extension' => '/values/Extension.php',
		'phario\\manifest\\library' => '/values/Library.php',
		'phario\\manifest\\license' => '/values/License.php',
		'phario\\manifest\\manifest' => '/values/Manifest.php',
		'phario\\manifest\\phpextensionrequirement' => '/values/PhpExtensionRequirement.php',
		'phario\\manifest\\phpversionrequirement' => '/values/PhpVersionRequirement.php',
		'phario\\manifest\\requirement' => '/values/Requirement.php',
		'phario\\manifest\\requirementcollection' => '/values/RequirementCollection.php',
		'phario\\manifest\\requirementcollectioniterator' => '/values/RequirementCollectionIterator.php',
		'phario\\manifest\\type' => '/values/Type.php',
		'phario\\manifest\\url' => '/values/Url.php',
		'phario\\manifest\\authorelement' => '/xml/AuthorElement.php',
		'phario\\manifest\\authorelementcollection' => '/xml/AuthorElementCollection.php',
		'phario\\manifest\\bundleselement' => '/xml/BundlesElement.php',
		'phario\\manifest\\componentelement' => '/xml/ComponentElement.php',
		'phario\\manifest\\componentelementcollection' => '/xml/ComponentElementCollection.php',
		'phario\\manifest\\containselement' => '/xml/ContainsElement.php',
		'phario\\manifest\\copyrightelement' => '/xml/CopyrightElement.php',
		'phario\\manifest\\elementcollection' => '/xml/ElementCollection.php',
		'phario\\manifest\\extelement' => '/xml/ExtElement.php',
		'phario\\manifest\\extelementcollection' => '/xml/ExtElementCollection.php',
		'phario\\manifest\\extensionelement' => '/xml/ExtensionElement.php',
		'phario\\manifest\\licenseelement' => '/xml/LicenseElement.php',
		'phario\\manifest\\manifestdocument' => '/xml/ManifestDocument.php',
		'phario\\manifest\\manifestdocumentloadingexception' => '/xml/ManifestDocumentLoadingException.php',
		'phario\\manifest\\manifestelement' => '/xml/ManifestElement.php',
		'phario\\manifest\\phpelement' => '/xml/PhpElement.php',
		'phario\\manifest\\requireselement' => '/xml/RequiresElement.php',
	],
	__DIR__
);

\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/PharIo/Version/autoload.php'
]);
