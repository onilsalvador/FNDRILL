package;

import llua.Convert;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

#if windows
import Discord.DiscordClient;
#end

class PasswordState extends MusicBeatState
{
    var thing:Bool = true;
	var tw:FlxSprite;
	var correct:Bool = false;
	var pass1value:Int = 0;
	var pass2value:Int = 0;
    var pass3value:Int = 0;
    var pass4value:Int = 0;
	var selectpass:Int = 0;
	var incameo:Bool = false;
	var pass4 = new FlxText(400, 500, 0, '0', 30, true);
	var pass3 = new FlxText(300, 500, 0, '0', 30, true);
	var pass2 = new FlxText(200, 500, 0, '0', 30, true);
	var pass1 = new FlxText(100, 500, 0, '0', 30, true);

	override function create()
        {

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('drillBG'));
			bg.scrollFactor.x = 0;
			bg.scrollFactor.y = 0;
			bg.setGraphicSize(Std.int(bg.width * 0.5));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = true;

			add(bg);

			add(pass1);

			add(pass2);

			add(pass3);

			add(pass4);

			super.create();

			if (FlxG.sound.music.playing)
				FlxG.sound.destroy;
				FlxG.sound.playMusic(Paths.music("breakfast"), 1, true);
		}
	function changeNumber(selection:Int) 
	{
		switch(selectpass)
		{
		case 1:
		{
			pass1value += selection;
			if (pass1value < 0) pass1value = 9;
			if (pass1value > 9) pass1value = 0;
		}
		case 2:
		{
			pass2value += selection;
			if (pass2value < 0) pass2value = 9;
			if (pass2value > 9) pass2value = 0;
		}
		case 3:
		{
			pass3value += selection;
			if (pass3value < 0) pass3value = 9;
			if (pass3value > 9) pass3value = 0;
		}
		case 4:
		{
			pass4value += selection;
			if (pass4value < 0) pass4value = 9;
			if (pass4value > 9) pass4value = 0;
		}
		}
	}

	function doTheThing(first:Int, second:Int, third:Int, fourth:Int) 
		{
			if (first == 1 && second == 9 && third == 8 && fourth == 0)
				{
					correct = true;
					PlayState.SONG = Song.loadFromJson('drilldozer-sky', 'drilldozer');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 3;
					PlayState.storyWeek = 7;
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.play(Paths.sound('confirmMenu'));
				}
			if (first == 3 && second == 3 && third == 3 && fourth == 3)
				{
					FlxG.sound.music.destroy();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					var fileName = Paths.video("mother");
					var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					bg.scrollFactor.set();
					add(bg);
		
					(new FlxVideo(fileName)).finishCallback = function() {
						remove(bg);
					}
				}
			else 
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			
		}
	override public function update(elapsed:Float)
		{
			if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) selectpass += 1;

			if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) selectpass -= 1;

			if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S) changeNumber(1);

			if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) changeNumber(-1);

			if (FlxG.keys.justPressed.ENTER && !correct) doTheThing(pass1value, pass2value, pass3value, pass4value);

			if (FlxG.keys.justPressed.ENTER && incameo) LoadingState.loadAndSwitchState(new PasswordState());

			if (FlxG.keys.justPressed.ESCAPE && !incameo) LoadingState.loadAndSwitchState(new MainMenuState());



			pass1.text = Std.string(pass1value);
			pass2.text = Std.string(pass2value);
			pass3.text = Std.string(pass3value);
			pass4.text = Std.string(pass4value);

			if (selectpass < 1) selectpass = 1;
			if (selectpass > 4) selectpass = 4;

			super.update(elapsed);
		}

}