/*******************************************
 * Author : hanxianming
 * Date   : 2016-3-23
 * Use    :
 *******************************************/

package
{
import com.pawgame.StringUtils;

import fairygui.editor.plugin.ICallback;
import fairygui.editor.plugin.IFairyGUIEditor;
import fairygui.editor.plugin.IPublishData;
import fairygui.editor.plugin.IPublishHandler;

import flash.filesystem.File;

public final class AutoGenerateCodePlugin implements IPublishHandler
{
    private var _editor:IFairyGUIEditor;

    public function AutoGenerateCodePlugin(editor:IFairyGUIEditor)
    {
        _editor = editor;
    }


    /**
     * 组件输出类定义列表。这是一个Map，key是组件id，value是一个结构体，例如：
     * {
     * 		classId : "8swdiu8f",
     * 		className ： "AComponent",
     * 		superClassName : "GButton",
     * 		members : [
     * 			{ name : "n1" : type : "GImage" },
     * 			{ name : "list" : type : "GList" },
     * 			{ name : "a1" : type : "GComponent", src : "Component1" },
     * 			{ name : "a2" : type : "GComponent", src : "Component2", pkg : "Package2" },
     * 		]
     * }
     * 注意member里的name并没有做排重处理。
     */
    public function doExport(data:IPublishData, callback:ICallback):Boolean
    {
        if (_editor.project.customProperties["gen_code"] != "true")
            return false;

        var classCodes:Array = [];

        var code_path:String = _editor.project.customProperties["code_path"];
        if (code_path == "" || code_path == null)
        {
            callback.addMsg("请指定导出路径 code_path");
            return false;
        }

        code_path = new File(data.filePath).resolvePath(code_path).nativePath;

        var codeFolder:File = new File(data.filePath);
        var bindPackage:String = PinYinUtils.toPinyin(data.targetUIPackage.name);
        codeFolder = codeFolder.resolvePath(code_path);
        try
        {
            codeFolder.deleteDirectory(true)
        }
        catch (error:Error)
        {
        }

        if (!codeFolder.exists)
            codeFolder.createDirectory();
        //包
        var packageName:String = bindPackage;
        classCodes.push("namespace " + packageName);
        classCodes.push("{");

        //各个类
        var hasOutput:Boolean;
        var logInfo:String = "";
        for each(var classInfo:Object in data.outputClasses)
        {
            var className:String = PinYinUtils.toPinyin(classInfo.className);
            if (className.indexOf('UI_') != 0) continue;
            hasOutput = true;

            classCodes.push("\texport class " + className + " extends g.GAsyncPanel");
            classCodes.push("\t{");

            var memberInfo:Object;
            var memberName:String;
            //遍历写入变量名
            for each(memberInfo in classInfo.members)
            {
                memberName = memberInfo.name;
                logInfo += StringUtils.stringfy(memberInfo);
                if (checkIsUseDefaultName(memberName)) continue;
                var memberType:String = memberInfo.type;
                if (memberType == 'Controller')
                {
                }
                else if (memberType == 'Transition')
                {
                }
                else if (memberType == 'GComponent')
                {
                    if (memberName.indexOf('btn_') == 0 || memberName.indexOf('tab_') == 0 ||
                            memberName.indexOf('ck_') == 0 || memberName.indexOf('rb_') == 0)
                    {
                        memberType = 'GButton';
                    }
                    else if (memberName.indexOf('bar_') == 0)
                    {
                        memberType = 'GProgressBar';
                    }
                    else if (memberName.indexOf('slider_') == 0)
                    {
                        memberType = 'GSlider';
                    }
                    else if (memberName.indexOf('comb_') == 0)
                    {
                        memberType = 'GComboBox';
                    }
                }

                classCodes.push("\t\t" + memberName + ":fairygui." + memberType + ";");
            }

            //写入构造函数
            classCodes.push("\t\tconstructor()");
            classCodes.push("\t\t{");
            classCodes.push("\t\t\tsuper('" + bindPackage + "', '" + className + "');");
            classCodes.push("\t\t}");

            //遍历写入变量获取
            classCodes.push("\t\tprotected doReady()");
            classCodes.push("\t\t{");

            for each(memberInfo in classInfo.members)
            {
                memberName = memberInfo.name;
                if (checkIsUseDefaultName(memberName)) continue;
                if (memberInfo.type == "Controller")
                {
                    classCodes.push("\t\t\tthis." + PinYinUtils.toPinyin(memberName) + " = this._skin.getController('" + memberName + "');");
                }
                else if (memberInfo.type == "Transition")
                {
                    classCodes.push("\t\t\tthis." + PinYinUtils.toPinyin(memberName) + " = this._skin.getTransition('" + memberName + "');");
                }
                else
                {
                    classCodes.push("\t\t\tthis." + PinYinUtils.toPinyin(memberName) + " = this._skin.getChild('" + memberName + "') as any;");
                }
            }
            classCodes.push("\t\t}");

            classCodes.push("\t}");
        }

        classCodes.push("}");
        if (hasOutput)
        {
            FileTool.writeFile(codeFolder.nativePath + File.separator + bindPackage + ".ts", classCodes.join("\r\n"));
        }

//        _editor.alert(logInfo);

        callback.callOnSuccess();
        return true;
    }

    private function checkIsUseDefaultName(name:String):Boolean
    {
        if (name.charAt(0) == "n" || name.charAt(0) == "c" || name.charAt(0) == "t")
        {
            return _isNaN(name.slice(1));
        }
        return false;
    }

    private function _isNaN(str:String):Boolean
    {
        return !isNaN(parseInt(str));

    }
}


}