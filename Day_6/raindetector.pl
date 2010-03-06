#!/usr/bin/perl -w

# Perl rain detector
# Uses the BBC's weather forecast RSS feed to determine if it's likely
# to rain today, and calls another process with different arguments
# depening on the forecast. 

# Copyright (C) 2010 Jim MacArthur. http://www.srimech.com

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

use XML::Parser;
use Data::Dumper;
use Time::localtime;

my $postcode = "M3"; # Change this to the first part of your postcode

my $text= "";
my $forecasts = {};

sub char # Processes text data in the XML stream
{
    my($expat,$newtext) = @_;
    our $text .= $newtext;
}

sub title # Called when <title> is found
{
    my ($e, $elem, $attr, $val) = @_;
    our $text = "";
}

sub title_ # Called when </title> is found
{
    our $text;
    my ($e, $elem, $attr, $val) = @_;
    print "$elem: $text\n";
    if($text =~ /^([A-Za-z]*)day: (.*),/)
    {
	my $day = $1;
	print "Forecast set for $day: $2\n";
	$forecasts{$day} = $2;
    }
    $text = "";
}

my $xmlfile = "download.xml";

if($#ARGV>=0)
{
	$xmlfile = $ARGV[0];
}
else
{
	`wget http://newsrss.bbc.co.uk/weather/forecast/9/Next3DaysRSS.xml?area=$postcode -O download.xml`;
}

open(XML,"<$xmlfile");
my @text = <XML>;

my $pl = new XML::Parser(Style=>'Subs');
$pl->setHandlers(Char => \&char);
$pl->parse(join("\n",@text));
my $t = localtime;

close(XML);

my @days = ('Sun','Mon','Tues','Wednes','Thurs','Fri','Satur');
my $todayName = $days[$t->wday];
if(!defined($forecasts{$todayName}))
{
	# Forecasts switch over to the following day at around 8pm,
	# so we may need to advance
	$todayName=$days[($t->wday+1)%7];
}
print "Today is: ".$todayName."day\n";
my $forecast = $forecasts{$todayName};
print "Forecast for today: ".$forecast."\n";

if($forecast =~ /(rain|snow|sleet)/i)
{
    print "LED On\n";
    `./setLED.py 255`;
}
else
{
    print "LED Off\n";
    `./setLED.py 0`;
}
