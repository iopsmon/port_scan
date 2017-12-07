#!/usr/bin/perl
#+-------------------------------------------------------------------------------+
#DESCRIPTION: Scans your servers common ports 
#USE:perl <FILENNAME>
#EXAMPLE: perl dc_server_port_scan.pl 
#DATE:18/11/2016
#AUTHOR:Deepak Chohan
#VERSION:1.0
#+-------------------------------------------------------------------------------+

use strict; 
use warnings;
use Net::Ping; 
use IO::Socket;
use Term::ANSIColor;

#Write the server name into the myhosts.txt file
open (MYHOSTSFILE, "<", "./myhosts.txt") or die $!;

 
##Create a file to report on what servers are running (alive) and what type of app/service
open (SRV_RPT, ">", "./server_report.txt") or die $!;
open SRV_ALIVE, ">", "./server_alive.txt" or die $!;
 

#Start of Variables

my $output = '';
my $host; 
my $timeout = 10;


#These are common ports hackers target 
my @well_known_ports = qw( 20 21 22 23 25 53 80 110 135 137 138 139 161 443 512 513 514 1433 3306 1521 5432 8080  );

# End of my variables
#
#Code Start
sub ping_hosts {
	while (my @lines = <MYHOSTSFILE>) 
		{ 
		 foreach $host (@lines) 
		{
		  print "Pinging $host\n";
		  my $p = Net::Ping ->new("icmp"); #create ping object
		  chomp $host;
		  if ( $p-> ping ($host, $timeout) ) 
		{	 
		  print color ('bold green');
		  print "+------------------------------------------+\n";  	
		  print "Host ".$host."  is alive\n";
		  my $aliveoutput = "Host ".$host." is alive\n";
		  print SRV_ALIVE ""; 		
		  print SRV_ALIVE "+------------------------------------------+\n";
		  print SRV_ALIVE $aliveoutput; 
		  print SRV_ALIVE "";
		  print "\n";
		  print color ('reset');
 		  foreach my $port (@well_known_ports)
	 	{
          my  $socket = IO::Socket::INET->new(PeerAddr => $host , PeerPort => $port , Proto => 'tcp' , Timeout => 5); #create socket connection
          if($socket )
        {
		  print color ('bold green');
          print "Port: $port on $host is open.\n";
		  my $openport = "Port: $port on $host is open.\n";
		  my $portrpt = "$port $host\n";
		  print SRV_ALIVE "";	
		  print SRV_ALIVE $openport;
		  print SRV_RPT $portrpt; 
		  print color ('reset');
        }
          else
        {
          print  "Port: $port on $host is closed.\n";
        }
		   }
              } 
		  else
		  { 	
		  print color ('bold red');
		  print "+------------------------------------------+\n";
          print "Warning: ".$host." is offline\n";
          print "\n";
          print color ('reset');
	    }	
   	  }	
    }
 } 
	 

#Run the functions
ping_hosts;
print $output;
close MYHOSTSFILE; 
close SRV_ALIVE;
close SRV_RPT;
exit (0);
#End of Code

