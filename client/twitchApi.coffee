
nv.addGraph ->
  chart = nv.models.lineChart().margin(left: 100).useInteractiveGuideline(true).showLegend(true).showYAxis(true).showXAxis(true)
  chart.xAxis.axisLabel('Time (ms)').tickFormat d3.format(',r')
  chart.yAxis.axisLabel('Voltage (v)').tickFormat d3.format('.02f')
  chart.forceY([0, 300])

  ### Done setting the chart up? Time to render it!###
  values = []
  data = [{
    values
    key: 'SBJ'
    }
  ]
  window.values = values
  #You need data...
  d3.select('#chart').datum(data).call chart
  #Finally, render the chart!
  #Update the chart when window resizes.

  i = 0
  fetchNewData = () ->
    d3.json 'https://api.twitch.tv/kraken/streams/SlickBlackJesus', (err, res) ->
      if err
        console.log "Error #{err}"
      else
        values.push {
          x: ++i
          y: res.stream.viewers
        }
        chart.update()

  setInterval () ->
    fetchNewData()
  , 1000

  nv.utils.windowResize ->
    chart.update()
    return

  chart
