# Crypto-Scraper
Scrape crypto currencies
Perl script for scraping crypto-currencies from [Coingecko](https://www.coingecko.com)

## Usage
```
./scraper.pl
```
The initial crypto-scraper scrapes currencies for: 
* **Bitcoin**  -> **USD/EUR** 
* **Ethereum** -> **USD/EUR** 
* **Litecoin** -> **USD/EUR**.

Actual script output is:
```
$VAR1 = [
          {
            'date' => 1498568509,
            'conversion_currency' => 'usd',
            'code' => 'BTC',
            'currency' => 'Bitcoin',
            'exchange_rate' => '2.410,93821334',
            'market_capitalisation' => '39.572.356.278,9',
            'trading_volume' => '531.616.393,2'
          },
          {
            'market_capitalisation' => '35.116.073.666,0',
            'trading_volume' => '471.750.539,6',
            'code' => 'BTC',
            'date' => 1498568512,
            'conversion_currency' => 'eur',
            'currency' => 'Bitcoin',
            'exchange_rate' => '2.139,44005020'
          },
          {
            'market_capitalisation' => '21.411.986.492,0',
            'trading_volume' => '751.747.571,6',
            'date' => 1498568530,
            'code' => 'ETH',
            'conversion_currency' => 'usd',
            'currency' => 'Ethereum',
            'exchange_rate' => '230,65681694'
          },
          ...
        ];


```

## Authors

* **Patrick Kowalik** - *Initial work* - [Crypto-Scraper](https://github.com/patrick0585/Crypto-Scraper)
