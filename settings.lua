data:extend(
{
	{
		type = "int-setting",
		name = "strayker-utilizer-per-tier-speed",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 1,
		maximum_value = 15,
		order = "ba"
	},
	{
		type = "int-setting",
		name = "strayker-tesseract-check-per-second",
		order = "aa",
		setting_type = "runtime-global",
		default_value = 15,
		minimum_value = 1,
		maximum_value = 60,
	},
}
)


