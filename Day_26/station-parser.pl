#!/usr/bin/perl -w

use strict;
use HTML::SimpleLinkExtor;
use Encode;
use URI::Escape;

my @alphabet = ('A'...'Z');

# Alter this if you are not running the script in the same directory as the HTML files.
my $htmlpath = '';

my $extor = HTML::SimpleLinkExtor->new;

my $filename;
my $data;

foreach my $letter (@alphabet)
{
  $filename = $htmlpath . "rs-$letter.html";

  if (-e $filename)
  {
    $data = '';

    open HTML_FILE, "< $filename" or warn "Could not open HTML file\n";

    while (my $line = <HTML_FILE>)
    {
      $data .= $line;
    }

    $data = decode_utf8($data);

    close HTML_FILE;

    # Fetch all the links in this file
    $extor->parse($data);
  }
}

my @all_urls = $extor->href;
my $csv = '"Station Name","Code","Longitude","Latitude"' . "\n";

foreach my $url (@all_urls)
{
  if ($url =~ m#^/wiki/(.*?)(_railway_station|_station)$#)
  {
    my $station = $1;

    $station = uri_unescape($station);
    $station =~ s/'//g;
    $station =~ s/&/and/g;
    $station =~ s/[()]//g;

    $filename = $htmlpath . "$station.html";

    $station =~ s/_/ /g;

    $data = '';
    my $longitude = '';
    my $latitude = '';
    my $stationcode = '';

    if (-e $filename)
    {
      open HTML_FILE, "< $filename" or warn "Could not open HTML file\n";

      while (my $line = <HTML_FILE>)
      {
        $data .= $line;
      }

      close HTML_FILE;

      # Coordinates are always in the same format, so a simple regex will do.
      # A tidier version of this script would probably use a proper HTML parser!
      # Coordinates are of the form <span class="geo">{longitude}; {latitude}</span>.
      if ($data =~ m#<span class="geo">([0-9]+\.[0-9]+); (-?[0-9]+\.[0-9]+)</span>#)
      {
        $longitude = $1;
        $latitude = $2;
      }

      # Get the station code - again a proper HTML parser would be sensible.
      if ($data =~ m#<td class="" style="">([A-Z]{3})</td>#)
      {
        $stationcode = $1;
      }

      # Only append a line to the CSV output if we have foudn the longitude, latitude and 
      #print "$station station is at coordinates: $longitude, $latitude and has station code $stationcode\n";#
      if ($stationcode && $longitude && $latitude)
      {
        $csv .= '"' . $station . '","' . $stationcode . '","' . $longitude . '","' . $latitude . '"' . "\n";
      }
    }
  }
}

print $csv;