width = 960
height = 500
fill = d3.scale.category10()

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)
    .append('g')
    .attr('transform', 'scale(2)')

defs = svg.append('defs')

pattern = defs.append('pattern')
  .attr('id', 'image')
  .attr('patternUnits', 'userSpaceOnUse')
  .attr('height', '200')
  .attr('width', '200')

container = svg.append('g')
  .attr("transform", "translate(0, 0)")

pattern.append('image')
  .attr('x', 0)
  .attr('y', 0)
  .attr('height', '200')
  .attr('width', '200')
  .attr('xlink:href', "image4.jpg")
  
svg.append('text')
  .attr('x', 10)
  .attr('y', height-10)
  .text("Created with Fivas")

discData = [8 ..1]
maxRadius = 100
discs = null
updateDiscs = (data, radius=maxRadius) ->
  discs = container.selectAll('.disc').data(data)

  discs.enter().append('circle')
    .attr('class', 'disc')

  discs.transition()
    .attr('r', (d) -> radius*d/data.length)
    .attr('cx', 100)
    .attr('cy', 100)
    .style('fill', "url(#image)")

  discs.exit().remove()

updateDiscs(discData)

rotate = (deg) -> 
  (d,i,a) ->
    deg = ((discData.length-d+1) *2) * 180
    if i%2 == 0 then deg = -deg
    d3.interpolateString("rotate(0, 100, 100)", "rotate(#{deg}, 100, 100)")


d3.select('#dividers').on 'input', () ->
  # update gui
  d3.select('#dividersValue').text(this.value)

  discData = [this.value .. 1]
  updateDiscs(discData)

d3.select('#maxRadius').on 'input', () ->
  # update gui
  d3.select('#maxRadiusValue').text(this.value)
  maxRadius = this.value
  updateDiscs(discData, maxRadius)

d3.select('#start').on 'click', () ->
  oldWidth = discs.style('stroke-width')
  discs.style('stroke-width', 0)

  discs.transition().duration(5000)
    .attrTween('transform', rotate(180))
  .each 'end', () ->
    discs.style('stroke-width', oldWidth)