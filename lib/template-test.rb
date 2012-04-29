require "template-test/version"
require 'nokogiri'

module Template
  module Test
    # Class that holds the context for a template
    # Variables used by the template can be added to the
    # context using the set method.
    # @see #set
    class Context
      attr_accessor :nodes

      def initialize(template_path, &block)
        @template_path = template_path
        # how to capture local variables
        self.instance_eval(&block)
      end

      # @return [Nokogiri::HTML] the document that wraps the rendered template
      # @param [Boolean] reload true if the document should be parsed again
      def document(reload = false)
        if reload
          @document = nil
        end
        @document ||= Nokogiri::HTML(render())
      end

      # Searches the rendered HTML document for the given
      # XPATH query. In the given block the result of the
      # xpath query is available through the 'nodes' instance variable.
      # @param [String] xpath an XPATH search expression
      # @param [Proc] block the testing code
      # @example see {file:spec/erb_spec.rb}.
      def xpath(xpath, &block)
        @xpath = xpath
        @nodes = document().xpath(@xpath)
        self.instance_eval(&block)
      end

      # Assigns an instance variable which is available when the template is rendered.
      # @param [Symbol] symbol the name of the instance variable
      # @param [Object] value the value of the instance variable
      # @example see {file:spec/erb_spec.rb}.
      def set(symbol, value)
        sym = "@#{symbol.to_s}".to_sym
        instance_variable_set(sym, value)
        self.send(:define_singleton_method, symbol) do
          instance_variable_get(sym)
        end
      end

      # Renders the template. All variables defined by @see #set
      # are available in the template. They can be accessed as instance
      # variables or by using the attribute accessor.
      # @return [String] the rendered template
      def render
        case @template_path
          when /\.erb$/
            render_erb(@template_path)
          when /\.haml$/
            render_haml(@template_path)
          else
            raise StandardError, "Unsupported template #{@template_path}"
        end
      end

      alias :assign :set

      private

      def render_erb(template_name)
        require 'erb'
        template = ERB.new File.read("#{@template_path}")
        # render the template in the document context
        template.result(binding())
      end

      def render_haml(template_name)
        require 'haml'
        engine = Haml::Engine.new(File.read("#{@template_path}"))
        engine.render(binding())
      end
    end

    # Runs the test code in the provided block for the specified template.
    # @param [String] template_path the path to the template
    # @param [Proc] block a block with the template testing code
    # @return [Context] the template test context
    # @example see {file:spec/erb_spec.rb}.
    def template(template_path, &block)
      Context.new(template_path, &block)
    end
  end
end
