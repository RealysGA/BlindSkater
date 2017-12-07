package com.isartdigital.ui.popin;

import com.isartdigital.game.GameManager;
import com.greensock.TweenLite;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.PointerEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Popin;
import haxe.extern.EitherType;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.InteractionEvent;
	
/**
 * Exemple de classe héritant de Popin
 * @author Mathieu ANTHOINE
 */
class Confirm extends Popin 
{
	
	private var background:Sprite;
	
	/**
	 * instance unique de la classe Confirm
	 */
	private static var instance: Confirm;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Confirm {
		if (instance == null) instance = new Confirm();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		background = new Sprite(Texture.fromImage(Config.url(Config.assetsPath+"Confirm.png")));
		background.anchor.set(0.5, 0.5);
		addChild(background);
		openTween = TweenLite.from(this, 0.5, { y : 200, alpha: 0, onComplete:onOpen,paused:true} );
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
		UIManager.closeCurrentPopin();
	}
	
	override private function onClose():Void 
	{
		super.onClose();
		GameManager.start();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (?pOptions:EitherType<Bool, DestroyOptions>): Void {
		removeChild(background);
		off(PointerEventType.POINTER_DOWN,onPointer);
		instance = null;
		super.destroy(pOptions);
	}

}