<html>
<head>
	<style type="text/css">
	body {
		font-family: sans-serif;
	}

	table.cal {
		width: 100%;
		border-collapse:collapse;

	}

	table.cal th {
		background-color: black;
		color: white;
		font-weight: bold;
	}

	table.cal td {
		text-align: center;
		border: lightgray 1px solid;
		background-color: #C2DFFF;

	}

	table.cal td.g {
		color: gray;
	}
	table.cal td.n {
		background-color: transparent;
		border: 0;
	}
	table.cal td.c {
		background-color: #C2DFFF;	
	}
	</style>
</head>
<body>
<table class="cal">
<tr>
	<td class="n">&nbsp;</td>
	<th>Sunday</th>
        <th>Monday</th>
        <th>Tuesday</th>
        <th>Wednesday</th>
        <th>Thursday</th>
        <th>Friday</th>
        <th>Saturday</th>
</tr>
<?php

$day = strtotime('first day');
$startday = $day - (date('w', $day)*86400);
$lday = strtotime('last day');
$endday = $lday + ((6-date('w', $lday))*86400);
$today = strtotime('today');
$days = ($endday - $startday) / 86400;
$weeks = $days / 7;

$current = $startday;

for ($x = 0; $x <= $weeks; $x++)
{
	echo "<tr>";
	echo "<th>Week ".($x+1)."</th>";
	for ($y = 0; $y < 7; $y++)
	{
		echo "<td class=\"".(($current<$day OR $current > $lday)?'n g':'')."\">".date('jS M', $current)."</td>\n";
		$current = $current + 86400;
	}
	echo "</tr>";

}

?>
</table>
</body>
</html>
