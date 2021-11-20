package;

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

#if sys
import sys.FileSystem;
#end

using StringTools;

class Titlereal extends MusicBeatState 
{
    public var drilllogo:BGSprite = new BGSprite('gear3', 0, 0, 1, 1, ['IDLE00'], true);
    
    override public function create():Void
    {

    var walltitle2:FlxBackdrop = new FlxBackdrop(Paths.image('titlescreen2'));
    add(walltitle2);
    var walltitle1:FlxSprite = new FlxSprite().loadGraphic(Paths.image('titlescreen1'));
    add(walltitle1);

    var whiteflash:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    add(whiteflash);

    drilllogo.screenCenter();
    add(drilllogo);    
    super.create();
    new FlxTimer().start(1, function(tmr:FlxTimer)
    {
    FlxTween.tween(whiteflash, {alpha: 0}, 3, {onComplete:
        function(twn:FlxTween) 
            {
            FlxG.sound.playMusic(Paths.music('drilltitle'), 1, false);
            FlxTween.tween(FlxG.camera.scroll, {x: 10240}, 7.297, {onComplete: function(twn:FlxTween) { titlelogoappear(); },ease: FlxEase.sineInOut});
                }});
        });

    }

    function titlelogoappear()
        {
            FlxG.camera.scroll.set(0, 0);
            
        }
    override function update(elapsed:Float)
    {
        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;
        if(pressedEnter)
            {
                MusicBeatState.switchState(new MainMenuState());
            }
    }
}