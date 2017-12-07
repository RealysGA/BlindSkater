package com.isartdigital;

import com.isartdigital.ui.GraphicLoader;
import com.isartdigital.ui.UIManager;
import com.isartdigital.ui.screens.TitleCard;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.LoadEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.GameStageScale;
import com.isartdigital.utils.game.StateManager;
import com.isartdigital.utils.game.StateObject;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import pixi.core.Application;
import pixi.core.renderers.SystemRenderer;
import pixi.interaction.EventEmitter;
import pixi.interaction.InteractionEvent;
import pixi.loaders.Loader;

/**
 * Classe d'initialisation et lancement du jeu
 * @author Mathieu ANTHOINE
 */

class Main extends EventEmitter
{
	
	/**
	 * chemin vers le fichier de configuration
	 */
	private static var configPath:String = "config.json";	
	
	/**
	 * instance unique de la classe Main
	 */
	private static var instance: Main;
	
	/**
	 * Application
	 */
	private var app: Application;
	
	/**
	 * Renderer
	 */
	public var renderer(default,null):SystemRenderer;
	
	/**
	 * initialisation générale
	 */
	private static function main ():Void {
		Main.getInstance();
	}

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Main {
		if (instance == null) instance = new Main();
		return instance;
	}
	
	/**
	 * création du jeu et lancement du chargement du fichier de configuration
	 */
	private function new () {
		
		super();
		
		var lOptions:ApplicationOptions = {};
		lOptions.width = DeviceCapabilities.width;
		lOptions.height = DeviceCapabilities.height;
		lOptions.backgroundColor = 0x999999;
		// lOptions.roundPixels = true;
		
		app = new Application(lOptions);
		renderer=app.renderer;
		Browser.document.body.appendChild(app.view);
		
		var lConfig:Loader = new Loader();
		configPath += "?" + Date.now().getTime();
		lConfig.add(configPath);
		lConfig.once(LoadEventType.COMPLETE, preloadAssets);
		
		lConfig.load();

	}
	
	/**
	 * charge les assets graphiques du preloader principal
	 */
	private function preloadAssets(pLoader:Loader):Void {
		
		// initialise les paramètres de configuration
		Config.init(Reflect.field(pLoader.resources,configPath).data);
		
		// Active le mode debug
		if (Config.debug) Debug.getInstance().init();
		// défini l'alpha des colliders
		if (Config.debug && Config.data.colliderAlpha != null) StateManager.colliderAlpha = Config.data.colliderAlpha;
		// défini l'alpha des rendus
		if (Config.debug && Config.data.rendererAlpha != null) StateManager.rendererAlpha = Config.data.rendererAlpha;
		
		// défini le mode de redimensionnement du Jeu
		GameStage.getInstance().scaleMode = GameStageScale.SHOW_ALL;
		
		// initialise le GameStage et défini la taille de la safeZone
		GameStage.getInstance().init(app.render,2048, 1366,true);
		
		// Ajoute le GameStage au stage
		app.stage.addChild(GameStage.getInstance());
		
		// ajoute Main en tant qu'écouteur des évenements de redimensionnement
		Browser.window.addEventListener(EventType.RESIZE, resize);
		resize();
		
		// lance le chargement des assets graphiques du preloader
		var lLoader:GameLoader = new GameLoader();
		lLoader.addAssetFile("black_bg.png");
		lLoader.addAssetFile("preload.png");
		lLoader.addAssetFile("preload_bg.png");
		
		lLoader.once(LoadEventType.COMPLETE, loadAssets);
		lLoader.load();
		
	}	
	
	/**
	 * lance le chargement principal
	 */
	private function loadAssets (pLoader:GameLoader): Void {
		
		var lLoader:GameLoader = new GameLoader();
		
		lLoader.addAssetFile("colliders.json");
		lLoader.addSoundFile("sounds.json");

		lLoader.addAssetFile("alpha_bg.png");
		lLoader.addAssetFile("TitleCard_bg.png");
		lLoader.addAssetFile("Confirm.png");
		lLoader.addAssetFile("Template.json");
		lLoader.addFontFile("fonts.css");
		lLoader.addAssetFile("TemplateSettings.json");

		lLoader.on(LoadEventType.PROGRESS, onLoadProgress);
		lLoader.once(LoadEventType.COMPLETE, onLoadComplete);

		// affiche l'écran de préchargement
		UIManager.openScreen(GraphicLoader.getInstance());
		
		lLoader.load();
		
	}
	
	/**
	 * transmet les paramètres de chargement au préchargeur graphique
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadProgress (pLoader:GameLoader): Void {
		GraphicLoader.getInstance().update(pLoader.progress/100);
	}
	
	/**
	 * initialisation du jeu
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadComplete (pLoader:GameLoader): Void {
		
		pLoader.off(LoadEventType.PROGRESS, onLoadProgress);
		
		// affiche le bouton FullScreen quand c'est nécessaire
		// NOTE: en attendant le fix du bug de scaleViewPort en Fullscreen
		if (DeviceCapabilities.system!=DeviceCapabilities.SYSTEM_ANDROID) DeviceCapabilities.displayFullScreenButton();
		
		// Ouvre la TitleCard
		UIManager.openScreen(TitleCard.getInstance());
		
		app.ticker.add(gameLoop);
	}
	
	/**
	 * game loop
	 * @param	pDeltaTime Valeur du temps scalaire de la dernière image à cette image
	 */
	private function gameLoop(pDeltaTime:Float):Void {		
		emit(EventType.GAME_LOOP);
	}
	
	/**
	 * Ecouteur du redimensionnement
	 * @param	pEvent evenement de redimensionnement
	 */
	public function resize (pEvent:InteractionEvent = null): Void {
		renderer.resize(DeviceCapabilities.width, DeviceCapabilities.height);
		GameStage.getInstance().resize();
	}
		
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		app.ticker.remove(gameLoop);
		app.destroy();
		Browser.window.removeEventListener(EventType.RESIZE, resize);
		instance = null;
	}
	
}