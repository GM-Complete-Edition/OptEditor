object Form1: TForm1
  Left = 700
  Top = 328
  Width = 473
  Height = 444
  Caption = 'Options File Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FileTree: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 457
    Height = 385
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
    Indent = 19
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages, toUseExplorerTheme]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnBeforeItemErase = FileTreeBeforeItemErase
    OnCreateEditor = FileTreeCreateEditor
    OnGetText = DataTreeGetText
    OnNodeDblClick = FileTreeNodeDblClick
    OnScroll = FileTreeScroll
    Columns = <
      item
        Position = 0
        Width = 220
        WideText = 'Name'
      end
      item
        Position = 1
        Width = 158
        WideText = 'Value'
      end
      item
        Position = 2
        Width = 75
        WideText = 'Type'
      end>
  end
  object OpenFile: TOpenDialog
    Top = 520
  end
  object mm1: TMainMenu
    Left = 72
    Top = 48
    object itemFile: TMenuItem
      Caption = 'File'
      object itemOpen: TMenuItem
        Caption = 'Open'
        OnClick = itemOpenClick
      end
      object itemSave: TMenuItem
        Caption = 'Save'
        OnClick = itemSaveClick
      end
    end
    object itemHelp: TMenuItem
      Caption = 'Help'
      object itemAbout: TMenuItem
        Caption = 'About'
        OnClick = itemAboutClick
      end
    end
  end
  object savefile: TSaveDialog
    Filter = 'Ghost Master Option File|*.opt'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 272
    Top = 72
  end
end
