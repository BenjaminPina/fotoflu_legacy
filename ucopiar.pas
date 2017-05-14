unit uCopiar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, DefaultTranslator, FileUtil;

type

  { TfrmCopiar }

  TfrmCopiar = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    pbrAvance: TProgressBar;
    sttPos: TStaticText;
    sttOrigen: TStaticText;
    sttDestino: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    iPos: Integer;
  public
    { public declarations }
    Origenes,
    Destinos: TStringList;
    bPreservar: Boolean;
  end;

var
  frmCopiar: TfrmCopiar;

implementation

{$R *.lfm}

{ TfrmCopiar }

procedure TfrmCopiar.FormCreate(Sender: TObject);
begin
  iPos := 0;
  bPreservar := True;
end;

procedure TfrmCopiar.FormActivate(Sender: TObject);
var
  i: Integer;
begin
  pbrAvance.Max := Origenes.Count;
  for i := 0 to Origenes.Count - 1 do
  begin
    pbrAvance.Position := i + 1;
    sttOrigen.Caption := Origenes.Strings[i];
    sttDestino.Caption := Destinos.Strings[i];
    sttPos.Caption := IntToStr(i + 1) + '/' + IntToStr(Origenes.Count);
    if FileExists(Destinos.Strings[i]) then  //evitar copiar ya copiados
      Continue;
    if CopyFile(Origenes.Strings[i], Destinos.Strings[i]) then
    begin
      if not bPreservar then //borrar el archivo de origen
        DeleteFile(Origenes.Strings[i]);
    end
    else
      if MessageDlg('Error', 'No se pudo copiar el archivo: ' + Origenes.Strings[i]
          , mtError, [mbIgnore, mbAbort], 0) = mrAbort then
        Abort; //--->
    Application.ProcessMessages;
  end;
  Close;
end;

end.

