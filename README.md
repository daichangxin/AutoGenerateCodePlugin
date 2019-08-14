# AutoGenerateCodePlugin
FairyGUI的Egret代码导出，需配合pargame_egret框架

## 2019-08-14更新
新增接口导出模式，暂时仅用在了Layabox导出类型，egret一样可以。这个模式下仅导出组件的子项的类型声明，获取方法参考下面的ts代码，相比之前的导出Class代码，要节省很多很多代码文件。
```typescript
export function getMembersInfo(skin: fairygui.GComponent) {
    const result = {};
    //children
    let i, len = 0;
    for (i = 0, len = skin.asCom.numChildren; i < len; i++) {
        const child = skin.asCom.getChildAt(i);
        const childName = child.name;
        //忽略空命名
        if (isDefaultName(childName)) continue;
        result[childName] = child;
    }
    //transition
    let t_arr: fairygui.Transition[] = skin['_transitions'];
    for (i = 0, len = t_arr.length; i < len; i++) {
        const t = t_arr[i];
        const tName = t.name;
        //忽略空命名
        if (isDefaultName(tName)) continue;
        result[tName] = t;
    }
    //controller
    let c_arr: fairygui.Controller[] = skin['_controllers'];
    for (i = 0, len = c_arr.length; i < len; i++) {
        const c = c_arr[i];
        const cName = c.name;
        //忽略空命名
        if (isDefaultName(cName)) continue;
        result[cName] = c;
    }
    return result;
}
```

## 使用
编辑器中加入自定义属性(文件-项目设置-自定义属性)：
```
gen_code=true
code_path=D:\workspace\path_to_output_code
```
点击导出即可。

## 匹配规则
- 每个包仅生成一个ts文件(防止类文件过多)
- 仅导出组件名以UI_开头的组件(防止导出不需要的组件)
- GComponent类型，会检测：
- - 'btn_', 'tab_', 'rb_'为GButton
- - 'bar_'为GProgressBar
- - 'slider_'为GSlider
- - 'comb_'为GComboBox

## 参考
1. http://ask.fairygui.com/?/question/5
2. http://www.fairygui.com/guide/

