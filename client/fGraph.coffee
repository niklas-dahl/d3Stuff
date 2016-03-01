width = 960
height = 500
fill = d3.scale.category10()

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

infoText = svg.append('text')
  .attr('x', 30)
  .attr('y', height-30)
  .text('infoText')

nodes = []

forceLayout = d3.layout.force()
    .nodes(nodes)
    # .gravity(0)
    .size([width, height])
    # .start()

forceLayout.on 'tick', () ->
  nodes.forEach (n, i) ->
    n.alive++
    if n.alive > 1000
      nodes.splice(i, 1)

  infoText.text("Nodes: #{nodes.length}")
  render()

render = () ->
  circles = svg.selectAll('circle').data(nodes, (n) -> n.id)

  # enter
  circles.enter().append('circle')
    .attr('r', 10)
    .style('fill', (n, i) -> fill(n.id))

  # update
  circles
    .attr('cx', (n) -> n.x)
    .attr('cy', (n) -> n.y)

  # exit
  circles.exit().remove()
    # .attr('r', (d) -> 5)
    # .attr('cx', (d) -> parseInt(d.id%80) * 10 + 30)
    # .attr('cy', (d) -> parseInt(d.id/100) * 10 + 30)

render()

nodeId = 0
addNode = (x, y) ->
  nodes.push {
    x
    y
    alive: 0
    id: nodeId++
  }
  forceLayout.start()
  render()

alpha = 0
setInterval () ->
  r = 200
  mX = width/2
  mY = height/2
  alpha += .3

  kX = Math.sin(alpha) * r
  kY = Math.cos(alpha) * r

  addNode(mX + kX, mY + kY)

, 100