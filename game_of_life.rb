class GameOfLife
  attr_accessor :state, :prev_state
  
  # initialize two dimensional array of size ::size::
  # with a random distribution of 1s and 0s
  def initialize(size = 5)
    @state = Array.new(size) do
      Array.new(size){ rand(2) }
    end
  end
  
  def evolve
    @prev_state = Marshal.load(Marshal.dump(@state))
    (0..@state.size-1).each do |x|
      (0..@state.size-1).each do |y|
        @state[x][y] = cell_survives?(x,y) ? 1 : 0
      end
    end
    @prev_state = nil
    @state
  end
  
  private
  
  # doesn't currently allow for backwards folding (ie, indices greater than size-1 should be index - (size -1 )
  # modulo? )
  def number_of_neighbors(x,y)
    count = 0
    [-1,0,1].each do |dx|
      [-1,0,1].each do |dy|
        count += @prev_state[(x+dx) % @prev_state.size][(y+dy) % @prev_state.size]
      end
    end
    # puts "# neighbors: #{count - @prev_state[x][y]}"
    # puts "prev: #{@prev_state.inspect} id: #{@prev_state.object_id}"
    # puts "current: #{@state.inspect} id: #{@state.object_id}"
    count - @prev_state[x][y]
  end

  # any live cell with 2 or 3 neighbours lives to next generation
  # any dead cell with exactly 3 live neighbours becomes a live cell  
  def cell_survives?(x,y)
    cell = @prev_state[x][y]
    case number_of_neighbors(x,y)
    when 2: cell == 1
    when 3: true
    else false
    end
  end
end