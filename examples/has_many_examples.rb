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
    ActiveRecord::Base.connection.execute("CREATE TABLE people(id, name)")
    ActiveRecord::Base.connection.execute("CREATE TABLE widgets(id, name, person_id)")

    Person = Class.new(ActiveRecord::Base)
    Widget = Class.new(ActiveRecord::Base)
    
    Person.send(:include, DemetersRevenge::HasManyExtensions)
  end
  
  before(:each) do
    Person.send(:has_many, :widgets)
    
    @person = Person.create
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
  
  after(:all) do
    FileUtils.rm('examples.db')
  end
  
end