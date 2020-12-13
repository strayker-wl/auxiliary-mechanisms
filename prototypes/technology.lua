data:extend({
{
    type = "technology",
    name = "utilizer-1",
    icon = "__auxiliary-mechanisms__/graphics/technology/utilizer.png",
	icon_size = 128,
	upgrade="true",
    prerequisites = {"automation-2"},
    effects =
    {
        {
          type = "unlock-recipe",
          recipe = "utilizer-1"
        }
    },		 
    unit =
    {
        count = 100,
        ingredients =
        {
            {"automation-science-pack", 1},
        },
        time = 30
    }
},
{
    type = "technology",
    name = "utilizer-2",
    icon = "__auxiliary-mechanisms__/graphics/technology/utilizer.png",
	icon_size = 128,
	upgrade="true",
    prerequisites = {"utilizer-1"},
    effects =
    {
        {
          type = "unlock-recipe",
          recipe = "utilizer-2"
        }
    },		 
    unit =
    {
        count = 150,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 35
    }
},
{
    type = "technology",
    name = "utilizer-3",
    icon = "__auxiliary-mechanisms__/graphics/technology/utilizer.png",
	icon_size = 128,
	upgrade="true",
    prerequisites = {"advanced-electronics", "engine", "utilizer-2"},
    effects =
    {
        {
          type = "unlock-recipe",
          recipe = "utilizer-3"
        }
    },		 
    unit =
    {
        count = 200,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
        },
        time = 40
    }
},
{
    type = "technology",
    name = "utilizer-4",
    icon = "__auxiliary-mechanisms__/graphics/technology/utilizer.png",
	icon_size = 128,
	upgrade="true",
    prerequisites = {"concrete", "plastics", "utilizer-3"},
    effects =
    {
        {
          type = "unlock-recipe",
          recipe = "utilizer-4"
        }
    },		 
    unit =
    {
        count = 250,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"production-science-pack", 1},
			{"chemical-science-pack", 1},
        },
        time = 45
    }
},
{
    type = "technology",
    name = "utilizer-5",
    icon = "__auxiliary-mechanisms__/graphics/technology/utilizer.png",
	icon_size = 128,
	upgrade="true",
    prerequisites = {"electric-engine", "steel-processing", "utilizer-4"},
    effects =
    {
        {
          type = "unlock-recipe",
          recipe = "utilizer-5"
        }
    },		 
    unit =
    {
        count = 300,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"production-science-pack", 1},
			{"chemical-science-pack", 1},
			{"utility-science-pack", 1},
        },
        time = 50
    }
},
{
    type = "technology",
    name = "utilizer-6",
    icon = "__auxiliary-mechanisms__/graphics/technology/utilizer.png",
	icon_size = 128,
	upgrade="true",
    prerequisites = {"advanced-electronics-2", "utilizer-5"},
    effects =
    {
        {
          type = "unlock-recipe",
          recipe = "utilizer-6"
        }
    },		 
    unit =
    {
        count = 500,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"production-science-pack", 1},
			{"chemical-science-pack", 1},
			{"utility-science-pack", 1},
        },
        time = 60
    }
},
{
    type = "technology",
    name = "tesseract-1",
    icon = "__auxiliary-mechanisms__/graphics/technology/tesseract.png",
    icon_size = 128,
    upgrade="true",
    prerequisites = {
        "electric-energy-accumulators",
        "advanced-electronics",
        "logistics-2",
    },
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "am-tesseract-dummy-1"
        },
        {
            type = "unlock-recipe",
            recipe = "am-tesseract-fluid-dummy-1"
        },
    },
    unit =
    {
        count = 300,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
        },
        time = 30
    }
},
{
    type = "technology",
    name = "tesseract-2",
    icon = "__auxiliary-mechanisms__/graphics/technology/tesseract.png",
    icon_size = 128,
    upgrade="true",
    prerequisites = {
        "tesseract-1",
        "advanced-electronics-2",
        "logistics-3",
    },
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "am-tesseract-dummy-2"
        },
        {
            type = "unlock-recipe",
            recipe = "am-tesseract-fluid-dummy-2"
        },
    },
    unit =
    {
        count = 400,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
        },
        time = 40
    }
},
{
    type = "technology",
    name = "tesseract-3",
    icon = "__auxiliary-mechanisms__/graphics/technology/tesseract.png",
    icon_size = 128,
    upgrade="true",
    prerequisites = {
        "tesseract-2",
    },
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "am-tesseract-dummy-3"
        },
        {
            type = "unlock-recipe",
            recipe = "am-tesseract-fluid-dummy-3"
        },
    },
    unit =
    {
        count = 500,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"utility-science-pack", 1},
        },
        time = 50
    }
},
})
