module Spec
  module Rails
    
    module Filter
      def self.included(base)
        base.send( :include, InstanceMethods )
      end
      module InstanceMethods
        def runnable_callback?(action)
          should_run_callback?( Struct.new(:action_name).new(action) )
        end
      end
    end

    module Matchers
      class HaveFilter
        def initialize(filter_name)
          @filter_name = filter_name.to_sym
          @filter_type = :before
          @actions = :any_action
        end

        def matches?(target)
          @target = target.class
          filter = @target.filter_chain.find(@filter_name) { |filter| filter.type == @filter_type }

          if @actions == :any_action
            filter
          else
            @actions = stringify(@actions)
            filter and @actions.find { |action| filter.runnable_callback?(action) }
          end
        end

        def failure_message
          "#{@target} expected to have #{@filter_type}_filter #{@filter_name} but none found"
        end

        def negative_failure_message  
          "#{@target} expected not to have #{@filter_type}_filter #{@filter_name}, but it was found"
        end

        def before(actions)
          @filter_type = :before
          @actions = actions
          self
        end

        def after(actions)
          @filter_type = :after
          @actions = actions
          self
        end

        def around(actions)
          @filter_type = :around
          @actions = actions
          self
        end

        private

        def stringify(ary)
          ary = [ary] unless ary.is_a?(Array)
          ary.map(&:to_s)
        end
      end

      def have_filter(method_name)
        HaveFilter.new(method_name)
      end

      def have_before_filter(method_name)
        HaveFilter.new(method_name).before(:any_action)
      end

      def have_after_filter(method_name)
        HaveFilter.new(method_name).after(:any_action)
      end

      def have_around_filter(method_name)
        HaveFilter.new(method_name).around(:any_action)
      end
    end
  end
end

