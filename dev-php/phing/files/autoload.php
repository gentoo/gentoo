<?php
$vendor_dir = '/usr/share/php';
if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
  require_once("${vendor_dir}/Fedora/Autoloader/autoload.php");
}

/*
  At least for the moment, we don't need to autoload the Phing classes
  themselves, because the "require" statements are all still there.
*/

\Fedora\Autoloader\Dependencies::required(
  array("${vendor_dir}/Symfony/Component/Yaml/autoload.php")
);
