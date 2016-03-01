width = 960
height = 500
fill = d3.scale.category10()

mouseX = mouseY = 0

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

gradient = svg.append("defs")
  .append("linearGradient")
    .attr("id", "gradient")
    .attr("x1", "0%")
    .attr("y1", "0%")
    .attr("x2", "100%")
    .attr("y2", "100%")
    .attr("spreadMethod", "pad");

gradient.append("stop")
    .attr("offset", "0%")
    .attr("stop-color", "#0c0")
    .attr("stop-opacity", 1);

gradient.append("stop")
    .attr("offset", "100%")
    .attr("stop-color", "#c00")
    .attr("stop-opacity", 1);

svg.append("rect")
    .attr("width", 100)
    .attr("height", 100)
    .style("fill", "url(#gradient)")

line1 = svg.append('rect')
  .attr('y', 0)
  .attr('width', 1)
  .attr('height', height)
  .attr('fill', 'red')

line2 = svg.append('rect')
  .attr('y', 0)
  .attr('height', 1)
  .attr('width', width)
  .attr('fill', 'red')

rect1 = svg.append('rect')
  .attr('x', 100)
  .attr('y', 100)
  .attr('width', 140)
  .attr('height', 30)
  .attr('fill', 'blue')

positionText = svg.append('text')
  .attr('x', 110)
  .attr('y', 120)
  .attr('fill', 'white')

scaleX = d3.scale.linear()
  .range([0, width])
  .domain([0, width])

line = svg.append('path')
  .style("stroke", "url(#gradient)")

lineFunc = d3.svg.line()
  .x((d) -> scaleX d[0])
  .y((d) -> d[1])
  .interpolate("cardinal")

mousePosition = []

svg.on 'mousemove', () ->
  pos = d3.mouse(this)

  mouseX = pos[0]
  mouseY = pos[1]

  line1.attr('x', mouseX)
  line2.attr('y', mouseY)

  positionText.text("Mouse: (#{mouseX}, #{mouseY})")

svg.on 'mousedown', () ->
  console.log 'click'

  pos = d3.mouse(this)
  svg.append('circle')
    .attr('cx', pos[0])
    .attr('cy', pos[1])
    .attr('r', 3)

  # clone
  newPositions = []
  for item in mousePosition
    newPositions.push(item)

  if mousePosition[mousePosition.length-1]
    newPositions.push(mousePosition[mousePosition.length-1])
  mousePosition.push(pos)

  line
    .attr('d', lineFunc(newPositions))
    .transition()
    .attr('d', lineFunc(mousePosition))

