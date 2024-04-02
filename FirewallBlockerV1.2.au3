#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <GuiListView.au3>

#RequireAdmin ; Ask for administrator privileges

Global $hGUI, $hFolderInput, $hBrowseButton, $hScanButton, $hClearButton, $hListView, $hBlockButton, $hSelectAllButton, $hRemoveBlockButton

$hGUI = GUICreate("Firewall Blocker V:1.2 by PrinceJacob", 500, 420)
$hFolderInput = GUICtrlCreateInput("", 10, 10, 300, 20)
$hBrowseButton = GUICtrlCreateButton("Browse", 320, 10, 60, 20)
$hScanButton = GUICtrlCreateButton("Scan Folder", 390, 10, 100, 20)
$hListView = GUICtrlCreateListView("Executable Files", 10, 40, 480, 330, BitOR($LVS_REPORT, $LVS_SINGLESEL, $WS_BORDER))
$hBlockButton = GUICtrlCreateButton("Block Selected", 230, 380, 100, 30)
$hClearButton = GUICtrlCreateButton("Clear List", 120, 380, 100, 30)
$hSelectAllButton = GUICtrlCreateButton("Select All", 10, 380, 100, 30)
$hRemoveBlockButton = GUICtrlCreateButton("Remove Block", 340, 380, 100, 30)


_GUICtrlListView_SetExtendedListViewStyle($hListView, $LVS_EX_CHECKBOXES + $LVS_EX_FULLROWSELECT)

GUISetState(@SW_SHOW)

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
        Case $hScanButton
            ScanFolder()
        Case $hClearButton
            ClearList()
        Case $hBlockButton
            BlockSelected()
        Case $hBrowseButton
            BrowseFolder()
        Case $hSelectAllButton
            SelectAllItems()
        Case $hRemoveBlockButton
            RemoveBlockSelected()
    EndSwitch
WEnd

Func ScanFolder()
    Local $sFolder = GUICtrlRead($hFolderInput)
    If StringStripWS($sFolder, 3) = '' Or Not FileExists($sFolder) Then
        MsgBox($MB_ICONERROR, "Error", "Invalid folder path or folder does not exist.")
        Return
    EndIf

    GUICtrlSetData($hListView, "")

    Local $aFiles = _FileListToArrayRec($sFolder, "*.exe", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)
    If @error Then
        MsgBox($MB_ICONERROR, "Error", "Error scanning folder.")
        Return
    EndIf

    _GUICtrlListView_BeginUpdate($hListView)
    _GUICtrlListView_DeleteAllItems($hListView) ; Clear existing items
    For $i = 1 To $aFiles[0]
        _GUICtrlListView_AddItem($hListView, $aFiles[$i])
    Next
    _GUICtrlListView_EndUpdate($hListView)

    ; Auto-adjust column width based on content
    For $i = 0 To _GUICtrlListView_GetColumnCount($hListView) - 1
        _GUICtrlListView_SetColumnWidth($hListView, $i, $LVSCW_AUTOSIZE_USEHEADER)
    Next
EndFunc

Func ClearList()
    _GUICtrlListView_DeleteAllItems($hListView)
EndFunc

Func BlockSelected()
    Local $aSelectedItems = GetCheckedItems($hListView)
    If UBound($aSelectedItems) = 1 Then ; Only 1 element, which is the initialized element
        MsgBox($MB_ICONINFORMATION, "Information", "No items selected.")
        Return
    EndIf

    For $i = 1 To UBound($aSelectedItems) - 1
        Local $sFilePath = _GUICtrlListView_GetItemText($hListView, $aSelectedItems[$i])
        If Not FileExists($sFilePath) Then ContinueLoop

        ; Block inbound rule
        RunWait(@ComSpec & ' /c netsh advfirewall firewall add rule name="BlockedExe_' & StringRegExpReplace($sFilePath, '[\\/:*?"<>|]', '_') & '_Inbound" dir=in action=block program="' & $sFilePath & '"')

        ; Block outbound rule
        RunWait(@ComSpec & ' /c netsh advfirewall firewall add rule name="BlockedExe_' & StringRegExpReplace($sFilePath, '[\\/:*?"<>|]', '_') & '_Outbound" dir=out action=block program="' & $sFilePath & '"')
    Next

    MsgBox($MB_ICONINFORMATION, "Information", "Selected .exe files blocked in Windows Firewall.")
EndFunc

Func BrowseFolder()
    Local $sFolder = FileSelectFolder("Select a folder", "", 7)
    If @error Then Return

    GUICtrlSetData($hFolderInput, $sFolder)
EndFunc

Func GetCheckedItems($hListView)
    Local $aCheckedItems[1] = [0]
    Local $iCount = _GUICtrlListView_GetItemCount($hListView)
    
    For $i = 0 To $iCount - 1
        If _GUICtrlListView_GetItemChecked($hListView, $i) Then
            ReDim $aCheckedItems[UBound($aCheckedItems) + 1]
            $aCheckedItems[0] += 1 ; Increase the count of checked items
            $aCheckedItems[$aCheckedItems[0]] = $i
        EndIf
    Next
    
    Return $aCheckedItems
EndFunc

Func SelectAllItems()
    Local $iCount = _GUICtrlListView_GetItemCount($hListView)
    
    For $i = 0 To $iCount - 1
        _GUICtrlListView_SetItemChecked($hListView, $i, True)
    Next
EndFunc

Func RemoveBlockSelected()
    Local $aSelectedItems = GetCheckedItems($hListView)
    If UBound($aSelectedItems) = 1 Then ; Only 1 element, which is the initialized element
        MsgBox($MB_ICONINFORMATION, "Information", "No items selected.")
        Return
    EndIf

    For $i = 1 To UBound($aSelectedItems) - 1
        Local $sFilePath = _GUICtrlListView_GetItemText($hListView, $aSelectedItems[$i])
        If Not FileExists($sFilePath) Then ContinueLoop

        ; Remove inbound rule
        RunWait(@ComSpec & ' /c netsh advfirewall firewall delete rule name="BlockedExe_' & StringRegExpReplace($sFilePath, '[\\/:*?"<>|]', '_') & '_Inbound"')

        ; Remove outbound rule
        RunWait(@ComSpec & ' /c netsh advfirewall firewall delete rule name="BlockedExe_' & StringRegExpReplace($sFilePath, '[\\/:*?"<>|]', '_') & '_Outbound"')
    Next

    MsgBox($MB_ICONINFORMATION, "Information", "Firewall blocks removed for selected .exe files.")
EndFunc
