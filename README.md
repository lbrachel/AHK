# AHK
===================================
##热键管理脚本
-----------------------------------
主要是控制MEOW的启挂停，还有一些小的热键集成		
		1. 在热键管理器中添加相应的功能-运行-调试
		2. 编译成.exe文件替换现有版本（修改图标）
		3. 添加到自启文件夹中C:\Users\zcs\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

##0.0.0：
###1. 更新了消息的显示方式;使用TrayTip代替MsgBox。
###2. 使MEOW软件进程挂起并不能阻止使用代理上网，因为IE代理设置仍然存在，所以还是使用代理在联网。准确方法是自动切换IE代理设置，这样才能控制直连或代理。所以    修正程序为0.0.1版，具体功能如下：
	  ####1. 单击Ctrl+d控制IE代理设置（系统代理设置），使其在直连和代理之间切换
	  ####2. 双击Ctrl+d控制软件MEOW的开/关
###0.0.1：
###1. 增加了开机自检功能，如果软件没开，但代理开着，就要关打理，否则不能上网
###2. 关代理时同时清理自动配置脚本
    
