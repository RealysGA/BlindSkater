package com.isartdigital.game;

import com.isartdigital.game.sprites.Template;
import com.isartdigital.ui.UIManager;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.system.Monitor;
import com.isartdigital.utils.system.MonitorField;
import pixi.core.math.Point;

/**
 * Manager en charge de gérer le déroulement d'une partie
 * @author Mathieu ANTHOINE
 */
class GameManager
{
	
	static public function start (): Void {
		
		// demande au Manager d'interface de se mettre en mode "jeu"
		UIManager.startGame();	
		
		// début de l'initialisation du jeu
		GameStage.getInstance().getGameContainer().addChild(Template.getInstance());
		Template.getInstance().start();	
		
		// Monitoring
		var lTemplateSettings : Array<MonitorField> = [
			{ name:"position",step:20},
			{ name:"scale", min: new Point(0, 0), max: new Point(2, 3)},
			{ name:"resume"},
			{ name:"pause"}
		];
		
		Monitor.setSettings(GameLoader.getContent("TemplateSettings.json"), Template.getInstance());
		//Monitor.start(Template.getInstance(), lTemplateSettings);
		Monitor.start(Template.getInstance(), lTemplateSettings, GameLoader.getContent("TemplateSettings.json"));
		
		// enregistre le GameManager en tant qu'écouteur de la gameloop principale
		Main.getInstance().on(EventType.GAME_LOOP, gameLoop);
		
		testSound()
		
	}
	
	private function testSound():Void{
		
	}
	
	/**
	 * boucle de jeu (répétée à la cadence du jeu en fps)
	 */
	public static function gameLoop (): Void {
		if (DeviceCapabilities.system == DeviceCapabilities.SYSTEM_DESKTOP) {
			if (CollisionManager.hitTestPoint(Template.getInstance().hitBox, Main.getInstance().renderer.plugins.interaction.mouse.global)) trace ("HIT !");
		}
	}
	
	/**
	 * stop l'écoute de la gameLoop
	 */
	public static function end (): Void {
		Main.getInstance().off(EventType.GAME_LOOP,gameLoop);
	}

}