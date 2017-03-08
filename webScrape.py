# -*- coding: utf-8 -*-
"""
Created on Sat Mar  4 09:52:53 2017

@author: jason
"""

import scrapy

class RealEstateSpider(scrapy.Spider):
    name = "realestate_spider"
    start_urls = ['http://www.century21.ca/search/PropType-RES/Q-Calgary%2C%20AB/51.22680066918126;-114.69211094881416;50.79999337690936;-113.48498814607979/v_Gallery']

    def parse(self,response):
        ADD_SELECTOR = '//span[@class="address-line-2"]/text()'
        SQFT_SELECTOR = '//li[@class="sqft"]/text()'
        yield {'add':response.xpath(ADD_SELECTOR).extract(),
               'sqft': response.xpath(SQFT_SELECTOR).extract()}
               
        
        NEXT_PAGE_SELECTOR = '.next-link ::attr(href)'
        next_page = response.css(NEXT_PAGE_SELECTOR).extract_first()

        if next_page:
            base_url = 'century21.ca'
            yield scrapy.Request(
                response.urljoin(next_page),
                callback=self.parse
            )
