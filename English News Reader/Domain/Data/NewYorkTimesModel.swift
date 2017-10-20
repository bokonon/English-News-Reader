//
//  NewYorkTimesModel.swift
//  English News Reader
//
//  Created by yuji shimada on 2017/10/08.
//  Copyright © 2017年 yuji shimada. All rights reserved.
//

import Foundation

class NewYorkTimesModel {
    var _id: NSString
    var abstract: NSString
    var byline: Byline
    var document_type: NSString
    var headline: HeadLine
    var keywords: [Keywords]
    var lead_paragraph: NSString
    var multimedia: [Multimedia]
    var news_desk: NSString
    var print_page: NSString
    var pub_date: NSString
    var section_name: NSString
    var slideshow_credits: NSString
    var snippet: NSString
    var source: NSString
    var subsection_name: NSString
    var type_of_material: NSString
    var web_url: NSString
    var word_count: NSString
    
    init() {
        self._id = ""
        self.abstract = ""
        self.byline = Byline()
        self.document_type = ""
        self.headline = HeadLine()
        self.keywords = [Keywords]()
        self.lead_paragraph = ""
        self.multimedia = [Multimedia]()
        self.news_desk = ""
        self.print_page = ""
        self.pub_date = ""
        self.section_name = ""
        self.slideshow_credits = ""
        self.snippet = ""
        self.source = ""
        self.subsection_name = ""
        self.type_of_material = ""
        self.web_url = ""
        self.word_count = ""
    }
    
    class Byline {
        
        var original: NSString
        var person: [Person]
        var document_type: NSString
        
        init() {
            self.original = ""
            self.person = [Person]()
            self.document_type = ""
        }
        
        init(original: String, person: [Person], document_type: String){
            self.original = original as NSString
            self.person = person
            self.document_type = document_type as NSString
        }
        
    }
    
    class HeadLine {
        
        var content_kicker: NSString
        var kicker: NSString
        var main: NSString
        var print_headline: NSString
        
        init() {
            self.content_kicker = ""
            self.kicker = ""
            self.main = ""
            self.print_headline = ""
        }
        
        init(content_kicker: String, kicker: String, main: String, print_headline: String){
            self.content_kicker = content_kicker as NSString
            self.kicker = kicker as NSString
            self.main = main as NSString
            self.print_headline = print_headline as NSString
        }
    }
    
    class Keywords {
        
        var is_major: NSString
        var name: NSString
        var rank: NSString
        var value: NSString
        
        init() {
            self.is_major = ""
            self.name = ""
            self.rank = ""
            self.value = ""
        }
        
        init(is_major: String, name: String, rank: String, value: String){
            self.is_major = is_major as NSString
            self.name = name as NSString
            self.rank = rank as NSString
            self.value = value as NSString
        }
    }
    
    class Multimedia {
        
        var height: NSString
        var legacy: Legacy
        var subtype: NSString
        var type: NSString
        var url: NSString
        var width: NSString
        
        init() {
            self.height = ""
            self.legacy = Legacy()
            self.subtype = ""
            self.type = ""
            self.url = ""
            self.width = ""
        }
        
        init(height: String, legacy:Legacy, subtype: String, type: String, url: String, width: String){
            self.height = height as NSString
            self.legacy = legacy
            self.subtype = subtype as NSString
            self.type = type as NSString
            self.url = url as NSString
            self.width = width as NSString
        }
    }
    
    class Legacy {
        
        var wide: NSString
        var wideheight: NSString
        var widewidth: NSString
        
        init() {
            self.wide = ""
            self.wideheight = ""
            self.widewidth = ""
        }
        
        init(wide: String, wideheight: String, widewidth: String){
            self.wide = wide as NSString
            self.wideheight = wideheight as NSString
            self.widewidth = widewidth as NSString
        }
    }
    
    class Person {
        
        var firstname: NSString
        var lastname: NSString
        var organization: NSString
        var rank: NSString
        var role: NSString
        
        init() {
            self.firstname = ""
            self.lastname = ""
            self.organization = ""
            self.rank = ""
            self.role = ""
        }
        
        init(firstname: String, lastname: String, organization: String, rank: String, role: String){
            self.firstname = firstname as NSString
            self.lastname = lastname as NSString
            self.organization = organization as NSString
            self.rank = rank as NSString
            self.role = role as NSString
        }
    }
    
}
