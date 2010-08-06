#!/usr/bin/env perl

use strict;
use warnings;

use lib '../lib';
use WebService::Instapaper;

use Getopt::Long;

my $reader = WebService::Instapaper->new(
    username => 'something',    # required!!!
    password => 's3cr3t',       # optional, cfr http://www.instapaper.com
);

my $config = {};

GetOptions( $config, 'url=s' );

die "Usage: $0 --url http://www.perl.org\n" unless exists $config->{url};

if ( $reader->add( url => $config->{url} ) ) {
    print "The url (" . $config->{url} . ") has been added successfully.\n";
}
else {
    print "We received the following error: ("
      . $reader->code . ") "
      . $reader->message . ".\n";
}
