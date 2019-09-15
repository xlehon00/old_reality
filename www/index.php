<?php
// absolute filesystem path to the web root
define('WWW_DIR', dirname(__FILE__));

// absolute filesystem path to the application root
define('APP_DIR', WWW_DIR . '/../app');

// absolute filesystem path to the libraries
define('LIBS_DIR', WWW_DIR . '/../libs');

// paht to libraries provided by composer
define('VENDOR_DIR', WWW_DIR . '/../vendor');

// absolute filesystem path to the thúmbs of gallery
define('IMAGE_DIR', WWW_DIR . '/images');

$container = require __DIR__ . '/../app/bootstrap.php';

$container->getByType(Nette\Application\Application::class)
	->run();
