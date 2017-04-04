<?php
require __DIR__.'/../src/Composer/autoload.php';
\Fedora\Autoloader\Autoload::addPsr0('Composer\\Test\\', __DIR__ . '/');
require __DIR__.'/Composer/TestCase.php';
