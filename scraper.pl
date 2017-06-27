#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  scraper.pl
#
#        USAGE:  ./scraper.pl  
#
#  DESCRIPTION:  Scrape crypto-currencies
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Patrick Kowalik , patrick.kowalik@online.de
#      COMPANY:  ---
#      VERSION:  1.0
#      CREATED:  27.06.2017 07:25:44
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use LWP::UserAgent ();
use HTML::TreeBuilder;
use HTML::TreeBuilder::XPath;

my $ua = LWP::UserAgent->new;
$ua->timeout(20);
$ua->env_proxy;

my $useragents = [
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0',
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko',
    'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; AS; rv:11.0) like Gecko',
    'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13',
    'Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko',
    'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/5.0)',
];

# currencies to scrape
my $currencies = [
    { name => "bitcoin", tags => ["usd", "eur"] },
    { name => "ethereum", tags => ["usd", "eur"] },
    { name => "litecoin", tags => ["usd", "eur"] }
];

# storage for scraping results
my $results = [];

foreach my $currency (@$currencies) {

    my $tags = $currency->{tags};
    my $currency_name = $currency->{name};
    
    foreach my $tag (@$tags) {
    
        my $url = "https://www.coingecko.com/de/kurs_chart/$currency_name/$tag";
        
        # pick custom user agent
        my $random_useragent = @$useragents[rand @$useragents];
        $ua->agent($random_useragent);
        
        my $response = $ua->get($url);

        if ($response->is_success) {
            
            my $content = $response->decoded_content;
            my $tree = HTML::TreeBuilder::XPath->new;
            $tree->parse($content);
        
            my %opts = (
                currency => "1",
                code => "2",
                exchange_rate => "3",
                market_capitalisation => "4",
                trading_volume => "5"
            );
            
            my $scraped_currency;
            
            foreach my $key ( keys %opts) {
                my $xpath = '//div[@class="col-xs-12"]/div/table[@class="table"]/tbody/tr/td['.$opts{$key}.']';
                my $value = $tree->findvalue($xpath);
                
                if($value=~/[\d.,]+/) {
                    $value=~s/^\s+(.*\d+)\s+.*//g;
                    $scraped_currency->{$key} = $1;
                } else {
                    $scraped_currency->{$key} = $value;
                }
            }
            
            $scraped_currency->{conversion_currency} = $tag;
            $scraped_currency->{date} = time();
            
            push(@$results, $scraped_currency);

            
            # delay
            sleep(2);
        } else {
            die $response->status_line;
        }	
    }
}

use Data::Dumper;
print Dumper($results);
