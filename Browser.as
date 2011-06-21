package {

import flash.display.*;
import flash.utils.*;
import flash.geom.*;
import flash.events.*;
import qnx.ui.core.*;
import qnx.ui.text.*;
import qnx.ui.buttons.*;
import qnx.media.QNXStageWebView;
import qnx.events.NetworkResourceRequestedEvent;
import qnx.events.ExtendedLocationChangeEvent;

/**
 * The main class for NewBrowser.
 * Like NewSpeak, except for the Internet!
 * Definitely DoublePlusGood than the official browser!
 * :)
 */

[SWF(width="1024", height="600", frameRate="30", backgroundColor="#ffffff")]
public class Browser extends Sprite{

	public static const COMICSANS_STYLESHEET_URL:String = 'data:text/css;charset=utf-8,*{font-family%3A"Comic Sans MS"%2C sans-serif%3B}';
	public static const COMICSANS_STYLESHEET:String = '* {font-family:"Comic Sans MS", sans-serif;}';
	public static const INJECT_SCRIPT:String = 'var __comicsanscss = document.createElement("style"); ' + 
			'__comicsanscss.innerHTML = \'* {font-family:"Comic Sans MS", sans-serif;}\';' + 
			'document.getElementsByTagName("head")[0].appendChild(__comicsanscss);';
	public var mainContainer:Container;
	public var toolbar:Container;
	public var controls:Dictionary = new Dictionary();
	public var webview:QNXStageWebView;
	public function Browser(){
		buildUI();
	}
	protected function buildUI():void{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		mainContainer = new Container();
            	mainContainer.margins = Vector.<Number>([0,0,0,0]);
            	mainContainer.flow = ContainerFlow.VERTICAL;
		mainContainer.setSize(stage.stageWidth, stage.stageHeight);
		addChild(mainContainer);

		toolbar = new Container();
		toolbar.margins = Vector.<Number>([10,10,10,10]);
		toolbar.flow = ContainerFlow.HORIZONTAL;
		toolbar.setSize(mainContainer.width, 60);
		toolbar.align = ContainerAlign.NEAR;
		mainContainer.addChild(toolbar);
		addButtons();
		webview = new QNXStageWebView();
		webview.viewPort = new Rectangle(0, toolbar.height, stage.stageWidth, stage.stageHeight - toolbar.height);
		webview.stage = stage;
		webview.loadURL("about:blank");
		webview.addEventListener("locationChange", locationChangeHandler);
		webview.addEventListener("documentLoaded", documentLoadedHandler);
		webview.userStyleSheet = COMICSANS_STYLESHEET_URL;
		toolbar.layout();
		stage.addEventListener("orientationChange", function(e:Event):void{
			resizeControls();
		});
		stage.addEventListener("resize", function(e:Event):void{
			resizeControls();
		});

	}
	protected function addButtons():void{
		controls["back"] = new BackButton();
		controls.back.label = "Back";
		toolbar.addChild(controls.back);
		controls.back.addEventListener("click", backButtonHandler);
		controls["forward"] = new LabelButton();
		controls.forward.label = ">";
		controls.forward.width = 40;
		toolbar.addChild(controls.forward);
		controls.forward.addEventListener("click", forwardButtonHandler);
		controls["urlField"] = new TextInput();
		toolbar.addChild(controls.urlField);
		controls.urlField.addEventListener("keyDown", urlFieldKeyDownHandler);
		controls.urlField.keyboardType = KeyboardType.URL;
		
	}
	protected function resizeControls():void{
		mainContainer.setSize(stage.stageWidth, stage.stageHeight);
		toolbar.setSize(mainContainer.width, 60);
		webview.viewPort = new Rectangle(0, toolbar.height, stage.stageWidth, stage.stageHeight - toolbar.height);
		toolbar.layout();
	}
	private function backButtonHandler(e:Event):void{
		webview.historyBack();
	}
	private function forwardButtonHandler(e:Event):void{
		webview.historyForward();
	}
	private function urlFieldKeyDownHandler(e:KeyboardEvent):void{
		if(e.keyCode == 13){ //Enter key
			var url:String = controls.urlField.text;
			if(!isSupportedURL(url)){
				url = "http://" + url;
			}
			try{
				navigateToURL(url);
			}
			catch(e:Error){
			}
		}
	}
	public function isSupportedURL(url:String):Boolean{
		url = url.toLowerCase();
		return url.substr(0, 5) == "http:" || url.substr(0,6) == "https:" || url.substr(0,6) == "about:" ||
			url.substr(0, 5) == "file:" || url.substr(0, 5) == "data:" || url.substr(0, 11) == "javascript:";
	}
	public function navigateToURL(newURL:String):void{
		webview.loadURL(newURL);
	}
	private function locationChangeHandler(e:ExtendedLocationChangeEvent):void{
		controls.urlField.text = e.location;
	}
	private function documentLoadedHandler(e:Event):void{
		injectStylesheet();
	}
	private function injectStylesheet():void{
		webview.executeJavaScript(INJECT_SCRIPT);
	}

}
}
