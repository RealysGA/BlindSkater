package com.isartdigital.ui.screens;

import com.isartdigital.ui.popin.Confirm;
import com.greensock.TweenLite;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.PointerEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Screen;
import haxe.extern.EitherType;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.InteractionEvent;

	
/**
 * Exemple de classe héritant de Screen
 * @author Mathieu ANTHOINE
 */
class TitleCard extends Screen 
{
	private var background:Sprite;
	
	/**
	 * instance unique de la classe TitleCard
	 */
	private static var instance: TitleCard;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TitleCard {
		if (instance == null) instance = new TitleCard();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new() 
	{
		super();
		background = new Sprite(Texture.fromImage(Config.url(Config.assetsPath+"TitleCard_bg.png")));
		background.anchor.set(0.5, 0.5);
		addChild(background);

	}
	
	override private function onOpen():Void 
	{
		super.onOpen();
		interactive = true;
		buttonMode = true;
		
		once(PointerEventType.POINTER_DOWN,onPointer);
	}
	
	private function onPointer (pEvent:InteractionEvent): Void {
		SoundManager.getSound("click").play();
		UIManager.openPopin(Confirm.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (?pOptions:EitherType<Bool, DestroyOptions>): Void {
		off(PointerEventType.POINTER_DOWN,onPointer);
		instance = null;
		super.destroy(pOptions);
	}

}