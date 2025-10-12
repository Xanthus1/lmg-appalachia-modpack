-- Only keep appalachia biomes / decorations
keep_biomes = {
	"appalachia_deciduous_forest",
	"appalachia_grasslands",
	"appalachia_under"
}
core.register_on_mods_loaded(function()
    for name, biomedef in pairs(core.registered_biomes) do
        local found = false
        for _,value in ipairs(keep_biomes) do
            if value == name then
                found = true
            end
        end
        if found == false then
            core.unregister_biome(name)
        else
            local new_biome_def = table.copy(biomedef)
            core.unregister_biome(name)
            core.register_biome(new_biome_def)
        end
    end
    register_appalachian_biome()

    -- clear all decorations and register appalachia decorations
    core.clear_registered_decorations()
    register_appalachian_decorations()
end)
