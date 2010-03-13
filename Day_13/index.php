<?php

require_once("externals/xajax_core/xajax.inc.php");

$xajax = new xajax();
$xajax->configure('javascript URI','externals/');

$xajax->registerFunction("ajaxPopulateTable");

$times=array(1,2,3);
$rooms=array(1,2,3);


function ajaxPopulateTable() {
  global $times, $rooms;
  
  $now=rand(0,3);
  $next=$now+1;
  
  $return=new xajaxResponse();

  foreach($times as $time) {
    foreach($rooms as $room) {
      $intTalkID=rand(0, 100);
      if($time==$now) {$assign="now";} elseif($time==$next) {$assign="next";} else {$assign="";}
      $return->assign("time_{$time}_room_{$room}", "className", "room_{$room} time_{$time} {$assign}");
      $return->assign("time_{$time}_room_{$room}", "innerHTML", "Talk $intTalkID in room $room at time $time");
    }
  }
  return $return;
}

$xajax->processRequest();

?>
<html>
<head>
<title>Timetable</title>
<?php $xajax->printJavascript(); ?>
<script type="text/javascript">
function update() {
  xajax_ajaxPopulateTable(); 
  setTimeout("update()", 10000);
}
</script>
<style>
<!--
.now {background-color: Silver;}
.next {background-color: Yellow;}
-->
</style>
</head>
<body>
  <table width=100%>
    <thead>
      <tr>
<?php
  foreach($times as $time) {echo "        <th class=\"time_{$time}\">Time $time</th>\r\n";}?>
      </tr>
    </thead>
    <tbody>
<?php
  foreach($rooms as $room) {
    echo "      <tr>\r\n";
    foreach($times as $time) {echo "        <td id=\"time_{$time}_room_{$room}\" class=\"room_{$room} time_{$time}\" />\r\n";}
    echo "      </tr>";}?>
    </tbody>
  </table>
  <script>update();</script>
</body>