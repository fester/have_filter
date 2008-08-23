require 'have_filter'
ActionController::Filters::Filter.send( :include, Spec::Rails::Filter ) 
