unit Editors;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VirtualTrees, ExtDlgs, ImgList, Buttons, ExtCtrls, ComCtrls,
  Mask,OptClass,PanelX,CheckLst;

type
  // Describes the type of value a property tree node stores in its data property.
  TValueType = (
    vtNone,
    vtString,
    vtPickString,
    vtNumber,
    vtPickNumber,
    vtMemo,
    vtDate
  );

//----------------------------------------------------------------------------------------------------------------------

  // Our own edit link to implement several different node editors.
  TPropertyEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TWinControl;
    FEdit2: TWinControl;        // One of the property editor classes.
    FNumEdit: Integer;
    FCheckList: Boolean;
    FRect: TRect;
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HexEditKeyPress(Sender: TObject; var Key: Char);
    procedure HexEditChange(Sender: TObject);
    procedure KeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    destructor Destroy; override;

    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------

type
  TPropertyTextKind = (
    ptkText,
    ptkHint
  );

//----------------------------------------------------------------------------------------------------------------------

implementation


//----------------- TPropertyEditLink ----------------------------------------------------------------------------------

// This implementation is used in VST3 to make a connection beween the tree
// and the actual edit window which might be a simple edit, a combobox
// or a memo etc.

destructor TPropertyEditLink.Destroy;

begin
  if FEdit is TEditX then
    FEdit.Free; //because Bond is Indus.
  if FNumEdit > 1 then
    Fedit2.Free;
  if FEdit.HandleAllocated then
    PostMessage(FEdit.Handle, CM_RELEASE, 0, 0);
  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPropertyEditLink.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CanAdvance: Boolean;
begin
  case Key of
    VK_RETURN:
      begin
        FTree.EndEditNode;
        FEdit.Free;
        Key := 0;
      end;
  end;
end;

procedure TPropertyEditLink.HexEditKeyPress(Sender: TObject;
  var Key: Char);
begin
if not (Key in [#3,#27,#22,#127, '0'..'9', 'a'..'f', 'A'..'F']) then
      key := #0;  
end;

procedure TPropertyEditLink.KeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
  #27,#13:  Key:=#0;
  end;
end;

procedure TPropertyEditLink.EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPropertyEditLink.BeginEdit: Boolean;

begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
  if FNumEdit > 1 then
    FEdit2.Show;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPropertyEditLink.CancelEdit: Boolean;

begin
  Result := True;
  FEdit.Hide;
  if FNumEdit > 1 then
    FEdit2.Hide;
end;

//----------------------------------------------------------------------------------------------------------------------
const
ConvertHex: array['0'..'f'] of SmallInt =
    ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15);
function HexToByte (S:Pchar):Byte;   
begin
   result := Byte((ConvertHex[S[0]] shl 4) + ConvertHex[S[1]]);
end;

procedure TPropertyEditLink.HexEditChange(Sender: TObject);
var
 i: Integer;
 s: String;
 pz: Integer;
begin
s := TEdit(sender).Text;
 pz:= TMaskEdit(sender).SelStart;
 for i := Length(s) downto 1 do
 begin
   if i=9 then begin  s[i]:=' '; continue; end;
   if not (s[i] in ['0'..'9','A'..'F']) then s[i]:='0';
 end;
 TEdit(sender).Text := s;
 TMaskEdit(sender).SelStart := pz;
end;

function TPropertyEditLink.EndEdit: Boolean;
var
  Data: PPropertyData;
  bytes: array[0..15]of byte;
  i:Integer;
  b:Integer;
  s:string;
  pp:Pchar;
  fp,bp:Cardinal;
  fsInt: SmallInt; fByte: Byte;
  fInt,kCB1,kCB2,eInt: integer; fFloat:Single;
  fFlags: Cardinal;
begin
  Result := True;

  Data := FTree.GetNodeData(FNode);

  case Data.DBType of
    OptUniString:
      begin
        s:=TEdit(FEdit).Text;
        if s <> Data.DValue then
        begin
          if s <> '' then
          begin
            String(Data.PValue^):= s;
            Data.DValue:= s;
          end;
          FTree.InvalidateNode(FNode);
        end;
      end;
    OptString:
      begin
        s:=TEdit(FEdit).Text;
        if S <> Data.DValue then
        begin
          Data.DValue := S;
          if length(Pchar(Data.PValue^))>0 then
            StrDispose(Pchar(Data.PValue^));
          PChar(Data.PValue^) :=StrNew(PChar(s));
          FTree.InvalidateNode(FNode);
        end;
      end;
    OptDword:
      begin
        s:=TEdit(FEdit).Text;
        if S <> Data.DValue then
        begin
          Data.DValue := S;
          b:=7;
          for i:=0 to 3 do begin
            bytes[i]:=HexToByte(@s[b]);
            Dec(b,2);
          end;
          Move(bytes[0],Data.PValue^,4);
          FTree.InvalidateNode(FNode);
        end;
      end;
    OptInt:
      begin
        fInt:=Round(TEditX(FEdit).GetFloatVal);
        if fInt <> Integer(Data.PValue^) then
        begin
          Data.DValue := IntToStr(fInt);
          Integer(Data.PValue^) :=fInt;
          FTree.InvalidateNode(FNode);
        end;
      end;
    OptFloat:
      begin
        fFloat:=TEditX(FEdit).GetFloatVal;
        if fFloat <> Single(Data.PValue^) then
        begin
          Data.DValue := Format('%.2f',[fFloat]);
          Single(Data.PValue^) :=fFloat;
          FTree.InvalidateNode(FNode);
        end;
      end;
      OptBoolean:
      begin
        fInt:=TComboBox(FEdit).ItemIndex;
        if fInt <> Integer(Data.PValue^) then
        begin
          Data.DValue := TComboBox(FEdit).Text;
          Integer(Data.PValue^) :=fInt;
          FTree.InvalidateNode(FNode);
        end;
      end;
      OptEnum:
      begin
        eInt:=  TComboBox(FEdit).ItemIndex;
        case Data.EnumIndex of
          0: s := EnumEventCameras[eInt];
          1: s := EnumGraphicsQuality[eInt];
          2: s := EnumTextureQuality[eInt];
          3: s := EnumKeyCodes[eInt];
        end;
        Integer(Data^.PValue^):= eInt;
        Data.DValue:= s;
      end;
      OptKey:
      begin
      kCB1:= TComboBox(FEdit).ItemIndex;
      kCB2:= TComboBox(FEdit2).ItemIndex;
      if kCB1 = 3 then
      begin
        TKey(Data.PValue^).add_key:= 318;
        TKey(Data.PValue^).key3:= 304;
        TKey(Data.PValue^).key4:= 306;
        TKey(Data.PValue^).key5:= 305;
      end
      else
        TKey(Data.PValue^).add_key:= kCB1 + 304;
      if (kCB2 = 240) or (kCB2 = 241) then
        begin
          TKey(Data.PValue^).key:= kCB2 + 78;
          TKey(Data.PValue^).add_key:= 319;
          TKey(Data.PValue^).key3:= 318;
          TKey(Data.PValue^).key4:= 318;
          TKey(Data.PValue^).key5:= 318;
        end
      else if (kCB2 = 238) or (kCB2 = 239) then
        TKey(Data.PValue^).key:= kCB2 + 18
      else
        TKey(Data.PValue^).key:= kCB2;

      if (TKey(Data.PValue^).key <> 319) and (TKey(Data.PValue^).key <> 318) then
      begin
          if  (TKey(Data.PValue^).key <> 256) and (TKey(Data.PValue^).key <> 257) then
          begin
            case TKey(Data.PValue^).add_key of
              304 : s:= 'Shift + ';
              305 : s:= 'Crtl + ';
              306 : s:= 'Alt + ';
            end;
            s:= s+ EnumKeyCodes[Integer(Data.PValue^)];
          end else s:=EnumKeyCodes[Integer(Data.PValue^) - 18];
      end;
      Data.DValue:= s;
      FTree.InvalidateNode(FNode);
    end;
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPropertyEditLink.GetBounds: TRect;
begin
  Result := FRect;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPropertyEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;

var
  Data: PPropertyData;
  function MakeCombobox(ss: array of String):TComboBox;
  var
    i: integer;
  begin
      Result := TComboBox.Create(nil);
      with Result as TComboBox do
      begin
        Visible := False;
        Parent := Tree;
        for i:=Low(ss) to High(ss) do   Items.Add(ss[I]);
        SendMessage(GetWindow(Handle,GW_CHILD), EM_SETREADONLY, 1, 0);
        OnKeyUp := EditKeyUp;
        OnKeyDown:=EditKeyDown;
      end;
  end;
  function NewEditX(P:Pointer;Offset:Integer=0):TEditX;
  begin
    Result:=TEditX.Create(nil);
     with Result as TEditX do
    begin
      Visible := False;
      Precision:=6;
      FloatDiv:=0.01;
      FloatVal:=Single(Pointer(LongWord(P)+Offset)^);
      Parent := Tree;
      OnKeyUp := EditKeyUp;
    end;
  end;
  function NewEditXI(P:Pointer;Offset:Integer=0):TEditX;
  begin
    Result:=TEditX.Create(nil);
     with Result as TEditX do
    begin
      Visible := False;
      Precision:=0;
      FloatDiv:=1;
      MaxValue:=High(Integer);
      MinValue:=Low(Integer);
      FloatVal:=Integer(Pointer(LongWord(P)+Offset)^);
      Parent := Tree;
      OnKeyUp := EditKeyUp;
    end;
  end;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FNumEdit := 0;
  FCheckList:= False;
  // determine what edit type actually is needed
 // FEdit.Free;
  FEdit := nil;
  Data := FTree.GetNodeData(Node);
  case Data.DBType of
    OptUniString,OptString:
      begin
        FEdit := TEdit.Create(nil);
        with FEdit as TEdit do
        begin
          Visible := False;
          Parent := Tree;
          Text := Data.DValue;
          OnKeyDown := EditKeyDown;
          OnKeyUp := EditKeyUp;
          OnKeyPress:= KeyPress;
        end;
      end;
   OptInt:
      begin
        FNumEdit := 1;
        FEdit := TEditX.Create(nil);
        with FEdit as TEditX do
        begin
          Visible := False;
          Precision:=0;
          FloatDiv:=1;
          MinValue:=Low(SmallInt);
          MaxValue:=High(SmallInt);
          FloatVal:=SmallInt(Data.PValue^);
          Parent := Tree;
          OnKeyUp := EditKeyUp;
        end;
      end;
   OptFloat:
      begin
        FNumEdit := 1;
        FEdit := NewEditX(Data.PValue);
      end;
   OptBoolean:
      begin
        FEdit := MakeCombobox(OptBool);
        TComboBox(FEdit).ItemIndex:= Integer(Data.PValue^);
      end;
   OptEnum:
   begin
      case Data.EnumIndex of
        0: FEdit := MakeCombobox(EnumEventCameras);
        1: FEdit := MakeCombobox(EnumGraphicsQuality);
        2: FEdit := MakeCombobox(EnumTextureQuality);
        3: FEdit := MakeCombobox(EnumKeyCodes);
      end;
      TComboBox(FEdit).ItemIndex:= Integer(Data.PValue^);
   end;
   OptKey:
      begin
        FNumEdit := 2;
        FEdit := MakeCombobox(sarray);
        FEdit2 := MakeCombobox(EnumKeyCodes);
      if TKey(Data.PValue^).add_key = 318 then
        TComboBox(FEdit).ItemIndex:= 3
      else
        TComboBox(FEdit).ItemIndex:= TKey(Data.PValue^).add_key - 304;
      if (TKey(Data.PValue^).key = 319) or (TKey(Data.PValue^).key = 318) then
        TComboBox(FEdit2).ItemIndex:= TKey(Data.PValue^).key - 78
      else if (TKey(Data.PValue^).key = 256) or (TKey(Data.PValue^).key = 257) then
        TComboBox(FEdit2).ItemIndex:= TKey(Data.PValue^).key - 18
      else
        TComboBox(FEdit2).ItemIndex:= TKey(Data.PValue^).key;
    end;
   OptDword:
      begin
        FEdit := TMaskEdit.Create(nil);
        with FEdit as TMaskEdit do
        begin
          Visible := False;
          Parent := Tree;
          EditMask := '>aaaaaaaa<;1;0';
          Text := Data.DValue;
          OnKeyPress:= HexEditKeyPress;
          OnKeyDown := EditKeyDown;
          OnKeyUp := EditKeyUp;
          OnChange:= HexEditChange;
        end;
      end;

  else
    Result := False;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPropertyEditLink.ProcessMessage(var Message: TMessage);

begin
  FEdit.WindowProc(Message);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPropertyEditLink.SetBounds(R: TRect);

var
  Dummy: Integer;
  RTemp: TRect;
begin
  FRect:=R;
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  case FNumEdit of
    0: begin
    FEdit.BoundsRect := R;
    end;
    1:
    begin
      R.Right:=R.Right -13;
      FEdit.BoundsRect := R;
    end;
    2:
    begin
      RTemp:= R;
      RTemp.Right:=R.Left + ((R.Right-R.Left) div 2);
      FEdit.BoundsRect := RTemp;
      RTemp.Left:=R.Left + ((R.Right-R.Left) div 2);
      RTemp.Right:=R.Right;
      FEdit2.BoundsRect := RTemp;
    end;
  end;
end;

end.
