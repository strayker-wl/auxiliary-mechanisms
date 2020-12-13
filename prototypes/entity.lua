-- settings
local utilizerPerTierSpeed = settings.startup["strayker-utilizer-per-tier-speed"].value

-- utilizers
for i = 1, 6 do
	local entity = {
		type = "furnace",
		name = "utilizer-"..i,
		icon = "__auxiliary-mechanisms__/graphics/icon/utilizer/utilizer-"..i..".png",
		icon_size = 32,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable =
		{
			mining_time = 0.5,
			result = "utilizer-"..i
		},
		max_health = 300 + i * 50,
		corpse = "medium-remnants",
		dying_explosion = "medium-explosion",
		resistances =
		{
			{
			  type = "fire",
			  percent = 80
			}
		},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		module_specification =
		{
		  module_slots = 1 + i,
		  module_info_icon_shift = {0, 0.8}
		},
		allowed_effects = {"consumption", "speed", "pollution"},
		crafting_categories = {"recycle"},
		result_inventory_size = 1,
		crafting_speed = utilizerPerTierSpeed * i,
		energy_usage = (60 * i - (i - 1) * 15).."kW",
		source_inventory_size = 1,
		fast_replaceable_group = "utilizer",
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-input",
			emissions_per_minute = (10 * i - (i - 1) * 3)
		},
		working_sound =
		{
		  sound =
		  {
			{
			  filename = "__base__/sound/assembling-machine-t1-1.ogg",
			  volume = 0.8
			},
			{
			  filename = "__base__/sound/assembling-machine-t1-2.ogg",
			  volume = 0.8
			}
		  },
		  idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		  apparent_volume = 1.5
		},
		animation =
		{
		  layers =
		  {
			{
			  filename = "__auxiliary-mechanisms__/graphics/entity/utilizer/utilizer-"..i..".png",
			  priority="high",
			  width = 108,
			  height = 114,
			  frame_count = 32,
			  line_length = 8,
			  shift = util.by_pixel(0, 2),
			}
		  }
		},
	}
	data:extend({entity})
end

-- tesseracts
local function createControlUnitPrototype(tier, corners, isFluid)
	local fluidSuffix = ""
	local energyUsage = math.ceil(10 * tier * tier) --MW
	if isFluid then
		fluidSuffix = "fluid-"
	end
	local controlUnit = {
		{
			type = "item",
			name = "am-tesseract-"..fluidSuffix.."control-unit-"..tier,
			icon = "__auxiliary-mechanisms__/graphics/icon/tesseract/tesseract-"..fluidSuffix..tier..".png",
			icon_size = 32,
			flags = {"hidden","only-in-cursor"},
			stack_size = 100,
		},
		{
			type = "lamp",
			name = "am-tesseract-"..fluidSuffix.."control-unit-"..tier,
			icon = "__auxiliary-mechanisms__/graphics/icon/tesseract/tesseract-"..fluidSuffix..tier..".png",
			icon_size = 32,
			flags = {"placeable-neutral", "player-creation"},
			minable = nil,
			max_health = 100,
			corpse = "lamp-remnants",
			collision_mask = {},
			collision_box = nil,
			selection_box = {{-corners.small, -corners.small}, {corners.small, -corners.middle}},
			vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
			energy_source =
			{
				type = "electric",
				usage_priority = "secondary-input"
			},
			energy_usage_per_tick = energyUsage.."MW",
			darkness_for_all_lamps_on = 1,
			darkness_for_all_lamps_off = 0,
			always_on = true,
			light = {intensity = 0, size = 0},
			light_when_colored = {intensity = 0, size = 0},
			glow_size = 0,
			glow_color_intensity = 0,
			picture_off =
			{
				filename = "__auxiliary-mechanisms__/graphics/entity/tesseract/blank.png",
				priority = "low",
				width = 32,
				height = 32,
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
				shift = {0, 0},
			},
			picture_on =
			{
				filename = "__auxiliary-mechanisms__/graphics/entity/tesseract/blank.png",
				priority = "low",
				width = 32,
				height = 32,
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
				shift = {0, 0},
			},
			signal_to_color_mapping = nil,
			circuit_wire_connection_point = nil,
			circuit_connector_sprites = nil,
			circuit_wire_max_distance = nil,
			placeable_by = {
				item = "am-tesseract-"..fluidSuffix.."buffer-"..tier,
				count = 1,
			},
		}
	}
	data:extend(controlUnit)
end

local function createDummyProtorype(tier, size, corners, isFluid)
	local fluidSuffix = ""
	if isFluid then
		fluidSuffix = "fluid-"
	end
	local dummy = {
		type = "simple-entity-with-force",
		name = "am-tesseract-"..fluidSuffix.."dummy-"..tier,
		flags = {
			"player-creation",
		},
		selectable_in_game = true,
		build_sound = nil,
		mined_sound = nil,
		created_smoke = nil,
		minable = {
			mining_time = 1,
			result = nil,
		},
		collision_mask = {
			"object-layer",
		},
		collision_box = {{-corners.full, -corners.full}, {corners.full, corners.full}},
		selection_box = {{-corners.full, -corners.full}, {corners.full, corners.full}},
		picture = {
			filename = "__auxiliary-mechanisms__/graphics/entity/tesseract/tesseract-"..fluidSuffix..tier..".png",
			width = 36 * size,
			height = 38 * size,
		},
		render_layer = "object",
		tile_width = size,
		tile_height = size,
	}
	data:extend({dummy})
end

local function createTesseractPrototype(tier, size)
	local capacity = size * size * tier * 10 -- slots count
	local corners = {
		small = size / 2 - 0.5,
		full = size / 2 - 0.1,
		--middle = 0.25
		middle = 0
	}
	createControlUnitPrototype(tier, corners, false)
	createDummyProtorype(tier, size, corners, false)
	local tesseract = {
		{
			type = "item",
			name = "am-tesseract-buffer-"..tier,
			icon = "__auxiliary-mechanisms__/graphics/icon/tesseract/tesseract-"..tier..".png",
			icon_size = 32,
			flags = {"hidden","only-in-cursor"},
			stack_size = 100,
		},
		{
			type = "container",
			name = "am-tesseract-buffer-"..tier,
			icon = "__auxiliary-mechanisms__/graphics/icon/tesseract/tesseract-"..tier..".png",
			icon_size = 32,
			flags = {"placeable-neutral", "player-creation"},
			minable = {mining_time = 1, result = "am-tesseract-dummy-"..tier},
			max_health = 300,
			corpse = "small-remnants",
			open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65 },
			close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
			resistances =
			{
				{
					type = "fire",
					percent = 90
				}
			},
			picture = {
				filename = "__auxiliary-mechanisms__/graphics/entity/tesseract/tesseract-"..tier..".png",
				width = 36 * size,
				height = 38 * size,
				priority = "low",
			},
			collision_box = {{-corners.full, -corners.full}, {corners.full, corners.full}},
			selection_box = {{-corners.small, corners.middle}, {corners.small, corners.small}},
			inventory_size = capacity,
			vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
			circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
			circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
			circuit_wire_max_distance = default_circuit_wire_max_distance,
			placeable_by = {
				item = "am-tesseract-dummy-"..tier,
				count = 1,
			},
			tile_width = size,
			tile_height = size,
		}
	}
	data:extend(tesseract)
end

local function createTesseractFluidPrototype(tier, size)
	local capacity = size * size * tier * 10 * 1000 -- fluid count
	local corners = {
		small = size / 2 - 0.5,
		full = size / 2 - 0.1,
		middle = 0.25
	}
	local pipes = {
		v1 = size / 2 - 0.5,
		v2 = size / 2 + 0.5
	}
	createControlUnitPrototype(tier, corners, true)
	createDummyProtorype(tier, size, corners, true)
	local tesseract = {
		{
			type = "item",
			name = "am-tesseract-fluid-buffer-"..tier,
			icon = "__auxiliary-mechanisms__/graphics/icon/tesseract/tesseract-fluid-"..tier..".png",
			icon_size = 32,
			flags = {"hidden","only-in-cursor"},
			stack_size = 100,
		},
		{
			type = "storage-tank",
			name = "am-tesseract-fluid-buffer-"..tier,
			icon = "__auxiliary-mechanisms__/graphics/icon/tesseract/tesseract-fluid-"..tier..".png",
			icon_size = 32,
			flags = {"placeable-neutral", "player-creation", "not-rotatable"},
			minable = {mining_time = 1, result = "am-tesseract-fluid-dummy-"..tier},
			max_health = 300,
			corpse = "small-remnants",
			open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65 },
			close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
			resistances = { { type = "fire", percent = 90 } },
			collision_box = {{-corners.full, -corners.full}, {corners.full, corners.full}},
			selection_box = {{-corners.small, corners.middle}, {corners.small, corners.small}},
			fluid_box = {
				base_area = capacity/100,
				pipe_picture = assembler2pipepictures(),
				pipe_covers = pipecoverspictures(),
				pipe_connections = {
					{ position = {-pipes.v1, -pipes.v2} },
					{ position = {-pipes.v2, -pipes.v1} },
					{ position = {pipes.v2, pipes.v1} },
					{ position = {pipes.v1, pipes.v2} },
					{ position = {pipes.v1, -pipes.v2} },
					{ position = {pipes.v2, -pipes.v1} },
					{ position = {-pipes.v2, pipes.v1} },
					{ position = {-pipes.v1, pipes.v2} },
				},
			},
			two_direction_only = false,
			flow_length_in_ticks = 360,
			window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}},
			vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
			pictures = {
				picture = {
					filename = "__auxiliary-mechanisms__/graphics/entity/tesseract/tesseract-fluid-"..tier..".png",
					width = 36 * size,
					height = 38 * size,
					priority = "low",
				},
				fluid_background = {
					filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
					priority = "low",
					width = 32,
					height = 15
				},
				window_background = {
					filename = "__base__/graphics/entity/storage-tank/window-background.png",
					priority = "low",
					width = 17,
					height = 24
				},
				flow_sprite = {
					filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
					priority = "low",
					width = 160,
					height = 20
				},
				gas_flow = {
					filename = "__base__/graphics/entity/pipe/steam.png",
					priority = "low",
					line_length = 10,
					width = 24,
					height = 15,
					frame_count = 60,
					axially_symmetrical = false,
					direction_count = 1,
					animation_speed = 0.25,
					hr_version =
					{
						filename = "__base__/graphics/entity/pipe/hr-steam.png",
						priority = "low",
						line_length = 10,
						width = 48,
						height = 30,
						frame_count = 60,
						axially_symmetrical = false,
						animation_speed = 0.25,
						direction_count = 1
					}
				}
			},
			working_sound = {
				sound = {
					filename = "__base__/sound/storage-tank.ogg",
					volume = 0.8
				},
				apparent_volume = 1.5,
				max_sounds_per_type = 3
			},
			circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points,
			circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites,
			circuit_wire_max_distance = default_circuit_wire_max_distance,
			placeable_by = {
				item = "am-tesseract-fluid-dummy-"..tier,
				count = 1,
			},
			tile_width = size,
			tile_height = size,
		}
	}
	data:extend(tesseract)
end

local sizes = {2, 4, 6}
for i = 1, 3 do
	createTesseractPrototype(i, sizes[i])
	createTesseractFluidPrototype(i, sizes[i])
end