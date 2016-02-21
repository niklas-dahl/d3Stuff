# calc width and height
outerHeight = 800
margin = { top: 30, right: 30, bottom: 40, left: 40 }
innerHeight = outerHeight - margin.top  - margin.bottom

# create svg
svg = d3.select('#svgContainer').append('svg')
  .attr('height', outerHeight)

graph = svg.append('g')
  .attr('transform', "translate(#{margin.left}, #{margin.top})")
  .attr('class', 'graphContent')

xAxisG = graph.append('g')
  .attr('transform', "translate(0, #{innerHeight})")
yAxisG = graph.append('g')

colorScale = d3.scale.category10()

renderData = (data, ow) ->
  # sizes
  outerWidth = ow
  innerWidth  = outerWidth  - margin.left - margin.right

  # scales
  xDomain = d3.extent(data, (d) -> d.sepal_length)
  xScale = d3.scale.linear()
    .domain(xDomain)
    .range([0, innerWidth])

  yDomain = d3.extent(data, (d) -> d.petal_length)
  yScale = d3.scale.linear()
    .domain(yDomain)
    .range([innerHeight, 0])

  # axis
  xAxis = d3.svg.axis().scale(xScale).orient('bottom')
  yAxis = d3.svg.axis().scale(yScale).orient('left')
  xAxisG.call(xAxis)
  yAxisG.call(yAxis)

  # selection
  circles = graph.selectAll('circle').data(data)

  # enter
  circles.enter().append('circle')
    .attr('stroke', (d) -> colorScale(d.species) )
    .attr('r', 10)

    .on 'mouseover', () ->
      d3.select(this).transition()
        .duration(1000)
        .attr('r', (d) -> 30)

    .on 'mouseout', () ->
      d3.select(this).transition()
        .attr('r', 10)

  # update
  circles.transition()
    .attr('cx', (d) -> xScale(d.sepal_length) )
    .attr('cy', (d) -> yScale(d.petal_length) )

  # exit
  circles.exit().transition()
    .duration(100)
    .attr('r', 0)
    .each 'end', () ->
      d3.select(this)
        .remove()

flowerInformationPath = 'https://raw.githubusercontent.com/curran/screencasts/gh-pages/introToD3/examples/code/snapshot73/iris.csv'
type = (dataPoint) ->
  dataPoint.petal_length  = +dataPoint.petal_length 
  dataPoint.petal_width   = +dataPoint.petal_width 
  dataPoint.sepal_length  = +dataPoint.sepal_length
  dataPoint.sepal_width   = +dataPoint.sepal_width
  dataPoint

d3.csv flowerInformationPath, type, (data) ->
#  renderData(data, 300)

  window.onresize = (event) ->
    containerWidth = +svg.style('width').replace('px', '')
    renderData(data, containerWidth)

  i = 5 * 6
  setInterval () ->
    containerWidth = +svg.style('width').replace('px', '')
    # data.push {
    #   petal_length: data[0].petal_length + i
    #   sepal_length: data[0].sepal_length + i
    # }
    data.push {
      petal_length: (Math.sin(i/10))*(5 + i/10) + 1
      sepal_length: i/5
    }
    
    i++
    renderData(data, containerWidth)
  , 300