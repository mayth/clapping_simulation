class window.Hole
  @requestAnimationFrame: (callback) ->
    (window.requestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.webkitRequestAnimationFrame or
      window.msRequestAnimationFrame or
      (f) -> window.setTimeout(f, 1000 / @fps)
    )(callback)

  NEIGHBOR_THRESHOLD = 15
  ticks: 0

  constructor: (@width, @height, @audienceSize, rows, cols) ->
    @actualWidth = @width - @audienceSize
    @actualHeight = @height - @audienceSize
    dx = @actualWidth / cols
    dy = @actualHeight / rows
    @seats = new Array(rows * cols)
    for i in [0...rows]
      for j in [0...cols]
        @seats[i * cols + j] = new Audience(@audienceSize + j * dx, @audienceSize + i * dy)
    @generateCanvas()

  generateCanvas: ->
    @canvas = document.createElement('canvas')
    @canvas.width = @width
    @canvas.height = @height
    unsupportedText = document.createTextNode('Your browser doesn\'t support Canvas. Please upgrade the browser or use the other one.')
    @canvas.appendChild(unsupportedText)

  start: =>
    Hole.requestAnimationFrame(@update)

  update: (now) =>
    @draw(now)
    for a, i in @seats
      neighbors = (aa for aa in @seats when a != aa and a.isNeighbor(aa, NEIGHBOR_THRESHOLD))
      a.update(@ticks, neighbors)
    ++@ticks
    Hole.requestAnimationFrame(@update)

  draw: (now) =>
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    for a in @seats
      color = { r: if a.isClapping(@ticks) then 255 else 0 }
      @drawPoint(a.x, a.y, @audienceSize, color)

  drawPoint: (x, y, r, color = {}) =>
    cr = color['r'] || 0
    cg = color['g'] || 0
    cb = color['b'] || 0
    ca = color['a'] || 1.0
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.fillStyle = "rgba(#{cr},#{cg},#{cb},#{ca});"
    ctx.arc(x, y, r, 0, Math.PI * 2, false)
    ctx.fill()
