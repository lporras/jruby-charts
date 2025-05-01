require 'jar-dependencies'
require_jar 'org.jfree', 'jfreechart', '1.5.5'
require_jar 'org.jfree', 'org.jfree.chart3d', '2.1.0'

require 'json'

java_import java.awt.Color
java_import java.awt.Rectangle
java_import java.awt.image.BufferedImage
java_import javax.imageio.ImageIO
java_import org.jfree.chart3d.Chart3DFactory
java_import org.jfree.chart3d.data.DefaultKeyedValues
java_import org.jfree.chart3d.data.category.StandardCategoryDataset3D
java_import org.jfree.chart3d.interaction.StandardKeyedValues3DItemSelection
java_import org.jfree.chart3d.label.StandardCategoryItemLabelGenerator
java_import org.jfree.chart3d.legend.LegendAnchor
java_import org.jfree.chart3d.marker.CategoryMarker

dataset = StandardCategoryDataset3D.new
data = JSON.load(File.read("data/app_monitoring_revenue.json"))
data.each do |name, subset|
  values = DefaultKeyedValues.new
  subset.each { values.put(_1, _2) }
  dataset.add_series_as_row name, values
end

chart = Chart3DFactory.create_bar_chart("Quarterly Revenues",
                                      "Application & Performance Monitoring Companies", dataset, nil, "Quarter",
                                      "$million Revenues")
chart.chart_box_color = Color.new(255, 255, 255, 127)
chart.legend_anchor = LegendAnchor::BOTTOM_RIGHT

plot = chart.plot
plot.gridline_paint_for_values = Color::BLACK

row_axis = plot.row_axis
row_axis.set_marker "RM1", CategoryMarker.new("Apple")

column_axis = plot.column_axis
column_axis.set_marker "CM1", CategoryMarker.new("Q4/12")

renderer = plot.renderer
item_label_generator = StandardCategoryItemLabelGenerator.new(StandardCategoryItemLabelGenerator::VALUE_TEMPLATE)
item_selection = StandardKeyedValues3DItemSelection.new
item_label_generator.item_selection = item_selection
renderer.item_label_generator = item_label_generator

width, height = 600, 600
category_chart_image = BufferedImage.new(width, height, BufferedImage::TYPE_INT_RGB)
category_chart_graphics = category_chart_image.create_graphics
chart.draw(category_chart_graphics, Rectangle.new(width, height))

category_chart_file = File.open("category_chart.png", "w")
ImageIO.write(category_chart_image, "PNG", category_chart_file.to_outputstream)

# clean up resources
category_chart_graphics.dispose
category_chart_file.close

require_jar 'org.jfree', 'org.jfree.svg', '5.0.6'
java_import org.jfree.svg.SVGGraphics2D

svg_graphics = SVGGraphics2D.new(width, height)
svg_graphics.defs_key_prefix = "jruby_charts"
chart.element_hinting = true
chart.draw(svg_graphics, Rectangle.new(width, height))
svg = svg_graphics.get_svg_element chart.id
File.write("category_chart.svg", svg)

require_jar 'org.jfree', 'org.jfree.pdf', '2.0.1'
java_import org.jfree.pdf.PDFDocument

pdfDoc = PDFDocument.new
pdfDoc.title = "Application & Performance Monitoring Companies Revenue"
pdfDoc.author = "Charles Oliver Nutter";
page = pdfDoc.create_page(Rectangle.new(612, 468))
pdf_graphics = page.graphics2D
chart.draw(pdf_graphics, Rectangle.new(0, 0, 612, 468))
File.write("category_chart.pdf", pdfDoc.pdf_bytes)