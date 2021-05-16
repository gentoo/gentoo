<?php
if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
  require_once('/usr/share/php/Fedora/Autoloader/autoload.php');
}

\Fedora\Autoloader\Autoload::addPsr4(
  'PHPMD\\',
  __DIR__ . '/../src/main/php/PHPMD'
);


\Fedora\Autoloader\Dependencies::required(
  array('/usr/share/phpdepend/vendor/autoload.php')
);
