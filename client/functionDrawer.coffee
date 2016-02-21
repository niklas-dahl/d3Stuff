# configure dimensions
outerWidth =  1000
outerHeight = 600

margin =
  top:    20
  right:  20
  bottom: 20
  left:   20

width = outerWidth - margin.left - margin.right
height = outerHeight - margin.top - margin.bottom

# create svg element
svg = d3.select('#svgContainer').append('svg')
    .attr('width', outerWidth)
    .attr('height', outerHeight)
  .append('g')
    .attr('transform', "translate(#{margin.left}, #{margin.top})")

# scales
xDomain = [-10, 10]
yDomain = [-2, 2]
stepSize = .01

xScale = d3.scale.linear()
    .range([0, width])
    .domain(xDomain)

yScale = d3.scale.linear()
    .range([height, 0])
    .domain(yDomain)

# axis
xAxis = d3.svg.axis()
    .scale(xScale)
    .orient('bottom')

yAxis = d3.svg.axis()
    .scale(yScale)
    .orient('left')

# function
f = (x) -> Math.sin x*x

# line
line = d3.svg.line()
    .x((d) -> xScale(d.x) )
    .y((d) -> yScale(d.y) )

data = null
# generate data
generateData = (f) ->
  data = []
  for i in [0 ... (xDomain[1] - xDomain[0]) * (1/stepSize) ]
    x = xDomain[0] + i*stepSize
    data.push
      x: x
      y: f(x)

generateData(f)

# draw line
drawLine = () ->
  svg.append('path')
    .datum(data)
    .attr('class', 'line')
    .attr('d', line)
drawLine()

updateLine = () ->
  svg.select('.line').transition()
      .duration(750)
      .attr('d', line(data))

updateScale = () ->
  svg.select('.line').transition()
      .duration(750)
      .attr('d', line(data))

  svg.select('.x.axis').transition()
      .duration(750)
      .call(xAxis)

  svg.select('.y.axis').transition()
      .duration(750)
      .call(yAxis)

# draw axis
svg.append('g')
    .attr('class', 'x axis')
    .attr('transform', "translate(0, #{height/2})")
  .call(xAxis)

svg.append('g')
    .attr('class', 'y axis')
    .attr('transform', "translate(#{width/2}, 0)")
  .call(yAxis)

# add event listener
d3.select('button').on 'click', () ->
  inputField = d3.select('#input')
  input = document.getElementById('input').value

  if input.length == 0
    return
  input = input.replace(new RegExp('sin', 'g'), 'Math.sin')
  input = input.replace(new RegExp('cos', 'g'), 'Math.cos')
  input = input.replace(new RegExp('tan', 'g'), 'Math.tan')
  input = input.replace(new RegExp('exp', 'g'), 'Math.exp')


  evalFunc = (x) ->
    eval(input)

  try
    generateData(evalFunc)
    updateLine()
  catch
    console.log 'something went wrong'


# slider
d3.select('#xRange').on 'change', () ->
  value = +document.getElementById('xRange').value
  value += 50
  value = value || 1
  xDomain = [-value, value]
  xScale.domain(xDomain)
  updateScale()

d3.select('#yRange').on 'change', () ->
  value = +document.getElementById('yRange').value
  value += 50
  value = value || 1
  yDomain = [-value, value]
  yScale.domain(yDomain)
  updateScale()