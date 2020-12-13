if bobmods then
	if angelsmods then
		if angelsmods.smelting then
			bobmods.lib.recipe.add_new_ingredient("utilizer-2", {"clay-brick", 15})
			bobmods.lib.tech.add_prerequisite("utilizer-2", "angels-stone-smelting-1")
			
			bobmods.lib.recipe.add_new_ingredient("utilizer-3", {"concrete", 15})
			bobmods.lib.tech.add_prerequisite("utilizer-3", "concrete")
			
			bobmods.lib.recipe.replace_ingredient("utilizer-4", "concrete", "concrete-brick")
			bobmods.lib.tech.add_prerequisite("utilizer-4", "angels-stone-smelting-2")
			
			bobmods.lib.recipe.add_new_ingredient("utilizer-5", {"reinforced-concrete-brick", 15})
			bobmods.lib.tech.add_prerequisite("utilizer-5", "angels-stone-smelting-3")

			bobmods.lib.recipe.replace_ingredient("am-tesseract-dummy-1", "concrete", "clay-brick")
			bobmods.lib.tech.add_prerequisite("am-tesseract-dummy-1", "angels-stone-smelting-1")

			bobmods.lib.recipe.replace_ingredient("am-tesseract-fluid-dummy-1", "concrete", "clay-brick")
			bobmods.lib.tech.add_prerequisite("am-tesseract-fluid-dummy-1", "angels-stone-smelting-1")

			bobmods.lib.recipe.replace_ingredient("am-tesseract-dummy-2", "concrete", "concrete-brick")
			bobmods.lib.tech.add_prerequisite("am-tesseract-dummy-2", "angels-stone-smelting-2")

			bobmods.lib.recipe.replace_ingredient("am-tesseract-fluid-dummy-2", "concrete", "concrete-brick")
			bobmods.lib.tech.add_prerequisite("am-tesseract-fluid-dummy-2", "angels-stone-smelting-2")

			bobmods.lib.recipe.replace_ingredient("am-tesseract-dummy-3", "refined-concrete", "reinforced-concrete-brick")
			bobmods.lib.tech.add_prerequisite("am-tesseract-dummy-3", "angels-stone-smelting-3")

			bobmods.lib.recipe.replace_ingredient("am-tesseract-fluid-dummy-3", "refined-concrete", "reinforced-concrete-brick")
			bobmods.lib.tech.add_prerequisite("am-tesseract-fluid-dummy-3", "angels-stone-smelting-3")

			-- extended angels
			if data.raw.item["titanium-concrete-brick"] then
				bobmods.lib.recipe.replace_ingredient("utilizer-6", "refined-concrete", "titanium-concrete-brick")
				bobmods.lib.tech.add_prerequisite("utilizer-6", "angels-stone-smelting-4")
			end
		end
	end

	if bobmods.plates then
		bobmods.lib.recipe.add_new_ingredient("utilizer-3", {"steel-gear-wheel", 10})
		bobmods.lib.tech.add_prerequisite("utilizer-3", "steel-processing")
		
		bobmods.lib.recipe.replace_ingredient("utilizer-4", "plastic-bar", "brass-gear-wheel")
		bobmods.lib.tech.add_prerequisite("utilizer-4", "zinc-processing")
		
		bobmods.lib.recipe.replace_ingredient("utilizer-5", "steel-plate", "titanium-gear-wheel")
		bobmods.lib.tech.add_prerequisite("utilizer-5", "titanium-processing")
		
		bobmods.lib.recipe.add_new_ingredient("utilizer-6", {"nitinol-gear-wheel", 10})
		bobmods.lib.tech.add_prerequisite("utilizer-6", "nitinol-processing")
	end
	
	if bobmods.electronics then
		bobmods.lib.recipe.replace_ingredient("utilizer-5", "advanced-circuit", "processing-unit")
		bobmods.lib.tech.add_prerequisite("utilizer-5", "advanced-electronics-2")
		
		bobmods.lib.recipe.replace_ingredient("utilizer-6", "processing-unit", "advanced-processing-unit")
		bobmods.lib.tech.add_prerequisite("utilizer-6", "advanced-electronics-3")

		bobmods.lib.recipe.replace_ingredient("am-tesseract-dummy-3", "processing-unit", "advanced-processing-unit")
		bobmods.lib.tech.add_prerequisite("am-tesseract-dummy-3", "advanced-electronics-3")

		bobmods.lib.recipe.replace_ingredient("am-tesseract-fluid-dummy-3", "processing-unit", "advanced-processing-unit")
		bobmods.lib.tech.add_prerequisite("am-tesseract-fluid-dummy-3", "advanced-electronics-3")
	end

	if bobmods.logistics then
		bobmods.lib.recipe.replace_ingredient("am-tesseract-dummy-2", "steel-chest", "brass-chest")
		bobmods.lib.recipe.replace_ingredient("am-tesseract-dummy-3", "steel-chest", "titanium-chest")
		bobmods.lib.recipe.replace_ingredient("am-tesseract-fluid-dummy-2", "storage-tank", "storage-tank-2")
		bobmods.lib.recipe.replace_ingredient("am-tesseract-fluid-dummy-3", "storage-tank", "storage-tank-3")
	end
end