width = 960
height = 500
fill = d3.scale.category10()

outerCircle = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)
.append('g')
  .attr('transform', "translate(30, 30)")

voronoi = d3.geom.voronoi()
  .x((d) -> d.x)
  .y((d) -> d.y)
  .clipExtent([-10, -10], [width+10, height+10])

force = d3.layout.force()
  .charge(-2000)
  .friction(.3)
  .size([width, height])

nodes = []

circle = outerCircle.append('circle')
  .attr 'cx', 100
  .attr 'cy', 100
  .attr 'r', 100
  .style 'fill', 'blue'

window.requestAnimationFrame () ->
  circle.transition().duration(1000)
    .attr 'r', 90
  .transition().duration(1000)
    .attr 'r', 100
, 3000