import requests
from bs4 import BeautifulSoup
import pandas as pd
import random
import time
 
 #liste des URLs à scraper
URLS = [
    "https://www.bestbuy.com/site/apple-iphone-15-128gb-unlocked-black/6507478.p?skuId=6507478",
    "https://www.bestbuy.com/site/apple-iphone-13-5g-128gb-unlocked-starlight/6417789.p?skuId=6417789",
    "https://www.bestbuy.com/site/apple-iphone-15-plus-128gb-unlocked-black/6507473.p?skuId=6507473",
    "https://www.bestbuy.com/site/apple-iphone-se-3rd-generation-64gb-unlocked-black/6507470.p?skuId=6507470",
    "https://www.bestbuy.com/site/apple-iphone-14-plus-128gb-unlocked-midnight/6507549.p?skuId=6507549",
    "https://www.bestbuy.com/site/apple-iphone-14-128gb-unlocked-midnight/6507555.p?skuId=6507555",
    "https://www.bestbuy.com/site/apple-iphone-16-128gb-apple-intelligence-pink-at-t/6418000.p?skuId=6418000",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-256gb-apple-intelligence-black-titanium-at-t/6443470.p?skuId=6443470",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-max-256gb-apple-intelligence-black-titanium-at-t/6443483.p?skuId=6443483",
    "https://www.bestbuy.com/site/apple-iphone-15-256gb-unlocked-green/6507500.p?skuId=6507500",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-max-256gb-apple-intelligence-desert-titanium-verizon/6443374.p?skuId=6443374",
    "https://www.bestbuy.com/site/apple-iphone-16-plus-128gb-apple-intelligence-pink-at-t/6525442.p?skuId=6525442",
    "https://www.bestbuy.com/site/apple-iphone-14-256gb-unlocked-blue/6507495.p?skuId=6507495",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-256gb-apple-intelligence-desert-titanium-verizon/6443361.p?skuId=6443361",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-128gb-apple-intelligence-black-titanium-at-t/6443466.p?skuId=6443466",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-128gb-apple-intelligence-black-titanium-verizon/6443354.p?skuId=6443354",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-512gb-apple-intelligence-black-titanium-at-t/6443475.p?skuId=6443475",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-512gb-apple-intelligence-black-titanium-verizon/6443363.p?skuId=6443363",
    "https://www.bestbuy.com/site/apple-iphone-16-128gb-apple-intelligence-ultramarine-verizon/6418082.p?skuId=6418082",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-max-512gb-apple-intelligence-black-titanium-at-t/6443487.p?skuId=6443487",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-max-512gb-apple-intelligence-black-titanium-verizon/6443377.p?skuId=6443377",
    "https://www.bestbuy.com/site/total-by-verizon-iphone-se-3rd-generation-64gb-prepaid-midnight/6577429.p?skuId=6577429",
    "https://www.bestbuy.com/site/apple-iphone-16-256gb-apple-intelligence-black-at-t/6418004.p?skuId=6418004",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-128gb-apple-intelligence-black-titanium-at-t/6525404.p?skuId=6525404",
    "https://www.bestbuy.com/site/apple-iphone-16-256gb-apple-intelligence-ultramarine-verizon/6418090.p?skuId=6418090",
    "https://www.bestbuy.com/site/apple-iphone-16-plus-128gb-apple-intelligence-black-verizon/6525508.p?skuId=6525508",
    "https://www.bestbuy.com/site/apple-iphone-16-plus-256gb-apple-intelligence-ultramarine-verizon/6487421.p?skuId=6487421",
    "https://www.bestbuy.com/site/apple-iphone-16-plus-256gb-apple-intelligence-ultramarine-at-t/6487273.p?skuId=6487273",
    "https://www.bestbuy.com/site/apple-iphone-15-plus-128gb-black-at-t/6525386.p?skuId=6525386",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-max-1tb-apple-intelligence-desert-titanium-verizon/6443383.p?skuId=6443383",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-256gb-apple-intelligence-blue-titanium-at-t/6525412.p?skuId=6525412",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-max-256gb-apple-intelligence-white-titanium-verizon/6525490.p?skuId=6525490",
    "https://www.bestbuy.com/site/apple-iphone-15-128gb-pink-verizon/6418071.p?skuId=6418071",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-1tb-apple-intelligence-desert-titanium-at-t/6443481.p?skuId=6443481",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-256gb-apple-intelligence-blue-titanium-verizon/6525479.p?skuId=6525479",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-128gb-apple-intelligence-black-titanium-verizon/6525471.p?skuId=6525471",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-max-1tb-apple-intelligence-desert-titanium-at-t/6443493.p?skuId=6443493",
    "https://www.bestbuy.com/site/apple-iphone-15-plus-256gb-black-verizon/6525460.p?skuId=6525460",
    "https://www.bestbuy.com/site/apple-iphone-15-plus-128gb-black-verizon/6525454.p?skuId=6525454",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-max-256gb-apple-intelligence-blue-titanium-at-t/6525424.p?skuId=6525424",
    "https://www.bestbuy.com/site/apple-iphone-16-512gb-apple-intelligence-pink-verizon/6525505.p?skuId=6525505",
    "https://www.bestbuy.com/site/apple-iphone-16-plus-512gb-apple-intelligence-white-at-t/6487276.p?skuId=6487276",
    "https://www.bestbuy.com/site/apple-iphone-16-pro-1tb-apple-intelligence-desert-titanium-verizon/6443370.p?skuId=6443370",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-max-512gb-apple-intelligence-black-titanium-at-t/6525425.p?skuId=6525425",
    "https://www.bestbuy.com/site/apple-iphone-15-256gb-green-verizon/6418095.p?skuId=6418095",
    "https://www.bestbuy.com/site/apple-iphone-15-512gb-yellow-verizon/6525451.p?skuId=6525451",
    "https://www.bestbuy.com/site/apple-iphone-15-256gb-yellow-at-t/6418011.p?skuId=6418011",
    "https://www.bestbuy.com/site/apple-iphone-15-128gb-blue-at-t/6417993.p?skuId=6417993",
    "https://www.bestbuy.com/site/apple-iphone-15-512gb-green-at-t/6525385.p?skuId=6525385",
    "https://www.bestbuy.com/site/apple-iphone-15-plus-512gb-yellow-verizon/6525468.p?skuId=6525468",
    "https://www.bestbuy.com/site/apple-iphone-14-plus-128gb-yellow-verizon/6418065.p?skuId=6418065",
    "https://www.bestbuy.com/site/apple-iphone-15-plus-256gb-green-at-t/6525396.p?skuId=6525396",
    "https://www.bestbuy.com/site/apple-iphone-16-plus-512gb-apple-intelligence-ultramarine-verizon/6443352.p?skuId=6443352",
    "https://www.bestbuy.com/site/apple-iphone-15-plus-512gb-yellow-at-t/6525400.p?skuId=6525400",
    "https://www.bestbuy.com/site/apple-iphone-16-512gb-apple-intelligence-black-at-t/6525434.p?skuId=6525434",
    "https://www.bestbuy.com/site/apple-iphone-14-plus-128gb-yellow-at-t/6417986.p?skuId=6417986",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-512gb-apple-intelligence-natural-titanium-verizon/6525482.p?skuId=6525482",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-1tb-apple-intelligence-black-titanium-verizon/6525485.p?skuId=6525485",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-max-512gb-apple-intelligence-natural-titanium-verizon/6525496.p?skuId=6525496",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-512gb-apple-intelligence-blue-titanium-at-t/6525416.p?skuId=6525416",
    "https://www.bestbuy.com/site/apple-iphone-15-pro-1tb-apple-intelligence-blue-titanium-at-t/6525420.p?skuId=6525420",
    "https://www.bestbuy.com/site/apple-pre-owned-excellent-iphone-11-64gb-unlocked-black/6510048.p?skuId=6510048",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-excellent-12-5g-64gb-unlocked-black/6530509.p?skuId=6530509",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-se-2020-64gb-unlocked-red/6561418.p?skuId=6561418",
    "https://www.bestbuy.com/site/apple-pre-owned-excellent-iphone-13-5g-128gb-unlocked-midnight/6580656.p?skuId=6580656",
    "https://www.bestbuy.com/site/apple-pre-owned-excellent-iphone-xr-64gb-unlocked-black/6510040.p?skuId=6510040",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-15-pro-max-5g-256gb-apple-intelligence-unlocked-black-titanium/6586591.p?skuId=6586591",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-13-pro-5g-128gb-unlocked-graphite/6551233.p?skuId=6551233",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-pro-5g-128gb-unlocked-graphite/6554880.p?skuId=6554880",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-15-pro-5g-128gb-apple-intelligence-unlocked-black-titanium/6586592.p?skuId=6586592",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-13-pro-max-5g-128gb-unlocked-graphite/6563055.p?skuId=6563055",
    "https://www.bestbuy.com/site/apple-pre-owned-excellent-iphone-se-2020-64gb-unlocked-black/6519727.p?skuId=6519727",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-pro-5g-128gb-graphite-verizon/6573630.p?skuId=6573630",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-14-5g-128gb-unlocked-midnight/6583363.p?skuId=6583363",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-14-pro-max-5g-256gb-unlocked-space-black/6580657.p?skuId=6580657",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-mini-5g-128gb-unlocked-black/6525075.p?skuId=6525075",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-15-5g-128gb-unlocked-black/6588508.p?skuId=6588508",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-5g-pro-max-128gb-unlocked-pacific-blue/6583361.p?skuId=6583361",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-5g-64gb-unlocked-blue/6583365.p?skuId=6583365",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-11-128gb-unlocked-black/6505707.p?skuId=6505707",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-mini-5g-64gb-unlocked-purple/6516536.p?skuId=6516536",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-11-pro-64gb-unlocked-space-gray/6502954.p?skuId=6502954",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-5g-64gb-black-verizon/6573882.p?skuId=6573882",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-5g-128gb-unlocked-purple/6510050.p?skuId=6510050",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-11-64gb-unlocked-purple/6506183.p?skuId=6506183",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-14-5g-128gb-unlocked-starlight/6558736.p?skuId=6558736",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-13-5g-128gb-unlocked-starlight/6567196.p?skuId=6567196",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-se-2022-5g-3rd-gen-64gb-unlocked-starlight/6528519.p?skuId=6528519",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-13-5g-128gb-blue-verizon/6573867.p?skuId=6573867",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-xr-64gb-unlocked-white/6398590.p?skuId=6398590",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-14-pro-5g-128gb-unlocked-space-black/6567290.p?skuId=6567290",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-xr-64gb-black-verizon/6574084.p?skuId=6574084",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-256gb-space-black-unlocked/6569503.p?skuId=6569503",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-15-pro-5g-256gb-apple-intelligence-unlocked-blue-titanium/6586084.p?skuId=6586084",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-14-pro-max-5g-128gb-unlocked-silver/6562958.p?skuId=6562958",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-11-pro-max-64gb-unlocked-space-gray/6503000.p?skuId=6503000",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-3rd-generation-64gb-midnight-verizon/6574081.p?skuId=6574081",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-128gb-midnight-unlocked/6563679.p?skuId=6563679",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-13-5g-128gb-unlocked-midnight/6563303.p?skuId=6563303",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-with-64gb-memory-cell-phone-unlocked-black/6563229.p?skuId=6563229",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-plus-128gb-unlocked-midnight/6569505.p?skuId=6569505",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-3rd-generation-64gb-midnight-unlocked/6563668.p?skuId=6563668",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-64gb-black-verizon/6574066.p?skuId=6574066",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-128gb-white-unlocked/6569444.p?skuId=6569444",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-x-256gb-space-gray-verizon/6573874.p?skuId=6573874",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-max-256gb-deep-purple-verizon/6573888.p?skuId=6573888",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-max-256gb-deep-purple-at-t/6567110.p?skuId=6567110",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-max-128gb-space-black-verizon/6573521.p?skuId=6573521",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-128gb-black-verizon/6574071.p?skuId=6574071",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-pro-64gb-space-gray-verizon/6574070.p?skuId=6574070",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-2nd-generation-64gb-productred-verizon/6574068.p?skuId=6574068",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-5g-128gb-black-verizon/6573863.p?skuId=6573863",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-128gb-midnight-verizon/6573631.p?skuId=6573631",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-max-128gb-deep-purple-at-t/6567111.p?skuId=6567111",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-15-5g-256gb-unlocked-black/6586119.p?skuId=6586119",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-13-pro-5g-128gb-graphite-at-t/6567094.p?skuId=6567094",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-pro-max-5g-256gb-gold-verizon/6573881.p?skuId=6573881",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-pro-max-5g-128gb-graphite-verizon/6573860.p?skuId=6573860",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-13-5g-256gb-unlocked-midnight/6562382.p?skuId=6562382",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-15-pro-max-5g-1tb-apple-intelligence-unlocked-blue-titanium/6586099.p?skuId=6586099",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-14-pro-5g-256gb-unlocked-space-black/6567274.p?skuId=6567274",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-pro-max-256gb-space-gray-verizon/6574065.p?skuId=6574065",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-pro-max-64gb-space-gray-verizon/6573519.p?skuId=6573519",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-pro-max-5g-256gb-unlocked-gold/6516534.p?skuId=6516534",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-5g-256gb-unlocked-purple/6516544.p?skuId=6516544",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-max-128gb-deep-purple-unlocked/6563666.p?skuId=6563666",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-128gb-deep-purple-verizon/6573865.p?skuId=6573865",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-max-256gb-deep-purple-unlocked/6563295.p?skuId=6563295",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-13-pro-5g-256gb-unlocked-graphite/6562119.p?skuId=6562119",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-pro-max-5g-128gb-unlocked-graphite/6510038.p?skuId=6510038",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-11-pro-max-256gb-unlocked-silver/6506182.p?skuId=6506182",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-mini-5g-256gb-unlocked-black/6530882.p?skuId=6530882",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-15-pro-max-5g-512gb-apple-intelligence-unlocked-white-titanium/6586097.p?skuId=6586097",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-13-mini-5g-128gb-unlocked-blue/6567195.p?skuId=6567195",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-2nd-generation-64gb-unlocked-productred/6563300.p?skuId=6563300",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-5g-64gb-unlocked-productred/6569510.p?skuId=6569510",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-13-pro-5g-128gb-graphite-unlocked/6563319.p?skuId=6563319",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-13-pro-max-5g-128gb-graphite-unlocked/6569506.p?skuId=6569506",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-11-256gb-unlocked-red/6506169.p?skuId=6506169",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-14-5g-256gb-unlocked-blue/6567285.p?skuId=6567285",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-se-2020-128gb-unlocked-white/6495548.p?skuId=6495548",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-pro-5g-128gb-graphite-unlocked/6563675.p?skuId=6563675",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-128gb-deep-purple-unlocked/6569540.p?skuId=6569540",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-pro-max-5g-128gb-gold-unlocked/6563315.p?skuId=6563315",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-pro-max-5g-256gb-graphite-unlocked/6563198.p?skuId=6563198",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-15-plus-5g-128gb-unlocked-black/6586090.p?skuId=6586090",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-pro-max-with-64gb-memory-cell-phone-unlocked-gold/6569517.p?skuId=6569517",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-pro-5g-256gb-unlocked-gold/6516560.p?skuId=6516560",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-8-plus-64gb-space-gray-unlocked/6563321.p?skuId=6563321",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-x-64gb-space-gray-verizon/6304052.p?skuId=6304052",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-xs-64gb-unlocked-space-gray/6398619.p?skuId=6398619",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-x-256gb-unlocked-space-gray/6394667.p?skuId=6394667",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-13-mini-5g-256gb-unlocked-blue/6567170.p?skuId=6567170",
    "https://www.bestbuy.com/product/apple-iphone-13-5g-128gb-unlocked-midnight/6417788/openbox",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-x-64gb-at-t/6304050.p?skuId=6304050",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-13-pro-5g-128gb-graphite-verizon/6573858.p?skuId=6573858",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-2nd-generation-64gb-unlocked-black/6441084.p?skuId=6441084",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-x-64gb-space-gray-unlocked/6449455.p?skuId=6449455",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-xr-128gb-black-verizon/6573956.p?skuId=6573956",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-8-plus-64gb-gold-verizon/6573363.p?skuId=6573363",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-8-64gb-gold-verizon/6573886.p?skuId=6573886",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-64gb-black-at-t/6576228.p?skuId=6576228",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-2nd-generation-64gb-unlocked-white/6569515.p?skuId=6569515",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-13-5g-128gb-blue-at-t/6567185.p?skuId=6567185",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-8-128gb-space-gray-verizon/6573958.p?skuId=6573958",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-pro-128gb-deep-purple-at-t/6575175.p?skuId=6575175",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-128gb-midnight-at-t/6567101.p?skuId=6567101",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-xs-64gb-gold-verizon/6573861.p?skuId=6573861",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-14-plus-128gb-midnight-verizon/6573670.p?skuId=6573670",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-5g-128gb-black-unlocked/6563307.p?skuId=6563307",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-pro-5g-128gb-graphite-at-t/6576292.p?skuId=6576292",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-xr-64gb-white-unlocked/6563199.p?skuId=6563199",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-xs-max-with-64gb-memory-cell-phone-unlocked-space-gray/6563201.p?skuId=6563201",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-pro-max-256gb-gold-unlocked/6569393.p?skuId=6569393",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-8-256gb-space-gray-sprint/6304057.p?skuId=6304057",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-8-64gb-space-gray-sprint/6255530.p?skuId=6255530",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-2nd-generation-128gb-unlocked-black/6569512.p?skuId=6569512",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-pro-max-256gb-unlocked-space-gray/6563308.p?skuId=6563308",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-11-pro-max-with-256gb-memory-cell-phone-unlocked-midnight-green/6569436.p?skuId=6569436",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-xr-256gb-unlocked-black/6398591.p?skuId=6398591",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-xr-128gb-unlocked-black/6398614.p?skuId=6398614",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-8-64gb-gold-unlocked/6563313.p?skuId=6563313",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-pro-5g-512gb-unlocked-gold/6528962.p?skuId=6528962",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-x-256gb-space-gray-unlocked/6563677.p?skuId=6563677",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-2nd-generation-64gb-unlocked-black/6449456.p?skuId=6449456",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-8-128gb-space-gray-unlocked/6563311.p?skuId=6563311",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-x-256gb-space-gray-sprint/6304048.p?skuId=6304048",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-x-64gb-space-gray-sprint/6304051.p?skuId=6304051",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-x-64gb-unlocked-silver/6394668.p?skuId=6394668",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-12-mini-5g-64gb-black-unlocked/6569534.p?skuId=6569534",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-se-2nd-generation-128gb-unlocked-black/6441086.p?skuId=6441086",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-12-pro-max-5g-512gb-unlocked-pacific-blue/6516533.p?skuId=6516533",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-7-256gb-unlocked-jet-black/6305087.p?skuId=6305087",
    "https://www.bestbuy.com/site/apple-pre-owned-iphone-8-plus-256gb-4g-lte-unlocked-silver/6305072.p?skuId=6305072",
    "https://www.bestbuy.com/site/apple-geek-squad-certified-refurbished-iphone-7-plus-128gb-jet-black-unlocked/5642305.p?skuId=5642305",
]
 
 #pour changer de user agents (éviter le blocage)
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
]
 
def get_headers():
    return {
        "User-Agent": random.choice(USER_AGENTS),
        "Accept-Language": "en-US,en;q=0.5"
    }
 
def scrape_product(url):
    try:
        response = requests.get(url, headers=get_headers(), timeout=10)
        if response.status_code != 200:
            print(f"Impossible de joindre l'url {url} - Statut : {response.status_code}")
            return None
        
        soup = BeautifulSoup(response.content, "html.parser")
         
        title = soup.find("h1").text.strip() if soup.find("h1") else "Nom indispo"
         
        price_container = soup.find("div", {"class": "priceView-hero-price"})
        price = price_container.find("span").text.strip() if price_container and price_container.find("span") else "Prix indisponible"
         
        model_info_container = soup.find("div", {"class": "title-data lv"})
        if model_info_container:
            model_info_span = model_info_container.find("span", {"class": "product-data-value text-info ml-50 body-copy"})
            model_info = model_info_span.text.strip() if model_info_span else "Info model indisponible"
        else:
            model_info = "Info model indisponible"
        
        return {"Nom": title, "Prix": price, "Model": model_info, "URL": url}

    except Exception as e:
        print(f"Erreur de parsing pour l'url {url}: {e}")
        return None

iphone_data = []
for url in URLS:
    print(f"Scraping: {url}")
    data = scrape_product(url)
    if data:
        iphone_data.append(data)
    time.sleep(random.uniform(2, 5)) 
 
if iphone_data:
    df = pd.DataFrame(iphone_data)
    df.to_csv("prix_iphones_bestbuy.csv", index=False)
    print("Terminé")
    print(df)
else:
    print("Une erreur est survenue")