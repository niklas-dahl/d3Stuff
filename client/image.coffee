width = 960
height = 1300
fill = d3.scale.category10()

canvas = null
initImage = () ->
  img = document.getElementById('img')
  img.crossOrigin = "Anonymous"
  canvas = document.createElement('canvas')
  canvas.width = img.width
  canvas.height = img.height
  canvas.getContext('2d').drawImage(img, 0, 0, img.width, img.height)
  
getImagePixel = (x, y) ->
  if !canvas
    initImage()

  canvas.getContext('2d').getImageData(x, y, 1, 1).data;

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

pixelNum = 0
imgWidth = 66
imgHeight = 68

pixelWidth = 14
xOffset = 30
yOffset = 30

pixels = []
render = () ->
  elm = svg.selectAll('circle').data(pixels)

  elm.enter().append('circle')
    .attr('r', 100)
    .attr('cx', width/2)
    .attr('cy', height)
    .style('fill', (d, i) -> d3.rgb(d.color[0], d.color[1], d.color[2]) )
  .transition().duration(3000)#.ease(Math.sqrt)
    .attr('r', pixelWidth/2)
    .attr('cx', (d) -> d.imgX*pixelWidth + xOffset)
    .attr('cy', (d) -> d.imgY*pixelWidth + yOffset)

divier = 5
interval = setInterval () ->
  y = parseInt( pixelNum / imgWidth )
  x = pixelNum % imgWidth
  if y%2 == 1
    x = imgWidth-1 - x 

  getImagePixel(x, y)

  pixels.push {
    imgX: x
    imgY: y
    color: getImagePixel(x*10, y*10)
  }
  render()

  pixelNum+=divier
  if pixelNum > imgWidth*imgHeight
    if pixelNum%divier + 1 == divier
      clearInterval(interval)
      
    pixelNum = pixelNum%divier + 1

, 10

console.log 'image '