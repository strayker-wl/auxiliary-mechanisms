function createRecuclingRecipesList()
	local recipes = {}
	for itemName, item in pairs(data.raw.item) do
		recipe = createRecuclingRecipe(item)
		table.insert(recipes, recipe)
	end
	data:extend(recipes)
end

function createRecuclingRecipe(item)
	local results = {}
	local recipe = {
		type = "recipe",
		name = "am-recucling-"..item.name,
		icon = item.icon,
		icon_size = 32,
		category = "recycle",
		subgroup = "am-recucling-recipes",
		hidden = "true",
		energy_required = 1,
		ingredients = {{item.name, 1}},
		results = results,
		allow_decomposition = false
	}
	if item.icons then
		recipe.icons = item.icons
	end
	return recipe
end
