# pseudo plugin container
plugin = {}

plugin.gauge = () ->
  min = 0
  max = 100
  value = 0
  renderValue = 0
  bottumText = 'Visitors'

  # arc interpolator
  arcTween = (arc, oldVal, newVal) ->
    return (d) ->
      i = d3.interpolateNumber(oldVal, newVal)
      return (t) ->
        return arc(i(t))

  gauge = (arcGroup) ->
    arc = d3.svg.arc()
      .startAngle(0)
      .endAngle((d) -> d * 2 * Math.PI)
      .innerRadius(85)
      .outerRadius(110)

    outerArc = d3.svg.arc()
      .startAngle(0)
      .endAngle(Math.PI*2)
      .innerRadius(85)
      .outerRadius(110)

    # center circle
    arcGroup.append('circle')
      .attr('r', 85)
      .attr('cx', 0)
      .attr('cy', 0)
      .attr('class', 'centerCircle')

    # center text
    text = arcGroup.append('text')
      .attr('y', 15)
      .attr('class', 'innerText')
      .text("#{Math.round(value)}%")

    # buttom text
    arcGroup.append('text')
      .attr('y', 150)
      .style('text-anchor', 'middle')
      .style('fill', 'black')
      .style('font-size', '2em')
      .text(bottumText)

    # background arc
    arcGroup.append('path')
      .attr('d', outerArc)
      .attr('class', 'outline')

    # actual arc
    renderValue = value / (max-min)
    arcElm = arcGroup.append('path').data([renderValue])
      .attr('d', (d) -> arc(d))
      .attr('class', 'bar')

    gauge.update = () ->
      arcElm.transition().duration(1000).ease('elastic')#.ease((x) -> (x+.2)%1)#.ease('linear')
        .attrTween('d', arcTween(arc, renderValue, value/(max-min)) )
      renderValue = value/(max-min)

      text.text("#{Math.round(value)}%")


  # getter / setter / chainable
  gauge.min = (newVal) ->
    if arguments.length == 0
      return min
    min = newVal
    gauge
  gauge.max = (newVal) ->
    if arguments.length == 0
      return max
    max = newVal
    gauge
  gauge.value = (newVal) ->
    if arguments.length == 0
      return value
    value = newVal
    gauge
  gauge.text = (newVal) ->
    if arguments.length == 0
      return bottumText
    bottumText = newVal
    gauge

  gauge



console.log 'gauge test'

width =  800
height = 600

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

gauge = plugin.gauge()
  .min(0)
  .max(100)
  .value(60)

gauge2 = plugin.gauge()
  .value(10)
  .text('Online')

gauge3 = plugin.gauge()
  .value(.9)
  .text('Fehler Quote')


svg.append('g')
    .attr('id', 'gauge1')
    .attr('class', 'gauge')
    .attr('transform', "translate(#{400}, #{height/2-20}) scale(2)")
    .call(gauge2)

svg.append('g')
    .attr('id', 'gauge2')
    .attr('class', 'gauge')
    .attr('transform', "translate(#{150}, #{height/2 + 150})")
    .call(gauge)

svg.append('g')
    .attr('id', 'gauge3')
    .attr('class', 'gauge')
    .attr('transform', "translate(#{650}, #{height/2 + 150})")
    .call(gauge3)

window.gauge = gauge

i = 0
g = .5
setInterval () ->
  if i >= 100
    g += .5
    i = 0

  oldVal = i/100
  i += g*10
  newVal = i /100
  # i = i%100

  gauge.value(gauge.value() + Math.floor(Math.random()*50)-25 ).update()
  gauge2.value(gauge2.value() + Math.floor(Math.random()*30)-15 ).update()
  gauge3.value(gauge3.value() + Math.floor(Math.random()*30)-15 ).update()
  

, 2000
