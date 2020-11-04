require 'app/tile.rb'
require 'app/map.rb'

def tick(args)
  args.state.sprite_size ||= 16
  args.state.tile_size ||= 72
  args.state.num_tiles ||= 9
  args.state.ui_width ||= 4

  args.state.tiles = generate_level(args) if args.state.tiles.nil?
  args.state.starting_tile ||= random_passable_tile(args)
  args.state.player.x ||= args.state.starting_tile.x
  args.state.player.y ||= args.state.starting_tile.y

  player_input(args)
  draw(args)
end

def draw(args)
  args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
  args.state.tiles.each do |column|
    column.each do |tile|
      args.outputs.sprites << tile.draw_args(args)
    end
  end
  args.outputs.sprites << player_draw(args)
end

def player_draw(args)
  {
    x: args.state.player.x,
    y: args.state.player.y,
    w: args.state.tile_size,
    h: args.state.tile_size,
    path: 'sprites.png',
    tile_x: 0,
    tile_y: 0,
    tile_w: args.state.sprite_size,
    tile_h: args.state.sprite_size
  }
end

def player_move(args, delta_x, delta_y)
  args.state.player.x += delta_x * args.state.tile_size
  args.state.player.y += delta_y * args.state.tile_size
end

def player_input(args)
  delta_x = 0
  delta_y = 0
  if args.inputs.controller_one.key_down.down  || args.inputs.keyboard.key_down.down
    delta_y = -1
  elsif args.inputs.controller_one.key_down.up  || args.inputs.keyboard.key_down.up
    delta_y = 1
  end
  if args.inputs.controller_one.key_down.left  || args.inputs.keyboard.key_down.left
    delta_x = -1
  elsif args.inputs.controller_one.key_down.right  || args.inputs.keyboard.key_down.right
    delta_x = 1
  end
  player_move(args, delta_x, delta_y)
end
