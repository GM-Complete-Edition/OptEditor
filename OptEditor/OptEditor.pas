unit OptEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, OptClass, Menus, Editors, ExtCtrls, PanelX;

type
  TForm1 = class(TForm)
    FileTree: TVirtualStringTree;
    OpenFile: TOpenDialog;
    mm1: TMainMenu;
    itemFile: TMenuItem;
    itemOpen: TMenuItem;
    itemSave: TMenuItem;
    itemHelp: TMenuItem;
    itemAbout: TMenuItem;
    savefile: TSaveDialog;
    procedure DataTreeGetText(Sender: TBaseVirtualTree;Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;var CellText: WideString);
    procedure FileTreeBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure itemOpenClick(Sender: TObject);
    procedure itemAboutClick(Sender: TObject);
    procedure itemSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileTreeCreateEditor(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure FileTreeNodeDblClick(Sender: TBaseVirtualTree;
      const HitInfo: THitInfo);
    procedure FileTreeScroll(Sender: TBaseVirtualTree; DeltaX,
      DeltaY: Integer);
  private
    { Private declarations }
  public
  cOptFile:TOptFile;
    { Public declarations }
  end;

var
  Form1: TForm1;
implementation
uses ValueEditor;
{$R *.dfm}

procedure TForm1.DataTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PPropertyData;
begin
  Data := Sender.GetNodeData(Node);
  if TextType = ttNormal then
    case Column of
    0:
      CellText := Data.DName;
    1:
      CellText := Data.DValue;
    2:
      CellText := Data.DType;
    end;
end;
procedure TForm1.FileTreeBeforeItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
  var
    r:TRect;
begin
 inherited;
  R := Sender.GetDisplayRect(Node, 0, True);
  if Odd((R.Top-Sender.OffsetY) div Node.NodeHeight) then
  begin
    ItemColor := 16446961;
    EraseAction := eaColor;
  end;
end;

procedure TForm1.itemOpenClick(Sender: TObject);
begin
  OpenFile.InitialDir:= 'C:\Users\Public\Documents\Ghost Master\SaveGames\';
  OpenFile.Options:= [ofFileMustExist];
  OpenFile.Filter:= 'Ghost Master Option File|*.opt';
  if OpenFile.Execute then
  begin
    if cOptFile <> nil then
      cOptFile.Free;
    Filetree.Clear;
    FileTree.NodeDataSize:= SizeOf(TPropertyData);
    cOptFile:= TOptFile.Create(FileTree);
    cOptFile.filename:= extractfilename(OpenFile.FileName);
    cOptFile.setMemoryStream(OpenFile.FileName);
    cOptFile.AddFields(nil);
  end;
  FileTree.FullExpand;
end;
procedure TForm1.itemAboutClick(Sender: TObject);
begin
  ShowMessage('Version: 1.0' + Chr(10)+  '@Woitek1993');
end;

procedure TForm1.itemSaveClick(Sender: TObject);
var
  Data: PPropertyData;
begin
  if cOptFile <> nil then
    Data:=fileTree.GetNodeData(fileTree.GetFirstLevel(0));
    savefile.FileName:= Data^.DName;
    if savefile.Execute then
      cOptFile.WriteFile(savefile.FileName);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Left:=(Screen.Width-Width)  div 2;
   Top:=(Screen.Height-Height) div 2;
end;

procedure TForm1.FileTreeCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TPropertyEditLink.Create;
end;

procedure TForm1.FileTreeNodeDblClick(Sender: TBaseVirtualTree;
  const HitInfo: THitInfo);
var
  Data: PPropertyData;
begin
 if HitInfo.HitColumn = 1 then begin
    Data := Sender.GetNodeData(HitInfo.HitNode);
    case  Data.DBType of
      OptString,OptUniString,OptInt,OptFloat,OptDword,OptBoolean,OptKey,OptEnum:
      begin
        Sender.EditNode(HitInfo.HitNode, 1);
      end;
    end;
  end;
end;

procedure TForm1.FileTreeScroll(Sender: TBaseVirtualTree; DeltaX,
  DeltaY: Integer);
begin
 if Sender.IsEditing then Sender.updateEditBounds;
end;

end.
