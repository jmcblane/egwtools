#!/usr/bin/ruby

## API Documentation: https://a.egwwritings.org

require_relative 'auth'
require 'open-uri'
require 'json'
require 'sanitize'
require 'nokogiri'

# $book_list = $egw.get('/content/books', :headers => { 'Accept' => 'application-type/json' }, :params => { "type": "book" })
# Thought I might need this... but I haven't needed it yet.

class String
    def is_i?
        /\A[-+]?\d+\z/ === self
    end
end

def clean_json(url, **opts)
    data = $egw.get(url, opts)
    json = JSON.parse(data.body)
    return json
end

def script_index(book, chapter, verse)
    entry_json = clean_json('/search/advanced/scripture/navigate',
                      :params => { 'book': book,
                                   'chapter': chapter,
                                   'verse': verse } )
    index_json = clean_json("/content/books/2778/content/#{entry_json['para']}")

    return(index_json[0]['content'])
end

def get_index_refs(raw_html)
    refs = Nokogiri::HTML(raw_html)
    total = refs.css('span').length
    count = refs.css('span').length

    ref_array = []

    refs.css('span').each do |i|
        book, para = i['data-link'].split(".")
        ref_json = clean_json("/content/books/#{book}/content/#{para}", 
                           :params => { "limit": "2" } )
        ref_array.push( { 'title': ref_json[0]['refcode_long'].gsub!(/\(.*\)/, "\n"),
                          'refcode': ref_json[0]['refcode_short'],
                          'book': book,
                          'para': para,
                          'text': Sanitize.fragment(ref_json[0]['content']) + "\n\n" + Sanitize.fragment(ref_json[1]['content']) } )
    end

    return ref_array
end

def get_paragraph(book, para)
    para_json = clean_json("/content/books/#{book}/content/#{para}")
    return { 'title': para_json[0]['refcode_long'].gsub(/\(.*\)/, ""),
             'refcode': para_json[0]['refcode_short'],
             'text': para_json[0]['content'] }
end

def get_chapter(book, para)
    chap_json = clean_json("/content/books/#{book}/chapter/#{para}")
    chap_text = []
    chap_json.each { |par| chap_text.push(Sanitize.fragment(par['content'] + " {#{par['refcode_short']}}" + "\n\n")) }
    return { 'title': chap_json[0]['refcode_long'].gsub!(/\(.*\)/, "\n"),
             'refcode': chap_json[0]['refcode_short'],
             'text': chap_text.join }
end

def ref_lookup(s_query)
    result_json = clean_json("/search/suggestions", :params => { query: s_query, lang: 'en' })
    if result_json[0]['type'] == 'search'
        return nil
    else
        book, para = result_json[0]['para_id'].split(".")
        return { 'book': book, 'para': para }
    end
end

def nwad_lookup(s_query)
    result_json = clean_json("/search/advanced/dictionary/content", :params => { chapter: s_query })
    defs = []
    result_json.each { |e| defs.push( Sanitize.fragment( e['content'] ) ) }
    x = defs.length - 1
    while x >= 0
        defs[x] = "\n" + defs[x] if defs[x][0].is_i? == true
        defs[x] = "    " + defs[x] if defs[x][0].is_i? == false && defs[x] != defs[0]
        x -= 1
    end
    return defs.join("\n")
end

def search(type, s_query, book="")
    if type == "egwbooks"
        results = clean_json("/search/advanced/book", :params => { query: s_query, lang: "en", limit: 100 })
    else
        results = clean_json("/search/advanced/#{type}", :params => { query: s_query, limit: 100})
    end

    cleaned_up = []

    for i in results['results']
        cleaned_up.push( { 'title': i['refcode_long'].gsub(/\(.*\)/, ""),
                           'book': i['para_id'].split(".")[0],
                           'para': i['para_id'].split(".")[1],
                           'refcode': i['refcode_short'],
                           'text': Sanitize.fragment(i['snippet']) } )
    end

    return cleaned_up
end

def book_toc(book_num)
    contents = clean_json("/content/books/#{book_num}/toc")
    toc_array = []

    for i in contents
        toc_array.push( { 'book': i['para_id'].split(".")[0],
                          'para': i['para_id'].split(".")[1],
                          'title': i['title'] } )
    end

    return toc_array
end

def devotional
    dev_books = clean_json('/content/books/by_folder/1227')
    return dev_books
end

def rand_devotional
    today = Time.now.strftime("%B %e")
    entries = clean_json('/search', :params => { query: today, folder: 1227 })
    rand_entry = entries['results'][rand(1..entries['results'].length)] 
    info = get_chapter(rand_entry['para_id'].split(".")[0], rand_entry['para_id'].split(".")[1])
    return info
end

#
## EDITING AND DEBUGGING STUFF
#

$content_json = JSON.parse(open("http://a.egwwritings.org/content/docs/schema/?format=openapi").read)

def api(which=nil, more=nil)
    if which == nil
        $content_json['paths'].each { |x, y| puts x }
        return 0
    elsif (which != nil && more == nil)
        $content_json['paths'][which]['get']['parameters'].each { |i| puts i['name'] }
        return 0
    elsif (which != nil && more != nil)
        $content_json['paths'][which]['get']['parameters'].each do |i|
            puts i['name']
            puts "    Required? " + i['required'].to_s
            puts "    Type: " + i['type']
            puts "    " + i['description']
        end
        return 0
    end
end
