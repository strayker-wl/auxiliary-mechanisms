data:extend({
-- utilizers
{
    type = "recipe",
    name = "utilizer-1",
    energy_required = 1,
	enabled = "false",
	ingredients = 
	{
		{"assembling-machine-2", 1},
		{"iron-plate", 10},
		{"stone-brick", 15},
		{"electronic-circuit", 5},
	},
	result = "utilizer-1"
},
{
    type = "recipe",
    name = "utilizer-2",
    energy_required = 1,
	enabled = "false",
	ingredients = 
	{
		{"utilizer-1", 1},
		{"iron-gear-wheel", 15},
		{"iron-stick", 5},
		{"electronic-circuit", 10},
	},
	result = "utilizer-2"
},
{
    type = "recipe",
    name = "utilizer-3",
    energy_required = 1,
	enabled = "false",
	ingredients = 
	{
		{"utilizer-2", 1},
		{"engine-unit", 10},
		{"advanced-circuit", 5},
	},
	result = "utilizer-3"
},
{
    type = "recipe",
    name = "utilizer-4",
    energy_required = 1,
	enabled = "false",
	ingredients = 
	{
		{"utilizer-3", 1},
		{"concrete", 10},
		{"advanced-circuit", 10},
		{"plastic-bar", 10},
	},
	result = "utilizer-4"
},
{
    type = "recipe",
    name = "utilizer-5",
    energy_required = 1,
	enabled = "false",
	ingredients = 
	{
		{"utilizer-4", 1},
		{"electric-engine-unit", 10},
		{"advanced-circuit", 15},
		{"steel-plate", 10},
	},
	result = "utilizer-5"
},
{
    type = "recipe",
    name = "utilizer-6",
    energy_required = 1,
	enabled = "false",
	ingredients = 
	{
		{"utilizer-5", 1},
		{"refined-concrete", 10},
		{"processing-unit", 10},
	},
	result = "utilizer-6"
},
-- tesseracts
{
	type = "recipe",
	name = "am-tesseract-dummy-1",
	energy_required = 1,
	enabled = "false",
	ingredients =
	{
		{"advanced-circuit", 20},
		{"concrete", 24},
		{"steel-chest", 2},
		{"accumulator", 2},
		{"iron-plate", 20},
	},
	result = "am-tesseract-dummy-1"
},
{
	type = "recipe",
	name = "am-tesseract-dummy-2",
	energy_required = 1,
	enabled = "false",
	ingredients =
	{
		{"am-tesseract-dummy-1", 1},
		{"processing-unit", 20},
		{"substation", 2},
		{"steel-chest", 8},
		{"concrete", 24},
		{"steel-plate", 30},
	},
	result = "am-tesseract-dummy-2"
},
{
	type = "recipe",
	name = "am-tesseract-dummy-3",
	energy_required = 1,
	enabled = "false",
	ingredients =
	{
		{"am-tesseract-dummy-2", 1},
		{"processing-unit", 20},
		{"steel-chest", 24},
		{"refined-concrete", 48},
		{"steel-plate", 60},
	},
	result = "am-tesseract-dummy-3"
},
{
	type = "recipe",
	name = "am-tesseract-fluid-dummy-1",
	energy_required = 1,
	enabled = "false",
	ingredients =
	{
		{"advanced-circuit", 20},
		{"concrete", 20},
		{"storage-tank", 2},
		{"accumulator", 2},
		{"steel-plate", 20},
	},
	result = "am-tesseract-fluid-dummy-1"
},
{
	type = "recipe",
	name = "am-tesseract-fluid-dummy-2",
	energy_required = 1,
	enabled = "false",
	ingredients =
	{
		{"am-tesseract-fluid-dummy-1", 1},
		{"processing-unit", 20},
		{"substation", 2},
		{"storage-tank", 8},
		{"concrete", 24},
		{"steel-plate", 20},
	},
	result = "am-tesseract-fluid-dummy-2"
},
{
	type = "recipe",
	name = "am-tesseract-fluid-dummy-3",
	energy_required = 1,
	enabled = "false",
	ingredients =
	{
		{"am-tesseract-fluid-dummy-2", 1},
		{"processing-unit", 20},
		{"storage-tank", 24},
		{"refined-concrete", 48},
		{"steel-plate", 60},
	},
	result = "am-tesseract-fluid-dummy-3"
}
})
