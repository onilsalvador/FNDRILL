package;

import flixel.util.FlxTimer;
import lime.utils.AssetCache;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public var selectarrow:FlxSprite;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var charButtons:Array<String> = ['storymenu', 'password', 'store', 'options'];

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('drillBG'));
		bg.setGraphicSize(1280, 720);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

        menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

        for (i in 0...charButtons.length)
            {
                var menuItem:FlxSprite = new FlxSprite(0, 0);
                
                menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + charButtons[i]);
                menuItem.animation.addByPrefix('idle', charButtons[i] + " basic", 24);
                menuItem.animation.addByPrefix('selected', charButtons[i] + " white", 24);
                menuItem.animation.play('idle');
    
                menuItem.ID = i;
                menuItems.add(menuItem);
                menuItem.antialiasing = ClientPrefs.globalAntialiasing;
                menuItem.setGraphicSize(1280, 720);
                menuItem.updateHitbox();
    
            }

        selectarrow = new FlxSprite(640, -500).loadGraphic(Paths.image('selectarrow'));
		selectarrow.setGraphicSize(Std.int(selectarrow.width * 0.5));
		selectarrow.antialiasing = ClientPrefs.globalAntialiasing;
        
        add(selectarrow);

		FlxG.sound.playMusic(Paths.music("mainmenu"), 1, false);
		FlxG.sound.music.onComplete = function () FlxG.sound.playMusic(Paths.music("loopmainmenu"), 1);

        changeItem();

		super.create();
    }

    var selectedSomethin:Bool = false;

	override  function update(elapsed:Float)
	{
        if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

            if (controls.ACCEPT)
                {
                    selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
                    menuItems.forEach(function(spr:FlxSprite)
                        {
                            if (curSelected == spr.ID)
                                {
                                    var choice:String = charButtons[curSelected];
                                    new FlxTimer().start(0.8, function(tmr:FlxTimer)
                                    {
                                    switch (choice)
                                    {
                                        case 'storymenu':
                                            MusicBeatState.switchState(new StoryMenuState());
                                        case 'password':
                                            MusicBeatState.switchState(new PasswordState());
                                        case 'store':
                                            MusicBeatState.switchState(new CreditsState());
                                        case 'options':
                                            MusicBeatState.switchState(new OptionsState());
                                    }
                                    });
                                }
                            switch (spr.ID)
                            {
                                case 0 | 1:
                                    {
                                        FlxTween.tween(spr, {x: -spr.width}, 1, {
                                            onComplete: function(twn:FlxTween)
                                            {
                                                spr.kill();
                                            }
                                        });
                                    }
                                case 2 | 3:
                                    {
                                        FlxTween.tween(spr, {x: spr.width}, 1, {
                                            onComplete: function(twn:FlxTween)
                                            {
                                                spr.kill();
                                            }
                                        });
                                    }
                            }
                            
                        });
                }
        }
    }

    function changeItem(change:Int = 0)
        {
            curSelected += change;
    
            if (curSelected >= menuItems.length)
                curSelected = menuItems.length - 1;
                
            if (curSelected < 0)
                curSelected = 0;
    
            menuItems.forEach(function(spr:FlxSprite)
            {
                spr.animation.play('idle');
                spr.updateHitbox();
    
                if (spr.ID == curSelected)
                {
                    spr.animation.play('selected');
                }
            });
        }

}