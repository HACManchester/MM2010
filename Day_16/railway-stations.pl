#!/usr/bin/perl -w

use strict;
use LWP::RobotUA;
use HTML::SimpleLinkExtor;
use Encode;
use URI::Escape;
use WWW::RobotRules::AnyDBM_File;

my @alphabet = ('A'...'Z');
my $wikiurl = 'http://en.wikipedia.org';
my $baseurl = $wikiurl . '/wiki/UK_railway_stations_–_';
my %options = ('agent' => 'crawler', 'show_progress' => 1, 'delay' => 3/60, 'from' => 'example@example.org');

my $rules = WWW::RobotRules::AnyDBM_File->new('crawler', 'robotcache');

my $ua = LWP::RobotUA->new(%options);
$ua->rules($rules);

my $extor = HTML::SimpleLinkExtor->new;

my $filename;
my $data;

foreach my $letter (@alphabet)
{
  my $pageurl = $baseurl . $letter;
  $filename = "rs-$letter.html";

  $ua->mirror($pageurl, $filename);

  # Check if filename exists before attempting to open it, as there are
  # currently no railway stations beginning with X or Z.
  if (-e $filename)
  {
    # HTML::Parser (used by SimpleLinkExtor) requires UTF-8 data
    # to be decoded before use
    $data = '';

    open HTML_FILE, "< $filename" or warn "Could not open HTML file\n";

    while (my $line = <HTML_FILE>)
    {
      $data .= $line;
    }

    $data = decode_utf8($data);

    close HTML_FILE;

    $extor->parse($data);
  }
}

my @all_urls = $extor->href;

foreach my $url (@all_urls)
{
  # There are links to other pages on the lists, so only extract those which
  # end in "_railway_station" or "_station".
  if ($url =~ m#^/wiki/(.*?)(_railway_station|_station)$#)
  {
    my $station = $1;

    # In order to get a sensible filename, we need to remove all escaped entities
    # (e.g. %20) and special characters, plus expand '&' to 'and'.
    $station = uri_unescape($station);
    $station =~ s/'//g;
    $station =~ s/&/and/g;
    $station =~ s/[()]//g;

    $url = $wikiurl . $url;

    $filename = "$station.html";
    $ua->mirror($url, $filename);
  }
}