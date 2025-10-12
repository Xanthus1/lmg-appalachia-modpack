hidebehind = {}

-- nodes (blocks)
dofile(core.get_modpath("lmgjam_hidebehind") .. "/src/nodes.lua")

-- decorations (structures that generate), biomes, map generation
dofile(core.get_modpath("lmgjam_hidebehind") .. "/src/mapgen.lua")

-- crafting (recipes)
dofile(core.get_modpath("lmgjam_hidebehind") .. "/src/crafting.lua")

-- entities (mobs)
dofile(core.get_modpath("lmgjam_hidebehind") .. "/api/mob_ai.lua")
dofile(core.get_modpath("lmgjam_hidebehind") .. "/mobs/hidebehind.lua")

