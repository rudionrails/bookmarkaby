require File.dirname(__FILE__) + '/test_helper'

class BookmarkabyTest < ActiveSupport::TestCase
  
  # "<div class=\"bookmarkaby\">
  # <a href=\"http://digg.com/submit?phase=2&amp;url=http://nowhere.dev&amp;title=awesome&amp;bodytext=&amp;tags=\">
  # <img alt=\"Digg\" src=\"/images/digg.gif\" />
  # </a>
  # </div>"
  
  def setup
    @view = ::ActionView::Base.new
    @view.output_buffer = ""
    
    @template = ""
  end
  
  test "should display nothing if no bookmarks given" do
    bkm = @view.bookmarkaby { }
    assert_nil bkm
  end
  
  test "should display nothing for non-existing bookmark services " do
    bkm = @view.bookmarkaby { |b| b.bookmark :some_non_existing_service }
    assert_nil bkm
  end
  
  test "should display an image link" do
    bkm = @view.bookmarkaby { |b| b.bookmark :digg }
    assert_match(/href.*img/, bkm)
  end
  
  test "should display default image" do
    image = "digg.gif"
    bkm = @view.bookmarkaby { |b| b.bookmark :digg }
    assert_match(/\/images\/#{Rudionrails::Bookmarkaby::BookmarkBuilder::DEFAULT_IMAGE_PREFIX}#{image}/, bkm)
  end
  
  test "should display image_prefix" do
    image_prefix = 'bookmarkaby/'
    bkm = @view.bookmarkaby(:image_prefix => image_prefix) { |b| b.bookmark :digg }
    assert_match(/\/images\/#{image_prefix}digg.gif/, bkm)
  end
  
  test "should display id" do
    id = 'bookmarkaby-id'
    bkm = @view.bookmarkaby(:id => id) { |b| b.bookmark :digg }
    assert_match(/<div.*id=\"#{id}\"/, bkm)
  end
  
  test "should display class" do
    klass = 'bookmarkaby-class'
    bkm = @view.bookmarkaby(:class => klass) { |b| b.bookmark :digg }
    assert_match(/<div.*class=\"#{klass}\"/, bkm)
  end
  
  test "should display url" do
    url = 'http://nowhere.dev'
    bkm = @view.bookmarkaby(:url => url) { |b| b.bookmark :digg }
    assert_match(/#{url}/, bkm)
  end
  
  test "should display title" do
    title = 'my title'
    bkm = @view.bookmarkaby(:title => title) { |b| b.bookmark :digg }
    assert_match(/#{title}/, bkm)
  end
  
  test "should display description" do
    description = 'this is an awesome bookmark'
    bkm = @view.bookmarkaby(:description => description) { |b| b.bookmark :digg }
    assert_match(/#{description}/, bkm)
  end
  
  test "should display the name of the service as image alt tag" do
    service = Rudionrails::Bookmarkaby::BookmarkBuilder::SERVICES[:digg]
    bkm = @view.bookmarkaby { |b| b.bookmark :digg }
    assert_match(/alt=\"#{service.first}\"/, bkm)
  end

end
