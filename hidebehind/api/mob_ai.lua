------------
-- Mob AI --
------------

-- Math --

local abs = math.abs
local atan2 = math.atan2
local cos = math.cos
local min = math.min
local max = math.max
local floor = math.floor
local pi = math.pi
local pi2 = pi * 2
local sin = math.sin
local rad = math.rad
local random = math.random

local function diff(a, b) -- Get difference between 2 angles
	return atan2(sin(b - a), cos(b - a))
end

local function clamp(val, minn, maxn)
	if val < minn then
		val = minn
	elseif maxn < val then
		val = maxn
	end
	return val
end

-- Vector Math --

local vec_add, vec_dot, vec_dir, vec_dist, vec_multi, vec_normal,
	vec_round, vec_sub = vector.add, vector.dot, vector.direction, vector.distance,
	vector.multiply, vector.normalize, vector.round, vector.subtract

local dir2yaw = minetest.dir_to_yaw
local yaw2dir = minetest.yaw_to_dir

-----------------
-- Local Tools --
-----------------

local farming_enabled = minetest.get_modpath("farming") and farming.registered_plants

if farming_enabled then
	minetest.register_on_mods_loaded(function()
		for name, def in pairs(minetest.registered_nodes) do
			local item_string = name:sub(1, #name - 2)
			local item_name = item_string:split(":")[2]
			local growth_stage = tonumber(name:sub(-1)) or 1
			if farming.registered_plants[item_string]
			or farming.registered_plants[item_name] then
				def.groups.crop = growth_stage
			end
			minetest.register_node(":" .. name, def)
		end
	end)
end

local animate_player = {}

if minetest.get_modpath("default")
and minetest.get_modpath("player_api") then
	animate_player = player_api.set_animation
elseif minetest.get_modpath("mcl_player") then
	animate_player = mcl_player.player_set_animation
end

local function get_group_positions(self)
	local objects = creatura.get_nearby_objects(self, self.name)
	local group = {}
	for _, object in ipairs(objects) do
		local obj_pos = object and object:get_pos()
		if obj_pos then table.insert(group, obj_pos) end
	end
	return group
end

local function calc_altitude(self, pos2)
	local height_half = self.height * 0.5
	local center_y = pos2.y + height_half
	local calc_pos = {x = pos2.x, y = center_y, z = pos2.z}
	local range = (height_half + 2)
	local offset = {x = 0, y = range, z = 0}
	local ceil_pos, floor_pos = vec_add(calc_pos, offset), vec_sub(calc_pos, offset)
	local ray_up = minetest.raycast(calc_pos, ceil_pos, false, true):next()
	local ray_down = minetest.raycast(calc_pos, floor_pos, false, true):next()
	ceil_pos = (ray_up and ray_up.above) or ceil_pos
	floor_pos = (ray_down and ray_down.above) or floor_pos

	local dist_up = ceil_pos.y - center_y
	local dist_down = floor_pos.y - center_y

	local altitude = (dist_up + dist_down) / 2

	return ((calc_pos.y + altitude) - center_y) / range * 2
end

--[[local function calc_steering_and_lift(self, pos, pos2, dir, steer_method)
	local steer_to = creatura.calc_steering(self, pos2, steer_method or creatura.get_context_small)
	pos2 = vec_add(pos, steer_to)
	local lift = creatura.get_avoidance_lift(self, pos2, 2)
	steer_to.y = (lift ~= 0 and lift) or dir.y
	return steer_to
end

local function calc_steering_and_lift_aquatic(self, pos, pos2, dir, steer_method)
	local steer_to = creatura.calc_steering(self, pos2, steer_method or creatura.get_context_small_aquatic)
	local lift = creatura.get_avoidance_lift_aquatic(self, vec_add(pos, steer_to), 2)
	steer_to.y = (lift ~= 0 and lift) or dir.y
	return steer_to
end]]

local function get_obstacle(pos, water)
	local pos2 = {x = pos.x, y = pos.y, z = pos.z}
	local n_def = creatura.get_node_def(pos2)
	if n_def.walkable
	or (water and (n_def.groups.liquid or 0) > 0) then
		pos2.y = pos.y + 1
		n_def = creatura.get_node_def(pos2)
		local col_max = n_def.walkable or (water and (n_def.groups.liquid or 0) > 0)
		pos2.y = pos.y - 1
		local col_min = col_max and (n_def.walkable or (water and (n_def.groups.liquid or 0) > 0))
		if col_min then
			return pos
		else
			pos2.y = pos.y + 1
			return pos2
		end
	end
end

--------------
-- Movement --
--------------

-- Methods


-- Simple Methods
--[[
creatura.register_movement_method("animalia:move", function(self)
	local radius = 2 -- Arrival Radius

	self:set_gravity(-9.8)
	local function func(_self, goal, speed_factor)
		-- Vectors
		local pos = self.object:get_pos()
		if not pos or not goal then return end

		local dist = vec_dist(pos, goal)
		local dir = vec_dir(pos, goal)

		-- Movement Params
		local vel = self.speed * speed_factor
		local turn_rate = self.turn_rate
		local mag = min(radius - ((radius - dist) / 1), 1)
		vel = vel * mag

		-- Apply Movement
		_self:turn_to(minetest.dir_to_yaw(dir), turn_rate)
		_self:set_forward_velocity(vel)
	end
	return func
end)
--]]

---------------
-- Functions --
---------------
--[[
function animalia.action_melee(self, target)
	local stage = 1
	local is_animated = self.animations["melee"] ~= nil
	local timeout = 1

	local function func(mob)
		local target_pos = target and target:get_pos()
		if not target_pos then return true end

		local pos = mob.stand_pos
		local dist = vec_dist(pos, target_pos)
		local dir = vec_dir(pos, target_pos)

		local anim = is_animated and mob:animate("melee", "stand")

		if stage == 1 then
			mob.object:add_velocity({x = dir.x * 3, y = 2, z = dir.z * 3})

			stage = 2
		end

		if stage == 2
		and dist < mob.width + 1 then
			mob:punch_target(target)
			local knockback = minetest.calculate_knockback(
				target, mob.object, 1.0,
				{damage_groups = {fleshy = mob.damage}},
				dir, 2.0, mob.damage
			)
			target:add_velocity({x = dir.x * knockback, y = dir.y * knockback, z = dir.z * knockback})

			stage = 3
		end

		if stage == 3
		and (not is_animated
		or anim == "stand") then
			return true
		end

		timeout = timeout - mob.dtime
		if timeout <= 0 then return true end
	end
	self:set_action(func)
end
--]]

--[[
function animalia.action_pursue(self, target, timeout, method, speed_factor, anim)
	local timer = timeout or 4
	local goal
	local function func(_self)
		local target_alive, line_of_sight, tgt_pos = _self:get_target(target)
		if not target_alive then
			return true
		end
		goal = goal or tgt_pos
		timer = timer - _self.dtime
		self:animate(anim or "walk")
		local safe = true
		if _self.max_fall
		and _self.max_fall > 0 then
			local pos = self.object:get_pos()
			if not pos then return end
			safe = _self:is_pos_safe(goal)
		end
		if line_of_sight
		and vec_dist(goal, tgt_pos) > 3 then
			goal = tgt_pos
		end
		if timer <= 0
		or not safe
		or _self:move_to(goal, method or "creatura:obstacle_avoidance", speed_factor or 0.5) then
			return true
		end
	end
	self:set_action(func)
end
--]]

function hidebehind.action_hide_and_peek(self, target)
	local start_point
	local target_point
	local hide_point
	local function func(mob)
		local target_alive, line_of_sight, tgt_pos = mob:get_target(target)
		start_point = start_point or mob.object:get_pos()
		target_point = target_point or tgt_pos
		
		if not hide_point then
			local vec_temp = vector.new(0, 0, 0)
			hide_point = vector.add(start_point, vec_temp)
		end

		animalia.action_pursue(mob, hide_point, 0.2)
		mob:animate("hide")
	end
	self:set_action(func)
end

-------------
-- Actions --
-------------

creatura.register_utility("hidebehind:sneak_towards_player", function(self, target)
	local on_cooldown = false
	local timer = 0.5

	local function func(mob)
		local target_alive, _, target_pos = mob:get_target(target)
		if not target_alive then 
			--core.chat_send_all("AI Debug: Target is dead, or doesn't exist")
			return true
		end

		local pos = mob.object:get_pos()
		if not pos then
			--core.chat_send_all("AI Debug: Mob can't locate itself")
			return true 
		end

		if on_cooldown then
			timer = timer - mob.dtime
			if timer <= 0 then
				timer = 0.5
				on_cooldown = false
			end
		else
			--if mob.attack_on_cooldown then return true, 1 end
			--if has_attacked then return true, 1 end
			if not mob:get_action() then
				--[[
				if has_hidden then
					--core.chat_send_all("AI Debug: Target has hidden (action canceled)")
					return true, 2
				end
				--]]

				local dist = vec_dist(pos, target_pos)

				if dist > mob.width + 2 then
					local target_yaw = target:get_look_horizontal()
					local linked_yaw = minetest.dir_to_yaw(vec_dir(target_pos, pos))

					if abs(diff(target_yaw, linked_yaw)) > pi / 4 then
						animalia.action_pursue(mob, target, 0.20)
						--core.chat_send_all("AI Debug: Pursuing target")
					else
						--core.chat_send_all("AI Debug: Hiding")
						hidebehind.action_hide_and_peek(mob, target)
						--creatura.action_idle(mob, 0.5, "hide")
					end
					return
				else
					--core.chat_send_all("AI Debug: Target is doing a melee attack")
					animalia.action_melee(mob, target)
					on_cooldown = true
					--has_attacked = true
					--has_hidden = true
				end
			end
		end


	end
	self:set_utility(func)
end)
------------
-- Mob AI --
-------------

hidebehind.mob_ai = {}

hidebehind.mob_ai.flee_and_hide = {
	utility = "animalia:basic_flee",
	get_score = function(self)

		local puncher = self._puncher
		local hp = self.hp

		if puncher and puncher:get_pos() and (hp <= 30) then
			return 0.75, {self, puncher}
		end
		self._puncher = nil
		return 0
	end
}

hidebehind.mob_ai.sneak_towards_player = {
	utility = "hidebehind:sneak_towards_player",
	get_score = function(self)
		local player = creatura.get_nearby_player(self)
		if player then
			local dist = vec_dist(self.stand_pos, player:get_pos())
			if dist < self.tracking_range then
				return 0.5, {self, player}
			end
		end
		return 0.0, {self, player}
	end
}

--[[
animalia.mob_ai.basic_attack = {
	utility = "animalia:basic_attack",
	get_score = function(self)
		local pos = entity.stand_pos
		if not pos then return end

		local order = entity.order or "wander"
		if order ~= "wander" then return 0 end

		local target = entity._target or (entity.attacks_players and creatura.get_nearby_player(entity))
		local tgt_pos = target and target:get_pos()

		if not tgt_pos
		or not entity:is_pos_safe(tgt_pos)
		or (target:is_player()
		and minetest.is_creative_enabled(target:get_player_name())) then
			target = creatura.get_nearby_object(entity, self.attack_list)
			tgt_pos = target and target:get_pos()
		end

		if not tgt_pos then entity._target = nil return 0 end

		if target == entity.object then entity._target = nil return 0 end

		if animalia.has_shared_owner(entity.object, target) then entity._target = nil return 0 end

		local dist = vec_dist(pos, tgt_pos)
		local score = (entity.tracking_range - dist) / entity.tracking_range

		if entity.trust
		and target:is_player()
		and entity.trust[target:get_player_name()] then
			local trust = entity.trust[target:get_player_name()]
			local trust_score = ((entity.max_trust or 10) - trust) / (entity.max_trust or 10)

			score = score - trust_score
		end

		entity._target = target
		return score * 0.5, {entity, target}
	end
}
--]]

--flee boomshine
--hide
--walk
--attack
