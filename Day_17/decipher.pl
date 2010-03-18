#!/usr/bin/perl -w

# decipher.pl - Terrible substitution cipher solver
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

# Takes a piece of ciphertext on standard input and a dictionary in 'testdict'
# and attempts to decipher it into intelligible text by frequency analysis
# and then by comparing words against the dictionary. 

# This is a very quickly and badly written piece of Perl and should not be
# used as an example of anything.

use strict;

my @dict;

sub min
{
    my ($x,$y) = @_;
    return($x<$y?$x:$y);
}

sub max
{
    my ($x,$y) = @_;
    return($x>$y?$x:$y);
}

# Read in the dictionary
my $dictFile = "testdict";
open DICTIONARY,"<$dictFile";
while(<DICTIONARY>)
{
    push @dict,lc($_);
}
close(DICTIONARY);

# Check the score of one word
sub spellScore
{
    my $word = shift;
    my $maxScore = 0;
    for my $d (@dict)
    {
	my $l1 = min(length($d),length($word));
	my $l2 = max(length($d),length($word));
	my $score=0;
	for my $i (0..($l1-1))
	{
	    if(substr($word,$i,1) eq substr($d,$i,1))
	    {
		$score += 1
		}
	}
	$score -= ($l2-$l1);
	if($score>$maxScore) { $maxScore = $score; }
    }
    # Normalise by the length of the word
    return $maxScore * 100 / length($word);
}

my $text = "";
while(<>)
{
    $text .= lc($_);
}

sub totalScore
{
    my $words = shift;
    my $totalScore = 0;
    for my $w (@{$words})
    {
	my $score = spellScore($w);
	$totalScore += $score;
    }
    return $totalScore;
    
}

# Process into pure words... 
$text =~ s/[^a-z]+/ /g;

print $text."\n";

my @words = split(/ /,$text);

# Now, frequency analysis

my %freq = ();
for my $i (0..25)
{
    $freq{$i} = 0;
}

for my $w (@words)
{
    for my $i (0..length($w)-1)
    {
	my $index = ord(substr($w,$i,1))-ord('a');
	$freq{$index} ++;
    }
}

# Print out the initial frequencies
for my $i (0..25)
{
    print chr($i+ord('a')) . ": ".$freq{$i}."\n";
}

#Sort this list by frequency
my @sortedList = sort { $freq{$b} <=> $freq{$a} } keys %freq;

my $seq = "";
for my $l(@sortedList)
{
    $seq .= chr($l+ord('a'));
}
print $seq."\n";

# Now try randomly swapping bits of the sequence 
my $maxScore = 0;

while(1)
{
    my $swap1 = int(rand(26));
    my $swap2 = int(rand(26));
    my $swappedSeq = $seq;
    my $temp = substr($swappedSeq,$swap1,1);
    substr($swappedSeq,$swap1,1,substr($swappedSeq,$swap2,1));
    substr($swappedSeq,$swap2,1,$temp);
    my $deciphered = $text;
    $_ = $deciphered;
    eval "tr/$swappedSeq/etaoinshrdlcumwfgypbvkjxqz/";
    my @words = split / /;
    my $score = totalScore(\@words);
    if($score > $maxScore) 
    {
	if($score > $maxScore)
	{
	    print join(" ",@words)."\n";
	    print "Score: ".$score."\n";
	}
	$maxScore = $score;
	$seq = $swappedSeq;
    }
}
