# pseudo plugin container
plugin = {}

# helper function for settings
plugin.addConfigurations = (outer, obj, settings, defaults) ->
  for setting, idx in settings
    
    obj[setting] = ((setting) ->
      (newVal) ->
        if arguments.length == 0
          return outer[setting]
        outer[setting] = newVal
        obj
    )(setting)

    outer[setting] = defaults[idx]

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
    console.log "init draw #{min}, #{max}, #{value}, #{text}"

    arc = d3.svg.arc()
      .startAngle(0.75 * 2 * Math.PI)
      .endAngle((d) -> (0.75 * 2 * Math.PI) + (Math.min(Math.max(d, 0), 1) * Math.PI))
      .innerRadius(85)
      .outerRadius(110)

    outerArc = d3.svg.arc()
      .startAngle(0.75 * 2 * Math.PI)
      .endAngle(0.75 * 2 * Math.PI + Math.PI)
      .innerRadius(85)
      .outerRadius(110)

    outerOuterArc = d3.svg.arc()
      .startAngle(0.75 * 2 * Math.PI)
      .endAngle(0.75 * 2 * Math.PI + Math.PI)
      .innerRadius(85)
      .outerRadius(110)

    # center text
    text = arcGroup.append('text')
      .attr('y', -25)
      .attr('class', 'innerText')
      .text("#{Math.round(value)}%")

    # bottum text
    arcGroup.append('text')
      .attr('y', 0)
      .style('text-anchor', 'middle')
      .style('fill', 'black')
      .style('font-size', '1.2em')
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

    # ticks
    tickCount = 5
    getTickX  = (n, rad) ->
      pos = n / tickCount
      deg = -Math.PI + pos * Math.PI
      Math.cos(deg) * rad
    
    getTickY  = (n, rad) ->
      pos = n / tickCount
      deg = -Math.PI + pos * Math.PI
      Math.sin(deg) * rad

    arcGroup.selectAll('.ticks').data([0 .. tickCount]).enter().append('line')
      .attr('class', 'tick')
      .attr('x1', (d) -> getTickX(d, 110))
      .attr('y1', (d) -> getTickY(d, 110))
      .attr('x2', (d) -> getTickX(d, 85))
      .attr('y2', (d) -> getTickY(d, 85))

    tickScale = d3.scale.linear().range([min, max])

    arcGroup.selectAll('.ticks').data([0 .. tickCount]).enter().append('text')
      .attr('class', 'tickText')
      .attr('x', (d) -> getTickX(d, 122))
      .attr('y', (d) -> getTickY(d, 122))
      .text((d) -> tickScale(d/tickCount))


    gauge.update = () ->
      scale = d3.scale.linear().domain([min, max]).range([0, 1])

      arcElm.transition().duration(1500).ease('elastic')#.ease((x) -> (x+.2)%1)#.ease('linear')
        .attrTween('d', arcTween(arc, renderValue, scale(value)) )

      renderValue = scale(value)

      text.text("#{Math.round(value)}%")


  # getter / setter / chainable
  plugin.addConfigurations(this, gauge, ['min', 'max', 'value', 'text'], [0, 100, 76, 'no text'])
  

  # gauge.min = (newVal) ->
  #   if arguments.length == 0
  #     return min
  #   min = newVal
  #   gauge
  # gauge.max = (newVal) ->
  #   if arguments.length == 0
  #     return max
  #   max = newVal
  #   gauge
  # gauge.value = (newVal) ->
  #   if arguments.length == 0
  #     return value
  #   value = newVal
  #   gauge
  # gauge.text = (newVal) ->
  #   if arguments.length == 0
  #     return bottumText
  #   bottumText = newVal
  #   gauge

  gauge

console.log 'gauge test 2'

width  = 800
height = 600

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

gauge2 = plugin.gauge()
  .min(-10)
  .max(40)
  # .max(70)
  .value(10)
  .text('load')

window.gauge = gauge2

svg.append('g')
    .attr('id', 'gauge1')
    .attr('class', 'gauge')
    .attr('transform', "translate(#{400}, #{300}) scale(2)")
    .call(gauge2)


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

  gauge2.value( (Math.random() * (gauge.max()-gauge.min()) + gauge.min() )).update()
  

, 1000
