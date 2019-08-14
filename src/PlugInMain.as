package {
import fairygui.editor.plugin.IFairyGUIEditor;

import flash.events.Event;

/**
 * 插件入口类，名字必须为PlugInMain。每个项目打开都会创建一个新的PlugInMain实例，并传入当前的编辑器句柄；
 * 项目关闭时dispose被调用，可以在这里处理一些清理的工作（如果有）。
 */
public class PlugInMain {
    private var _editor:IFairyGUIEditor;

    //插件载入时执行
    public function PlugInMain(editor:IFairyGUIEditor) {
        _editor = editor;
        if (_editor.project.type == "Egret") {
            _editor.registerPublishHandler(new ExportNoZipPlugIn(_editor));
//				_editor.registerPublishHandler(new GenerateCodePlugIn(_editor));
            _editor.registerPublishHandler(new AutoGenerateCodePlugin(_editor));
            _editor.registerPublishHandler(new BatExecutePlugin(_editor));
        } else if (_editor.project.type == 'Layabox') {
            _editor.registerPublishHandler(new AutoGenInterfaceCodePlugin(_editor));
        }
//			_editor.registerComponentExtension("窗口", "MyWindowClass", null);
//			_editor.menuBar.getMenu("tool").addItem("测试", onClickSet);
    }

    private function onClickSet(evt:Event):void {
        _editor.alert(_editor.project.type);
    }

    public function dispose():void {
    }
}
}