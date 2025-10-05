# Use jar-dependencies, included with JRuby, to load JFreeChart
require 'jar-dependencies'
require_jar 'org.jfree', 'jfreechart', '1.5.5'

# Create an empty PieDataset
pie_data = org.jfree.data.general.DefaultPieDataset.new

# Add values to the dataset
pie_data.insert_value 0, "Fun", 0.45
pie_data.insert_value 1, "Useful", 0.25
pie_data.insert_value 2, "Cool", 0.15
pie_data.insert_value 3, "Enterprisey", 0.10
pie_data.insert_value 4, "Exciting", 0.5

# Create a pie chart with default settings
pie_chart = org.jfree.chart.ChartFactory.create_pie_chart "Why JRuby?", pie_data

# Anti-alias the chart to look a bit cleaner
pie_chart.anti_alias = true

# Access the actual PiePlot to tweak additional settings
pie_plot = pie_chart.plot
pie_plot.set_explode_percent "Fun", 0.20

# Create a buffered image in memory at 500x500
pie_image = pie_chart.create_buffered_image 500, 500

# Write the image as a PNG to a file
Dir.mkdir("output") unless Dir.exist?("output")
javax.imageio.ImageIO.write(pie_image, "gif", File.open("output/piechart.gif", "w").to_outputstream)
