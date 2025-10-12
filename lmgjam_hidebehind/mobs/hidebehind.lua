----------------
-- Hidebehind --
----------------

local S = core.get_translator("lmgjam_hidebehind")

creatura.register_mob("lmgjam_hidebehind:hidebehind", {
	-- Engine Props
	visual_size = {x = 1.5, y = 1.5},
	mesh = "lmgjam_hidebehind.gltf",
	textures = {"lmgjam_hidebehind.png"},
	--child_textures = {},
	makes_footstep_sound = true,

	-- Creatura Props
	max_health = 80,
	damage = 3,
	speed = 5,
	tracking_range = 40,
	max_boids = 1,
	despawn_after = 500,
	stepheight = 1.1,
	sounds = {
		random = {
			name = "animalia_reindeer",
			gain = 0.5,
			distance = 8
		},
		hurt = {
			name = "animalia_reindeer_hurt",
			gain = 0.5,
			distance = 8
		},
		death = {
			name = "animalia_reindeer_death",
			gain = 0.5,
			distance = 8
		}
	},
	hitbox = {
		width = 0.5,
		height = 2.9
	},
	animations = {
		walk = {range = {x = 0, y = 2}, speed = 1, frame_blend = 0.0, loop = true},
		run = {range = {x = 0, y = 2}, speed = 2, frame_blend = 0.0, loop = true},
		stand = {range = {x = 3, y = 5}, speed = 1, frame_blend = 0.0, loop = true},
		hide = {range = {x = 6, y = 8}, speed = 1, frame_blend = 0.0, loop = false},
		melee = {range = {x = 9, y = 11}, speed = 1, frame_blend = 0.0, loop = true},
	},

	--follow = animalia.food_wheat,
	--[[
	drops = {
		{name = "animalia:venison_raw", min = 1, max = 3, chance = 1},
		{name = "animalia:leather", min = 1, max = 3, chance = 2}
	},
	--]]

	-- Behavior Parameters
	is_grazing_mob = false,
	is_herding_mob = false,

	--[[
	do_custom = function(self, dtime)
		-- Update every 0.25 seconds instead of every tick
		self.update_timer = (self.update_timer or 0) + dtime
		if self.update_timer < 1.00 then return end
		self.update_timer = 0

		local pos = self.object:get_pos()
		local player_pos = player_target:get_pos()

		-- Get the difference between the two positions
		local vec_dist = vector.subtract(pos, player_pos)
		-- Halve that difference
		local vec_half = vector.divide(vec_dist, 2)
		vec_half = vector.round(vec_half)
		-- Add that halved difference to the player's position
		-- This will get us a position roughly halfway to the player
		local vec_target = vector.add(player_pos, vec_half)

		self.object:move_to(vec_target)
		--core.find_nodes_in_area_under_air(pos, player_pos, "ignore")

		--core.find_nodes_in_area(pos1, pos2, nodenames, [grouped])
		--core.find_nodes_in_area_under_air(pos1, pos2, nodenames)
		--core.find_node_near(pos, radius, nodenames, [search_center])

		--pos, amount, texture, min_size, max_size, radius, gravity, glow, fall
		--mobs:effect(pos, 5, "fire_basic_flame.png", 1, 2, 0.1, 0.2, 14, nil)
	end
	--]]

	-- Animalia Props

	-- Functions
	utility_stack = {
		animalia.mob_ai.basic_wander,
		animalia.mob_ai.swim_seek_land,
		hidebehind.mob_ai.flee_and_hide,
		hidebehind.mob_ai.sneak_towards_player
	},

	activate_func = function(self)
		animalia.initialize_api(self)
	end,

	step_func = function(self)
		animalia.step_timers(self)
		animalia.head_tracking(self)
		animalia.do_growth(self, 60)
		animalia.update_lasso_effects(self)
		animalia.random_sound(self)
	end,

	death_func = animalia.death_func,

	on_rightclick = function(self, clicker)
		if animalia.feed(self, clicker, false, true) then
			return
		end
		if animalia.set_nametag(self, clicker) then
			return
		end
	end,

	on_punch = animalia.punch
})

creatura.register_abm_spawn("lmgjam_hidebehind:hidebehind", {
	chance = 12000, -- 1 in X
	spawn_on_load = true,
	chance_on_load = 1,
	interval = 15,
	min_height = -1,
	max_height = 1024,
	min_group = 1,
	max_group = 1,
	nodes = {"group:soil"},
	--biomes = animalia.registered_biome_groups["boreal"].biomes,
	--nodes = {"group:soil", "group:sand", "group:leaves"},
})


creatura.register_spawn_item("lmgjam_hidebehind:hidebehind", {
	col1 = "413022",
	col2 = "d5c0a3"
})