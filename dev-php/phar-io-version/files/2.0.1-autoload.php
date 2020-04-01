<?php
/* Autoloader for dev-php/phar-io-version */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
  require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
  [
    'phario\\version\\abstractversionconstraint' => '/constraints/AbstractVersionConstraint.php',
    'phario\\version\\andversionconstraintgroup' => '/constraints/AndVersionConstraintGroup.php',
    'phario\\version\\anyversionconstraint' => '/constraints/AnyVersionConstraint.php',
    'phario\\version\\exactversionconstraint' => '/constraints/ExactVersionConstraint.php',
    'phario\\version\\exception' => '/exceptions/Exception.php',
    'phario\\version\\greaterthanorequaltoversionconstraint' => '/constraints/GreaterThanOrEqualToVersionConstraint.php',
    'phario\\version\\invalidprereleasesuffixexception' => '/exceptions/InvalidPreReleaseSuffixException.php',
    'phario\\version\\invalidversionexception' => '/exceptions/InvalidVersionException.php',
    'phario\\version\\orversionconstraintgroup' => '/constraints/OrVersionConstraintGroup.php',
    'phario\\version\\prereleasesuffix' => '/PreReleaseSuffix.php',
    'phario\\version\\specificmajorandminorversionconstraint' => '/constraints/SpecificMajorAndMinorVersionConstraint.php',
    'phario\\version\\specificmajorversionconstraint' => '/constraints/SpecificMajorVersionConstraint.php',
    'phario\\version\\unsupportedversionconstraintexception' => '/exceptions/UnsupportedVersionConstraintException.php',
    'phario\\version\\version' => '/Version.php',
    'phario\\version\\versionconstraint' => '/constraints/VersionConstraint.php',
    'phario\\version\\versionconstraintparser' => '/VersionConstraintParser.php',
    'phario\\version\\versionconstraintvalue' => '/VersionConstraintValue.php',
    'phario\\version\\versionnumber' => '/VersionNumber.php',
  ],
  __DIR__
);
