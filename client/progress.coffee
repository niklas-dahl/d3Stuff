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

# add progress plugin
plugin.progress = () ->
  # settings object
  settings = {}

  width  = 500
  height = 30
  
  # generator function
  progress = (group) ->
    # background
    borderRadius = 10
    group.append('rect')
      .attr('class', 'background')
      .attr('rx', borderRadius)
      .attr('ry', borderRadius)
      .attr('width', width)
      .attr('height', height)


    render = (data) ->
      if typeof data[0] == 'object'
        values = data.map (d) -> d.value
        names  = data.map (d) -> d.description
      else
        values = data
        names  = []

      console.log "render #{data.length} items"

      xScale = d3.scale.linear().domain([0, d3.sum(values)]).range([0, width])
      if settings.total
        xScale.domain([0, settings.total])

      color = d3.scale.ordinal()
        .range(['#1BBC9B', '#EFAD4D', '#D9544F'])

      # actual bars
      bars = group.selectAll('.bar').data(values)
      
      bars.enter().append('rect')
        .attr 'class', 'bar'
        .attr 'rx', (d, idx) ->
          if !idx
            return borderRadius
        .attr 'ry', (d, idx) ->
          if !idx
            return borderRadius
        .style 'fill', color

      bars.transition().duration(1000)
        .attr 'x', (d, idx) -> xScale( d3.sum(values.slice(0, idx)) )
        .attr 'width', (d, idx) ->
          if idx
            return xScale(d)
          return xScale(d)+10
        .attr 'height', height

      # bars description
      desc = group.selectAll('.desc').data(names)

      desc.enter().append('text')
        .attr('class', 'desc')
        .attr('y', -5)
        .style('fill', (d, idx) -> color(idx))
        .text((d) -> d)

      desc.transition().duration(1000)
        .attr('x', (d, idx) -> Math.max(xScale( d3.sum(values.slice(0, idx)) ), 50*idx) )

      # background border
      group.selectAll('.border').data([0]).enter().append('rect')
        .attr('class', 'border')
        .attr('rx', borderRadius)
        .attr('ry', borderRadius)
        .attr('width', width)
        .attr('height', height)

    render(settings.values)
    progress.update = () ->
      render(settings.values)


  # bind settings to generator
  plugin.addConfigurations settings, progress,
    ['total', 'values', 'asd'],
    [0      , [80]    , 'to come']

  # return generator
  progress


# actual start
console.log 'progress test'

width =  8000
height = 6000

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

progress = plugin.progress()
  .values([
    { value: Math.random() * 50, description: 'Niklas' }
    { value: Math.random() * 50, description: 'Doro' }
    { value: Math.random() * 50, description: 'Milena' }
  ])
  .total(120)

svg.append('g')
  .attr('class', 'progress')
  .attr('transform', "translate(#{50}, #{150}) scale(2.5)")
  .call(progress)

setInterval () ->
  progress.values()[0].value = Math.random() * 50
  progress.values()[1].value = Math.random() * 50
  progress.values()[2].value = Math.random() * 50

  progress.update()
, 2000

svg.app