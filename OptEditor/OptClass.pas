unit OptClass;

interface

uses Windows, Classes,SysUtils,Dialogs,VirtualTrees;

type
  TGeneral = record
end;

type
  TKey = record
  key:Cardinal;
  add_key:Cardinal;
  key3:Cardinal;
  key4:Cardinal;
  key5:Cardinal;
end;

type
  TControlsOpt = record
  invert_mouse_zoom:Cardinal;
  invert_mouse:Cardinal;
  invert_mouse_rotate:Cardinal;
  pan_forward:TKey;
  pan_back:TKey;
  pan_left:TKey;
  pan_right:TKey;
  rotate_camera_left:TKey;
  rotate_camera_right:TKey;
  menu_highlight_up:TKey;
  menu_highlight_down:TKey;
  menu_highlight_left:TKey;
  menu_highlight_right:TKey;
  unk1:TKey;
  unk2:TKey;
  unk3:TKey;
  unk4:TKey;
  unk5:TKey;
  unk6:TKey;
  pause_menu:TKey;
  zoom_camera_out:TKey;
  zoom_camera_in:TKey;
  tilt_camera_up:TKey;
  tilt_camera_down:TKey;
  zoom_out_full:TKey;
  zoom_in_full:TKey;
  tilt_camera_up_full:TKey;
  tilt_camera_down_full:TKey;
  move_up_level:TKey;
  move_down_level:TKey;
  move_top_level:TKey;
  move_bottom_level:TKey;
  unk7:TKey;
  unk8:TKey;
  unk9:TKey;
  reset_camera:TKey;
  reset_camera_clockwise:TKey;
  reset_camera_anticlockwise:TKey;
  save_camera_view:TKey;
  unk10:TKey;
  mission_briefing:TKey;
  unk11:TKey;
  detele_cancel:TKey;
  unk12:TKey;
  unk13:TKey;
  unk14:TKey;
  unk15:TKey;
  unk16:TKey;
  unk17:TKey;
  unk18:TKey;
  unk19:TKey;
  unk20:TKey;
  unk21:TKey;
  unk22:TKey;
  unk23:TKey;
  unk24:TKey;
  unk25:TKey;
  unk26:TKey;
  unk27:TKey;
  unk28:TKey;
  unk29:TKey;
  unk30:TKey;
  unk31:TKey;
  unk32:TKey;
  unk33:TKey;
  unk34:TKey;
  unk35:TKey;
  unk36:TKey;
  unk37:TKey;
  unk38:TKey;
  unk39:TKey;
  unk40:TKey;
  unk41:TKey;
  unk42:TKey;
  screen_grab:TKey;
  unk43:TKey;
  unk44:TKey;
  unk45:TKey;
  unk46:TKey;
  unk47:TKey;
  save_cam1:TKey;
  save_cam2:TKey;
  save_cam3:TKey;
  save_cam4:TKey;
  save_cam5:TKey;
  load_cam1:TKey;
  load_cam2:TKey;
  load_cam3:TKey;
  load_cam4:TKey;
  load_cam5:TKey;
  unk48:TKey;
  unk49:TKey;
  unk50:TKey;
  power_bar:TKey;
  orders_bar:TKey;
end;

type
  TGameOpt = record
  tutorialOn:Cardinal;
  showToolTips:Cardinal;
  toolTipDelay:Single;
  eventCameras:Cardinal;
  edgeOfScreenScrool:Cardinal;
  autoMoveCursor:Cardinal;
  panSpeed:Single;
end;
type
  TResolution = record
  width:Cardinal;
  height:Cardinal;
end;

type
  TDisplayOpt = record
  resolution:TResolution;
  graphicQuality:Cardinal;
  textureQuality:Cardinal;
  gamma:Single;
  exhancedCursor:Cardinal;
end;

type
  TAudioOpt = record
  masterVolume:Single;
  effectsVolume:Single;
  voicesVolume:Single;
  musicVolume:Single;
  audioQuality:Cardinal;
  subtitles:Cardinal;
  audioEAX:Cardinal;
end;

type
  OptDataTypes = (
     OptInt,OptDword,OptString,OptBoolean,OptFloat,OpDouble,OptStructure,OptFile,OptEnum,OptUniString,OptKey
  );

TLoadItemProcedure = procedure (Node1:PVirtualNode; i:integer; Parr:Pointer) of object;
type
// Node data record for the the document properties treeview.
PPropertyData = ^TPropertyData;
TPropertyData = record
  DName: String;
  DValue: String;
  PValue: Pointer;
  DType: String;
  DBType: OptDataTypes;
  EnumIndex: integer;
end;

type
TFile = class(TObject)
  constructor Create(tree: TCustomVirtualStringTree);
  destructor Destroy; override;
  function GetPointer: Pointer;
  procedure setMemoryStream(dir: string);
  procedure AddFields(CustomTree: TCustomVirtualStringTree); Virtual;
  function AddTreeData(ANode: PVirtualNode; Name: string;
  p: Pointer; Btype: OptDataTypes; VReplace: string; enump: integer): PVirtualNode;
  class procedure ReplaceText(Data: PPropertyData; VReplace: string; enump: integer);
  procedure WriteFile(filename: String); Virtual;
  function ReadDword():Cardinal;
  function ReadFloat():Single;
  procedure ReadKey(var k: TKey);
  function ReadUnicodeString(length: integer):String;
public
  filename:string;
  filePointer:Pointer;
  fileData:TMemoryStream;
  fileTree:TCustomVirtualStringTree;
end;

type
TOptFile = class (TFile)
  constructor Create(tree: TCustomVirtualStringTree);
  destructor Destroy; override;
  procedure AddFields(CustomTree: TCustomVirtualStringTree); override;
  procedure WriteFile(filename: String); override;
  public
    hash:Cardinal;
    version:Cardinal;
    player_name:String;
    GameOpt:TGameOpt;
    DisplayOpt:TDisplayOpt;
    AudioOpt:TAudioOpt;
    ControlsOpt:TControlsOpt;
    save_class_address:Cardinal;
    field_2896:Cardinal;
end;

const
  OptDataNames: array [OptDataTypes] of String = ('Int','Dword','String','Boolean','Float','Double','Structure','File','Enum','UString','Key');
  EnumEventCameras: array [0..2] of String = ('None','Critical','All');
  EnumGraphicsQuality: array [0..2] of String = ('Fastest','Average','Best');
  EnumTextureQuality: array [0..2] of String = ('16 Meg','32 Meg','64 Meg');
  EnumKeyCodes: array [0..241] of String = (//237 + 4 special
'Unk0','ESCAPE','1','2','3','4','5','6','7','8','9','0','MINUS','EQUALS',
'BACK','TAB','Q','W','E','R','T','Y','U','I','O','P','LBRACKET','RBRACKET',
'RETURN','LCONTROL','A','S','D','F','G','H','J','K','L','SEMICOLON','APOSTROPHE','GRAVE','LSHIFT','BACKSLASH','Z','X','C','V','B','N','M','COMMA','PERIOD','SLASH','RSHIFT','MULTIPLY','LMENU','SPACE','CAPITAL','F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','NUMLOCK','SCROLL','NUMPAD7','NUMPAD8','NUMPAD9','SUBTRACT','NUMPAD4','NUMPAD5','NUMPAD6','ADD','NUMPAD1','NUMPAD2','NUMPAD3','NUMPAD0','DECIMAL','Unk84','Unk85','OEM_102','F11','F12','Unk89','Unk90','Unk91','Unk92','Unk93','Unk94','Unk95','Unk96','Unk97','Unk98','Unk99',
'F13','F14','F15','Unk103','Unk104','Unk105','Unk106','Unk107','Unk108','Unk109','Unk110','Unk111','KANA','Unk113','Unk114','ABNT_C1','Unk116','Unk117','Unk118','Unk119','Unk120','CONVERT','Unk122','NOCONVERT','Unk124','YEN','ABNT_C2','Unk127','Unk128','Unk129','Unk130','Unk131','Unk132','Unk133','Unk134','Unk135','Unk136','Unk137','Unk138','Unk139','Unk140','NUMPADEQUALS','Unk142','Unk143','PREVTRACK','AT','COLON','UNDERLINE','KANJI','STOP','AX','UNLABELED','Unk152','NEXTTRACK','Unk154','Unk155','NUMPADENTER','RCONTROL','Unk158','Unk159','MUTE','CALCULATOR','PLAYPAUSE','Unk163','MEDIASTOP','Unk165','Unk166','Unk167','Unk168','Unk169','Unk170','Unk171','Unk172',
'Unk173','VOLUMEDOWN','Unk175','VOLUMEUP','Unk177','WEBHOME','NUMPADCOMMA','Unk180','DIVIDE','Unk182','SYSRQ','RMENU','Unk185','Unk186','Unk187','Unk188','Unk189','Unk190','Unk191','Unk192','Unk193','Unk194','Unk195','Unk196'
,'PAUSE','Unk198','HOME','UP','PRIOR','Unk202','LEFT','Unk204','RIGHT','Unk206','END','DOWN','NEXT','INSERT','DELETE','Unk212','Unk213','Unk214','Unk215','Unk216','Unk217','Unk218','LWIN','RWIN','APPS','POWER','SLEEP','Unk224','Unk225','Unk226','WAKE','Unk228','WEBSEARCH','WEBFAVORITES','WEBREFRESH','WEBSTOP','WEBFORWARD','WEBBACK','MYCOMPUTER','MAIL','MEDIASELECT','LBM', 'RBM', 'UNK318', 'NONE');
  OptBool: array [0..1] of String = ( 'False', 'True' );
  sarray: array [0..3] of String = ('Shift','Crtl','Alt','None');
implementation

constructor TFile.Create(tree: TCustomVirtualStringTree);
begin
  fileData:= TMemoryStream.Create;
  fileTree:=tree;
end;

destructor TFile.Destroy;
begin
  if fileData <> nil then
    fileData.Free;
  inherited;
end;

procedure TFile.WriteFile(filename: String);
begin

end;

function TFile.GetPointer: Pointer;
begin
 Result:=Pointer(Longword(fileData.Memory)+fileData.Position);
end;

procedure TFile.setMemoryStream(dir: string);
begin
 fileData.LoadFromFile(dir);
 filePointer:=GetPointer;
end;

procedure TFile.AddFields(CustomTree: TCustomVirtualStringTree);
begin
 fileTree.Clear;
end;

function TFile.AddTreeData(ANode: PVirtualNode; Name: string;
  p: Pointer; Btype: OptDataTypes; VReplace: string; enump: integer): PVirtualNode;
var
 Data: PPropertyData;
 s:string;
begin
 Result:=fileTree.AddChild(ANode);
 Data:=fileTree.GetNodeData(Result);
 fileTree.ValidateNode(Result, False);
 Data^.DName:=Name;
 Data^.PValue:=p;
 Data^.DType:=OptDataNames[Btype];
 Data^.DBType:=Btype;
 Data^.EnumIndex:= enump;
 ReplaceText(Data, VReplace, enump);
end;

class procedure TFile.ReplaceText(Data: PPropertyData; VReplace: string; enump: integer);
var
  s: string;
begin
  s:='';
  case Data.DBtype of
    OptInt: s:=Format('%d',[Integer(Data.PValue^)]);
    OptDword: s:=Format('%.*x',[8,Dword(Data.PValue^)]);
    OptBoolean: if (Dword(Data.PValue^) = 1) then s:='True' else s:='False';
    OptFloat: s:=Format('%f',[Single(Data.PValue^)]);
    //OptString:
    OptEnum:
    begin
      case enump of
        0: s:= EnumEventCameras[Integer(Data.PValue^)];
        1: s:= EnumGraphicsQuality[Integer(Data.PValue^)];
        2: s:= EnumTextureQuality[Integer(Data.PValue^)];
        3: s:= EnumKeyCodes[Integer(Data.PValue^)];
      end;
    end;
    OptKey:
    begin
    if (TKey(Data.PValue^).key <> 319) and (TKey(Data.PValue^).key <> 318) then
      begin
          if  (TKey(Data.PValue^).key <> 256) and (TKey(Data.PValue^).key <> 257) then
          begin
            case TKey(Data.PValue^).add_key of
              304 : s:= 'Shift + ';
              305 : s:= 'Crtl + ';
              306 : s:= 'Alt + ';
            end;
            case enump of
              0: s:= s+ EnumEventCameras[Integer(Data.PValue^)];
              1: s:= s+ EnumGraphicsQuality[Integer(Data.PValue^)];
              2: s:= s+ EnumTextureQuality[Integer(Data.PValue^)];
              3: s:= s+ EnumKeyCodes[Integer(Data.PValue^)];
            end;
          end else s:=EnumKeyCodes[Integer(Data.PValue^) - 18];
      end;
    end;
   end;
 if VReplace<>'' then s:=VReplace;
 Data.DValue:=s;
end;

function TFile.ReadDword():Cardinal;
begin
    Result:= DWord(filePointer^);
    Inc(Longword(filePointer), 4);
end;

function TFile.ReadFloat():Single;
begin
    Result:= Single(filePointer^);
    Inc(Longword(filePointer), 4);
end;

procedure TFile.ReadKey(var k: TKey);
begin
     k.key:=ReadDword;
     k.add_key:=ReadDword;
     k.key3:=ReadDword;
     k.key4:=ReadDword;
     k.key5:=ReadDword;
end;

function TFile.ReadUnicodeString(length: integer):String;
var
  i: integer;
  s: string;
begin
  SetLength(Result,length);
  s:='';
  for i:=0 to length -1 do
  begin
    if Char(filePointer^) = '' then
    begin
      Inc(Longword(filePointer), (length-i) * 2);
      SetLength(Result,i);
      Result:=s;
      break;
    end;
    s:=s + Char(filePointer^);
    Inc(Longword(filePointer), 2);
  end;
end;

constructor TOptFile.Create(tree: TCustomVirtualStringTree);
begin
  Inherited Create(tree);
  SetLength(player_name,32);
end;

destructor TOptFile.Destroy;
begin
  inherited;
end;

procedure TOptFile.AddFields(CustomTree: TCustomVirtualStringTree);
var
  root,gameOptNode,displayOptNode,resolutionNode,audioOptNode,controlsOptNode,keysNode: PVirtualNode;
begin
  //load all variables
  hash:=ReadDword;
  version:=ReadDword;
  player_name:=ReadUnicodeString(32);
  GameOpt.tutorialOn:=ReadDword;
  GameOpt.showToolTips:=ReadDword;
  GameOpt.toolTipDelay:=ReadFloat;
  GameOpt.eventCameras:=ReadDword;
  GameOpt.edgeOfScreenScrool:=ReadDword;
  GameOpt.autoMoveCursor:=ReadDword;
  GameOpt.panSpeed:=ReadFloat;
  DisplayOpt.resolution.width:=ReadDword;
  DisplayOpt.resolution.height:=ReadDword;
  DisplayOpt.graphicQuality:=ReadDword;
  DisplayOpt.textureQuality:=ReadDword;
  DisplayOpt.gamma:=ReadFloat;
  DisplayOpt.exhancedCursor:=ReadDword;
  AudioOpt.masterVolume:=ReadFloat;
  AudioOpt.effectsVolume:=ReadFloat;
  AudioOpt.voicesVolume:=ReadFloat;
  AudioOpt.musicVolume:=ReadFloat;
  AudioOpt.audioQuality:=ReadDword;
  AudioOpt.subtitles:=ReadDword;
  AudioOpt.audioEAX:=ReadDword;
  ControlsOpt.invert_mouse_zoom:=ReadDword;
  ControlsOpt.invert_mouse:=ReadDword;
  ControlsOpt.invert_mouse_rotate:=ReadDword;
  //keys
  ReadKey(ControlsOpt.pan_forward);
  ReadKey(ControlsOpt.pan_back);
  ReadKey(ControlsOpt.pan_left);
  ReadKey(ControlsOpt.pan_right);
  ReadKey(ControlsOpt.rotate_camera_left);
  ReadKey(ControlsOpt.rotate_camera_right);
  ReadKey(ControlsOpt.menu_highlight_up);
  ReadKey(ControlsOpt.menu_highlight_down);
  ReadKey(ControlsOpt.menu_highlight_left);
  ReadKey(ControlsOpt.menu_highlight_right);
  ReadKey(ControlsOpt.unk1);
  ReadKey(ControlsOpt.unk2);
  ReadKey(ControlsOpt.unk3);
  ReadKey(ControlsOpt.unk4);
  ReadKey(ControlsOpt.unk5);
  ReadKey(ControlsOpt.unk6);
  ReadKey(ControlsOpt.pause_menu);
  ReadKey(ControlsOpt.zoom_camera_out);;
  ReadKey(ControlsOpt.zoom_camera_in);
  ReadKey(ControlsOpt.tilt_camera_up);
  ReadKey(ControlsOpt.tilt_camera_down);
  ReadKey(ControlsOpt.zoom_out_full);
  ReadKey(ControlsOpt.zoom_in_full);
  ReadKey(ControlsOpt.tilt_camera_up_full);
  ReadKey(ControlsOpt.tilt_camera_down_full);
  ReadKey(ControlsOpt.move_up_level);
  ReadKey(ControlsOpt.move_down_level);
  ReadKey(ControlsOpt. move_top_level);
  ReadKey(ControlsOpt. move_bottom_level);
  ReadKey(ControlsOpt.unk7);
  ReadKey(ControlsOpt.unk8);
  ReadKey(ControlsOpt.unk9);
  ReadKey(ControlsOpt.reset_camera);
  ReadKey(ControlsOpt.reset_camera_clockwise);
  ReadKey(ControlsOpt.reset_camera_anticlockwise);
  ReadKey(ControlsOpt.save_camera_view);
  ReadKey(ControlsOpt.unk10);
  ReadKey(ControlsOpt.mission_briefing);
  ReadKey(ControlsOpt.unk11);
  ReadKey(ControlsOpt.detele_cancel);
  ReadKey(ControlsOpt.unk12);
  ReadKey(ControlsOpt.unk13);
  ReadKey(ControlsOpt.unk14);
  ReadKey(ControlsOpt.unk15);
  ReadKey(ControlsOpt.unk16);
  ReadKey(ControlsOpt.unk17);
  ReadKey(ControlsOpt.unk18);
  ReadKey(ControlsOpt.unk19);
  ReadKey(ControlsOpt.unk20);
  ReadKey(ControlsOpt.unk21);
  ReadKey(ControlsOpt.unk22);
  ReadKey(ControlsOpt.unk23);
  ReadKey(ControlsOpt.unk24);
  ReadKey(ControlsOpt.unk25);
  ReadKey(ControlsOpt.unk26);
  ReadKey(ControlsOpt.unk27);
  ReadKey(ControlsOpt.unk28);
  ReadKey(ControlsOpt.unk29);
  ReadKey(ControlsOpt.unk30);
  ReadKey(ControlsOpt.unk31);
  ReadKey(ControlsOpt.unk32);
  ReadKey(ControlsOpt.unk33);
  ReadKey(ControlsOpt.unk34);
  ReadKey(ControlsOpt.unk35);
  ReadKey(ControlsOpt.unk36);
  ReadKey(ControlsOpt.unk37);
  ReadKey(ControlsOpt.unk38);
  ReadKey(ControlsOpt.unk39);
  ReadKey(ControlsOpt.unk40);
  ReadKey(ControlsOpt.unk41);
  ReadKey(ControlsOpt.unk42);
  ReadKey(ControlsOpt.screen_grab);
  ReadKey(ControlsOpt.unk43);
  ReadKey(ControlsOpt.unk44);
  ReadKey(ControlsOpt.unk45);
  ReadKey(ControlsOpt.unk46);
  ReadKey(ControlsOpt.unk47);
  ReadKey(ControlsOpt.save_cam1);
  ReadKey(ControlsOpt.save_cam2);
  ReadKey(ControlsOpt.save_cam3);
  ReadKey(ControlsOpt.save_cam4);
  ReadKey(ControlsOpt.save_cam5);
  ReadKey(ControlsOpt.load_cam1);
  ReadKey(ControlsOpt.load_cam2);
  ReadKey(ControlsOpt.load_cam3);
  ReadKey(ControlsOpt.load_cam4);
  ReadKey(ControlsOpt.load_cam5);
  ReadKey(ControlsOpt.unk48);
  ReadKey(ControlsOpt.unk49);
  ReadKey(ControlsOpt.unk50);
  ReadKey(ControlsOpt.power_bar);
  ReadKey(ControlsOpt.orders_bar);
  //
  save_class_address:=ReadDword;
  field_2896:=ReadDword;


  //Add Tree
  AddTreeData(nil,ExtractFileName(filename),nil,OptFile,'',-1);
  root:=fileTree.GetFirstLevel(0);
  //OptFile
  AddTreeData(root,'Hash',@hash,OptDword,'',-1);
  AddTreeData(root,'Version',@version,OptInt,'',-1);
  AddTreeData(root,'Player Name',@player_name,OptUniString,player_name,-1);
  //GameOpt
  gameOptNode:= AddTreeData(root,'Game Options',nil,OptStructure,'',-1);
  AddTreeData(gameOptNode,'Haunting 101 Tutorial On',@GameOpt.tutorialOn,OptBoolean,'',-1);
  AddTreeData(gameOptNode,'Show Tool Tips for Powers',@GameOpt.showToolTips,OptBoolean,'',-1);
  AddTreeData(gameOptNode,'Tool Tip Delay',@GameOpt.toolTipDelay,OptFloat,'',-1);
  AddTreeData(gameOptNode,'Event Cameras',@GameOpt.eventCameras,OptEnum,'',0);
  AddTreeData(gameOptNode,'Screen Edge Pan',@GameOpt.edgeOfScreenScrool,OptBoolean,'',-1);
  AddTreeData(gameOptNode,'Auto Move Cursor',@GameOpt.autoMoveCursor,OptBoolean,'',-1);
  AddTreeData(gameOptNode,'Pan Speed',@GameOpt.panSpeed,OptFloat,'',-1);
  //DisplayOpt
  displayOptNode:= AddTreeData(root,'Display Option',nil,OptStructure,'',-1);
  resolutionNode:= AddTreeData(displayOptNode,'Resolution',nil,OptStructure,'',-1);
  AddTreeData(resolutionNode,'Width',@DisplayOpt.resolution.width,OptInt,'',-1);
  AddTreeData(resolutionNode,'Height',@DisplayOpt.resolution.height,OptInt,'',-1);
  AddTreeData(displayOptNode,'Overall Graphic Quality',@DisplayOpt.graphicQuality,OptEnum,'',1);
  AddTreeData(displayOptNode,'Texture Quality',@DisplayOpt.textureQuality,OptEnum,'',2);
  AddTreeData(displayOptNode,'Gamma',@DisplayOpt.gamma,OptFloat,'',-1);
  AddTreeData(displayOptNode,'Enhanced Cursor',@DisplayOpt.gamma,OptBoolean,'',-1);
  //AudioOpt
  audioOptNode:= AddTreeData(root,'Audio Option',nil,OptStructure,'',-1);
  AddTreeData(audioOptNode,'Master Volume',@AudioOpt.masterVolume,OptFloat,'',-1);
  AddTreeData(audioOptNode,'Sound Effects Volume',@AudioOpt.effectsVolume,OptFloat,'',-1);
  AddTreeData(audioOptNode,'Voices Volume',@AudioOpt.voicesVolume,OptFloat,'',-1);
  AddTreeData(audioOptNode,'Music Volume',@AudioOpt.musicVolume,OptFloat,'',-1);
  AddTreeData(audioOptNode,'Audio Quality',@AudioOpt.audioQuality,OptEnum,'',2);
  AddTreeData(audioOptNode,'Subtitles',@AudioOpt.subtitles,OptBoolean,'',-1);
  AddTreeData(audioOptNode,'audioEAX',@AudioOpt.subtitles,OptBoolean,'',-1);
  //ControlsOpt
  controlsOptNode:= AddTreeData(root,'Controls Option',nil,OptStructure,'',-1);
  AddTreeData(controlsOptNode,'Invert Mouse Zoom',@ControlsOpt.invert_mouse_zoom,OptBoolean,'',-1);
  AddTreeData(controlsOptNode,'Invert Mouse',@ControlsOpt.invert_mouse,OptBoolean,'',-1);
  AddTreeData(controlsOptNode,'Invert Mouse Rotate',@ControlsOpt.invert_mouse_rotate,OptBoolean,'',-1);
  keysNode:= AddTreeData(controlsOptNode,'Keys',nil,OptStructure,'',-1);
  AddTreeData(keysNode,'Pan forward',@ControlsOpt.pan_forward,OptKey,'',3);
  AddTreeData(keysNode,'Pan back',@ControlsOpt.pan_back,OptKey,'',3);
  AddTreeData(keysNode,'Pan left',@ControlsOpt.pan_left,OptKey,'',3);
  AddTreeData(keysNode,'Pan right',@ControlsOpt.pan_right,OptKey,'',3);
  AddTreeData(keysNode,'Rotate camera left',@ControlsOpt.rotate_camera_left,OptKey,'',3);
  AddTreeData(keysNode,'Rotate camera right',@ControlsOpt.rotate_camera_right,OptKey,'',3);
  AddTreeData(keysNode,'Menu Highlight Up',@ControlsOpt.menu_highlight_up,OptKey,'',3);
  AddTreeData(keysNode,'Menu Highlight Down',@ControlsOpt.menu_highlight_down,OptKey,'',3);
  AddTreeData(keysNode,'Menu Highlight Left',@ControlsOpt.menu_highlight_left,OptKey,'',3);
  AddTreeData(keysNode,'Menu Highlight Right',@ControlsOpt.menu_highlight_right,OptKey,'',3);
  AddTreeData(keysNode,'Select Level',@ControlsOpt.unk1,OptKey,'',3);
  AddTreeData(keysNode,'Follow Mouse Camera',@ControlsOpt.unk2,OptKey,'',3);
  AddTreeData(keysNode,'Menu Select',@ControlsOpt.unk3,OptKey,'',3);
  AddTreeData(keysNode,'Slider Select',@ControlsOpt.unk4,OptKey,'',3);
  AddTreeData(keysNode,'Camera Rotate',@ControlsOpt.unk5,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 6',@ControlsOpt.unk6,OptKey,'',3);
  AddTreeData(keysNode,'Pause Menu',@ControlsOpt.pause_menu,OptKey,'',3);
  AddTreeData(keysNode,'Zoom camera out',@ControlsOpt.zoom_camera_out,OptKey,'',3);
  AddTreeData(keysNode,'Zoom camera in',@ControlsOpt.zoom_camera_in,OptKey,'',3);
  AddTreeData(keysNode,'Tilt camera up',@ControlsOpt.tilt_camera_up,OptKey,'',3);
  AddTreeData(keysNode,'Tilt camera down',@ControlsOpt.tilt_camera_down,OptKey,'',3);
  AddTreeData(keysNode,'Zoom out full',@ControlsOpt.zoom_out_full,OptKey,'',3);
  AddTreeData(keysNode,'Zoom in full',@ControlsOpt.zoom_in_full,OptKey,'',3);
  AddTreeData(keysNode,'Tilt camera up full',@ControlsOpt.tilt_camera_up_full,OptKey,'',3);
  AddTreeData(keysNode,'Tilt camera down full',@ControlsOpt.tilt_camera_down_full,OptKey,'',3);
  AddTreeData(keysNode,'Move up a level',@ControlsOpt.move_up_level,OptKey,'',3);
  AddTreeData(keysNode,'Move down a level',@ControlsOpt.move_down_level,OptKey,'',3);
  AddTreeData(keysNode,'Move to top level',@ControlsOpt.move_top_level,OptKey,'',3);
  AddTreeData(keysNode,'Move to bottom level',@ControlsOpt.move_bottom_level,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 7',@ControlsOpt.unk7,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 8',@ControlsOpt.unk8,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 9',@ControlsOpt.unk9,OptKey,'',3);
  AddTreeData(keysNode,'Reset camera',@ControlsOpt.reset_camera,OptKey,'',3);
  AddTreeData(keysNode,'Reset camera clockwise',@ControlsOpt.reset_camera_clockwise,OptKey,'',3);
  AddTreeData(keysNode,'Reset camera anticlockwise',@ControlsOpt.reset_camera_anticlockwise,OptKey,'',3);
  AddTreeData(keysNode,'Save Reset Camera View',@ControlsOpt.save_camera_view,OptKey,'',3);
  AddTreeData(keysNode,'Default Reset Camera View',@ControlsOpt.unk10,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 11',@ControlsOpt.mission_briefing,OptKey,'',3);
  AddTreeData(keysNode,'Mission Briefing',@ControlsOpt.unk11,OptKey,'',3);
  AddTreeData(keysNode,'Delete Order / Cancel Bind',@ControlsOpt.detele_cancel,OptKey,'',3);
  AddTreeData(keysNode,'Delete Order',@ControlsOpt.unk12,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 13',@ControlsOpt.unk13,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 14',@ControlsOpt.unk14,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 15',@ControlsOpt.unk15,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 16',@ControlsOpt.unk16,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 17',@ControlsOpt.unk17,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 18',@ControlsOpt.unk18,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 19',@ControlsOpt.unk19,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 20',@ControlsOpt.unk20,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 21',@ControlsOpt.unk21,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 22',@ControlsOpt.unk22,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 23',@ControlsOpt.unk23,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 24',@ControlsOpt.unk24,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 25',@ControlsOpt.unk25,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 26',@ControlsOpt.unk26,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 27',@ControlsOpt.unk27,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 28',@ControlsOpt.unk28,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 29',@ControlsOpt.unk29,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 30',@ControlsOpt.unk30,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 31',@ControlsOpt.unk31,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 32',@ControlsOpt.unk32,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 33',@ControlsOpt.unk33,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 34',@ControlsOpt.unk34,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 35',@ControlsOpt.unk35,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 36',@ControlsOpt.unk36,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 37',@ControlsOpt.unk37,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 38',@ControlsOpt.unk38,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 39',@ControlsOpt.unk39,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 40',@ControlsOpt.unk40,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 41',@ControlsOpt.unk41,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 42',@ControlsOpt.unk42,OptKey,'',3);
  AddTreeData(keysNode,'Screen Grab',@ControlsOpt.screen_grab,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 43',@ControlsOpt.unk43,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 44',@ControlsOpt.unk44,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 45',@ControlsOpt.unk45,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 46',@ControlsOpt.unk46,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 47',@ControlsOpt.unk47,OptKey,'',3);
  AddTreeData(keysNode,'Save Bookmark 1',@ControlsOpt.save_cam1,OptKey,'',3);
  AddTreeData(keysNode,'Save Bookmark 2',@ControlsOpt.save_cam2,OptKey,'',3);
  AddTreeData(keysNode,'Save Bookmark 3',@ControlsOpt.save_cam3,OptKey,'',3);
  AddTreeData(keysNode,'Save Bookmark 4',@ControlsOpt.save_cam4,OptKey,'',3);
  AddTreeData(keysNode,'Save Bookmark 5',@ControlsOpt.save_cam5,OptKey,'',3);
  AddTreeData(keysNode,'Load Bookmark 1',@ControlsOpt.load_cam1,OptKey,'',3);
  AddTreeData(keysNode,'Load Bookmark 2',@ControlsOpt.load_cam2,OptKey,'',3);
  AddTreeData(keysNode,'Load Bookmark 3',@ControlsOpt.load_cam3,OptKey,'',3);
  AddTreeData(keysNode,'Load Bookmark 4',@ControlsOpt.load_cam4,OptKey,'',3);
  AddTreeData(keysNode,'Load Bookmark 5',@ControlsOpt.load_cam5,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 48',@ControlsOpt.unk48,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 49',@ControlsOpt.unk49,OptKey,'',3);
  AddTreeData(keysNode,'Unknown 50',@ControlsOpt.unk50,OptKey,'',3);
  AddTreeData(keysNode,'Open Power Bar Menu',@ControlsOpt.power_bar,OptKey,'',3);
  AddTreeData(keysNode,'Open Orders Menu',@ControlsOpt.orders_bar,OptKey,'',3);
  AddTreeData(root,'Save Class Address',@save_class_address,OptDword,'',-1);
  AddTreeData(root,'field_2896',@field_2896,OptDword,'',-1);
end;
procedure TOptFile.WriteFile(filename: String);
var
  fs: TFileStream;
  i,len: integer;
  b: byte;
begin
  fs:= TFileStream.Create(filename, fmCreate);
  fs.Write(hash,SizeOf(hash));
  fs.Write(version,SizeOf(version));
  len:=Length(player_name);
  for i:=1 to 32 do
  begin
    if i < len + 1 then
    begin
      fs.Write(player_name[i],SizeOf(char));
      fs.Write(b,SizeOf(b))
    end
    else
    begin
      fs.Write(b,SizeOf(b));
      fs.Write(b,SizeOf(b));
    end;
  end;
  fs.Write(GameOpt,SizeOf(GameOpt));
  fs.Write(DisplayOpt,SizeOf(DisplayOpt));
  fs.Write(AudioOpt,SizeOf(AudioOpt));
  fs.Write(ControlsOpt,SizeOf(ControlsOpt));
  fs.Write(save_class_address,SizeOf(save_class_address));
  fs.Write(field_2896,SizeOf(field_2896));
  fs.Free;
end;
end.
