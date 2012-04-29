require 'spec_helper'

describe "testing HAML templates" do
  it "should assign variables and evaluate xpath expressions" do
    template "spec/template/form.html.haml" do
      # set instance variables required by the template
      assign :title, "this is the title"
      assign :content, "this is the content"

      xpath "//input[@name='title']" do
        nodes.count.should == 1
        nodes[0].attr("value").should == title
      end

      xpath "//textarea[@name='content']" do
        nodes.count.should == 1
        nodes[0].text.should == content
      end
    end
  end
end