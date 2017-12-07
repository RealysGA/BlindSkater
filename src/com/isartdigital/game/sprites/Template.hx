package com.isartdigital.game.sprites;

import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.ColliderType;
import com.isartdigital.utils.game.stateObjects.StateAnimatedSprite;
import com.isartdigital.utils.game.StateObject;
import haxe.extern.EitherType;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.interaction.InteractionEvent;
	
/**
 * Exemple de classe héritant de StateObject
 * @author Mathieu ANTHOINE
 */
class Template extends StateAnimatedSprite 
{
	
	/**
	 * instance unique de la classe Template
	 */
	private static var instance: Template;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Template {
		if (instance == null) instance = new Template();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
		// ATTENTION: assetName et colliderType se définissent après le super
		colliderType = ColliderType.SIMPLE;
		
		Main.getInstance().renderer.plugins.interaction.on(MouseEventType.MOUSE_DOWN, onPointer);
		Main.getInstance().renderer.plugins.interaction.on(TouchEventType.TOUCH_END, onPointer);
		
	}
	
	override private function setModeNormal():Void {
		setState(STATE_DEFAULT, true);
		super.setModeNormal();
	}
	
	private function onPointer (pEvent:InteractionEvent): Void {
		trace(pEvent.type+":"+pEvent.data.identifier+ " | " + pEvent.data.global.x + ', ' + pEvent.data.global.y);
		position.set(pEvent.data.getLocalPosition(parent).x, pEvent.data.getLocalPosition(parent).y);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (?pOptions:EitherType<Bool, DestroyOptions>): Void {
		Main.getInstance().renderer.plugins.interaction.on(MouseEventType.MOUSE_DOWN, onPointer);
		Main.getInstance().renderer.plugins.interaction.on(TouchEventType.TOUCH_END, onPointer);
		instance = null;
		super.destroy(pOptions);
	}

}