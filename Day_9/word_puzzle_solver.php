<?php
/****************************************************************
March Madness - 2010 for HacMan.org.uk - 9th March entry
Entry by Paul 'Tallscreen' Plowman    madstunts@hotmail.com
Code released under the GNU General Public License version 3.0

This basically allows you to cheat at crosswords and Scrabble.

* For crosswords, type the word using ? for any unknown letters.
* For Scrabble, list your letters using ? For blanks.

Put it on a webserver which runs PHP and open in a web-browser.

You need a file called "words.txt" in the same directory, which
should be a list of valid words, one per line. There are some
downloadable wordlists here: http://is.gd/a3Qxd

This is a bit of a hack, and does lots of unneeded looping, but
it works.
****************************************************************/
?>

<html>
<head>
  <title>Word-Puzzle Solver</title>
</head>
<body>

<h1>Word Puzzle Solvematic</h1>
<p>By Paul Plowman</p>
<hr />

<?php

// Read the word data into $dat
$rows = file("words.txt");
  

// ----------------- CROSSWORD WORDS ------------------

// Get the form information
$qs = strtoupper(trim($_GET["cross"]));

// If the crossword form wasn't blank...
if ($qs != NULL)
  {
  echo "<h2>Crossword Words ($qs)</h2>\n\n";

  // Number of words returned
  $count = 0;

  // For each word in the word list...
  foreach($rows as $row)
    {
    $row = strtoupper(trim($row));
    $good = 1;

    // If the word is the correct length...
    if (strlen($row) == strlen($qs))
      {
      // Step through each letter...
      for ($n=0;$n<strlen($row);$n++)
        {
        // If word hasn't already been ruled out but letter is not same or '?'...
        if(($good) && ($qs[$n]!=$row[$n]) && ($qs[$n]!='?'))
          {
          // Rule word out
          $good = 0;
          }
        }
      // If whole word is good...
      if ($good)
        {
        // Print word and increment count
        if ($count>0) { echo ", "; }
        echo $row;
        $count++;
        }
      }
    }
  if($count == 0)
    {
    echo "No matches found!";
    }
  echo "\n<hr />\n\n";
  }


// ----------------- SCRABBLE WORDS ------------------

// Get the form information

// If the Scrabble form wasn't blank...
// If your word-list is lowercase, you need to change this line.
$qs = strtoupper(trim($_GET["scrab"]));
$min = strtoupper(trim($_GET["min"]));
if ($qs != NULL)
  {
  if ($min == NULL) {$min = 0;}
  echo "<h2>Scrabble Words ($qs)</h2>\n\n";

  // Number of words returned
  $count = 0;

  // For each word in the word list...
  foreach($rows as $row)
    {
    $in = $qs;
    $row = strtoupper(trim($row));
    $good = 1;

    // If word is not too long...
    if (strlen($row) <= strlen($in))
      {
      // Go through each letter
      for ($n=0;$n<strlen($row);$n++)
        {
        // If word has not been ruled out...
        if ($good)
          {
          // If letter[n] is not in our list of letters...
          if(!(strstr($in, $row[$n])))
            {
            // ...and there are no blank letters left...
            if(!(strstr($in, "?"))) //If there's a blank
              {
              // ... then rule out word.
              $good = 0;
              }
             else
              {
              // If we used a spare blank, set it to "_"
              $in[strpos($in, "?")] = "_";
              }
            }
           else
            {
            // If we used a letter, set it to "_"
            $in[strpos($in, $row[$n])] = "_";
            }
          }
        }
      // If all letters are good and word is long enough...
      if (($good) && (strlen($row) >= $min))
        {
        // Print word and increment count
        if ($count>0) { echo ", "; }
        echo $row;
        $count++;
        }
      }
    }
  if($count == 0)
    {
    echo "No matches found!";
    }
  echo "\n<hr />\n\n";

  }
?>

<h4>Enter crossword word using '?' for unknown letters, or enter Scrabble letters using '?' for blanks.</h4>
<form action="words.php" method="get">
<p>Crossword Search: <input type="text" name="cross" maxlength="40" /></p>
<p>Scrabble Search: <input type="text" name="scrab" maxlength="10" />
Minimum Scrabble word length:
<select name="min">
  <option>1</option>
  <option>2</option>
  <option>3</option>
  <option selected>4</option>
  <option>5</option>
  <option>6</option>
  <option>7</option>
  <option>8</option>
  <option>9</option>
  <option>10</option>
</select>
</p>
<input type="submit" value="Send" />
</form>

</body>
</html>

