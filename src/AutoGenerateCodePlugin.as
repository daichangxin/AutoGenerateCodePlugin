package
{
import com.pawgame.modules.uicode.CodeDeleExport;
import com.pawgame.modules.uicode.CodeUIExport;
import com.pawgame.modules.uicode.MemberVo;

import fairygui.editor.plugin.ICallback;
import fairygui.editor.plugin.IFairyGUIEditor;
import fairygui.editor.plugin.IPublishData;
import fairygui.editor.plugin.IPublishHandler;

import flash.filesystem.File;

public final class AutoGenerateCodePlugin implements IPublishHandler
{
    private var _editor:IFairyGUIEditor;

    private var _uiExport:CodeUIExport;
    private var _deleExport:CodeDeleExport;

    public function AutoGenerateCodePlugin(editor:IFairyGUIEditor)
    {
        _editor = editor;
        _uiExport = new CodeUIExport();
        _deleExport = new CodeDeleExport();
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

        var packageCodes:Array = [];

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
        if (!codeFolder.exists)
            codeFolder.createDirectory();
        //包
        var packageName:String = 'c';
        packageCodes.push("namespace " + packageName);
        packageCodes.push("{");

        //各个类
        var hasOutput:Boolean;
        for each(var classInfo:Object in data.outputClasses)
        {
            var className:String = PinYinUtils.toPinyin(classInfo.className);
            var classCodes:Array;
            if (className.indexOf('UI_') == 0)
            {
                classCodes = _uiExport.doExport(bindPackage, className, this.getAllMembers(classInfo));
                if (classCodes && classCodes.length)
                {
                    hasOutput = true;
                    packageCodes = packageCodes.concat(classCodes);
                }
            }
            else if (className.indexOf('dele_') == 0)
            {
                classCodes = _deleExport.doExport(bindPackage, className, this.getAllMembers(classInfo));
                if (classCodes && classCodes.length)
                {
                    hasOutput = true;
                    packageCodes = packageCodes.concat(classCodes);
                }
            }
            else
            {
                continue;
            }
        }

        packageCodes.push("}");
        if (hasOutput)
        {
            FileTool.writeFile(codeFolder.nativePath + File.separator + bindPackage + ".ts", packageCodes.join("\r\n"));
        }

        callback.callOnSuccess();
        return true;
    }

    private function getAllMembers(classInfo:Object):Array
    {
        var memberInfo:Object;
        var memberName:String;
        var memberType:String;
        var allMembers:Array = [];
        for each(memberInfo in classInfo.members)
        {
            memberName = memberInfo.name;
            if (checkIsUseDefaultName(memberName)) continue;
            memberType = memberInfo.type;
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

            allMembers.push(new MemberVo(memberName, memberType));
        }
        return allMembers;
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