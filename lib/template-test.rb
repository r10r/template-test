require "template-test/version"
require 'nokogiri'

module Template
  module Test
    class Context
      attr_accessor :nodes

      def initialize(template_path, &block)
        @template_path = template_path
        # how to capture local variables
        self.instance_eval(&block)
      end

      # @return the parsed Nokogiri::HTML document that wraps the rendered template
      # @param [Boolean] reload true if the document should be parsed again
      def document(reload = false)
        if reload
          @document = nil
        end
        @document ||= Nokogiri::HTML(render())
      end

      # Evaluates the given block of test code in the context
      # of the document which wraps the rendered template.
      # The nodes retrieved by the given xpath expression can
      # be accessed through the 'nodes' method.
      # @param xpath an XPATH search expression
      # @param block the testing code
      # @example see #spec/erb_spec.rb
      def xpath(xpath, &block)
        @xpath = xpath
        @nodes = document().xpath(@xpath)
        self.instance_eval(&block)
      end

      # Creates an instance variable which is available in the rendered template.
      # @param [Symbol] symbol the name of the instance variable
      # @param [Object] value the value of the instance variable
      # @example see #spec/erb_spec.rb
      def set(symbol, value)
        sym = "@#{symbol.to_s}".to_sym
        instance_variable_set(sym, value)
        self.send(:define_singleton_method, symbol) do
          instance_variable_get(sym)
        end
      end

      # Renders the template in this context. All variables defined by #set
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
    # @param template_path the path to the template
    # @param block a block containing the template testing code
    # @example see #spec/erb_spec.rb
    def template(template_path, &block)
      Context.new(template_path, &block)
    end
  end
end
