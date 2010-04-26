module ActionView #:nodoc:
  module Helpers #:nodoc:
    module FormTagHelper
      # Creates a search field.
      #
      # ==== Options
      # * <tt>:autosave</tt> - If set to true, will generate a domain-based
      #   namespace (e.g., for blog.rubyonrails.com, "com.rubyonrails.blog").
      #   Also accepts string values.
      # * <tt>:results</tt> - The number of previous searches displayed in the
      #   drop-down. Default: 10, with <tt>:autosave</tt>.
      # * Otherwise accepts the same options as text_field_tag.
      #
      # ==== Examples
      #   search_field_tag 'query'
      #   # => <input id="query" name="query" type="search" />
      #
      #   search_field_tag 'query', nil, :autosave => true
      #   # => <input id="query" name="query" type="search" autosave="tld.yourdomain" results="10">
      #
      #   search_field_tag 'site_search', nil, :autosave => 'com.rubyonrails', :results => 5
      #   # => <input id="site_search" name="site_search" type="search" autosave="com.rubyonrails" results="5">
      def search_field_tag(name, value = nil, options = {})
        options = options.stringify_keys

        if options["autosave"]
          if options["autosave"] == true
            options["autosave"] = request.host.split(".").reverse.join(".")
          end
          options["results"] ||= 10
        end

        if options["onsearch"]
          options["incremental"] = true unless options.has_key?("incremental")
        end

        text_field_tag(name, value, options.update("type" => "search"))
      end

      # Creates a text field of type "tel".
      #
      # ==== Options
      # * Accepts the same options as text_field_tag.
      def telephone_field_tag(name, value = nil, options = {})
        text_field_tag(name, value, options.stringify_keys.update("type" => "tel"))
      end
      alias phone_field_tag telephone_field_tag

      # Creates a text field of type "url".
      #
      # ==== Options
      # * Accepts the same options as text_field_tag.
      def url_field_tag(name, value = nil, options = {})
        text_field_tag(name, value, options.stringify_keys.update("type" => "url"))
      end

      # Creates a text field of type "email".
      #
      # ==== Options
      # * Accepts the same options as text_field_tag.
      def email_field_tag(name, value = nil, options = {})
        text_field_tag(name, value, options.stringify_keys.update("type" => "email"))
      end

      # Creates a number field.
      #
      # ==== Options
      # * <tt>:min</tt> - The minimum acceptable value.
      # * <tt>:max</tt> - The maximum acceptable value.
      # * <tt>:in</tt> - A range specifying the <tt>:min</tt> and
      #   <tt>:max</tt> values.
      # * <tt>:step</tt> - The acceptable value granularity.
      # * Otherwise accepts the same options as text_field_tag.
      #
      # ==== Examples
      #   number_field_tag 'quantity', nil, :in => 1...10
      #   => <input id="quantity" name="quantity" min="1" max="9" />
      def number_field_tag(name, value = nil, options = {})
        options = options.stringify_keys
        options["type"] ||= "number"
        if range = options.delete("in") || options.delete("within")
          options.update("min" => range.min, "max" => range.max)
        end
        text_field_tag(name, value, options)
      end

      # Creates a range form element.
      #
      # ==== Options
      # * Accepts the same options as number_field_tag.
      def range_field_tag(name, value = nil, options = {})
        number_field_tag(name, value, options.stringify_keys.update("type" => "range"))
      end
    end

    module FormHelper #:nodoc:
      def search_field(object_name, method, options = {})
        options = options.stringify_keys

        if options["autosave"]
          if options["autosave"] == true
            options["autosave"] = request.host.split(".").reverse.join(".")
          end
          options["results"] ||= 10
        end

        if options["onsearch"]
          options["incremental"] = true unless options.has_key?("incremental")
        end

        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("search", options)
      end

      def telephone_field(object_name, method, options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("tel", options)
      end
      alias phone_field telephone_field

      def url_field(object_name, method, options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("url", options)
      end

      def email_field(object_name, method, options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("email", options)
      end

      def number_field(object_name, method, options = {})
        options = options.stringify_keys
        options["type"] ||= "number"
        if range = options.delete("in") || options.delete("within")
          options.update("min" => range.min, "max" => range.max)
        end
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("number", options)
      end

      def range_field(object_name, method, options = {})
        options = options.stringify_keys
        options["type"] ||= "number"
        if range = options.delete("in") || options.delete("within")
          options.update("min" => range.min, "max" => range.max)
        end
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("range", options)
      end
    end

    class FormBuilder #:nodoc:
      %w(search_field telephone_field url_field email_field number_field range_field).each do |selector|
        src = <<-end_src
          def #{selector}(method, options = {})
            @template.send(
              #{selector.inspect},
              @object_name,
              method,
              objectify_options(options))
          end
        end_src
        class_eval src, __FILE__, __LINE__
      end

      alias phone_field telephone_field
    end
  end
end
