<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="staticfiles/css/outerframe.css">
    <title>Campbellsoup</title>
</head>
<body>

<?php
echo nl2br("\r\n");
echo nl2br("\r\n");
echo nl2br("\r\n");
echo nl2br("\r\n");
?>

<div id="myOuterFraming">
<p class="intro">
<?php
echo nl2br("\r\n");
echo nl2br("\r\n");
$path = ".";
$dh = opendir($path);
$i=1;
while (($file = readdir($dh)) !== false) {
if($file != "." && $file != ".." && $file != "index.php")
{
echo "<a href='$path/$file'>$file</a><br /><br />";
$i++;
}
}
closedir($dh);
echo nl2br("\r\n");
echo nl2br("\r\n");
?>
</p>
</div>

</body>
</html>
