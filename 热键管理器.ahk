
;************************1.MEOW.exe_start********************************;
;~ 单击Ctrl+d键一次启动/暂停MEOW.exe，按两次Ctrl+d键退出程序。
;~ 时间：2016.11.30
;~ 作者：jinge
;~ 版本：0.0.1
;#NoTrayIcon    ;来自ie代理设置模块;不显示托盘图标.
#Persistent     ;让脚本持久运行(即直到用户关闭或遇到 ExitApp
;;----------------------------------------------------------
;;    开机自检
;;----------------------------------------------------------
if ( RegRead("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1	and		ProcessExist("MEOW.exe")=0 )		;软件没开而且代理开着，就要关掉代理
	{
		proxydisable()
	}	
x:=1
#MaxThreadsPerHotkey 2  ;超过两次的连击都被认为是2次，所以2次以上的连击都会被忽略
^d::  ; Ctrl+d 热键.
#MaxThreadsPerHotkey 1
intCount := (intCount ? (intCount + 1) : 1)
Sleep, 1000
if (intCount = 1)
    { 
        Process, Exist, MEOW.exe
        NewPID = %ErrorLevel%  ; 由于 ErrorLevel 会经常发生改变, 所以要立即保存这个值.
        if  NewPID = 0   ;软件没有打开,需要检测代理情况，如处于打开就保持，没有打开则需要打开，否则无法上网！
            {
            ToolTip,MEOW is off ! `nDouble "Ctrl+d" to open。
			SetTimer, RemoveToolTip, 3000      ;如果程序没有启动，就启动程序			
            }
        else		;软件处于打开状态
            {
                SetProxy()                 ;执行开关代理功能
            }		
		
        ;~ if x=1
			;~ {
				;~ Process_Suspend("MEOW.exe") ; 挂起进程
                ;~ ;MsgBox,hehe
				;~ x:=0
				
			;~ }
		;~ else if  x=0
			;~ {
				;~ Process_Resume("MEOW.exe") ; 恢复进程
                ;~ ;MsgBox,huhu
				;~ x:=1
				
			;~ }
            
               
    }
else if (intCount = 2)
    {
        Process, Exist, MEOW.exe
        NewPID = %ErrorLevel%  ; 由于 ErrorLevel 会经常发生改变, 所以要立即保存这个值.
        if  NewPID = 0				 ;如果程序没有启动，就启动程序
            {
				MsgBox,0,MEOW is Off,Switch setting to On?, 3
				IfMsgBox OK
				{
					Run, D:\MEOW-x64-1.5\MEOW.exe      
					ToolTip,Set MEOW On done
					SetTimer, RemoveToolTip, 3000   
				}				
            }
        else
            {
				MsgBox,0,MEOW is On,Switch setting to OFF?, 3		 ;如果程序正在运行，结束进程，
				IfMsgBox OK
				{
					ProcTerminate("MEOW.exe")                
					ToolTip,Set MEOW OFF done
					SetTimer, RemoveToolTip, 3000   
				}				
				if RegRead("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1		
					{
						proxydisable()
					}				 
            }
    }
intCount := "" ; 重置记数器。
Return

;========子程序_开始==========
;~ Process_Suspend(PID_or_Name){
    ;~ PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    ;~ h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
    ;~ If !h   
        ;~ Return -1
    ;~ DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
    ;~ DllCall("CloseHandle", "Int", h)
    ;~ ;MsgBox,,,MEOW.exe suspended, 1      ;1秒后退出提示窗口
    ;~ ;TrayTip, ,MEOW suspended,1,1
	;~ ToolTip,MEOW suspended
	;~ return
;~ }

;~ Process_Resume(PID_or_Name){
    ;~ PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    ;~ h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)

    ;~ If !h   
        ;~ Return -1
    ;~ DllCall("ntdll.dll\NtResumeProcess", "Int", h)
    ;~ DllCall("CloseHandle", "Int", h)
    ;~ ;MsgBox,,, MEOW.exe resumed, 1
    ;~ TrayTip, ,MEOW resumed,1,1
	;~ return
;~ }

;~ ProcExist(PID_or_Name=""){
    ;~ Process, Exist, % (PID_or_Name="") ? DllCall("GetCurrentProcessID") : PID_or_Name
    ;~ Return Errorlevel    
;~ }

 ProcTerminate(PID_or_Name) ; 结束进程
 {
	Process, Close, %PID_or_Name%
	Process, Exist,  %PID_or_Name%
	;MsgBox,,, MEOW.exe is  terminated, 1
    ;TrayTip, ,MEOW terminated,1,1
	ToolTip,MEOW terminated
	SetTimer, RemoveToolTip, 2000
	return
 } 
 ;*******************IE proxy setting_start*******************************;

SetProxy(address = "",state = ""){
	if (address = "") and (state = "")
		state = Toggle
	if address
		RegWrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyServer,%address%
	if (state ="ON")
	{
		flag = 1
		RegWrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
		ToolTip,Set proxy ON done
	}
	else if (state="OFF")
	{
		flag = 1
		RegWrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
		ToolTip,Set proxy OFF done
	}
	else if (state = "Toggle")
	{
		if RegRead("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1
		{
			MsgBox,0,Proxy is ON,Switch setting to OFF?, 3
			IfMsgBox OK
			{
				flag = 1
				RegWrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
				ToolTip,Set proxy OFF done
			}
		}
		else if RegRead("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 0
		{
			MsgBox,0,Proxy is OFF,Switch setting to ON?, 3
			IfMsgBox OK
			{
				flag = 1
				RegWrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
				ToolTip,Set proxy ON done
			}
		}
	}
	if (flag == 1)
	{
		DllCall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
		DllCall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
		;Sleep,2000
		;ToolTip
		SetTimer, RemoveToolTip, 2000   ;这样可以不使用Sleep来使tooltip显示一段时间后消失
	}
	return
}
;;----------------------------------------------------------
;;    Function RegRead
;;----------------------------------------------------------
RegRead(RootKey, SubKey, ValueName = "")		;使ToolTip显示消失子函数
{
	RegRead, v, %RootKey%, %SubKey%, %ValueName%
	return, v
}
;;----------------------------------------------------------
;;    Function RemoveToolTip
;;----------------------------------------------------------
RemoveToolTip:									;要让工具提示在一段时间后消失, 而不使用 Sleep 的方法 (它停止了当前线程):
SetTimer, RemoveToolTip, Off
ToolTip
return
;;----------------------------------------------------------
;;    Function ProcessExist
;;----------------------------------------------------------
ProcessExist(Name){
	Process,Exist,%Name%
	return Errorlevel
} 
;;----------------------------------------------------------
;;    Function proxydisable
;;----------------------------------------------------------
proxydisable(){
		RegWrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0		;并将代理关闭。
		RegDelete,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,AutoConfigURL			;删除自动脚本配置信息
		dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")				;重置网络
		dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
		return
	}		
  ;*******************IE proxy setting_start*******************************;
  ;========+++++子程序_结束=========================;
  
 ;************************MEOW.exe_end********************************;
 
 ;************************2.添加热字符串_start********************************;  
::qqemail:: 74098@qq.com
;************************添加热字符串_end********************************;
  
;************************3.添加热键_start********************************;  
!x:: Run, I:\个人\xinxi.txt - 记事本    ;Alt+x打开个人信息文本
!d:: Run, D:\MEOW-x64-1.5\direct.txt - 记事本    ;Alt+d打开代理服务器直连地址列表  
  
;************************添加热键_end********************************;
