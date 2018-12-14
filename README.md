# AutoGenerateCodePlugin
FairyGUI的Egret代码导出，需配合pargame_egret框架

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

