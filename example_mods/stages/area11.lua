function onCreate()
	-- background 
	makeLuaSprite('bg', 'drill/area11', -500, -300);
	setLuaSpriteScrollFactor('bg', 1, 1);

	makeAnimatedLuaSprite('camera', 'drill/area11camera', -500, -300);
	luaSpriteAddAnimationByPrefix('camera', 'first', 'area11camera idle', 2, true);
	luaSpritePlayAnimation('camera', 'first');

	addLuaSprite('bg', false);
	addLuaSprite('camera', true);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end