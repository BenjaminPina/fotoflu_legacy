unit udatosdm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, FileUtil, ZConnection, ZDataset,
  ZSqlUpdate;

type

  { TdmDatos }

  TdmDatos = class(TDataModule)
    dsDestinos: TDataSource;
    dsConfiguracion: TDataSource;
    dsExtensiones: TDataSource;
    sqlDestinosdescripcion1: TMemoField;
    sqlDestinosid1: TLongintField;
    sqlExtensionesextension1: TMemoField;
    sqlExtensionesindice1: TLongintField;
    sqlExtensionesmarca1: TMemoField;
    zcDatos: TZConnection;
    zqConfiguracion: TZQuery;
    zqDestinosdescripcion1: TMemoField;
    zqDestinosid1: TLongintField;
    zqExtensiones: TZQuery;
    zqDestinos: TZQuery;
    zqDirectorioExiste: TZQuery;
    zqEliminaDestino: TZQuery;
    zqDirectorioAlta: TZQuery;
    zqExtensionesextension1: TMemoField;
    zqExtensionesindice1: TLongintField;
    zqExtensionesmarca1: TMemoField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure sqlDestinosdescripcion1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure zqDestinosdescripcion1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure zqExtensionesextension1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure zqExtensionesmarca1GetText(Sender: TField; var aText: string;
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
  zcDatos.Connect;
  zqConfiguracion.Open;
  zqDestinos.Open;
  zqExtensiones.Open;
end;

procedure TdmDatos.DataModuleDestroy(Sender: TObject);
begin
  zqConfiguracion.Close;
  zqDestinos.Close;
  zqExtensiones.Close;
  zcDatos.Disconnect;
end;

procedure TdmDatos.sqlDestinosdescripcion1GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(sqlDestinosdescripcion1.AsString, 1, 50);
end;

procedure TdmDatos.zqDestinosdescripcion1GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(zqDestinosdescripcion1.AsString, 1, 50);
end;

procedure TdmDatos.zqExtensionesextension1GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(zqExtensionesextension1.AsString, 1, 50);
end;

procedure TdmDatos.zqExtensionesmarca1GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(zqExtensionesmarca1.AsString, 1, 50);
end;

function TdmDatos.getDestJpg: Integer;
begin
  Result := zqConfiguracion.FieldByName('dest_jpg').AsInteger;
end;

function TdmDatos.getDestRaw: Integer;
begin
  Result := zqConfiguracion.FieldByName('dest_raw').AsInteger;
end;

function TdmDatos.getDestSelectas: Integer;
begin
  Result := zqConfiguracion.FieldByName('dest_raw').AsInteger;
end;

function TdmDatos.getDirectorio: string;
begin
  Result := zqConfiguracion.FieldByName('directorio').AsString;
end;

function TdmDatos.getExtRaw: Integer;
begin
  Result := zqConfiguracion.FieldByName('ext_raw').AsInteger;
end;

function TdmDatos.getVentana: Integer;
begin
  Result := zqConfiguracion.FieldByName('ventana').AsInteger;
end;

function TdmDatos.getVersion: string;
begin
  Result := zqConfiguracion.FieldByName('version').AsString;
end;

procedure TdmDatos.setDestJpg(AValue: Integer);
begin
  zqConfiguracion.FieldByName('dest_jpg').AsInteger := AValue;
end;

procedure TdmDatos.setDestRaw(AValue: Integer);
begin
  zqConfiguracion.FieldByName('dest_raw').AsInteger := AValue;
end;

procedure TdmDatos.setDestSelectas(AValue: Integer);
begin
  zqConfiguracion.FieldByName('dest_selectas').AsInteger := AValue;
end;

procedure TdmDatos.setDirectorio(AValue: string);
begin
  zqConfiguracion.FieldByName('directorio').AsString := AValue;
end;

procedure TdmDatos.setExtRaw(AValue: Integer);
begin
  zqConfiguracion.FieldByName('ext_raw').AsInteger := AValue;
end;

procedure TdmDatos.setVentana(AValue: Integer);
begin
  zqConfiguracion.FieldByName('ventana').AsInteger := AValue;
end;

procedure TdmDatos.EliminaDestino(id: Integer);
begin
  zqEliminaDestino.ParamByName('id').AsInteger := id;
  zqEliminaDestino.ExecSQL;
end;

procedure TdmDatos.DirectorioAlta(Ruta: string);
var
  i: Integer;
begin
  with zqDirectorioExiste do
  begin
    Close;
    ParamByName('dir').AsString := Ruta;
    Open;
    i := RecordCount;
    Close;
    if i = 1 then
      Exit;  //-->
  end;
  with zqDirectorioAlta do
  begin
    ParamByName('dir').AsString := Ruta;
    ParamByName('hoy').AsFloat := Now;
    ExecSQL;
  end;
end;

end.

