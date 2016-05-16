width = 960
height = 500
fill = d3.scale.category10()

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

plateHeight = 30

# create the bars data
barData = []
for i in [0 .. 2]
  barData.push {
    num: i
    currentElmCount: 0
    x: 100 + i*200
    y: 100
    getTopY: () ->
      (this.y + 355) - (this.currentElmCount * (plateHeight+10))
  }

# create bars
bars = svg.selectAll('.turm').data(barData).enter()
  .append('rect')
  .attr('class', 'turm')
  .attr('x', (d) -> d.x)
  .attr('y', (d) -> d.y)
  .attr('width', 50)
  .attr('height', 400)

plateData = []
for i in [5 .. 1]
  plateData.push {
    size: i
    position: 0
    x: barData[0].x + 50/2 - ((i+1)*30/2)
    y: barData[0].getTopY()
  }
  barData[0].currentElmCount++;

topY = 80;

# drag behavior
drag = d3.behavior.drag()
drag.on 'drag', (d, i) ->
  d.y += d3.event.dy
  if d.y < topY
    d.x += d3.event.dx
    if(d.dx)
      d.x += d.dx
      d.dx = 0
  else
    if(!d.dx?)
      d.dx = 0 
    d.dx += d3.event.dx

  # update position
  d3.select(this)
    .attr('x', (d) -> d.x)
    .attr('y', (d) -> d.y)

plates = svg.selectAll('.plate').data(plateData).enter()
  .append('rect')
    .attr('id', (d) -> "plate_#{d.size}")
    .attr('class', 'plate')
    .attr('width', (d) -> (d.size+1)*30)
    .attr('height', plateHeight)
    .attr('x', (d) -> d.x)
    .attr('y', (d) -> d.y)

svg.select('#plate_1').transition().duration(1000)
  .attr('y', topY)
  .each 'end', () ->
    console.log d3.select(this)
    d3.select(this).transition().attr('x', 0)

# svg.select('#scheibe_1')
#   .transition().duration(1000).attr('y', topY)
#   .transition().duration(1000).attr('x', towerPosX[2])
#   .transition().duration(1000).attr('y', 460)
#   .each () ->

#     svg.select('#scheibe_2')
#       .transition().duration(1000).attr('y', topY)
#       .transition().duration(1000).attr('x', towerPosX[1])
#       .transition().duration(1000).attr('y', 460)
#       .each () ->

#         svg.select('#scheibe_1')
#           .transition().duration(1000).attr('y', topY)
#           .transition().duration(1000).attr('x', towerPosX[1])
#           .transition().duration(1000).attr('y', 420)
#           .each () ->

#             svg.select('#scheibe_3')
#               .transition().duration(1000).attr('y', topY)
#               .transition().duration(1000).attr('x', towerPosX[2]-20)
#               .transition().duration(1000).attr('y', 460)
#               .each () ->

#                 svg.select('#scheibe_1')
#                   .transition().duration(1000).attr('y', topY)
#                   .transition().duration(1000).attr('x', towerPosX[0])
#                   .transition().duration(1000).attr('y', 340)
#                   .each () ->

#                     svg.select('#scheibe_2')
#                       .transition().duration(1000).attr('y', topY)
#                       .transition().duration(1000).attr('x', towerPosX[2]-5)
#                       .transition().duration(1000).attr('y', 420)
#                       .each () ->

#                         svg.select('#scheibe_1')
#                           .transition().duration(1000).attr('y', topY)
#                           .transition().duration(1000).attr('x', towerPosX[2]+6)
#                           .transition().duration(1000).attr('y', 380)
#                           .each () ->


