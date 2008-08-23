# require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/spec_helper'


class DummyApplicationController < ActionController::Base
  before_filter :before_filter_method
  after_filter :after_filter_method
  around_filter :around_filter_method
  
  before_filter :before_show_filter_method, :only => :show
  around_filter :around_show_filter_method, :only => :show
  after_filter :after_show_filter_method, :only => :show

  before_filter :except_hide_before_filter_method, :except => :hide
  around_filter :except_hide_around_filter_method, :except => :hide
  after_filter :except_hide_after_filter_method, :except => :hide
  
  before_filter :before_some_actions_filter, :only => [:method_1, :method_2]
end


describe "Default filter lookup settings" do
  include Spec::Rails::Matchers
  before(:each) { @controller = DummyApplicationController.new }

  it "should look for before_filters" do
    @controller.should have_filter(:before_filter_method)
  end
  
  it "should not look for after_filters" do
    @controller.should_not have_filter(:after_filter_method)
  end

  it "should not look for around_filters" do
    @controller.should_not have_filter(:around_filter_method)
  end
  
  it "should look for filter restricted with :only" do
    @controller.should have_filter(:before_show_filter_method)
  end
  
  it "should look for filter restricted with :except" do
    @controller.should have_filter(:except_hide_before_filter_method)
  end
end


describe "Lookup for filter with specified type" do
  include Spec::Rails::Matchers  
  before(:each) { @controller = DummyApplicationController.new }

  it "should detect generic before_filter" do
    @controller.should have_filter(:before_filter_method).before(:any_action)
  end

  it "should detect generic around_filter" do
    @controller.should have_filter(:around_filter_method).around(:any_action)
  end

  it "should detect generic after_filter" do
    @controller.should have_filter(:after_filter_method).after(:any_action)
  end
end


describe "Lookup for filter restricted with :only" do
  include Spec::Rails::Matchers
  before(:each) {@controller = DummyApplicationController.new}
  it "should detect before filter" do
    @controller.should have_filter(:before_show_filter_method).before(:show)
  end
  
  it "should detect after filter" do
    @controller.should have_filter(:around_show_filter_method).around(:show)
  end
  
  it "should detect around filter" do
    @controller.should have_filter(:after_show_filter_method).after(:show)
  end

  it "should not detect before filter for actions it's not specified for" do
    @controller.should_not have_filter(:before_show_filter_method).before(:hide)
  end

  it "should not detect around filter for actions it's not specified for" do
    @controller.should_not have_filter(:around_show_filter_method).before(:hide)
  end
  
  it "should not detect after filter for actions it's not specified for" do
    @controller.should_not have_filter(:after_show_filter_method).before(:hide)
  end
end


describe "Lookup for filter restricted with :except" do
  include Spec::Rails::Matchers
  before(:each) {@controller = DummyApplicationController.new}
  it "should detect before filter" do
    @controller.should have_filter(:except_hide_before_filter_method).before(:show)
  end
  
  it "should detect after filter" do
    @controller.should have_filter(:except_hide_after_filter_method).after(:show)
  end
  
  it "should detect around filter" do
    @controller.should have_filter(:except_hide_around_filter_method).around(:show)
  end

  it "should not detect before filter for actions it's not specified for" do
    @controller.should_not have_filter(:except_hide_before_filter_method).before(:hide)
  end

  it "should not detect around filter for actions it's not specified for" do
    @controller.should_not have_filter(:except_hide_around_filter_method).before(:hide)
  end

  it "should not detect after filter for actions it's not specified for" do
    @controller.should_not have_filter(:except_hide_after_filter_method).before(:hide)
  end
end


describe "Filter lookup with array of actions specified" do
  include Spec::Rails::Matchers
  before(:each){ @controller = DummyApplicationController.new }
  it "should detect filter specified only for specific actions" do
    @controller.should have_filter(:before_some_actions_filter).before([:method_1, :method_2])
  end
  
  it "should detect filter specified fol all actions except specified" do
    @controller.should_not have_filter(:before_some_actions_filter).before(:show)
  end  
end


describe "matcher variations" do
  include Spec::Rails::Matchers
  before(:each) { @controller = DummyApplicationController.new }
  
  it "should treat have_before_filter(:action) as have_filter(:action).before(:any_action)" do
    @controller.should have_before_filter(:before_filter_method)
  end
  
  it "should treat have_around_filter(:action) as have_filter(:action).around(:any_action)" do
    @controller.should have_around_filter(:around_filter_method)
  end
  
  it "should treat have_after_filter(:action) as have_filter(:action).after(:any_action)" do
    @controller.should have_after_filter(:after_filter_method)
  end
  
end
