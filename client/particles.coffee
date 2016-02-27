console.log 'Hey'

width  = 800
height = 800

# create svg
svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

# black background
svg.append('rect')
  .attr('width', width)
  .attr('height', height)
  .style('fill', 'black')


i = 0
addBlob = (x, y) ->
  i++

  svg
    .append('circle')
      .attr('class', 'blob')
      .attr('cx', x)
      .attr('cy', y)
      .attr('r', 3)
      .style('stroke', d3.hsl((i = (i + 1) % 360), 1, .5))
    .transition().delay(0).duration(1000)
      .ease(Math.sqrt)
      .attr('r', 80)
    .transition().duration(1000)
      .ease((x) -> x*x)
      .attr('r', 5)
      .attr('cx', width/2)
      .attr('cy', height/2)
    .transition().delay(5000).duration(5000)
      .ease((x) -> x*x)
      .attr('r', 500)
      # .attr('stroke', 'white')
      .style('opacity', 0)
      .remove()


alpha = 0
setInterval () ->
  # if alpha == 100
  #   return

  r = 200
  mX = width/2
  mY = height/2
  alpha += .1

  kX = Math.sin(alpha) * r
  kY = Math.cos(alpha) * r

  addBlob(mX + kX, mY + kY)

, 30

# mouse handler
svg.on 'mousemove', () ->
  mousePos = d3.mouse(this)
  mosueX = mousePos[0]
  mosueY = mousePos[1]

  addBlob(mosueX, mosueY)

