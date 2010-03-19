
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 

<head>

<link rel="stylesheet"  href="style.css" type="text/css">
<!--<link rel="stylesheet"  href="mstyle.css" media="handheld" type="text/css">-->
<link type="text/css" rel="stylesheet" media="only screen and (max-device-width: 480px)" href="mstyle.css" />

<title></title>

</head>
<body>

<div id="main">

	<div id="header"></div>

	<div id="content"> 

// File reading links

$row = 1;
if (($handle = fopen("links.csv", "r")) !== FALSE) {
    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
        $row++;
            echo "<div><a href=" . $data[0] . " target='link'>" . $data[1] ."</a></div>\n";
    }
    fclose($handle);
}


}
?>
</div>
<div id="addlink">
<form action="addlink.php" method="post">
URL: <input type="text" name="url" />
Name: <input type="text" name="name" />
<input type="submit" />
</form>
</body>
</html>

