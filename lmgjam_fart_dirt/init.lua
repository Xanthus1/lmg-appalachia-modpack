minetest.register_node("lmgjam_fart_dirt:fart_dirt", {
	description = "Fart Dirt",
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_dirt_defaults(),
	drop = "default:dirt",

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		minetest.sound_play("fart_dirt_fart", {
			pos = pos,
			max_hear_distance = 16,
			gain = 1.0,
		})
	end,
})

-- Randomly replace dirt with fart dirt after mapgen
minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	
	local c_dirt = minetest.get_content_id("default:dirt")
	local c_fart = minetest.get_content_id("lmgjam_fart_dirt:fart_dirt")

	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			for x = minp.x, maxp.x do
				local vi = area:index(x, y, z)
				if data[vi] == c_dirt then
					if math.random(10) == 1 then -- 1 in 10 chance
						data[vi] = c_fart
					end
				end
			end
		end
	end

	vm:set_data(data)
	vm:write_to_map()
end)
