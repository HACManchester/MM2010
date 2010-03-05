<?php

/*******************************************************************
 * March Madness - 2010 for HacMan.org.uk - 5th March entry
 * Entry by Paul 'Tallscreen' Plowman    madstunts@hotmail.com
 * Code released under the GNU General Public License version 3.0
 *******************************************************************
 * This function will convert Cartesian British National Grid
 * Reference values into a page and grid square for the London A-Z.
 * Obviously only works for coordinates which are actually in
 * London. I would have used the Manchester A-Z, but the layout of
 * The Manchester A-Z map pages is all over the place.
 *******************************************************************
 * Bung this file on your web server and browse to it. There's a
 * simple demo I've thrown together which uses a Javascript
 * bookmarklet to convert Streetmap pages to A-Z info. I think my
 * A-Z is a bit old, so this definitely works with the 2000 Edition.
 * It may not work with later editions. I have no idea. Enjoy.
 *******************************************************************/

function getaz($x,$y)
  {
  // Output this if unsuccessful
  $out = "error";

  // If the coords are within the bounds of the A-Z area
  if ((($x>=511000)&&($x<551000)&&($y>170000)&&($y<=191000)) ||
      (($x>=513500)&&($x<543500)&&($y>191000)&&($y<=194500)) ||
      (($x>=523500)&&($x<538500)&&($y>194500)&&($y<=198000)) ||
      (($x>=516000)&&($x<546000)&&($y>166500)&&($y<=170000)) ||
      (($x>=521000)&&($x<543500)&&($y>163000)&&($y<=166500)))
    {

    // Get Y-Coordinate
    $number = (intval((198000-$y)/500) % 7) + 1;

    // Get page number (unadjusted)
    $page = intval(($x-511000)/2500) + (intval((198000-$y)/3500)*16);

    // This adjusts the page numbers into the non-equal rows of the A-Z map area
    $page--;
    if ($page > 9) { $page -= 6; }
    if ($page > 21) { $page -= 3; }
    if ($page > 117) { $page -= 2; }
    if ($page > 129) { $page -= 6; }

    // Get X-Coordinate (a letter)
    // This shifts the x val because letters on pages <22 are five letters out from all the others
    if ($page<22) { $x += 2500; }
    $temp = (intval(($x-511000)/500) % 10) + 65;
    // This is because the A-Z doesn't use the letter 'I'
    if ($temp>72) { $temp++; }

    $letter = chr($temp);

    $out = "$page,$letter,$number";
    }

  return $out;
  }



// -------- This bit is a very basic demo --------

// Read the Querystring
$qs = $_SERVER['QUERY_STRING'];

// If there's some input variables
if ($qs != NULL)
  {
  // Split the variables and shove them intop the AtoZ function
  $xy = explode(",", $qs);
  $atoz = getaz($xy[0],$xy[1]);

  // If the variables are invalid
  if ($atoz == "error")
    {
    echo 'Value is outside the A-Z map area. Click <a href="http://www.ukonscreen.com/_crap/atoz.jpg">here</a> for an image showing the valid area';
    }
   else
    {
    // Show the results
    $mapbits = explode(",", $atoz);
    echo "<h1>Page: $mapbits[0], Grid Square: $mapbits[1]$mapbits[2]</h1>";
    }
  }
 else
  {
  // If there's no input variables
  echo "<h1>London A-Z converter thingy.</h1>\n";
  echo '<h3>By Paul Plowman</h3>';
  echo "<p>For a demo, drag the following link onto your links bar: ";
  echo '<a href="javascript:(function(){ L = location.href;L=L.toUpperCase();X=L.substring((L.indexOf(%22X=%22))+2, L.indexOf(%22&Y=%22));Y=L.substring((L.indexOf(%22Y=%22))+2, L.indexOf(%22&%22,(L.indexOf(%22Y=%22))));window.location=%22http://'.$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'].'?%22+X+%22,%22+Y;})()">A to Z</a>';
  echo "</p>";
  echo '<p>Now go to <a href="http://www.streetmap.co.uk">Streetmap</a>.</p>';
  echo '<p>Find somewhere in London, and place the arrow where you want, then click on the "A to Z" link in your links bar.</p>';
  }

?>
