require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe "ActiveRecord class with has_many extension mixed in" do
  
  before do
    @klass = ActiveRecordStub.dup
    @klass.send(:include, DemetersRevenge::HasManyExtensions)
  end
  
  it "should delegate to original has_many then inject transmogrifiers when calling has_many" do
    @klass.expects(:has_many_without_transmogrifiers).with(:widgets)
    DemetersRevenge::HasManyExtensions.expects(:inject_transmogrifiers).with(@klass, :widgets)
    @klass.send(:has_many, :widgets)
  end
  
  it "should raise if you try and include the extension more than once" do
    proc do 
      @klass.send(:include, DemetersRevenge::HasManyExtensions)
      
    end.should raise_error(DemetersRevenge::MultipleTransmogrification)
  end
  
end

describe "ActiveRecord object after transmogrifiers injected for has_many :widgets" do
  
  before do
    DemetersRevenge::HasManyExtensions.inject_transmogrifiers(ActiveRecordStub, :widgets)
    @object = ActiveRecordStub.new
  end
  
  it "should respond to build_widget" do
    @object.should respond_to(:build_widget)
  end
  
  it "should respond to create_widget" do
    @object.should respond_to(:create_widget)
  end
  
  it "should respond to delete_widget" do
    @object.should respond_to(:delete_widget)
  end
  
  it "should respond to clear_widgets" do
    @object.should respond_to(:clear_widgets)
  end
  
  it "should respond to number_of_widgets" do
    @object.should respond_to(:number_of_widgets)
  end
  
  it "should respond to widget_count" do
    @object.should respond_to(:widget_count)
  end
  
  it "should respond to has_widgets?" do
    @object.should respond_to(:has_widgets?)
  end
  
  it "should respond to has_no_widgets?" do
    @object.should respond_to(:has_no_widgets?)
  end
  
  it "should respond to find_widgets" do
    @object.should respond_to(:find_widgets)
  end
  
end

describe "ActiveRecord object with has_many :widgets and transmogrifiers mixed in" do
  
  before(:all) do
    ActiveRecordStub.send(:include, DemetersRevenge::HasManyExtensions)
  end
  
  before do
    ActiveRecordStub.send(:has_many, :widgets)
    
    @object = ActiveRecordStub.new
    @association_proxy = mock('widgets association proxy')
    @object.stubs(:widgets).returns(@association_proxy)
  end
  
  it "should call build on association proxy with arguments when calling build_widget" do
    @association_proxy.expects(:build).with('arg1', 'arg2', 'arg3')
    @object.build_widget('arg1', 'arg2', 'arg3')
  end
  
  it "should call create on association proxy with arguments when calling create_widget" do
    @association_proxy.expects(:create).with('arg1', 'arg2', 'arg3')
    @object.create_widget('arg1', 'arg2', 'arg3')
  end
  
  it "should return the count from the association proxy when calling widget_count" do
    @association_proxy.expects(:count).returns(3)
    @object.widget_count.should == 3
  end
  
  it "should pass arguments to association proxy count method when calling widget_count with args" do
    @association_proxy.expects(:count).with(:conditions => 'foo')
    @object.widget_count(:conditions => 'foo')
  end
  
  it "should return the number of loaded widgets in the collection when calling number_of_widgets" do
    @association_proxy.stubs(:length).returns(10)
    @object.number_of_widgets.should == 10
  end
  
end