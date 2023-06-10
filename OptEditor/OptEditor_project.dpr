program OptEditor_project;

uses
  Forms,
  OptEditor in 'OptEditor.pas' {Form1},
  OptClass in 'OptClass.pas',
  Editors in 'Editors.pas',
  PanelX in 'PanelX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
