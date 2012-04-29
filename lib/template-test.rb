require "template-test/version"
require 'nokogiri'

module Template
  module Test
    class Context
      attr_accessor :nodes

      def initialize(template_name, &block)
        @template_name = template_name
        # how to capture local variables
        self.instance_eval(&block)
      end

      def document(reload = false)
        if reload
          @document = nil
        end
        @document ||= Nokogiri::HTML(render())
      end

      def xpath(xpath, &block)
        @xpath = xpath
        @nodes = document().xpath(@xpath)
        self.instance_eval(&block)
      end

      def set(symbol, value)
        sym = "@#{symbol.to_s}".to_sym
        instance_variable_set(sym, value)
        self.send(:define_singleton_method, symbol) do
          instance_variable_get(sym)
        end
      end

      def render
        case @template_name
          when /\.erb$/
            render_erb(@template_name)
          when /\.haml$/
            render_haml(@template_name)
          else
            raise StandardError, "Unsupported template #{@template_name}"
        end
      end

      alias :assign :set

      private

      def render_erb(template_name)
        require 'erb'
        template = ERB.new File.read("#{@template_name}")
        # render the template in the document context
        template.result(binding())
      end

      def render_haml(template_name)
        require 'haml'
        engine = Haml::Engine.new(File.read("#{@template_name}"))
        engine.render(binding())
      end
    end

    def template(template_name, &block)
      Context.new(template_name, &block)
    end
  end
end
