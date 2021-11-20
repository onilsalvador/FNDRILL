package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.TransitionData;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import BGSprite;

using StringTools;

class TitleState extends MusicBeatState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    static var initialized:Bool = false;

    public var warnScr:FlxSprite;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;

	var logoSpr:FlxSprite;
	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

    override public function create():Void
    {
         #if (polymod && !html5)
        if (sys.FileSystem.exists('mods/')) {
            var folders:Array<String> = [];
            for (file in sys.FileSystem.readDirectory('mods/')) {
                var path = haxe.io.Path.join(['mods/', file]);
                if (sys.FileSystem.isDirectory(path)) {
                    folders.push(file);
                }
            }
             if(folders.length > 0) {
                 polymod.Polymod.init({modRoot: "mods", dirs: folders});
            }
         }
    
        //Gonna finish this later, probably
        #end

        FlxG.game.focusLostFramerate = 60;
        FlxG.sound.muteKeys = muteKeys;
        FlxG.sound.volumeDownKeys = volumeDownKeys;
        FlxG.sound.volumeUpKeys = volumeUpKeys;

        PlayerSettings.init();


		// DEBUG BULLSHIT

		swagShader = new ColorSwap();
		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			#if desktop
			DiscordClient.initialize();
			Application.current.onExit.add (function (exitCode) {
				DiscordClient.shutdown();
			});
			#end

				startIntro();
		}
		#end
    }

    var swagShader:ColorSwap = null;

	function startIntro()
    {
        
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        add(bg); 
        
        warnScr = new FlxSprite().loadGraphic(Paths.image('warnScr'));
        warnScr.setGraphicSize(1280, 720);
        warnScr.updateHitbox();
        warnScr.alpha = 0;
        add(warnScr);
        FlxTween.tween(warnScr, {alpha: 1}, 1);

    }

    private static var closedState:Bool = false;

    override function update(elapsed:Float)
    {   
        
        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

        if (FlxG.keys.justPressed.F)
        {
            FlxG.fullscreen = !FlxG.fullscreen;
        }

        if (pressedEnter)
            
            FlxTween.tween(warnScr, {alpha: 0}, 1, {onComplete:
                function(twn:FlxTween) {

                    FlxG.switchState(new Titlereal());
                }
            });
    }

}
