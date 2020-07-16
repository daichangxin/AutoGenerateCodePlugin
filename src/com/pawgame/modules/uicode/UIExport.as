package com.pawgame.modules.uicode {
/**
 * UI_开头的组件导出
 */
public class UIExport {
    public static const inst:UIExport = new UIExport();

    public function UIExport() {

    }

    /**
     * 导出代码类结构
     */
    public function exportClassType(resName:String, className:String, allMembers:Array):Array
    {
        var classCodes:Array = [];
        classCodes.push("\texport class " + className + " extends g.GAsyncPanel");
        classCodes.push("\t{");

        //写入变量声明
        var member:MemberVo;
        for each (member in allMembers)
        {
            classCodes.push("\t\t" + member.name + ":fairygui." + member.type + ";");
        }

        //写入构造函数
        classCodes.push("\t\tconstructor()");
        classCodes.push("\t\t{");
        classCodes.push("\t\t\tsuper('" + resName + "', '" + className + "');");
        classCodes.push("\t\t}");

        //遍历写入变量获取
        classCodes.push("\t\tprotected doReady()");
        classCodes.push("\t\t{");
        for each(member in allMembers)
        {
            if (member.type == "Controller")
            {
                classCodes.push("\t\t\tthis." + PinYinUtils.toPinyin(member.name) + " = this._skin.getController('" + member.name + "');");
            }
            else if (member.type == "Transition")
            {
                classCodes.push("\t\t\tthis." + PinYinUtils.toPinyin(member.name) + " = this._skin.getTransition('" + member.name + "');");
            }
            else
            {
                classCodes.push("\t\t\tthis." + PinYinUtils.toPinyin(member.name) + " = this._skin.getChild('" + member.name + "') as any;");
            }
        }
        classCodes.push("\t\t}");

        //类包结束
        classCodes.push("\t}");
        return classCodes;
    }

    /**
     * 导出代码接口类型
     */
    public function exportInterfaceType(resName:String, className:String, allMembers:Array):Array{
        var classCodes:Array = [];
        classCodes.push("export interface " + className + "{");

        //写入变量声明
        var member:MemberVo;
        for each (member in allMembers)
        {
            classCodes.push("\t" + member.name + ":fgui." + member.type + ";");
        }

        //包结束
        classCodes.push("}");
        return classCodes;
    }
}
}
