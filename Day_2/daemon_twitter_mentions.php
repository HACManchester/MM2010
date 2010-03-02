<?php

/*******************************************************************
 * March Madness - 2010 for HacMan.org.uk - 2nd March entry
 * Entry by Jon "The Nice Guy" Spriggs jon@spriggs.org.uk
 * Code released under the GNU General Public License version 3.0
 *******************************************************************
 * One of the things I like best on identi.ca is the fact that it
 * sends you an e-mail when you get a "mention" in someone else's
 * timeline. I really miss that when it comes to Twitter. To fix 
 * this loss, I've written this small script which runs on your
 * home server and polls twitter on a minutely basis and e-mails
 * you if anything new appears in the meantime.
 *******************************************************************/

// ----------------- Configurable variables ----------------- 

// This controls what get's polled
$username='YourTwitterUsername';
$password='YourTwitterPassword';
// This controls where it get's sent and what it get's sent from
$from_email_address='an.email@address.from.a.domain.you.control.tld';
$to_email_address='your.real@address.tld';
// This controls what file you store your persistent data in
$status_file='.id.txt';
// This controls whether you show your inner workings
$debug=1;

// --------------- Non-Configurable variables --------------- 
$last_id=0; 

while(TRUE) {
  if($last_id==0) {$id=getLastID($status_file);}
  $mentions=getData($username, $password, $last_id);
  $stored_last_id=$last_id;
  $message_text='';
  foreach($mentions as $mention) {
    if($mention['id']>$last_id) {
      $last_id=$mention['id'];
    }
    $message_text.="{$mention['user']} : {$mention['text']}\r\n";
  }
  if($message_text!='' and $stored_last_id!=0) {
    if($GLOBALS['debug']!=0) {echo "Sending e-mail ($message_text)\r\n";}
    mail($to_email_address, 'Twitter Mentions at ' . date("Y-m-d H:i"), nl2br($message_text), "MIME-Version: 1.0\r\nContent-type: text/html; charset=iso-8859-1\r\nTo: $to_email_address\r\nFrom: $from_email_address\r\n");
  } elseif($stored_last_id==0) {
    if($GLOBALS['debug']!=0) {echo "First run - we should have sent $message_text\r\n";}
  }
  if($last_id!=$stored_last_id) {setLastID($last_id, $status_file);}

  sleep(60);
}

function getLastID($id_file='.id.txt') {
  if( ! file_exists($id_file)) {
    if($GLOBALS['debug']!=0) {echo "Tried to read last ID from $id_file, but it doesn't exist.\r\n";}
    return 0;
  }
  $file=fopen($id_file, 'r');
  $read='';
  while(!feof($file)) {$read.=fread($file, 8192);}
  fclose($file);
  $read=trim($read);
  if($GLOBALS['debug']!=0) {echo "Reading ID from $id_file (value received: $read)\r\n";}
  return($read);
}

function setLastID($id, $id_file='.id.txt') {
  if($GLOBALS['debug']!=0) {echo "Writing last ID number $id to file $id_file\r\n";}
  if(file_exists($id_file) and ( ! is_writable($id_file))) {die("Can't write to $id_file.");}
  if( ! $file=fopen($id_file, 'w')) {die("Can't open $id_file for writing.");}
  if( ! $write=fwrite($file, $id)) {die("Can't write status to $id_file.");}
  fclose($file);
}

function getData($user, $pass, $since='') {
  $url='http://twitter.com/statuses/mentions.json';
  if($since!='') {$url.="?since_id=$since";}
  if($GLOBALS['debug']!=0) {echo "Getting $url\r\n";}
  $curl=curl_init();
  curl_setopt($curl, CURLOPT_URL, $url);
  curl_setopt($curl, CURLOPT_USERPWD, "$user:$pass");
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
  $curl_result=curl_exec($curl);
  if($GLOBALS['debug']!=0) {echo "Done.\r\n(Result: $curl_result)\r\n";}
  if($curl_result===FALSE) {
    echo "Curl Error: " . curl_error($curl);
    curl_close($curl);
    return array();
  } else {
    $mentions=json_decode($curl_result);
    for($i=0; $i<count($mentions); $i++){
      $mention=$mentions[$i];
      $data[]=array('id'=>$mention->id, 'user'=>$mention->user->screen_name, 'text'=>$mention->text);
    }
    curl_close($curl);
    if(count($mentions)>0) {
      asort($data);
      if($GLOBALS['debug']!=0) {echo "Data parsed and returned to loop function.\r\n";}
      return($data);
    } else {return array();}
  }
}
?>
