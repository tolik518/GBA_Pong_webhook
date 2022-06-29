<?php

$path  = getcwd();
$files = scandir($path);
$files = array_diff(scandir($path), array('.', '..', 'index.php'));

foreach($files as $file){
    echo "<a href='$file'>$file</br ></a>";
}