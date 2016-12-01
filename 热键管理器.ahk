
;************************1.MEOW.exe_start********************************;
;~ 单击Ctrl+d键一次启动/暂停MEOW.exe，按两次Ctrl+d键退出程序。
;~ 时间：2016.11.30
;~ 作者：jinge
Process, Exist, MEOW.exe
NewPID = %ErrorLevel%  ; 由于 ErrorLevel 会经常发生改变, 所以要立即保存这个值.
if  NewPID = 0
    {
        Run, D:\MEOW-x64-1.5\MEOW.exe       ;首先打开软件，如果程序正在运行，就跳过打开。避免运行过程中再次打开脚本时，重复打开软件
    }
;否则：   
x:=1
#MaxThreadsPerHotkey 5  ;超过两次的连击都被认为是2次，所以2次以上的连击都会被忽略
^d::  ; Ctrl+d 热键.
#MaxThreadsPerHotkey 1
intCount := (intCount ? (intCount + 1) : 1)
Sleep, 1000
if (intCount = 1)
    { 
        if x=1
			{
				Process_Suspend("MEOW.exe") ; 挂起进程
                ;MsgBox,hehe
				x:=0
				
			}
		else if  x=0
			{
				Process_Resume("MEOW.exe") ; 恢复进程
                ;MsgBox,huhu
				x:=1
				
			}
               
    }
else if (intCount = 2)
    {
        ProcTerminate("MEOW.exe") ; 结束进程
    }

intCount := "" ; 重置记数器。
Return

;========子程序==========
Process_Suspend(PID_or_Name){
    PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
    If !h   
        Return -1
    DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
    DllCall("CloseHandle", "Int", h)
    ;MsgBox,,,MEOW.exe suspended, 1      ;1秒后退出提示窗口
    TrayTip, ,MEOW suspended,1,1
	return
}

Process_Resume(PID_or_Name){
    PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)

    If !h   
        Return -1
    DllCall("ntdll.dll\NtResumeProcess", "Int", h)
    DllCall("CloseHandle", "Int", h)
    ;MsgBox,,, MEOW.exe resumed, 1
    TrayTip, ,MEOW resumed,1,1
	return
}

ProcExist(PID_or_Name=""){
    Process, Exist, % (PID_or_Name="") ? DllCall("GetCurrentProcessID") : PID_or_Name
    Return Errorlevel    
}

 ProcTerminate(PID_or_Name) ; 结束进程
 {
	Process, Close, %PID_or_Name%
	Process, Exist,  %PID_or_Name%
	;MsgBox,,, MEOW.exe is  terminated, 1
    TrayTip, ,MEOW terminated,1,1
	return
 }
 ;************************MEOW.exe_end********************************;
 
 ;************************2.添加热字符串_start********************************;  
::qqemail:: 740983026@qq.com
;************************添加热字符串_end********************************;
  
;************************3.添加热键_start********************************;  
!x:: Run, I:\个人\xinxi.txt - 记事本    ;Alt+x打开个人信息文本
!d:: Run, D:\MEOW-x64-1.5\direct.txt - 记事本    ;Alt+d打开代理服务器直连地址列表  
  
;************************添加热键_end********************************;