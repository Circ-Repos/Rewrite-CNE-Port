
// libraries
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import openfl.system.Capabilities;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.CodenameBuildField;
import funkin.backend.system.Main;
// variables
static var redirectStates:Map<FlxState, String> = [
	TitleState => 'custom/title',
	MainMenuState => 'custom/mainMenu',
	FreeplayState => 'custom/freeplay',
	StoryMenuState => 'custom/storyMenu'
];
static var windowTitle:String = "VS Sonic";
// functions
function postStateSwitch(){ //post is more consistent than pre
	//set commit id to mod name
	Framerate.codenameBuildField.text = 'Codename Engine '+ Main.releaseCycle +' \nRewrite CNE Round 2 CNE Port';
	// resetTitle
	WindowUtils.resetTitle();
	// title
	window.title = windowTitle;
	//icon window
	window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('iconGame'))));

}
/*
function preStateSwitch(){
	// redirectStates
	for(i in redirectStates.keys()){
		if(Std.isOfType(FlxG.game._requestedState, i)){
			FlxG.game._requestedState = new ModState(redirectStates.get(i));
		}
	}     
}
*/