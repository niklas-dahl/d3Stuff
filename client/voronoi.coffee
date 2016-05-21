width = 960
height = 500

vertices = d3.range(100).map (d) ->
  [ Math.random() * width, Math.random() * height ]

voronoi = d3.geom.voronoi()
  .clipExtent([[0, 0], [width, height]])

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)
  .on 'mousemove', () ->
    console.log 'mousemove'

force = d3.layout.force()
  .charge(-120)
  .linkDistance(30)
  .size([width, height])

force.nodes(vertices).start()
force.on 'tick', () ->
  console.log "tick"
  path.attr 'd', polygon


path = svg.append('g').selectAll('path')

redraw = ->
  path = path.data(voronoi(vertices), polygon)
  path.exit().remove()
  path.enter().append('path')
    .attr('class', (d, i) -> 'q' + i % 9 + '-9')
    .attr 'd', polygon

  path.order()
  
polygon = (d) ->
  'M' + d.join('L') + 'Z'

svg.selectAll('circle').data(vertices.slice(1)).enter().append('circle')
  .attr('transform', (d) -> 'translate(' + d + ')')
  .attr('r', 1.5)

redraw()