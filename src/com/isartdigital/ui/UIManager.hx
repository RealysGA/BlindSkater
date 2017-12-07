package com.isartdigital.ui;

import com.isartdigital.ui.hud.Hud;
import com.isartdigital.utils.events.UIEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.Popin;
import com.isartdigital.utils.ui.Screen;

/**
 * Manager en charge de gérer les écrans d'interface
 * @author Mathieu ANTHOINE
 */
class UIManager 
{
	
	/**
	 * tableau des popins ouverts
	 */
	private static var popins:Array<Popin> = [];
	private static var screens:Array<Screen> = [];
	
	/**
	 * Ajoute un écran dans le conteneur de Screens
	 * @param	pScreen Screen à ouvrir
	 * @param	pCloseMode UIEventType.OPEN (sur ouverture), UIEventType.OPENED (après sur ouverture), null (avant ouverture)
	 */
	public static function openScreen (pScreen: Screen, ?pCloseMode:String=null, pBehind:Bool = false): Void {
		//if (screens.length >= 2) throw "UIManager: Vous devez d'abord fermer un Screen avant d'en ouvrir un nouveau";
		screens.push(pScreen);
		pBehind ? GameStage.getInstance().getScreensContainer().addChildAt(pScreen,0) : GameStage.getInstance().getScreensContainer().addChild(pScreen);	
		if (screens.length > 1) {
			if (pCloseMode == UIEventType.OPEN) pScreen.on(UIEventType.OPEN, closeScreen);
			else if (pCloseMode == UIEventType.OPENED) pScreen.on(UIEventType.OPENED, closeScreen);
			else {
				screens[screens.length - 2].once(UIEventType.CLOSED, pScreen.open);
				closeScreen();
				return;	
			}
		}
		pScreen.open();	
	}
	
	/**
	 * Supprime l'écran précédent
	 */
	public static function closeScreen (): Void {
		if (screens.length == 0) return;
		var lCurrent:Screen = screens.length == 1 ? screens.pop() : screens.splice(screens.length - 2,1)[0];		
		lCurrent.interactive = false;
		lCurrent.once(UIEventType.CLOSED,removeScreen);
		lCurrent.close();

	}
	
	private static function removeScreen (pEvent:Dynamic):Void {
		GameStage.getInstance().getScreensContainer().removeChild(pEvent.target);
	}
	
	/**
	 * Ajoute un popin dans le conteneur de Popin
	 * @param	pPopin Popin à ouvrir
	 */
	public static function openPopin (pPopin: Popin): Void {
		popins.push(pPopin);
		GameStage.getInstance().getPopinsContainer().addChild(pPopin);
		pPopin.open();
	}
	
	/**
	 * Supprime le popin dans le conteneur de Screens
	 */
	public static function closeCurrentPopin (): Void {
		if (popins.length == 0) return;
		var lCurrent:Popin = popins.pop();
		lCurrent.interactive = false;
		lCurrent.once(UIEventType.CLOSED,removePopin);
		lCurrent.close();

	}
	
	private static function removePopin (pEvent:Dynamic):Void {
		GameStage.getInstance().getPopinsContainer().removeChild(pEvent.target);
	}
	
	/**
	 * Ajoute le hud dans le conteneur de Hud
	 */
	public static function openHud (): Void {
		GameStage.getInstance().getHudContainer().addChild(Hud.getInstance());
		Hud.getInstance().open();
	}
	
	/**
	 * Retire le hud du conteneur de Hud
	 */
	public static function closeHud (): Void {
		GameStage.getInstance().getHudContainer().removeChild(Hud.getInstance());
		Hud.getInstance().close();
	}
	
	/**
	 * met l'interface en mode jeu
	 */
	public static function startGame (): Void {
		closeScreen();
		openHud();
	}

}