width = 900
height = 900
fill = d3.scale.category10()

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

draw = (x, y, size, angle, rekursions=8) ->
  svg.append('line')
    .style('stroke-width', "#{size/8}px")
    .style('stroke', d3.hsl((angle*15 % 360), 1, .5))
    .attr('x1', x)
    .attr('y1', y)
    .attr('x2', x + Math.cos(angle)*size)
    .attr('y2', y - Math.sin(angle)*size)

  if rekursions
    draw(x + Math.cos(angle)*size, y - Math.sin(angle)*size, size*.65, angle+Math.PI/6, rekursions-1)
    draw(x + Math.cos(angle)*size, y - Math.sin(angle)*size, size*.75, angle-Math.PI/4, rekursions-1)

i = 0
setInterval () ->
  if i < 14
    draw(400, 850, 200, Math.PI/2, i++)
, 1000