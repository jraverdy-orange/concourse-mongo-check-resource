#!/usr/bin/env perl

package Common;
use strict;
use warnings;
use JSON;
use Tie::IxHash;


sub get_last_version
{
	open(my $fh, ">:encoding(UTF-8)", '/tmp/input')
	    || die "Can't open UTF-8 encoded /tmp/input: $!\n";

	# redirect stdin to temporary input file
	while (<>) {
	    print $fh $_; # or simply "print;"
	}    
	close $fh;

	open($fh, "<:encoding(UTF-8)", '/tmp/input')
	    || die "Can't open UTF-8 encoded /tmp/input: $!\n";


	my $str = do { local $/; <$fh> };
	close $fh;

	my $decoded = JSON->new->decode($str);

	my $main_branch=$decoded->{'source'}{'branch'};

	my $force_version=$decoded->{'source'}{'version'};

	my $current_stable_release="";


	# getting all info from community page and putting them in an array
	my @rel=`curl -s -L  https://www.mongodb.com/download-center  https://www.mongodb.com/download-center#previous`;

	if (!defined($force_version))
	{
		if (defined($main_branch))
		{
			foreach my $i (@rel){
				# searching for version in array
				if ( $i =~ /mongodb-src-r($main_branch.\d+)/ )
				{
					$current_stable_release = $1;
					
				}
			}
		}else{die "The main branch or a specific version to fetch must be provided\n";}
			
	}
	else
	{
		$current_stable_release=$force_version
	}


	if ($current_stable_release eq "")
		{die "information about last Mongodb stable version have not been found on provided address\n"}

	# check if mongo-tools and mongo-rocks are available for this release
	my $provided = 0;

	while ( $provided == 0 )
	{
		$provided=1;

		my @mongorocks_archive=`curl -sI https://codeload.github.com/mongodb-partners/mongo-rocks/tar.gz/r${current_stable_release}`;

		foreach my $i (@mongorocks_archive){
			if ( $i =~ /HTTP\/1.1 404 Not Found/ ){$provided=0}
		}


	    if ($provided==1)
		{ 
			my @mongotools_archive=`curl -sI https://codeload.github.com/mongodb/mongo-tools/tar.gz/r${current_stable_release}`;

			foreach my $i (@mongotools_archive){
				if ( $i =~ /HTTP\/1.1 404 Not Found/ ){$provided=0}
			}

		}

		if ($provided==0){ $current_stable_release =~ s!(\d+.\d+.)(\d+)!($1).($2-1)!e }
	}

	if ($current_stable_release ne "")
	{
		# check if the src tar.gz is available
		my $valid_tar=0;
		my $http_status="ko";
		my $archive_name="mongodb-src-r${current_stable_release}.tar.gz";
		my @tar_info=`curl -sI https://fastdl.mongodb.org/src/$archive_name`;

		foreach my $i (@tar_info){
			if ( $i =~ /HTTP\/1.1 200 OK/ ){$http_status="ok";}
			if ( $i =~ /Content-Type: application\/x-gzip/){$valid_tar=1;}
		}

		if ($http_status eq "ko"){die "Download URL doesn't seem to be valid\n";}
		if ( ! $valid_tar ){die "The file $archive_name on remote doesn't seem to be a valid archive\n";}
	}
	return "$current_stable_release";
}

sub get_version_json
{
	my ($version)=@_;
	my %output=('ref' => $version);
    return JSON->new->pretty->encode(\%output);
}

1;