width = 800
height = 800
fill = d3.scale.category10()

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

svg.append('rect')
  .attr('width', width)
  .attr('height', height)
  .style('fill', 'black')

centerX = 400
centerY = 400
outerRadius = 200
innerRadius = 200
num = 50

# svg.append('circle')
#   .attr('cx', centerX)
#   .attr('cy', centerY)
#   .attr('r', outerRadius)

i = 1
data = []
max = 30
setInterval () ->
  i++

  data.push {
    x: centerX + Math.cos((i/max) * 2*Math.PI)*outerRadius
    y: centerY + Math.sin((i/max) * 2*Math.PI)*outerRadius
    i: i
  }
  if data.length > max
    data.shift()

  circles = svg.selectAll('.innerCircle').data(data, (d) -> d.i)

  circles.enter().append('circle')
    .attr('class', 'innerCircle')
    .style('stroke', (d) -> d3.hsl(d.i%360, 1, .5))
    .attr('r', 0)
    .attr('cx', centerX)
    .attr('cy', centerY)
      .transition().duration(2000)
        .attr('cx', (d) -> d.x)
        .attr('cy', (d) -> d.y)
        .attr('r', innerRadius)  

  circles.transition().duration(100)
    .attr('cx', (d) -> d.x)
    .attr('cy', (d) -> d.y)
    .attr('r', innerRadius)

  circles.exit().transition().duration(500)
    .attr('r', 0)
    .attr('cx', centerX)
    .attr('cy', centerY)
    .remove()

, 100