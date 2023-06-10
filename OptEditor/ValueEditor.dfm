object valueForm: TvalueForm
  Left = 153
  Top = 243
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  ClientHeight = 105
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TextPanel: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 25
    Caption = 'Value'
    TabOrder = 0
  end
  object pgValues: TPageControl
    Left = 0
    Top = 24
    Width = 257
    Height = 81
    ActivePage = TabSheet6
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    object TabSheet0: TTabSheet
      Caption = 'TabSheet0'
      TabVisible = False
      object intvalue: TSpinEdit
        Left = 24
        Top = 16
        Width = 129
        Height = 22
        MaxValue = 2147483647
        MinValue = -2147483648
        TabOrder = 0
        Value = 0
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ImageIndex = 1
      TabVisible = False
      object textvalue: TEdit
        Left = 24
        Top = 16
        Width = 129
        Height = 21
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 2
      TabVisible = False
      object cbvalue: TCheckBox
        Left = 24
        Top = 16
        Width = 129
        Height = 22
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 3
      TabVisible = False
      object floatvalue: TEditX
        Left = 24
        Top = 16
        Width = 121
        Height = 19
        FloatDiv = 0.100000000000000000
        Precision = 6
        LabelPosition = lpLeft
        LabelText = 'floatvalue'
        LabelSpacing = 5
        TabOrder = 0
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 4
      TabVisible = False
      object combovalue: TComboBox
        Left = 24
        Top = 16
        Width = 129
        Height = 21
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'TabSheet5'
      ImageIndex = 5
      TabVisible = False
      object firstcbvalue: TComboBox
        Left = 0
        Top = 16
        Width = 89
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = 'firstcbvalue'
      end
      object seccbvalue: TComboBox
        Left = 88
        Top = 16
        Width = 89
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Text = 'firstcbvalue'
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'TabSheet6'
      ImageIndex = 6
      TabVisible = False
      object stringvalue: TEdit
        Left = 24
        Top = 16
        Width = 129
        Height = 21
        TabOrder = 0
      end
    end
  end
  object btn1: TButton
    Left = 184
    Top = 40
    Width = 67
    Height = 33
    Caption = 'Apply'
    TabOrder = 2
    OnClick = btn1Click
  end
end
