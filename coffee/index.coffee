$ ->
  width = 400
  height = 400
  rows = 10
  cols = 10
  canvasContainer = $('#cvContainer')

  hole = new Hole(width, height, 4, rows, cols)
  canvasContainer.append(hole.canvas)

  hole.start()
