unit ValueEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, VirtualTrees, ComCtrls, ExtCtrls, PanelX, OptClass;

type
  TValueForm = class(TForm)
    TextPanel: TPanel;
    pgValues: TPageControl;
    TabSheet0: TTabSheet;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    btn1: TButton;
    intvalue: TSpinEdit;
    textvalue: TEdit;
    cbvalue: TCheckBox;
    floatvalue: TEditX;
    combovalue: TComboBox;
    firstcbvalue: TComboBox;
    seccbvalue: TComboBox;
    stringvalue: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    function StringArrayToStringList(arr: array of string): TStringList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    Node: PVirtualNode;
    { Public declarations }
  end;

var
  ValueForm: TValueForm;

implementation
uses OptEditor;
{$R *.dfm}

procedure TValueForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
    begin
      Hide;
    end;
  end;
end;

procedure TValueForm.FormShow(Sender: TObject);
var
  Data: PPropertyData;
begin
  Form1.Enabled:=false;
  Left:=(Screen.Width-Width)  div 2;
  Top:=(Screen.Height-Height) div 2;
  Data:= Form1.FileTree.GetNodeData(Node);
  case Data.DBType of
    OptInt:
    begin
      pgValues.ActivePageIndex:= 0;
      intvalue.Value:=Integer(Data.PValue^);
    end;
    OptDword:
    begin
      pgValues.ActivePageIndex:= 1;
      textvalue.Text:=IntToHex(Integer(Data.PValue^),0);
    end;
    OptBoolean:
    begin
      pgValues.ActivePageIndex:= 2;
      cbvalue.Checked:=(Dword(Data.PValue^) = 1);
      cbvalue.Caption:=Data.DName;
    end;
    OptFloat:
    begin
     pgValues.ActivePageIndex:= 3;
     floatvalue.FloatVal:= Single(Data.PValue^);
    end;
    OptEnum:
    begin
      pgValues.ActivePageIndex:= 4;
      combovalue.Items.Clear;
      case Data.EnumIndex of
        0: combovalue.Items:= StringArrayToStringList(EnumEventCameras);
        1: combovalue.Items:= StringArrayToStringList(EnumGraphicsQuality);
        2: combovalue.Items:= StringArrayToStringList(EnumTextureQuality);
        3: combovalue.Items:= StringArrayToStringList(EnumKeyCodes);
      end;
      combovalue.ItemIndex:= Integer(Data.PValue^);
    end;
    OptKey:
    begin
      pgValues.ActivePageIndex:= 5;
      if TKey(Data.PValue^).add_key = 318 then
        firstcbvalue.itemIndex:= 3
      else
        firstcbvalue.itemIndex:= TKey(Data.PValue^).add_key - 304;
      if (TKey(Data.PValue^).key = 319) or (TKey(Data.PValue^).key = 318) then
        seccbvalue.ItemIndex:= TKey(Data.PValue^).key - 78
      else if (TKey(Data.PValue^).key = 256) or (TKey(Data.PValue^).key = 257) then
        seccbvalue.ItemIndex:= TKey(Data.PValue^).key - 18
      else
        seccbvalue.ItemIndex:= TKey(Data.PValue^).key;
    end;
    OptString,OptUniString:
    begin
      pgValues.ActivePageIndex:= 6;
      stringvalue.MaxLength:=32;
      stringvalue.Text:=string(Data.PValue^);
    end;
  end;
end;

procedure TValueForm.btn1Click(Sender: TObject);
var
  Data: PPropertyData;
  temp,enumIndex: integer;
  vreplace: String;
begin
  Data:= Form1.FileTree.GetNodeData(Node);
  enumIndex:= -1;
  case Data.DBType of
    OptInt: Integer(Data^.PValue^):= intvalue.Value;
    OptDword:
    if (TryStrToInt('$'+textvalue.Text, temp)) and (Length(textvalue.Text) = 8)  then
    begin
      Integer(Data^.PValue^):= temp;
    end;
    OptBoolean:
    begin
      if cbvalue.Checked then
        temp:=1
      else
        temp:=0;
      Integer(Data^.PValue^):= temp;
    end;
    OptFloat: Single(Data^.PValue^):= floatvalue.GetFloatVal;
    OptEnum:
    begin
      Integer(Data^.PValue^):= combovalue.ItemIndex;
      enumIndex:= Data^.EnumIndex;
    end;
    OptKey:
    begin
      if firstcbvalue.itemIndex = 3 then
      begin
        TKey(Data.PValue^).add_key:= 318;
        TKey(Data.PValue^).key3:= 304;
        TKey(Data.PValue^).key4:= 306;
        TKey(Data.PValue^).key5:= 305;
      end
      else
        TKey(Data.PValue^).add_key:= firstcbvalue.itemIndex + 304;
      if (seccbvalue.itemIndex = 240) or (seccbvalue.itemIndex = 241) then
        begin
          TKey(Data.PValue^).key:= seccbvalue.itemIndex + 78;
          TKey(Data.PValue^).add_key:= 319;
          TKey(Data.PValue^).key3:= 318;
          TKey(Data.PValue^).key4:= 318;
          TKey(Data.PValue^).key5:= 318;
        end
      else if (seccbvalue.itemIndex = 238) or (seccbvalue.itemIndex = 239) then
        TKey(Data.PValue^).key:= seccbvalue.itemIndex + 18
      else
        TKey(Data.PValue^).key:= seccbvalue.itemIndex;
    enumIndex:= Data^.EnumIndex;
    end;
    OptString,OptUniString:
    begin
      if stringvalue.Text <> '' then
        String(Data.PValue^):= stringvalue.Text;
        vreplace:= stringvalue.Text;
    end;
  end;
  TFile.ReplaceText(Data,vreplace,enumIndex);
  Form1.Enabled:=True;
  Hide;
end;

function TValueForm.StringArrayToStringList(arr: array of string): TStringList;
var
  i: integer;
begin
  Result:= TStringList.Create;
  for i:=0 to Length(arr) -1 do
  begin
    Result.Add(arr[i]);
  end;
end;

procedure TValueForm.FormCreate(Sender: TObject);
const
  sarray: array [0..3] of String = ('Shift','Crtl','Alt','None');
begin
  Left:=(Screen.Width-Width)  div 2;
  Top:=(Screen.Height-Height) div 2;
  firstcbvalue.Items:=StringArrayToStringList(sarray);
  seccbvalue.Items:=StringArrayToStringList(EnumKeyCodes);
end;

procedure TValueForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.Enabled:=true;
end;

end.
