#!/usr/bin/ruby

require 'discordrb'
require_relative 'lib/backend'

# Get a token at discordapp.com/developers/applications
bot = Discordrb::Commands::CommandBot.new token: 'YOUR TOKEN HERE', prefix: "."

# puts "-"*30
# puts "This bot's invite URL is #{bot.invite_url + "&permissions=18432"}."
# puts "-"*30 + "\n\n"

bot.command(:invite, chain_usable: false) do |event|
    event.bot.invite_url
end

bot.command(:refresh) do |event|
    get_token
    event.respond "Token refreshed!"
end

bot.command :help do |event|
    event << "**Current commands:**"
    event << "-----------------"
    event << "    **.get** GC 17.1"
    event << "```Retrieves a paragraph by reference code.```"
    event << "    **.index** Genesis 1:1"
    event << "```Shows relevant EGW passages for the verse.```"
    event << "    **.webster** holiness"
    event << "```Webster's 1828 dictionary.```"
    event << "    **.readlink** GC 17.1"
    event << "```Returns the link to read the full chapter.```"
    event << "    **.random**"
    event << "```Get a random devotional entry for today.```"
    event << "    **.search** *egwbooks* abomination of desolation"
    event << "```Search results are given in a private message."
    event << "Valid search types: egwbooks, pioneers, topical, and periodicals```"
    event << "-----------------"
    event << "If the commands aren't working, try **.refresh**"
end

bot.command(:get) do |_event, *args|
    if args.length > 2

        book_no = ref_lookup(args[0])[:book]

        if args[4].is_i? == true
            query = args[1..-2].join(" ")
        else
            query = args[1..-3].join(" ")
        end

        search = clean_json("/search/", :params => {query: query, pubnr: book_no})

        if search['total'] > 0

            if (args[4] == "A" || args[4].is_i? == true)
                result_num = 0
            elsif args[4] == "B"
                result_num = 1
            elsif args[4] == "C"
                result_num = 2
            end

            para_no = search['results'][result_num]['para_id'].split(".")[1]
            refcode = search['results'][result_num]['refcode_short']
            info = get_chapter(book_no, para_no)
            paragraphs = info[:text].split("\n\n")

            if paragraphs[2] == "EGW"
                shift = 2
            elsif paragraphs[3] == "EGW"
                shift = 3
            elsif paragraphs[4] == "EGW"
                shift = 4
            else
                _event.respond "You found a bug! Tell Jacob!"
            end

            _event.respond paragraphs[args[-1].to_i + shift]
            _event.respond "**#{refcode} Par. #{args[-1]}**"

        end
    else
        reference = args.join(" ")
        if /-/.match?(reference.split(".")[1]) == true
            par_array = []
            refcodes = []
            book, para = reference.split(".")
            para_b, para_e = para.split("-")
            for i in (para_b.to_i..para_e.to_i)
                info = ref_lookup("#{book}.#{i}")
                if info.nil? == false
                    para = get_paragraph(info[:book], info[:para])
                    par_array.push( para[:text] )
                    refcodes.push( para[:refcode] )
                end
            end

            for i in par_array
                _event.respond( Sanitize.fragment(i) )
            end
            _event.respond( "**{ #{refcodes[0]} - #{refcodes[-1]} }**")

        else
            info = ref_lookup(reference)
            if info.nil? == false
                para = get_paragraph(info[:book], info[:para])
                _event << Sanitize.fragment(para[:text]) + " **{" + para[:refcode] + "}**"

            else
                "Nothing found. Try again."
            end
        end
    end
end
 
bot.command(:index) do |_event, *args|
    if args[1] != nil

         if args[0].is_i? == false
            b = args[0]
            c = args[1].split(":")[0]
            v = args[1].split(":")[1]
        else
            b = args[0..1].join("")
            c = args[2].split(":")[0]
            v = args[2].split(":")[1]
        end

        refs = script_index(b, c, v)
        _event.respond Sanitize.fragment(refs)
    end
end

bot.command(:webster) do |_event, *args|
    _event.respond nwad_lookup(args[0])
end

bot.command(:random) do |event|
    info = rand_devotional
    event.respond info[:title]
    event.respond info[:refcode]
    event.respond "-"*30
    text = info[:text].split("\n\n")
    event.respond text[0..text.length/2].join("\n\n") + "\n\n"
    event.respond text[text.length/2+1..-1].join("\n\n")
end

bot.command(:readlink) do |_event, *args|
    info = ref_lookup(args.join(" "))
    _event.respond "https://m.egwwritings.org/en/book/#{info[:book]}.#{info[:para]}"
end

def print_results(event, results)

    5.times do
        return if results == []
        ref = results.shift
        event.user.pm <<-EOC
--------------------
**#{ref[:title]}**
*#{ref[:refcode]}*
--------------------
#{ref[:text]}
--------------------
https://m.egwwritings.org/en/book/#{ref[:book]}.#{ref[:para]}
--------------------
EOC
    end
end

bot.command(:search) do |_event, *args|
    type = args[0]
    query = args[1..-1].join(" ")

    return "**Correct format is:** .search TYPE what you want (see .help for more)" if (query.nil? || query == "")

    type = "apl" if type == "pioneers"

    results = search(type, query)
    return "No results. Check your search type." if (results.nil? || results == [])
    print_results(_event, results)
end

bot.run
