<?php
/* Autoloader for dev-php/phar-io-version */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
  require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
  [
    'phario\\version\\abstractversionconstraint' => '/src/constraints/AbstractVersionConstraint.php',
    'phario\\version\\andversionconstraintgroup' => '/src/constraints/AndVersionConstraintGroup.php',
    'phario\\version\\anyversionconstraint' => '/src/constraints/AnyVersionConstraint.php',
    'phario\\version\\exactversionconstraint' => '/src/constraints/ExactVersionConstraint.php',
    'phario\\version\\exception' => '/src/exceptions/Exception.php',
    'phario\\version\\greaterthanorequaltoversionconstraint' => '/src/constraints/GreaterThanOrEqualToVersionConstraint.php',
    'phario\\version\\invalidprereleasesuffixexception' => '/src/exceptions/InvalidPreReleaseSuffixException.php',
    'phario\\version\\invalidversionexception' => '/src/exceptions/InvalidVersionException.php',
    'phario\\version\\orversionconstraintgroup' => '/src/constraints/OrVersionConstraintGroup.php',
    'phario\\version\\prereleasesuffix' => '/src/PreReleaseSuffix.php',
    'phario\\version\\specificmajorandminorversionconstraint' => '/src/constraints/SpecificMajorAndMinorVersionConstraint.php',
    'phario\\version\\specificmajorversionconstraint' => '/src/constraints/SpecificMajorVersionConstraint.php',
    'phario\\version\\unsupportedversionconstraintexception' => '/src/exceptions/UnsupportedVersionConstraintException.php',
    'phario\\version\\version' => '/src/Version.php',
    'phario\\version\\versionconstraint' => '/src/constraints/VersionConstraint.php',
    'phario\\version\\versionconstraintparser' => '/src/VersionConstraintParser.php',
    'phario\\version\\versionconstraintvalue' => '/src/VersionConstraintValue.php',
    'phario\\version\\versionnumber' => '/src/VersionNumber.php',
  ],
  dirname(__DIR__)
);
