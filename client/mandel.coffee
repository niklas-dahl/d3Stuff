width = 750
height = 500
fill = d3.scale.category10()

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

svg.append('rect')
  .attr('class', 'background')
  .attr('x', 0)
  .attr('y', 0)
  .attr('width', height)
  .attr('height', height)

circle = svg.append('circle')
  .attr('class', 'mainCircle')
  .attr('cx', height/2 + 10)
  .attr('cy', height/2 + 10)
  .attr('r', height/2 - 20)

middlePoint = {
  x: parseInt( circle.attr('cx') )
  y: parseInt( circle.attr('cy') )
  r: parseInt( circle.attr('r')  )
}

n = 300
points = d3.range(n).map (i) ->
  {
    x: middlePoint.x + Math.cos((i/n) * 2*Math.PI)*middlePoint.r
    y: middlePoint.y + Math.sin((i/n) * 2*Math.PI)*middlePoint.r
    r: 3
  }

svg.selectAll('.nPoint').data(points).enter()
  .append('circle')
    .attr('class', 'nPoint')
    .attr('cx', (d) -> d.x)
    .attr('cy', (d) -> d.y)
    .attr('r', (d) -> d.r)

factor = 2

text = svg.append('text')
  .attr('x', width-220)
  .attr('y', height/2)
  .text("MULTIPLICATOR: #{factor}")
  .style('fill', 'white')

lineData = d3.range(n).map (i) ->
 endIndex = (i*factor) % n
 {
  i: i
  x1: points[i].x
  y1: points[i].y
  x2: points[endIndex].x
  y2: points[endIndex].y
 }

updateLines = (data) ->
  lines = svg.selectAll('.nLines').data(data)
  lines.enter().append('line')
    .attr('class', 'nLines')
  
  lines.transition().duration(1000)
    .attr('x1', (d) -> d.x1)
    .attr('y1', (d) -> d.y1)
    .attr('x2', (d) -> d.x2)
    .attr('y2', (d) -> d.y2)
    .attr 'stroke', (d) -> 
      # return 'white'
      if d.j%2 == 0
        d3.hsl((d.i = (d.i + 1) % 360), 1, .5)
      else
        d.i+=10
        d3.hsl((d.i = (d.i + 1) % 360), 1, .5)

  lines.exit().remove()

updateLines(lineData)

setInterval () ->
  factor++
  text.text("MULTIPLICATOR: #{factor}")

  lineData = d3.range(n).map (i) ->
   endIndex = (i*factor) % n
   {
    j: Math.random()*360
    i: i
    x1: points[i].x
    y1: points[i].y
    x2: points[endIndex].x
    y2: points[endIndex].y
   }
  updateLines(lineData)
, 1000