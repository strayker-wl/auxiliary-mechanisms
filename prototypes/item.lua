-- utilizers
for i = 1, 6 do
	local item = {
		type = "item",
		name = "utilizer-"..i,
		icons = {
			{icon = "__auxiliary-mechanisms__/graphics/icon/utilizer/utilizer-"..i..".png"},
			{icon = "__auxiliary-mechanisms__/graphics/icon/tier/t"..i..".png"},
		},
		icon_size = 32,
		subgroup = "am-utilizers",
		order = "y[utilizer]-a"..i,
		place_result = "utilizer-"..i,
		stack_size = 100
	}
	data:extend({item})
end

-- tesseracts

for i = 1, 3 do
	local items = {
		{
			type = "item",
			name = "am-tesseract-dummy-"..i,
			icons = {
				{icon = "__auxiliary-mechanisms__/graphics/icon/tesseract/tesseract-"..i..".png"},
				{icon = "__auxiliary-mechanisms__/graphics/icon/tier/t"..i..".png"}
			},
			icon_size = 32,
			subgroup = "am-tesseracts",
			order = "y[tesseracts]-a"..i,
			place_result = "am-tesseract-dummy-"..i,
			stack_size = 100
		},
		{
			type = "item",
			name = "am-tesseract-fluid-dummy-"..i,
			icons = {
				{icon = "__auxiliary-mechanisms__/graphics/icon/tesseract/tesseract-fluid-"..i..".png"},
				{icon = "__auxiliary-mechanisms__/graphics/icon/tier/t"..i..".png"}
			},
			icon_size = 32,
			subgroup = "am-tesseracts-fluid",
			order = "y[tesseracts-fluid]-a"..i,
			place_result = "am-tesseract-fluid-dummy-"..i,
			stack_size = 100
		}
	}
	data:extend(items)
end
