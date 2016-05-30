width = 800
height = 800
fill = d3.scale.category10()

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

drawHouse = (x, y, scale, angle=0, rekursion=3) ->
  group = svg.append('g')
    .style('stroke', fill(angle))

  group.append('line')  
    .attr('x1', x)
    .attr('y1', y)
    .attr('x2', x+(Math.cos(angle)*scale))
    .attr('y2', y-(Math.sin(angle)*scale))

  b = Math.PI - Math.PI/2 - angle
  group.append('line')  
    .attr('x1', x)
    .attr('y1', y)
    .attr('x2', x-(Math.cos(b)*scale))
    .attr('y2', y-(Math.sin(b)*scale))

  group.append('line')
    .attr('x1', x-(Math.cos(b)*scale))
    .attr('y1', y-(Math.sin(b)*scale))
    .attr('x2', x-(Math.cos(b)*scale)+(Math.cos(angle)*scale))
    .attr('y2', y-(Math.sin(b)*scale)-(Math.sin(angle)*scale))
  
  group.append('line')
    .attr('x1', x+(Math.cos(angle)*scale))
    .attr('y1', y-(Math.sin(angle)*scale))
    .attr('x2', x-(Math.cos(b)*scale)+(Math.cos(angle)*scale))
    .attr('y2', y-(Math.sin(b)*scale)-(Math.sin(angle)*scale))

  # Dach
  l = scale
  c = Math.PI - Math.PI/3 - angle

  group.append('line')
    .attr('x1', x-(Math.cos(b)*scale))
    .attr('y1', y-(Math.sin(b)*scale))
    .attr('x2', x-(Math.cos(b)*scale) - (Math.cos(c)*l))
    .attr('y2', y-(Math.sin(b)*scale) - (Math.sin(c)*l))
  
  group.append('line')
    .attr('x1', x-(Math.cos(b)*scale)+(Math.cos(angle)*scale))
    .attr('y1', y-(Math.sin(b)*scale)-(Math.sin(angle)*scale))
    .attr('x2', x-(Math.cos(b)*scale) - (Math.cos(c)*l))
    .attr('y2', y-(Math.sin(b)*scale) - (Math.sin(c)*l))  

  if(rekursion)
    newScale = scale*.7
    drawHouse(x-(Math.cos(b)*scale), y-(Math.sin(b)*scale), newScale, angle+Math.PI/3, rekursion-1)
    newAngle = Math.PI + Math.PI/2 + (Math.PI-c-Math.PI/2) + Math.PI/3
    drawHouse(x-(Math.cos(b)*scale) - (Math.cos(c)*l), y-(Math.sin(b)*scale) - (Math.sin(c)*l), newScale, newAngle, rekursion-1)


i = 0
setInterval () ->
  if i < 11
    drawHouse(300, 600, 100, 0, i++)
, 300