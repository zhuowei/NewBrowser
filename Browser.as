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
	public var mainContainer:Container;
	public var toolbar:Container;
	public var controls:Dictionary = new Dictionary();
	public var webview:QNXStageWebView;
	public function Browser(){
		buildUI();
	}
	protected function buildUI():void{
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
		webview.loadURL("file:///");
		webview.addEventListener("locationChanging", locationChangingHandler);
		//webview.addEventListener("networkResourceRequested", networkResourceRequestedHandler);
		toolbar.layout();

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
		webview.viewPort = new Rectangle(0, 50, stage.stageWidth, stage.stageHeight - 50);
	}
	private function backButtonHandler(e:Event):void{
		webview.historyBack();
	}
	private function forwardButtonHandler(e:Event):void{
		webview.historyForward();
	}
	private function urlFieldKeyDownHandler(e:KeyboardEvent):void{
		if(e.keyCode == 13){ //Enter key
			try{
				navigateToURL(controls.urlField.text);
			}
			catch(e:Error){
			}
		}
	}
	public function navigateToURL(newURL:String):void{
		webview.loadURL(newURL);
	}
	private function locationChangingHandler(e:ExtendedLocationChangeEvent):void{
		controls.urlField.text = e.location;
	}
	/*private function networkResourceRequestedHandler(e:NetworkResourceRequestedEvent):void{
		if(e.url.indexOf("googleadservices.com")!=-1 || e.url.indexOf("ad.doubleclick.net")!=-1){ //ads! Destroy!
			e.action = NetworkResourceRequestedEvent.ACTION_DENY; //Take that!
		}
	}*/
}
}
