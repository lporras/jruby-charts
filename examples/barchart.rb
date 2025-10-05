# Use jar-dependencies, included with JRuby, to load JFreeChart
require 'jar-dependencies'
require_jar 'org.jfree', 'jfreechart', '1.5.5'

# Create an empty CategoryDataSet
bar_data = org.jfree.data.category.DefaultCategoryDataset.new

# Add values to the dataset
bar_data.add_value 44, "Ben and Jerry's", "Flavors by creamery"
bar_data.add_value 31, "Baskin Robbins", "Flavors by creamery"
bar_data.add_value 11, "Cold Stone", "Flavors by creamery"

# Create a bar chart with default settings
java_import org.jfree.chart.ChartFactory
bar_chart = ChartFactory.create_bar_chart "How Many Ice Cream Flavors?",
                                          "Creamery", "Flavors", bar_data

# Create a buffered image in memory at 500x500
bar_image = bar_chart.create_buffered_image 500, 500

# Write the image as a PNG to a file
Dir.mkdir("output") unless Dir.exist?("output")
bar_file = File.open("output/barchart.png", "w")
javax.imageio.ImageIO.write(bar_image, "PNG", bar_file.to_outputstream)
