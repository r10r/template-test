require 'spec_helper'

describe "test custom rendered HTML" do
  it "should test custom rendered HTML" do

    # render the template manually
    @title = "the title"
    @content = "the content"
    template = ERB.new File.read("spec/template/form.html.erb")
    body = template.result(binding())

    # inject the rendered template into the context
    html body do
      # check if the rendered template was properly injected
      @html.should == body
      html().should == body

      # and query on the injected rendered template
      xpath "//input[@name='title']" do
        nodes.length.should == 1
        nodes[0].attr("text").should == @title
      end
      xpath "//textarea[@name='content']" do
        nodes.length.should == 1
        # FIXME why is the @content not available here ?
        nodes[0].text().should == "the content"
      end
    end
  end
end