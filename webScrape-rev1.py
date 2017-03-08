# -*- coding: utf-8 -*-
"""
Created on Sat Mar  4 09:52:53 2017

@author: jason
"""

import scrapy

class RealEstateSpider(scrapy.Spider):
    name = "realestate_spider"
    start_urls = ['http://www.century21.ca/search/PropType-COND/Q-Calgary%2C%20AB/51.22680066918126;-114.69211094881416;50.79999337690936;-113.48498814607979/v_Gallery']

    def parse(self,response):
        LIST_SELECTOR = 'div.property-list-item'
        ADD_SELECTOR = 'span.address-line-2::text'
        SQFT_SELECTOR = 'li.sqft::text'
        for item in response.css(LIST_SELECTOR):
            yield {'add':item.css(ADD_SELECTOR).extract_first(),
               'sqft': item.css(SQFT_SELECTOR).extract_first()
               }
               
        
        NEXT_PAGE_SELECTOR = '.next-link ::attr(href)'
        next_page = response.css(NEXT_PAGE_SELECTOR).extract_first()

        if next_page:
            base_url = 'century21.ca'
            yield scrapy.Request(
                response.urljoin(next_page),
                callback=self.parse
            )
