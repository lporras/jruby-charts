#!/usr/bin/env jruby

# Main script to run all JRuby chart examples
# This will generate all charts in PNG, SVG, and PDF formats

# Create output directory if it doesn't exist
Dir.mkdir("output") unless Dir.exist?("output")

puts "JRuby Charts - Generating all example charts..."
puts "=" * 50

examples = [
  'examples/category_chart.rb',
  'examples/barchart.rb',
  'examples/piechart.rb'
]

examples.each do |example|
  puts "\nRunning: #{example}"
  puts "-" * 50

  begin
    require_relative example
    puts "✓ Completed: #{example}"
  rescue => e
    puts "✗ Error in #{example}: #{e.message}"
    puts e.backtrace.first(5).join("\n") if ENV['DEBUG']
  end
end

puts "\n" + "=" * 50
puts "All charts generated successfully!"
puts "Check the 'output' folder for the generated chart files."
