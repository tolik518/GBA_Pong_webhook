<?php

$path   = getcwd();
$ignore = ['.', '..', 'index.php', 'gba_icon_small.png'];
$files  = scandir($path);
$files  = array_diff($files, $ignore);

date_default_timezone_set("Europe/Berlin");

$bottom_border = "style='border-bottom: 1px solid grey;'";
$border = "style='border-bottom: 1px solid grey; border-right: 1px solid grey'";

echo "<h1>GBA Pong nightly builds</h1>";

echo "<table>";

echo "<tr>";
echo "<th $bottom_border>/</th> <th $border>file name</th> <th $border>file size</th> <th $border>upload date</th>";
echo "</tr>";

foreach ($files as $file) {
    echo "<tr>";
    echo "<td $bottom_border><img src='gba_icon_small.png'></td>";
    echo "<td $border><a href='$file'>$file</br ></a></td>";
    echo "<td $border>".round(filesize($file)/1024, 2)." KB</td>";
    echo "<td $border>".date("d-M-Y H:m:s",filemtime($file))."</td>";
    echo "</tr>";
}
echo "</table>";