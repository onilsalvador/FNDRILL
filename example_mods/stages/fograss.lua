function onCreate()

	makeLuaSprite('bg1', 'fo/BG1', 0, 0);
	setLuaSpriteScrollFactor('bg1', 1, 1);

    makeLuaSprite('bg2', 'fo/BG2', 0, 0);
	setLuaSpriteScrollFactor('bg2', 0.7, 0.7);
 
    makeLuaSprite('bg3', 'fo/BG3', 0, 0);
	setLuaSpriteScrollFactor('bg3', 0.7, 0.7);

    makeLuaSprite('bg4', 'fo/BG4', 0, 0);
	setLuaSpriteScrollFactor('bg1', 1, 1);
 
	addLuaSprite('bg1', false);
    addLuaSprite('bg2', false);
    addLuaSprite('bg3', false);
    addLuaSprite('bg4', false);



	close(true); 
end