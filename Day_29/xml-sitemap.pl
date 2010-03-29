#!/usr/bin/perl -w

use strict;
use LWP::RobotUA;
use HTML::SimpleLinkExtor;
use Encode;
use URI::Escape;
use URI;
use WWW::RobotRules::AnyDBM_File;
use DateTime;

my $base_url = $ARGV[0];

my %options = ('agent' => 'crawler', 'show_progress' => 1, 'delay' => 3/60, 'from' => 'example@example.org');
my $rules = WWW::RobotRules::AnyDBM_File->new('crawler', 'robotcache');

my $ua = LWP::RobotUA->new(%options);
$ua->rules($rules);

my $filename = "tmp.html"; # Store the contents of each page here, so we can decode and parse it
my $data = '';
my %visited_urls = ();
my @extracted_urls = ();
my $sitemap_xml = "<urlset>\n";
my $datetime = undef;

my $extor = HTML::SimpleLinkExtor->new();

my @crawl_urls = ();
my $current_url = $base_url; # Start crawling with the base URL.

while ($current_url && !(exists $visited_urls{$current_url}))
{
  #foreach my $url (@crawl_urls)
  #{
  #  print "CU: $url\n";
  #}

  unlink($filename);

  my $response = $ua->mirror($current_url, $filename);
  my $last_modified = $response->last_modified;

  # Mark this URL as visited
  $visited_urls{$current_url} = 1;

  if (-e $filename && $response->content_type eq 'text/html')
  {
    # If we have a last modified header, use it, otherwise default to the current time.
    if ($last_modified)
    {
      $datetime = DateTime->from_epoch(epoch => $last_modified);
    }
    else
    {
      $datetime = DateTime->from_epoch(epoch => time());
    }

    $sitemap_xml .= '<url><loc>' . $current_url . '</loc><lastmod>' . $datetime->ymd . '</lastmod>' . "\n";

    open HTML_FILE, "< $filename" or die "Could not open HTML file\n";

    while (my $line = <HTML_FILE>)
    {
      $data .= $line;
    }

    close HTML_FILE;

    $data = decode_utf8($data);

    $extor->parse($data);
    @extracted_urls = $extor->relative_links;
    $extor->clear_links;

    foreach my $extracted_url (@extracted_urls)
    {
      $extracted_url = URI->new_abs($extracted_url, $current_url)->canonical;
      # Only add the URL to the list to crawl if it has not already been visited
      # and it belongs to this domain.
      if (!(exists $visited_urls{$extracted_url}))
      {
        push(@crawl_urls, $extracted_url);
      }
    }
  }

  # Move on to the next URL in the crawl list
  $current_url = pop(@crawl_urls);
}

# We have run out of URLs to crawl, so we must have finished.
# Output the sitemap to sitemap.xml in the current directory.
$sitemap_xml .= '</urlset>';

open SITEMAP_FILE, "> sitemap.xml" or die "Could not create sitemap file\n";
print SITEMAP_FILE $sitemap_xml;
close SITEMAP_FILE;

print "All done\n";