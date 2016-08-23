unit uEstructuraFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, DefaultTranslator, DBGrids, DbCtrls, udatosdm;

type

  { TfrmEstructura }

  TfrmEstructura = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dbeDescripcion: TDBEdit;
    dbgDestinos: TDBGrid;
    grbEstructura: TGroupBox;
    spbAgregar: TSpeedButton;
    spbBorrar: TSpeedButton;
    spbEditar: TSpeedButton;
    spbAceptar: TSpeedButton;
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormShow(Sender: TObject);
    procedure spbAceptarClick(Sender: TObject);
    procedure spbAgregarClick(Sender: TObject);
    procedure spbBorrarClick(Sender: TObject);
    procedure spbEditarClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmEstructura: TfrmEstructura;

implementation

uses
  db;

{$R *.lfm}

{ TfrmEstructura }

procedure TfrmEstructura.DBNavigator1Click(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if Button = nbRefresh then
    dmDatos.sqlDestinos.ApplyUpdates;
end;

procedure TfrmEstructura.FormShow(Sender: TObject);
begin
  dbeDescripcion.Visible := False;
  spbAceptar.Enabled := False;
  dbgDestinos.Columns.Items[0].Visible := False;
  dbgDestinos.Columns.Items[1].Title.Caption := 'Destino';
end;

procedure TfrmEstructura.spbAceptarClick(Sender: TObject);
begin
  if dmDatos.sqlDestinos.State in [dsEdit, dsInsert] then
  begin
    dmDatos.sqlDestinos.Post;
    dmDatos.sqlDestinos.ApplyUpdates;
  end;
  dbeDescripcion.Visible := False;
  spbBorrar.Enabled := True;
  spbEditar.Enabled := True;
  spbAgregar.Enabled := True;
  spbAceptar.Enabled := False;
end;

procedure TfrmEstructura.spbAgregarClick(Sender: TObject);
begin
  dmDatos.sqlDestinos.Insert;
  dbeDescripcion.Visible := True;
  spbBorrar.Enabled := False;
  spbEditar.Enabled := False;
  spbAgregar.Enabled := False;
  spbAceptar.Enabled := True;
end;

procedure TfrmEstructura.spbBorrarClick(Sender: TObject);
begin
  dbeDescripcion.ReadOnly := True;
  if (MessageDlg('Eliminar Destino',
      '¿Estás seguro de borrar el destino "'
      + dmDatos.sqlDestinos.FieldByName('descripcion').AsString + '"?',
      mtConfirmation, mbYesNo, 0) = mrYes) then
  begin
    dmDatos.EliminaDestino(dmDatos.sqlDestinos.FieldByName('id').AsInteger);
    ShowMessage('Destino Eliminado');
  end;
end;

procedure TfrmEstructura.spbEditarClick(Sender: TObject);
begin
  dbeDescripcion.Visible := True;
  dmDatos.sqlDestinos.Edit;
  spbBorrar.Enabled := False;
  spbEditar.Enabled := False;
  spbAgregar.Enabled := False;
  spbAceptar.Enabled := True;
end;

end.

