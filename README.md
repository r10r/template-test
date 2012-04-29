# Template::Test

Template::Test provides a simple DSL to test the rendering of HTML templates
defined in ERB or HAML using XPATH expressions.

## Installation

Add this line to your application's Gemfile:

    gem 'template-test'

## Using with RSpec

In your `test_helper` include the Template::Test module in the rspec config:

    RSpec.configure do |config|
       config.include Template::Test
    end

## Examples

Have a look at the `*_spec.rb` files in the `spec` folder.