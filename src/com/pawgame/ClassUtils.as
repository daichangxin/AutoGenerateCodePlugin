package com.pawgame {
import com.pawgame.modules.uicode.MemberVo;

public class ClassUtils {
    public function ClassUtils() {

    }

    public static function getAllMembers(classInfo:Object):Array
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

    /**
     * 检查是否是系统自动命名
     */
    public static function checkIsUseDefaultName(name:String):Boolean
    {
        if (!name) return true;
        if (name.charAt(0) == "n" || name.charAt(0) == "c" || name.charAt(0) == "t")
        {
            return _isNum(name.slice(1));
        }
        return false;
    }

    private static function _isNum(str:String):Boolean
    {
        return !isNaN(parseInt(str));
    }
}
}
