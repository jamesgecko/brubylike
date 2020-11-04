require 'app/util.rb'

def generate_level(args)
  tiles = []
  try_to('generate map') do
    tiles, passable_tiles = generate_tiles(args)
    args.state.passable_tiles = passable_tiles
    args.state.random_tile ||= random_passable_tile(args)
    # passable_tiles == random_passable_tile(args).get_connected_tiles(args).length
  end
  tiles
end

def generate_tiles(args)
  passable_tiles = 0
  tiles = [];
  (0..args.state.num_tiles).each do |y|
    tiles[y] = []
    (0..args.state.num_tiles).each do |x|
      if rand < 0.3
        tiles[y][x] = Wall.new(x, y)
      else
        tiles[y][x] = Floor.new(x, y)
        passable_tiles += 1
      end
    end
  end
  [tiles, passable_tiles]
end

def in_bounds(args, x, y)
  x > 0 && y > 0 && x < args.state.num_tiles - 1 && y < args.state.num_tiles - 1
end

def get_tile(args, x, y)
  if in_bounds(args, x, y)
    args.state.tiles[x][y]
  else
    GTK::Log.puts_info "bonus wall at #{x}, #{y}"
    Wall.new(x, y)
  end
end

def random_passable_tile(args)
  tile = nil
  try_to('get random passable tile') do
    x = random_range(0, args.state.num_tiles - 1)
    y = random_range(0, args.state.num_tiles - 1)
    tile = get_tile(args, x, y)

    if tile.nil?
      # trace! 
      raise "nil tile at #{x}, #{y}"
    end
    GTK::Log.puts_info "tile #{tile.x}, #{tile.y}, #{tile.passable}"
    tile.passable == true && tile.monster == false
  end
  tile
end
