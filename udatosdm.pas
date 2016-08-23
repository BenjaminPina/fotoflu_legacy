unit udatosdm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, FileUtil;

type

  { TdmDatos }

  TdmDatos = class(TDataModule)
    dsDestinos: TDataSource;
    dsConfiguracion: TDataSource;
    dsExtensiones: TDataSource;
    slcDatos: TSQLite3Connection;
    sqlConfiguracion: TSQLQuery;
    sqlDestinosdescripcion1: TMemoField;
    sqlDestinosid1: TLongintField;
    sqlExtensionesextension1: TMemoField;
    sqlExtensionesindice1: TLongintField;
    sqlExtensionesmarca1: TMemoField;
    sqlExtensiones: TSQLQuery;
    sqlDestinos: TSQLQuery;
    sqlEliminaDestino: TSQLQuery;
    sqlDirectorioAlta: TSQLQuery;
    sqlDirectorioExiste: TSQLQuery;
    sqtDatos: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure sqlDestinosdescripcion1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure sqlExtensionesextension1GetText(Sender: TField;
      var aText: string; DisplayText: Boolean);
    procedure sqlExtensionesmarca1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
  private
    FVersion: string;
    { private declarations }
    function getDestJpg: Integer;
    function getDestRaw: Integer;
    function getDestSelectas: Integer;
    function getDirectorio: string;
    function getExtRaw: Integer;
    function getVentana: Integer;
    function getVersion: string;
    procedure setDestJpg(AValue: Integer);
    procedure setDestRaw(AValue: Integer);
    procedure setDestSelectas(AValue: Integer);
    procedure setDirectorio(AValue: string);
    procedure setExtRaw(AValue: Integer);
    procedure setVentana(AValue: Integer);
  public
    { public declarations }
    procedure EliminaDestino(id: Integer);
    procedure DirectorioAlta(Ruta: string);
    property Directorio: string read getDirectorio write setDirectorio;
    property Version: string read FVersion;
    property Ventana: Integer read getVentana write setVentana;
    property ExtRaw: Integer read getExtRaw write setExtRaw;
    property DestRaw: Integer read getDestRaw write setDestRaw;
    property DestJpg: Integer read getDestJpg write setDestJpg;
    property DestSelectas: Integer read getDestSelectas write setDestSelectas;
  end;

  //TODO eliminar getters y setters innecesarios

var
  dmDatos: TdmDatos;

implementation

{$R *.lfm}

{ TdmDatos }

procedure TdmDatos.DataModuleCreate(Sender: TObject);
begin
  FVersion := '1.9';
  slcDatos.Open;
  sqlConfiguracion.Open;
  sqlConfiguracion.Edit;
  sqlDestinos.Open;
  sqtDatos.Active := True;
  sqlExtensiones.Open;
end;

procedure TdmDatos.DataModuleDestroy(Sender: TObject);
begin
  sqlExtensiones.Close;
  sqlConfiguracion.Post;
  sqlConfiguracion.ApplyUpdates;
  sqtDatos.Commit;
  sqlConfiguracion.Close;
  slcDatos.Close;
end;

procedure TdmDatos.sqlDestinosdescripcion1GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(sqlDestinosdescripcion1.AsString, 1, 50);
end;

procedure TdmDatos.sqlExtensionesextension1GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(sqlExtensionesextension1.AsString, 1, 50);
end;

procedure TdmDatos.sqlExtensionesmarca1GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(sqlExtensionesmarca1.AsString, 1, 50);
end;

function TdmDatos.getDestJpg: Integer;
begin
  Result := sqlConfiguracion.FieldByName('dest_jpg').AsInteger;
end;

function TdmDatos.getDestRaw: Integer;
begin
  Result := sqlConfiguracion.FieldByName('dest_raw').AsInteger;
end;

function TdmDatos.getDestSelectas: Integer;
begin
  Result := sqlConfiguracion.FieldByName('dest_raw').AsInteger;
end;

function TdmDatos.getDirectorio: string;
begin
  Result := sqlConfiguracion.FieldByName('directorio').AsString;
end;

function TdmDatos.getExtRaw: Integer;
begin
  Result := sqlConfiguracion.FieldByName('ext_raw').AsInteger;
end;

function TdmDatos.getVentana: Integer;
begin
  Result := sqlConfiguracion.FieldByName('ventana').AsInteger;
end;

function TdmDatos.getVersion: string;
begin
  Result := sqlConfiguracion.FieldByName('version').AsString;
end;

procedure TdmDatos.setDestJpg(AValue: Integer);
begin
  sqlConfiguracion.FieldByName('dest_jpg').AsInteger := AValue;
end;

procedure TdmDatos.setDestRaw(AValue: Integer);
begin
  sqlConfiguracion.FieldByName('dest_raw').AsInteger := AValue;
end;

procedure TdmDatos.setDestSelectas(AValue: Integer);
begin
  sqlConfiguracion.FieldByName('dest_selectas').AsInteger := AValue;
end;

procedure TdmDatos.setDirectorio(AValue: string);
begin
  sqlConfiguracion.FieldByName('directorio').AsString := AValue;
end;

procedure TdmDatos.setExtRaw(AValue: Integer);
begin
  sqlConfiguracion.FieldByName('ext_raw').AsInteger := AValue;
end;

procedure TdmDatos.setVentana(AValue: Integer);
begin
  sqlConfiguracion.FieldByName('ventana').AsInteger := AValue;
end;

procedure TdmDatos.EliminaDestino(id: Integer);
begin
  sqlEliminaDestino.ParamByName('id').AsInteger := id;
  sqlEliminaDestino.ExecSQL;
  sqlConfiguracion.Close;
  sqlDestinos.Close;
  sqlConfiguracion.Open;
  sqlDestinos.Open;
end;

procedure TdmDatos.DirectorioAlta(Ruta: string);
var
  i: Integer;
begin
  with sqlDirectorioExiste do
  begin
    Close;
    ParamByName('dir').AsString := Ruta;
    Open;
    i := RecordCount;
    Close;
    if i = 1 then
      Exit;  //-->
  end;
  with sqlDirectorioAlta do
  begin
    ParamByName('dir').AsString := Ruta;
    ParamByName('hoy').AsFloat := Now;
    ExecSQL;
  end;
  sqtDatos.Commit;
end;

end.

