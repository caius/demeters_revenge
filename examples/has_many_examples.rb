require 'rubygems'
require 'spec'
require 'active_record'
require 'fileutils'
require File.join(File.dirname(__FILE__), *%w[../lib/demeters_revenge])

describe "Person that has_many Widgets" do
  
  before(:all) do
    ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'examples.db'
    )
    ActiveRecord::Base.connection.execute("CREATE TABLE people(id integer auto_increment primary_key, name)")
    ActiveRecord::Base.connection.execute("CREATE TABLE widgets(id integer auto_increment primary_key, name varchar(255), person_id integer)")

    Person = Class.new(ActiveRecord::Base)
    Widget = Class.new(ActiveRecord::Base)
    
    Person.send(:include, DemetersRevenge::HasManyExtensions)
  end
  
  before(:each) do
    Person.send(:has_many, :widgets)
    
    @person = Person.create
  end
  
  after(:each) do
    Person.delete_all
    Widget.delete_all
  end
  
  it "should be able to build widgets and report how many widgets it has" do
    @person.build_widget(:name => 'Widget One')
    @person.build_widget(:name => 'Widget Two')
    @person.number_of_widgets.should == 2
  end
  
  it "should be able to create widgets in the database and return a count" do
    @person.create_widget(:name => 'Widget One')
    @person.create_widget(:name => 'Widget Two')
    @person.widget_count.should == 2
  end
  
  it "should clear all widgets from the collection" do
    @person.build_widget(:name => 'Widget One')
    @person.clear_widgets
    @person.number_of_widgets.should == 0
  end
  
  it "should have no widgets by default" do
    @person.should have_no_widgets
  end
  
  it "should have widgets once at least on has been added" do
    @person.create_widget(:name => 'Widget One')
    @person.should have_widgets
  end
  
  it "should be able to delete created widgets" do
    widget = @person.create_widget
    @person.delete_widget(widget)
    @person.widget_count.should == 1
  end
  
  it "should be able to find an existing widget" do
    pending("Problem with sqlite")
  end
  
  after(:all) do
    FileUtils.rm('examples.db')
  end
  
end