require 'spec_helper'

describe "testing ERB templates" do
  it "should assign variables and evaluate xpath expressions" do
    template "spec/template/form.html.erb" do
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

  it "should assign variables and evaluate xpath expressions" do
    template "spec/template/form_local.html.erb" do
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