width = 960
height = 500
fill = d3.scale.category10()

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

bars = [0, 1, 2]
svg.selectAll('.turm').data(bars).enter()
  .append('rect')
  .attr('class', 'turm')
  .attr('x', (d) -> 100+d*200)
  .attr('y', 100)
  .attr('width', 50)
  .attr('height', 500)

scheibenData = []
for i in [1 .. 3]
  scheibenData.push {
    size: i
    position: 0
  }

scheiben = svg.selectAll('scheibe').data(scheibenData)

scheiben.enter().append('rect')
  .attr('id', (d) -> "scheibe_#{d.size}")
  .attr('class', 'scheibe')
  .attr('width', (d) -> d.size*30)
  .attr('height', 30)

update = () ->
  scheiben
    .attr('x', (d) -> 100+d.position*200 - d.size*30/2 + 25)
    .attr('y', (d) -> d.size* 55 + 300)

update()

topY = 40
towerPosX = [100+0*200, 100+1*200, 100+2*200]

svg.select('#scheibe_1')
  .transition().duration(1000).attr('y', topY)
  .transition().duration(1000).attr('x', towerPosX[2])
  .transition().duration(1000).attr('y', 460)
  .each () ->

    svg.select('#scheibe_2')
      .transition().duration(1000).attr('y', topY)
      .transition().duration(1000).attr('x', towerPosX[1])
      .transition().duration(1000).attr('y', 460)
      .each () ->

        svg.select('#scheibe_1')
          .transition().duration(1000).attr('y', topY)
          .transition().duration(1000).attr('x', towerPosX[1])
          .transition().duration(1000).attr('y', 420)
          .each () ->

            svg.select('#scheibe_3')
              .transition().duration(1000).attr('y', topY)
              .transition().duration(1000).attr('x', towerPosX[2]-20)
              .transition().duration(1000).attr('y', 460)
              .each () ->

                svg.select('#scheibe_1')
                  .transition().duration(1000).attr('y', topY)
                  .transition().duration(1000).attr('x', towerPosX[0])
                  .transition().duration(1000).attr('y', 340)
                  .each () ->

                    svg.select('#scheibe_2')
                      .transition().duration(1000).attr('y', topY)
                      .transition().duration(1000).attr('x', towerPosX[2]-5)
                      .transition().duration(1000).attr('y', 420)
                      .each () ->

                        svg.select('#scheibe_1')
                          .transition().duration(1000).attr('y', topY)
                          .transition().duration(1000).attr('x', towerPosX[2]+6)
                          .transition().duration(1000).attr('y', 380)
                          .each () ->


