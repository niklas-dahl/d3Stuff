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

# add the gauge plugin
plugin.gauge = () ->
  settings = {}

  # arc interpolator
  arcTween = (arc, oldVal, newVal) ->
    return (d) ->
      i = d3.interpolateNumber(oldVal, newVal)
      return (t) ->
        return arc(i(t))

  # returned generator function
  gauge = (arcGroup) ->
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
      .text("#{settings.valueFormatter(settings.value)}")

    # bottum text
    arcGroup.append('text')
      .attr('y', 0)
      .style('text-anchor', 'middle')
      .style('fill', 'black')
      .style('font-size', '1.2em')
      .text(settings.text)

    # background arc
    arcGroup.append('path')
      .attr('d', outerArc)
      .attr('class', 'outline')

    # actual arc
    settings.renderValue = settings.value / (settings.max-settings.min)
    arcElm = arcGroup.append('path').data([settings.renderValue])
      .attr('d', (d) -> arc(d))
      .attr('class', 'bar')

    # ticks
    getTickX  = (n, rad) ->
      pos = n / settings.segmentCount
      deg = -Math.PI + pos * Math.PI
      Math.cos(deg) * rad
    
    getTickY  = (n, rad) ->
      pos = n / settings.segmentCount
      deg = -Math.PI + pos * Math.PI
      Math.sin(deg) * rad

    arcGroup.selectAll('.ticks').data([0 .. settings.segmentCount]).enter().append('line')
      .attr('class', 'tick')
      .attr('x1', (d) -> getTickX(d, 110))
      .attr('y1', (d) -> getTickY(d, 110))
      .attr('x2', (d) -> getTickX(d, 85))
      .attr('y2', (d) -> getTickY(d, 85))

    tickScale = d3.scale.linear().range([settings.min, settings.max])

    arcGroup.selectAll('.ticks').data([0 .. settings.segmentCount]).enter().append('text')
      .attr 'class', (d) ->
        if !d 
          return 'first tickText'
        if d == settings.segmentCount
          return 'last tickText'
        'tickText'
      .attr('x', (d) -> getTickX(d, 122))
      .attr('y', (d) -> getTickY(d, 122))
      .text((d) -> settings.tickFormatter( tickScale(d/settings.segmentCount) ))

    gauge.update = () ->
      scale = d3.scale.linear().domain([settings.min, settings.max]).range([0, 1])

      arcElm.transition().duration(settings.duration).ease('elastic')
        .attrTween('d', arcTween(arc, settings.renderValue, scale(settings.value)) )

      settings.renderValue = scale(settings.value)

      text.text( settings.valueFormatter((settings.value)) )


  # add getter/setter/chainable to returned generator function
  plugin.addConfigurations(settings, gauge,
    ['min', 'max', 'value', 'text', 'segmentCount', 'tickFormatter',  'valueFormatter', 'duration' ],
    [ 0,     100,   50,      '',     5,              d3.format(".1f"), d3.format('.1f'), 1500  ]
  )
  
  # return genrator function
  gauge

# actual start of the programm
console.log 'gauge test 2 start'

width  = 1000
height = 1000

# create svg
svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

# instanciate the plugin
gauge = plugin.gauge()
  .text('performance')
  .duration(4000)
  .segmentCount(3)

gauge2 = plugin.gauge()
  .min(-10)
  .max(40)
  .value(10)
  .text('load')

gauge3 = plugin.gauge()
  .segmentCount(100)
  .tickFormatter(()->'')
  .valueFormatter(d3.format('d'))
  .min(100)
  .max(500)
  .value(200)

window.gauge = gauge2

# add plugin to svg
svg.append('g')
  .attr('id', 'gauge1')
  .attr('class', 'gauge')
  .attr('transform', "translate(#{400}, #{300}) scale(2)")
  .call(gauge2)

svg.append('g')
  .attr('class', 'gauge')
  .attr('transform', "translate(#{250}, #{600}) scale(1.5)")
  .call(gauge)

svg.append('g')
  .attr('class', 'gauge')
  .attr('transform', "translate(#{700}, #{600}) scale(1.5)")
  .call(gauge3)

setInterval () ->
  # set the value to a random value in range
  gauge2.value( (Math.random() * (gauge2.max()-gauge2.min()) + gauge2.min() )).update()
, 3000

setInterval () ->
  gauge3.value( (gauge3.value()+1) % gauge3.max() ).update()
, 10

setInterval () ->
  gauge.value( (Math.random() * (gauge.max()-gauge.min()) + gauge.min() )).update()
, 5000