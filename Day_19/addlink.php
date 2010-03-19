<head>
<meta http-equiv="refresh" content="3; URL=index.php">
</head>
<?php
$file=fopen("links.csv","a");
$a=$_POST["url"] . "," . $_POST["name"] . "\n" ;
fputs($file,$a);
fclose($file);

echo "Added link to the list, will redirect in 3 seconds"
//echo "
?>
