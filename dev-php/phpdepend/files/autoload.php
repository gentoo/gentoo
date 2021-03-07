<?php
$vendor_dir = '/usr/share/php';
if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
  require_once("${vendor_dir}/Fedora/Autoloader/autoload.php");
}

\Fedora\Autoloader\Autoload::addPsr4(
  'PDepend\\',
  __DIR__ . '/../src/main/php/PDepend'
);


\Fedora\Autoloader\Dependencies::required(
  array(
    "${vendor_dir}/Symfony/Component/Config/autoload.php",
    "${vendor_dir}/Symfony/Component/DependencyInjection/autoload.php",
    "${vendor_dir}/Symfony/Component/Filesystem/autoload.php"
  )
);
