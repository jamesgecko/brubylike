require 'app/map.rb'
require 'app/util.rb'

class Tile
  attr_accessor :x, :y, :passable, :monster

  def initialize(x, y, sprite, passable)
    @x = x
    @y = y
    @sprite = sprite
    @passable = passable
    @monster = false
  end

  def serialize
    {
      x: @x,
      y: @y,
      sprite: @sprite,
      passable: @passable,
      monster: @monster
    }
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end

  def get_neighbor(args, dx, dy)
    get_tile(args, @x + dx, @y + dy)
  end

  def get_adjacent_neighbors(args)
    shuffle([
      get_neighbor(args, 0, -1),
      get_neighbor(args, 0, 1),
      get_neighbor(args, -1, 0),
      get_neighbor(args, 1, 0),
    ])
  end

  def get_adjacent_passable_neighbors(args)
    get_adjacent_neighbors(args).select { |n| n.passable == true }
  end

  def get_connected_tiles(args)
    connected_tiles = [self]
    frontier = [self]
    while(frontier.count > 0)
      neighbors = frontier.pop
        .get_adjacent_passable_neighbors(args)
        .select { |n| connected_tiles.include?(n) }
      connected_tiles = connected_tiles.concat(neighbors)
      frontier = frontier.concat(neighbors)
    end
    connected_tiles
  end

  def draw_args(args)
    {
      x: @x * args.state.tile_size,
      y: @y * args.state.tile_size,
      w: args.state.tile_size,
      h: args.state.tile_size,
      path: 'sprites.png',
      tile_x: @sprite * args.state.sprite_size,
      tile_y: 0,
      tile_w: args.state.sprite_size,
      tile_h: args.state.sprite_size
    }
  end
end

class Floor < Tile
  def initialize(x, y)
    super(x, y, 2, true)
  end
end

class Wall < Tile
  def initialize(x, y)
    super(x, y, 3, false)
  end
end
