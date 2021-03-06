; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "VirtualWall Firewall"
!define PRODUCT_VERSION "1.0.5.1005"
!define PRODUCT_PUBLISHER "VirtualWall, Inc."
!define PRODUCT_WEB_SITE "http://www.vidun.com/"
!define PRODUCT_LEGALCOPYRIGHT "Copyright (C) 2005-2011 VirtualWall,Inc. www.vidun.com"
!define PRODUCT_FILEDESCRIPTION "${PRODUCT_NAME}"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\VwFirewallCfg.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_KEY_OLD "Software\Microsoft\Windows\CurrentVersion\Uninstall\VwFirewall"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"
!include "MyFileEx.nsh"
!include "defines.nsh"
!include "GetFileVersion.nsh"

; DeSafe Define
!define DESAFE_SERVICE_NAME "W3SVC"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "install.ico"
!define MUI_UNICON "UnInstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
;!insertmacro MUI_PAGE_LICENSE "Licence_zhcn.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\VwFirewallCfg.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"

; 语言包
!include "VwFirewall_languages.nsi"
!include "x64.nsh"


; MUI end ------

Name "$(g_sMlProductName) ${PRODUCT_VERSION}"
OutFile "VwFirewallSetup.exe"
InstallDir "C:\VirtualWall\VwFirewall"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
BrandingText "${PRODUCT_PUBLISHER}"

var g_bIsWindow2003
var g_sReadEnvStr


;LoadLanguageFile "${NSISDIR}\Contrib\Language Files\English.nlf"
;----------------------------------------------------------------
;Version Information
VIProductVersion ${PRODUCT_VERSION}
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "$(g_sMlProductName)"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "${PRODUCT_WEB_SITE}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${PRODUCT_LEGALCOPYRIGHT}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${PRODUCT_FILEDESCRIPTION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${PRODUCT_VERSION}"

VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "ProductName" "$(g_sMlProductName)"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "Comments" "${PRODUCT_WEB_SITE}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "LegalTrademarks" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "LegalCopyright" "${PRODUCT_LEGALCOPYRIGHT}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileDescription" "${PRODUCT_FILEDESCRIPTION}"
VIAddVersionKey /LANG=${LANG_SIMPCHINESE} "FileVersion" "${PRODUCT_VERSION}"
;----------------------------------------------------------------




Function .onInit

   ;
   ;      显示多语言选择对话框
   ;
   !insertmacro ShowMultiLanguageSelectionDialog
   ;!insertmacro MUI_LANGDLL_DISPLAY
   
   
   ;
   ; 检查当前操作系统是否是 Windows 2003，如果不是则停止安装。
   ;
   Version::IsWindows2003
   Pop $g_bIsWindow2003       ; get result

   ; check result
   StrCmp $g_bIsWindow2003 "1" lab_os_is_windows2003 lab_os_is_not_windows2003

lab_os_is_windows2003:
   Goto lab_start_install

lab_os_is_not_windows2003:
   MessageBox MB_OK "对不起，该软件必须安装在 Windows 2003 操作系统上！$\r$\n$\r$\n Sorry, this software must be installed on the Windows 2003 operating system! $\r$\n$\r$\n"
   Quit

; 开始安装
lab_start_install:

FunctionEnd






Section "MainSection" SEC01

  ;
  ; 测试 system32 目录是否可以写入文件
  ;
  ClearErrors
  FileOpen $0 "$WINDIR\system32\DeLibSys32test.dll" w
  IfErrors lab_testsys32dir_error
  FileWrite $0 "1"
  FileClose $0
  Goto lab_testsys32dir_succ
lab_testsys32dir_error:
  MessageBox MB_OK "$(g_sMlError_TestSys32Dir) $\r$\n$\r$\n"
  Quit

lab_testsys32dir_succ:


  ;
  ; 测试 system32\drivers 目录是否可以写入文件 .dll
  ;
  ;   File some.dll # extracts to C:\Windows\System32
  ;
  ${DisableX64FSRedirection}
  ClearErrors
  FileOpen $0 "$WINDIR\system32\drivers\DeLibSys32test.dll" w
  IfErrors lab_testdriversdir_dll_error
  FileWrite $0 "1"
  FileClose $0
  Goto lab_testdriversdir_dll_succ
lab_testdriversdir_dll_error:
  ${EnableX64FSRedirection}
  MessageBox MB_OK "$(g_sMlError_TestSysDriverDir) $\r$\n$\r$\n"
  Quit

lab_testdriversdir_dll_succ:
  ${EnableX64FSRedirection}

  ;
  ; 测试 system32\drivers 目录是否可以写入文件 .sys
  ;
  ${DisableX64FSRedirection}
  ClearErrors
  FileOpen $0 "$WINDIR\system32\drivers\DeLibSys32test.sys" w
  IfErrors lab_testdriversdir_sys_error
  FileWrite $0 "1"
  FileClose $0
  Goto lab_testdriversdir_sys_succ
lab_testdriversdir_sys_error:
  ${EnableX64FSRedirection}
  MessageBox MB_OK "$(g_sMlError_TestSysDriverDir2) $\r$\n$\r$\n"
  Quit

lab_testdriversdir_sys_succ:
  ${EnableX64FSRedirection}


;  ;
;  ;  提示是否准备好了
;  ;
;  MessageBox MB_YESNO "$(g_sMlInsRestartIISNote) $\r$\n$\r$\n" IDYES lab_inscfm_yes IDNO lab_inscfm_no
;lab_inscfm_yes:
;  Goto lab_inscfm_installnow
;lab_inscfm_no:
;  Quit
;
;  ; 开始安装过程
;lab_inscfm_installnow:


  ;
  ; 向服务器发送安装的 HTTP 请求
  ;
  ;DetailPrint "Initializing data ..."
  ;Internet::GetUrlCode "install.xingworld.net" "/VwFirewall/install/?cver=${PRODUCT_VERSION}" ${VAR_3}
  ;Sleep 3000


  ; 退出 TrayIcon
  DetailPrint "Closing trayicon ..."
  Exec '"$INSTDIR\VwFirewallCfg.exe" -uninstall'
  Sleep 3000

  ;
  ;     kill running
  ;
lab_killrun_start:
  Processes::FindProcess "VwFirewallCfg" ;without ".exe"
  StrCmp $R0 "1" lab_killrun_find lab_killrun_done
lab_killrun_find:

      DetailPrint "Killing the running process ..."
      Processes::KillProcess "VwFirewallCfg" ;without ".exe"
      StrCmp $R0 "1" lab_killProcess_ok lab_killProcess_failed
      lab_killProcess_ok:
      lab_killProcess_failed:

      goto lab_killrun_start

lab_killrun_done:


;  ;
;  ;    如果服务存在，则停止服务先
;  ;
;  ;    Plug-in : http://nsis.sourceforge.net/NSIS_Simple_Service_Plugin
;  ; Check if the service exists
;  SimpleSC::ExistsService "${DESAFE_SERVICE_NAME}"
;  Pop $0 ; returns an errorcode if the service doesn′t exists (<>0)/service exists (0)
;  IntCmp $0 0 labf_installsrv_exist labf_installsrv_notexist labf_installsrv_notexist
;  labf_installsrv_exist:
;
;      DetailPrint "Stopping service ${DESAFE_SERVICE_NAME} ..."
;      SimpleSC::StopService "${DESAFE_SERVICE_NAME}"
;
;      Goto labf_installsrv_done
;
;  labf_installsrv_notexist:
;      Goto labf_installsrv_done
;  labf_installsrv_done:


  ;
  ; 先删除一些旧版本的文件
  ;
  Delete "$SMPROGRAMS\VwFirewall\*.*"


  ;
  ;  更新系统 DLL
  ;
  ; LOCALFILE, DESTFILE, TEMPBASEDIR
  !insertmacro FileEx "VwFirewall\DeLib.dll" "$WINDIR\system32\DeLib.dll" "$INSTDIR\"
  !insertmacro FileEx "VwFirewall\DeLibDrv.dll" "$WINDIR\system32\DeLibDrv.dll" "$INSTDIR\"

  SetOutPath "$INSTDIR"
  SetOverwrite try
  File "VwFirewall\DeLib.dll"
  File "VwFirewall\DeLibDrv.dll"
  File "VwFirewall\VwFirewallCfg.exe"
  File "VwFirewall\VwFirewallDrv_wnet_x86.sys"
  File "VwFirewall\VwFirewallDrv_wnet_amd64.sys"
  File "VwFirewall\VwFirewall_chs.chm"
  
  File "VwFirewall\cfg.acls.antivirus.data"
  File "VwFirewall\cfg.acls.file.data"
  File "VwFirewall\cfg.acls.folder.data"
  File "VwFirewall\cfg.object.data"
  File "VwFirewall\cfg.service.data"

  File "VwFirewall\VwUpdate.exe"
  File "VwFirewall\VwUpdate.ini"

  ;  创建 Script 目录
  CreateDirectory "$INSTDIR\Script"
  SetOutPath "$INSTDIR\Script"
  SetOverwrite try
  File "VwFirewall\Script\XCACLS.vbs"


  ;  创建日志目录
  CreateDirectory "$INSTDIR\Logs"

  ; 拷贝配置文件
  ${DisableX64FSRedirection}
  SetOutPath "$WINDIR\system32\drivers\"
  IfFileExists "$WINDIR\system32\drivers\VwFirewallDrvConfig.ini" +2 +1
    File "VwFirewall\VwFirewallDrvConfig.ini"
  ${EnableX64FSRedirection}

  ;
  ;    检查 DLL 版本号
  ;
  Call VerifySharedDllVersion


  ; 删除老的快捷方式
  Delete "$DESKTOP\VwFirewall.lnk"
  Delete "$SMPROGRAMS\VwFirewall\VwFirewall.lnk"

  CreateDirectory "$SMPROGRAMS\VwFirewall"
  CreateShortCut "$SMPROGRAMS\VwFirewall\$(g_sMlProductName).lnk" "$INSTDIR\VwFirewallCfg.exe"
  CreateShortCut "$DESKTOP\$(g_sMlProductName).lnk" "$INSTDIR\VwFirewallCfg.exe"

  ; 执行初始化工作
  DetailPrint "Initializing Application ..."
  Exec '"$INSTDIR\VwFirewallCfg.exe" -install'
  Sleep 3000

  ; 安装驱动程序
  DetailPrint "Installing Driver ..."
  Exec '"$INSTDIR\VwFirewallCfg.exe" -drv_install -bgrun'
  Sleep 3000

 ; ;
 ; ;    start service
 ; ;
 ; ; Check if the service is running
 ; SimpleSC::ServiceIsRunning "${DESAFE_SERVICE_NAME}"
 ; Pop $0 ; returns an errorcode (<>0) otherwise success (0)
 ; Pop $1 ; return 1 (service is running) - return 0 (service is not running)
 ; IntCmp $1 1 lab_runsrv_running lab_runsrv_notrun lab_runsrv_notrun
 ; lab_runsrv_running:
 ;     DetailPrint "Service ${DESAFE_SERVICE_NAME} is running now."
 ;     Goto lab_runsrv_done
 ; lab_runsrv_notrun:
 ;     DetailPrint "Starting service ${DESAFE_SERVICE_NAME} ..."
 ;     SimpleSC::StartService "${DESAFE_SERVICE_NAME}"
 ;     Goto lab_runsrv_done
 ; lab_runsrv_done:
 ; Sleep 1000



  ;
  ;   Plug-in : http://nsis.sourceforge.net/NSIS_Simple_Firewall_Plugin
  ;   Add our applications to the firewall exception list
  ;   Add an application to the firewall exception list - All Networks - All IP Version - Enabled
  ;
  SimpleFC::AddApplication "VwFirewallCfg" "$INSTDIR\VwFirewallCfg.exe" 0 2 "" 1
  Pop $0 ; return error(1)/success(0)

  ; 设置 Systray 自动启动
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "VwFirewallCfgAuto" "$INSTDIR\VwFirewallCfg.exe -auto"

  ; 删除所有临时文件
  Delete "$INSTDIR\*.tmp"

SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\$(g_sMlProductName).url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\VwFirewall\Website.lnk" "$INSTDIR\$(g_sMlProductName).url"
  CreateShortCut "$SMPROGRAMS\VwFirewall\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  ;
  ;  删除以前的安装信息
  ;
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"


  WriteUninstaller "$INSTDIR\uninst.exe"

  ; 清除以前版本
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY_OLD}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\VwFirewallCfg.exe"
  ;WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(g_sMlProductName)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\VwFirewallCfg.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

  ;
  ; 重启操作系统
  ;
  MessageBox MB_YESNO|MB_ICONQUESTION "$(g_sMlInsSuccess) $\r$\n$\r$\n" IDNO +2
  Reboot

SectionEnd


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         检查共享 DLL 文件是否更新完成
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
var g_sDllSysVer
var g_sDllInscabVer
var g_bDllNeedUpdate

Function VerifySharedDllVersion

   ;
   ;  判断版本是否一样，否则提示重启计算机
   ;
   ClearErrors
   ${GetFileVersion_IsNeedUpdate} "$INSTDIR\DeLib.dll" "$WINDIR\system32\DeLib.dll" $g_bDllNeedUpdate
   StrCmp $g_bDllNeedUpdate "0" 0 VerifySharedDllVersion_NeedUpdate

   ${GetFileVersion_IsNeedUpdate} "$INSTDIR\DeLibDrv.dll" "$WINDIR\system32\DeLibDrv.dll" $g_bDllNeedUpdate
   StrCmp $g_bDllNeedUpdate "0" 0 VerifySharedDllVersion_NeedUpdate

   goto VerifySharedDllVersion_done


VerifySharedDllVersion_NeedUpdate:
   MessageBox MB_YESNO|MB_ICONQUESTION $(g_sMlDllUpgradeMustReboot) IDNO +3
   MessageBox MB_ICONINFORMATION $(g_sMlDllUpgradeMustReboot2)
   ; 写 Runonce，重启后再次运行
   WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" "VwFirewallSetupRunOnce" $CMDLINE
   Reboot

VerifySharedDllVersion_done:
   ; 删除临时文件，否则无法正常工作
   Delete "$INSTDIR\DeLib.dll"
   Delete "$INSTDIR\DeLibDrv.dll"

FunctionEnd




Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(g_sMlUninsCompleted) $\r$\n$\r$\n"
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(g_sMlUninsConfirm) $\r$\n$\r$\n" IDYES +2
  Abort
FunctionEnd

Section Uninstall

;; 停止 IIS 提示
;  MessageBox MB_YESNO "$(g_sMlUninsRestartIISNote) $\r$\n$\r$\n" IDYES lab_inscfm_yes IDNO lab_inscfm_no
;lab_inscfm_yes:
;  Goto lab_inscfm_uninstallnow
;
;lab_inscfm_no:
;  Quit
;
;
;; 开始卸载过程
;lab_inscfm_uninstallnow:

  ;
  ; 向服务器发送卸载的 HTTP 请求
  ;
  ;DetailPrint "Initializing data ..."
  ;Internet::GetUrlCode "install.xingworld.net" "/VwFirewall/uninstall/?cver=${PRODUCT_VERSION}" ${VAR_3}
  ;Sleep 3000

  ; 退出 TrayIcon
  DetailPrint "Closing trayicon ..."
  Exec '"$INSTDIR\VwFirewallCfg.exe" -uninstall'
  Sleep 3000

  ;
  ;     kill running
  ;
  lab_killrun_start:
  Processes::FindProcess "VwFirewallCfg" ;without ".exe"
  StrCmp $R0 "1" lab_killrun_find lab_killrun_done
  lab_killrun_find:

      DetailPrint "Killing the running process ..."
      Processes::KillProcess "VwFirewallCfg" ;without ".exe"
      StrCmp $R0 "1" lab_killProcess_ok lab_killProcess_failed
      lab_killProcess_ok:
      lab_killProcess_failed:

      goto lab_killrun_start

  lab_killrun_done:
  Sleep 1000

;  ;
;  ;    如果服务存在，则停止服务先
;  ;
;  ;    Plug-in : http://nsis.sourceforge.net/NSIS_Simple_Service_Plugin
;  ; Check if the service exists
;  SimpleSC::ExistsService "${DESAFE_SERVICE_NAME}"
;  Pop $0 ; returns an errorcode if the service doesn′t exists (<>0)/service exists (0)
;  IntCmp $0 0 labf_installsrv_exist labf_installsrv_notexist labf_installsrv_notexist
;  labf_installsrv_exist:
;
;      DetailPrint "Stopping service ${DESAFE_SERVICE_NAME} ..."
;      SimpleSC::StopService "${DESAFE_SERVICE_NAME}"
;
;      Goto labf_installsrv_done
;
;  labf_installsrv_notexist:
;      Goto labf_installsrv_done
;  labf_installsrv_done:


  ; 卸载驱动
  DetailPrint "Uninstalling Driver ..."
  Exec '"$INSTDIR\VwFirewallCfg.exe" -drv_uninstall -bgrun'
  Sleep 3000

;  ;
;  ;    start service
;  ;
;  ; Check if the service is running
;  SimpleSC::ServiceIsRunning "${DESAFE_SERVICE_NAME}"
;  Pop $0 ; returns an errorcode (<>0) otherwise success (0)
;  Pop $1 ; return 1 (service is running) - return 0 (service is not running)
;  IntCmp $1 1 lab_runsrv_running lab_runsrv_notrun lab_runsrv_notrun
;  lab_runsrv_running:
;      DetailPrint "Service ${DESAFE_SERVICE_NAME} is running now."
;      Goto lab_runsrv_done
;  lab_runsrv_notrun:
;      DetailPrint "Starting service ${DESAFE_SERVICE_NAME} ..."
;      SimpleSC::StartService "${DESAFE_SERVICE_NAME}"
;      Goto lab_runsrv_done
;  lab_runsrv_done:
;  Sleep 1000

  ;
  ;    Remove an application from the firewall exception list
  ;
  SimpleFC::RemoveApplication "$INSTDIR\VwFirewallCfg.exe"
  Pop $0 ; return error(1)/success(0)

  ; 删除 Systray 自动启动
  DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "VwFirewallCfgAuto"



  Delete "$INSTDIR\$(g_sMlProductName).url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\VwFirewallDrvConfig.ini"
  Delete "$INSTDIR\VwFirewallDrv_wnet_x86.sys"
  Delete "$INSTDIR\VwFirewallDrv_wnet_amd64.sys"
  Delete "$INSTDIR\VwFirewallCfg.exe"
  ;Delete "$INSTDIR\DeLibDrv.dll"
  ;Delete "$INSTDIR\DeLib.dll"
  Delete "$INSTDIR\VwFirewall_chs.chm"

  Delete "$INSTDIR\cfg.acls.antivirus.data"
  Delete "$INSTDIR\cfg.acls.file.data"
  Delete "$INSTDIR\cfg.acls.folder.data"
  Delete "$INSTDIR\cfg.object.data"
  Delete "$INSTDIR\cfg.service.data"

  Delete "$INSTDIR\VwUpdate.exe"
  Delete "$INSTDIR\VwUpdate.ini"

  ;  删除 Script 目录
  Delete "$INSTDIR\Script\XCACLS.vbs"

  Delete "$SMPROGRAMS\VwFirewall\Uninstall.lnk"
  Delete "$SMPROGRAMS\VwFirewall\Website.lnk"
  Delete "$DESKTOP\$(g_sMlProductName).lnk"
  Delete "$SMPROGRAMS\VwFirewall\$(g_sMlProductName).lnk"

  RMDir "$SMPROGRAMS\VwFirewall"
  RMDir "$INSTDIR\Script"
  RMDir "$INSTDIR"


  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd