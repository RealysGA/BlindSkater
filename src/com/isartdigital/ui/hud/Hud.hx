package com.isartdigital.ui.hud;

import com.isartdigital.utils.Config;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPosition;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import haxe.extern.EitherType;

/**
 * Classe en charge de gérer les informations du Hud
 * @author Mathieu ANTHOINE
 */
class Hud extends Screen 
{
	
	/**
	 * instance unique de la classe Hud
	 */
	private static var instance: Hud;
	
	private var hudTopLeft:Sprite;
	private var hudBottomLeft:Container;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}	
	
	public function new() 
	{
		super();
		modal = false;
		hudTopLeft = new Sprite(Texture.fromImage(Config.url(Config.assetsPath + "HudLeft.png")));
		
		hudBottomLeft = new Container();
			
		// affichage de textes utilisant des polices de caractères chargées
		var lTxt:Text = new Text((DeviceCapabilities.system==DeviceCapabilities.SYSTEM_DESKTOP ? "Click" : "Tap" )+ " to move", { fontFamily: "MyFont",fontSize:80 , fill: 0xFFFFFF, align: "left" } );
		lTxt.position.set(20, -220);
		hudBottomLeft.addChild(lTxt);
		
		var lTxt2:Text = new Text("or use cheat panel", { fontFamily: "MyOtherFont", fontSize:100, fill: 0x000000, align: "left" } );
		lTxt2.position.set(20, -120);
		hudBottomLeft.addChild(lTxt2);				
		
		addChild(hudTopLeft);
		addChild(hudBottomLeft);

		positionables.push({ item:hudTopLeft, align:UIPosition.TOP_LEFT, offsetX:0, offsetY:0});
		positionables.push({ item:hudBottomLeft, align:UIPosition.BOTTOM_LEFT, offsetX:0, offsetY:0});

	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (?pOptions:EitherType<Bool, DestroyOptions>): Void {
		instance = null;
		super.destroy(pOptions);
	}

}