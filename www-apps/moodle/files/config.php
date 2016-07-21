<?PHP
unset($CFG);
$CFG = new stdClass();

$CFG->dbtype    = 'mydb';
$CFG->dbhost    = 'localhost';
$CFG->dbname    = 'moodle_db';
$CFG->dbuser    = 'moodle_user';
$CFG->dbpass    = 'moodle_pass';
$CFG->prefix    = 'mdl_';

$CFG->dbpersist = false;

$CFG->wwwroot   = 'http://localhost/moodle';
$CFG->dirroot   = '/var/www/localhost/htdocs/moodle';
$CFG->dataroot  = '/var/www/localhost/moodle' ;

$CFG->directorypermissions = 02777;

$CFG->admin = 'admin';

if (file_exists("$CFG->dirroot/lib/setup.php"))  {
    include_once("$CFG->dirroot/lib/setup.php");
} else {
    echo "<p>Could not find this file: $CFG->dirroot/lib/setup.php</p>";
    echo "<p>Please supply this file or reinstall moodle</p>";
    die;
}
?>
