module PermalinkFu
  module Spec
    module Matchers
      class PermalinkTo
        def initialize(permalink, to_param = nil)
          @expected_permalink = permalink
          @expected_to_param = to_param
        end

        def matches?(target)
          @target = target
          @permalink, @to_param = target.permalink, target.to_param
          @permalink == @expected_permalink && @to_param == expected_to_param
        end

        def failure_message
          message = []

          message << "to permalink to #{@expected_permalink.inspect} (got #{@permalink.inspect})" if @permalink != @expected_permalink
          message << "to generate a URL like #{expected_to_param.inspect} (got #{@to_param.inspect})" if @to_param != expected_to_param
          
          "expected #{message.join(' and ')}"
        end

        private
          def expected_to_param
            @expected_to_param.blank? ? [@target.id, @permalink].delete_if(&:blank?).join('-') : @expected_to_param
          end
      end

      # Provides a matcher for nicer specs:
      #   
      #   describe Article do
      #     it "has a permalink" do
      #       Article.create(:title => 'Lorem ipsum').should permalink_to('lorem-ipsum')
      #     end
      #   end
      def permalink_to(*args)
        PermalinkTo.new(*args)
      end
    end
  end
end
