width = 800
height = 800
fill = d3.scale.category10()

drawLine = (p1, p2, c) ->
  svg.append('line')
    .style('stroke', c)
    .attr('x1', p1.x)
    .attr('y1', p1.y)
    .attr('x2', p2.x)
    .attr('y2', p2.y)

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

p1 = {
  x: 400
  y: 100
}
p2 = {
  x: 700
  y: 400
}
p3 = {
  x: 100
  y: 400
}
drawLine(p1, p2)
drawLine(p2, p3)
drawLine(p3, p1)

draw = (p1, p2, p3, rekursion=3) ->
  pM = {
    x: (p2.x + p3.x)/2
    y: (p2.y + p3.y)/2
  }
  drawLine(p1, pM, fill(rekursion))

  if rekursion
    draw(p2, pM, p1, rekursion-1)
    draw(p3, pM, p1, rekursion-1)

i = 0
setInterval () ->
  if i < 10
    draw(p1, p2, p3, i++)
, 1000