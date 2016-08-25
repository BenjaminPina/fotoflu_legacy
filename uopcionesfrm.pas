unit uOpcionesFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, DefaultTranslator, DbCtrls, DBGrids;

type

  { TfrmOpciones }

  TfrmOpciones = class(TForm)
    btbAceptar: TBitBtn;
    btnEstructura: TButton;
    dbcRaw: TDBLookupComboBox;
    dbcDJPG: TDBLookupComboBox;
    dbcDRaw: TDBLookupComboBox;
    dbcDSelectas: TDBLookupComboBox;
    grbParametros: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure btbAceptarClick(Sender: TObject);
    procedure btnEstructuraClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmOpciones: TfrmOpciones;

implementation

uses
  uEstructuraFrm, udatosdm;

{$R *.lfm}

{ TfrmOpciones }

procedure TfrmOpciones.btnEstructuraClick(Sender: TObject);
begin
  frmEstructura := TfrmEstructura.Create(Application);
  frmEstructura.ShowModal;
  frmEstructura.Free;
end;

procedure TfrmOpciones.btbAceptarClick(Sender: TObject);
begin
  dmDatos.zqConfiguracion.ApplyUpdates;
end;

end.

