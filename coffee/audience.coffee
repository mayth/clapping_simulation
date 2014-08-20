class window.Audience
  CLAPPING_TIME = 50

  @randomInt: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  constructor: (@x, @y) ->
    @interval = Audience.randomInt(CLAPPING_TIME * 2, 500)
    @nextClap = @interval

  update: (now, neighbors) ->
    if @nextClap + CLAPPING_TIME < now
      @nextClap = now + @interval

  isNeighbor: (other, threshold) =>
    Math.sqrt(Math.pow(@x - other.x, 2) + Math.pow(@y - other.y, 2)) <= threshold

  isClapping: (t) =>
    Math.abs(t - @nextClap) <= CLAPPING_TIME
