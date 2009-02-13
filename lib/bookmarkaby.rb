module Rudionrails
  module Bookmarkaby
  
    # takes :title, :url as options
    def bookmarkaby ( options = {}, &block )
      bb = BookmarkBuilder.new( self, options )
      yield bb
      concat_with_or_without_binding( bb.to_html, block.binding ) if bb.bookmarks?
    end
    
    class BookmarkBuilder
      
      DEFAULT_IMAGE_PREFIX = "bookmarkaby/" unless defined? DEFAULT_IMAGE_PREFIX
      
      URL = '{URL}' unless defined? URL
      TITLE = '{TITLE}' unless defined? TITLE
      DESCRIPTION  = '{DESCRIPTION}' unless defined? DESCRIPTION

      # keywords, tags
      SERVICES = {
        :reddit           => ["Reddit",     "http://reddit.com/submit?url=#{URL}&amp;title=#{TITLE}"],
        :digg             => ["Digg",       "http://digg.com/submit?phase=2&amp;url=#{URL}&amp;title=#{TITLE}&amp;bodytext=#{DESCRIPTION}&amp;tags="],
        :delicious        => ["Del.icio.us",  "http://del.icio.us/post?url=#{URL}&amp;title=#{TITLE}&amp;v=2&amp;notes=&amp;tags="],
        :stumbleupon      => ["StumbleUpon", "http://www.stumbleupon.com/submit?url=#{URL}&amp;title=#{TITLE}"],
        :slashdot         => ["Slashdot",   "http://slashdot.org/bookmark.pl?url=#{URL}&amp;title=#{TITLE}"],
        :technorati       => ["Technorati", "http://technorati.com/faves?add=#{URL}&amp;tag="],
        :newsvine         => ["Newsvine",   "http://www.newsvine.com/_wine/save?popoff=1&amp;u=#{URL}&amp;tags=&amp;blurb=#{TITLE}"],
        :magnolia         => ["Ma.Gnolia",  "http://ma.gnolia.com/bookmarklet/add?url=#{URL}&amp;title=#{TITLE}&amp;description=#{DESCRIPTION}&amp;tags="],
        :snurl            => ["snurl",      "http://snipr.com/site/snip?r=simple&link=#{URL}&title=#{TITLE}"],
        :spurl            => ["Spurl",      "http://www.spurl.net/spurl.php?v=3&amp;url=#{URL}&amp;title=#{TITLE}&amp;tags="],

        :twitter          => ['twitter',    "http://twitthis.com/twit?url=#{URL}&title=#{TITLE}"],
        :windowslive      => ['windows live', "https://favorites.live.com/quickadd.aspx?marklet=1&mkt=en-gb&top=0&url=#{URL}&title=#{TITLE}"],
        :myspace          => ['myspace',    "http://www.myspace.com/index.cfm?fuseaction=postto&l=1&u=#{URL}&t=#{TITLE}&c=#{DESCRIPTION}"],
        :facebook         => ["Facebook",   "http://www.facebook.com/sharer.php?u=#{URL}&amp;t=#{TITLE}"],
        :myaol            => ['my aol',     "http://favorites.my.aol.com/ffclient/AddBookmark?favelet=true&url=#{URL}&title=#{TITLE}"],
        :yahoo            => ["Yahoo",      "http://myweb2.search.yahoo.com/myresults/bookmarklet?u=#{URL}&amp;t=#{TITLE}&amp;d=#{DESCRIPTION}&amp;tag="],
        :google           => ["Google",     "http://www.google.com/bookmarks/mark?op=add&amp;bkmk=#{URL}&amp;title=#{TITLE}&amp;annotation=&amp;labels="],

        :linkarena        => ["Linkarena",  "http://linkarena.com/bookmarks/addlink/?url=#{URL}&amp;title=#{TITLE}&amp;desc=#{DESCRIPTION}&amp;tags="],
        :folkd            => ["Folkd",      "http://www.folkd.com/submit/#{URL}"],
        :jumptags         => ["Jumptags",   "http://www.jumptags.com/add/?url=#{URL}&amp;title=#{TITLE}"],
        :simpy            => ["Simpy",      "http://www.simpy.com/simpy/LinkAdd.do?href=#{URL}&amp;title=#{TITLE}&amp;tags=&amp;note="],
        :propeller        => ["Propeller",  "http://www.propeller.com/submit/?U=#{URL}&amp;T=#{TITLE}"],
        :furl             => ["Furl",       "http://www.furl.net/storeIt.jsp?u=#{URL}&amp;t=#{TITLE}&amp;keywords="],
        :tinyurl          => ["tiny url",   "http://tinyurl.com/create.php?url=#{URL}"],
        :blinklist        => ["Blinklist",  "http://www.blinklist.com/index.php?Action=Blink/addblink.php&amp;Description=#{DESCRIPTION}&amp;Tag=&amp;Url=#{URL}&amp;Title=#{TITLE}"],
        :blogmarks        => ["Blogmarks",  "http://blogmarks.net/my/new.php?mini=1&amp;simple=1&amp;url=#{URL}&amp;content=&amp;public-tags=&amp;title=#{TITLE}"],
        :diigo            => ["Diigo",      "http://www.diigo.com/post?url=#{URL}&amp;title=#{TITLE}&amp;tag=&amp;comments="],
        :blinkbits        => ["Blinkbits",  "http://www.blinkbits.com/bookmarklets/save.php?v=1&amp;title=#{TITLE}&amp;source_url=#{URL}&amp;source_image_url=&amp;rss_feed_url=&amp;rss_feed_url=&amp;rss2member=&amp;body=#{DESCRIPTION}"],
        :smarking         => ["Smarking",   "http://smarking.com/editbookmark/?url=#{URL}&amp;description=#{DESCRIPTION}&amp;tags="],
        :netvouz          => ["Netvouz",    "http://www.netvouz.com/action/submitBookmark?url=#{URL}&amp;description=#{DESCRIPTION}&amp;tags=&amp;title=#{TITLE}&amp;popup=yes"],

        :bookmarks_cc     => ["Bookmarks.cc", "http://www.bookmarks.cc/bookmarken.php?action=neu&amp;url=#{URL}&amp;title=#{TITLE}"],

        # german ones
        :yigg_de          => ["Yigg",       "http://yigg.de/neu?exturl=#{URL}"],
        :newsrider_de     => ["Newsider",   "http://www.newsider.de/submit.php?url=#{URL}"],
        :linksilo_de      => ["Linksilo",   "http://www.linksilo.de/index.php?area=bookmarks&amp;func=bookmark_new&amp;addurl=#{URL}&amp;addtitle=#{TITLE}"],
        :favit_de         => ["Favit",      "http://www.favit.de/submit.php?url=#{URL}"],
        :favoriten_de     => ["Favoriten",  "http://www.favoriten.de/url-hinzufuegen.html?bm_url=#{URL}&amp;bm_title=#{TITLE}"],
        :seekxl_de        => ["Seekxl",     "http://social-bookmarking.seekxl.de/?add_url=#{URL}&amp;title=#{TITLE}"],
        :kledy_de         => ["Kledy.de",   "http://www.kledy.de/submit.php?url=#{URL}"],
        :readster_de      => ["Readster",   "http://www.readster.de/submit/?url=#{URL}&amp;title=#{TITLE}"],
        :publishr_de      => ["Publishr",   "http://www.publishr.de/account/bookmark/?bookmark_url=#{URL}"],
        :icio_de          => ["Icio",       "http://www.icio.de/add.php?url=#{URL}"],
        :mr_wong_de       => ["Mr. Wong",   "http://www.mister-wong.de/index.php?action=addurl&amp;bm_url=#{URL}&amp;bm_description=#{TITLE}&amp;bm_notice=&amp;bm_tags="],
        :webnews_de       => ["Webnews",    "http://www.webnews.de/einstellen?url=#{URL}&amp;title=#{TITLE}"],
        :bonitrust_de     => ["BoniTrust",  "http://www.bonitrust.de/account/bookmark/?bookmark_url=#{URL}"],
        :oneview_de       => ["Oneview",    "http://www.oneview.de/quickadd/neu/addBookmark.jsf?URL=#{URL}&amp;title=#{TITLE}"],
      }.freeze unless defined? SERVICES

      def initialize ( template, options = {} )
        @template = template
        @bookmarks = []

        @url    = options.delete(:url)
        @title  = options.delete(:title)
        @description   = options.delete(:description)

        # default will be images/bookmarkaby/
        @image_prefix = options.delete(:image_prefix) || DEFAULT_IMAGE_PREFIX
        
        @options = { :class => 'bookmarkaby' }.merge( options )
      end

      # name, :image => 'image/path.png'
      def bookmark ( name, options = {}, html_options = {} )
        service = SERVICES[name]
        return unless service # igore if not in list
      
        image = @image_prefix.to_s + "#{options.delete(:image) || "#{name}.gif"}"
        @bookmarks << @template.link_to( @template.image_tag(image, :alt => service.first), parse_url(service.last), html_options)
      end
    
      # creates a bookmark for every known service
      def bookmark_all ( html_options = {} )
        SERVICES.keys.each { |s| bookmark(s, {}, html_options) }
      end

      def bookmarks; @bookmarks; end
      def bookmarks?; @bookmarks.any?; end
    
      def to_html
        @template.content_tag(:div, @bookmarks.join("\n"), @options)
      end


      protected

      def parse_url( url )
        url = url.sub(URL, @url.to_s)
        url.sub!(TITLE, @title.to_s)
        url.sub!(DESCRIPTION, @description.to_s)
        url
      end

    end
    
    private
    
    # This is for Rails downwards compatibility. Bookmarkaby was written for 
    # Rails 2.2.2, but this should also work for older versions now.
    def concat_with_or_without_binding( value, binding )
      return concat( value, binding ) if defined?(::Rails) && ::Rails::VERSION::STRING < "2.2.0"
      concat( value ) 
    end
  end
end

ActionView::Base.send :include, Rudionrails::Bookmarkaby
