package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;

#if windows
import Discord.DiscordClient;
#end

class PasswordState extends MusicBeatState
{
	var pass1value:Int = 0;
	var pass2value:Int = 0;
    var pass3value:Int = 0;
    var pass4value:Int = 0;
	var selectpass:Int = 0;
	var pass4 = new FlxText(400, 500, 0, '0', 30, true);
	var pass3 = new FlxText(300, 500, 0, '0', 30, true);
	var pass2 = new FlxText(200, 500, 0, '0', 30, true);
	var pass1 = new FlxText(100, 500, 0, '0', 30, true);
	var chips = new FlxText(900, 100, 0, '0', 30, true);
	var batteries = new FlxText(100, 100, 0, '0', 30, true);

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

			add(batteries);
			
			add(chips);

			super.create();

			if (FlxG.sound.music.playing)
			{
			FlxG.sound.playMusic(Paths.music("presettings"), 1, false);
			FlxG.sound.music.onComplete = function () FlxG.sound.playMusic(Paths.music("loopsettings"), 1);
			}
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

	function correctpassword(first:Int, second:Int, third:Int, fourth:Int) 
		{
			if (first == 1 && second == 9 && third == 8 && fourth == 0)
				{
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
			
			if (first == 4 && second == 2 && third == 7 && fourth == 3)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					CoolUtil.difficultyStuff = [
						['EASY', '-hard'],
						['NORMAL', '-hard'],
						['HARD', '-hard']
					];
				}
			if (first == 1 && second == 2 && third == 3 && fourth == 4)
					{
						if (PlayState.chips < 200)
						FlxG.sound.play(Paths.sound('confirmMenu'));
						else 
						{
							PlayState.chips -= 200;
							PlayState.extraLifes += 1;
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

			if (FlxG.keys.justPressed.ENTER) correctpassword(pass1value, pass2value, pass3value, pass4value);

			if (FlxG.keys.justPressed.ESCAPE) LoadingState.loadAndSwitchState(new MainMenuState());



			pass1.text = Std.string(pass1value);
			pass2.text = Std.string(pass2value);
			pass3.text = Std.string(pass3value);
			pass4.text = Std.string(pass4value);
			chips.text = Std.string(PlayState.chips);
			batteries.text = Std.string(PlayState.extraLifes);

			if (selectpass < 1) selectpass = 1;
			if (selectpass > 4) selectpass = 4;

			super.update(elapsed);
		}

}