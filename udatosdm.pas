unit udatosdm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, LazFileUtils, ZConnection, ZDataset;

type

  { TdmDatos }

  TdmDatos = class(TDataModule)
    dsArchivos: TDataSource;
    dsSelecciones: TDataSource;
    dsDestinos: TDataSource;
    dsConfiguracion: TDataSource;
    dsExtensiones: TDataSource;
    sqlDestinosdescripcion1: TMemoField;
    sqlDestinosid1: TLongintField;
    sqlExtensionesextension1: TMemoField;
    sqlExtensionesindice1: TLongintField;
    sqlExtensionesmarca1: TMemoField;
    zcDatos: TZConnection;
    zqArchivosid1: TLongintField;
    zqArchivosnombre1: TMemoField;
    zqArchivosseleccion1: TLongintField;
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
    zqDestinoxID: TZQuery;
    zqExtXid: TZQuery;
    zqArchivoAlta: TZQuery;
    zqArchivoExiste: TZQuery;
    zqHaySelecciones: TZQuery;
    zqSeleccionAlta: TZQuery;
    zqSelecciones: TZQuery;
    zqSeleccionesdescripcion1: TMemoField;
    zqSeleccionesid1: TLongintField;
    zqSeleccionesseleccionadas1: TLongintField;
    zqTotSel: TZQuery;
    zqTotParaBorrar: TZQuery;
    zqSeleccionBaja: TZQuery;
    zqDeselecciona: TZQuery;
    zqArchivos: TZQuery;
    zqUltId: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure zqArchivosnombre1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure zqDestinosdescripcion1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure zqExtensionesextension1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure zqExtensionesmarca1GetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure zqSeleccionesdescripcion1GetText(Sender: TField;
      var aText: string; DisplayText: Boolean);
  private
    FDirectorioID: Integer;
    FVersion: string;
    { private declarations }
    function getCambios: Integer;
    function getDestinoRaw: string;
    function getDestinoxID(id: Integer): string;
    function getDestinoJPG: string;
    function getDirectorio: string;
    function getExtRaw: string;
    function getFotoActual: Integer;
    function getParaBorrar: Integer;
    function getSeleccionadas: Integer;
    function getTotalArchivos: Integer;
    function getVentana: Integer;
    function getVersion: string;
    function HaySelecciones: Boolean;
    procedure setDirectorio(AValue: string);
    procedure setVentana(AValue: Integer);
    procedure ArchivoAlta(Archivo: string);
  public
    { public declarations }
    procedure EliminaDestino(id: Integer);
    procedure DirectorioAlta;
    procedure IniciaSeleccion(JPGs, Raws: TStringList);
    procedure SeleccionAlta(Descripcion: string);
    procedure AgregaCambio;
    procedure BorraCambio;
    property Directorio: string read getDirectorio write setDirectorio;
    property DirectorioID: Integer read FDirectorioID;
    property DestinoJPG: string read getDestinoJPG;
    property DestinoRaw: string read getDestinoRaw;
    property Version: string read FVersion;
    property Ventana: Integer read getVentana write setVentana;
    property ExtRaw: string read getExtRaw;
    property Cambios: Integer read getCambios;
    property Seleccionadas: Integer read getSeleccionadas;
    property ParaBorrar: Integer read getParaBorrar;
    property TotalArchivos: Integer read getTotalArchivos;
    property FotoActual: Integer read getFotoActual;
  end;

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
  zqConfiguracion.ApplyUpdates;
  zqConfiguracion.Close;
  zqDestinos.Close;
  zqExtensiones.Close;
  zcDatos.Disconnect;
end;

procedure TdmDatos.zqArchivosnombre1GetText(Sender: TField; var aText: string;
  DisplayText: Boolean);
begin
  aText := Copy(zqArchivosnombre1.AsString, 1, 200);
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

procedure TdmDatos.zqSeleccionesdescripcion1GetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  aText := Copy(zqSeleccionesdescripcion1.AsString, 1, 50);
end;

function TdmDatos.getDestinoxID(id: Integer): string;
begin
   with zqDestinoxID do
  begin
    Close;
    ParamByName('id').AsInteger := id;
    Open;
    Result := getDirectorio
        + FieldByName('descripcion').AsString
        + DirectorySeparator;
    Close;
  end;
end;

function TdmDatos.getDestinoRaw: string;
begin
  Result := getDestinoxID(zqConfiguracion.FieldByName('dest_raw').AsInteger);
end;

function TdmDatos.getCambios: Integer;
begin
  Result := zqSelecciones.RecordCount
end;

function TdmDatos.getDirectorio: string;
begin
  Result := zqConfiguracion.FieldByName('directorio').AsString;
end;

function TdmDatos.getExtRaw: string;
begin
  with zqExtXid do
  begin
    Close;
    ParamByName('id').AsInteger :=
        zqConfiguracion.FieldByName('ext_raw').AsInteger;
    Open;
    Result := FieldByName('extension').AsString;
    Close;
  end;
end;

function TdmDatos.getFotoActual: Integer;
begin
  Result := zqArchivos.RecNo;
end;

function TdmDatos.getParaBorrar: Integer;
begin
   with zqTotParaBorrar do
  begin
    ParamByName('dir').AsInteger := FDirectorioID;
    Open;
    Result := FieldByName('contador').AsInteger;
    Close;
  end;
end;

function TdmDatos.getSeleccionadas: Integer;
begin
  with zqTotSel do
  begin
    ParamByName('dir').AsInteger := FDirectorioID;
    Open;
    Result := FieldByName('contador').AsInteger;
    Close;
  end;
end;

function TdmDatos.getTotalArchivos: Integer;
begin
  Result := zqArchivos.RecordCount;
end;

function TdmDatos.getDestinoJPG: string;
begin
  Result := getDestinoxID(zqConfiguracion.FieldByName('dest_jpg').AsInteger);
end;

function TdmDatos.getVentana: Integer;
begin
  Result := zqConfiguracion.FieldByName('ventana').AsInteger;
end;

function TdmDatos.getVersion: string;
begin
  Result := zqConfiguracion.FieldByName('version').AsString;
end;

function TdmDatos.HaySelecciones: Boolean;
begin
  with zqHaySelecciones do
  begin
    ParamByName('dir').AsInteger := FDirectorioID;
    Open;
    Result := RecordCount = 1;
    Close;
  end;
end;

procedure TdmDatos.setDirectorio(AValue: string);
begin
  zqConfiguracion.Edit;
  zqConfiguracion.FieldByName('directorio').AsString := AValue;
end;

procedure TdmDatos.setVentana(AValue: Integer);
begin
  zqConfiguracion.FieldByName('ventana').AsInteger := AValue;
end;

procedure TdmDatos.ArchivoAlta(Archivo: string);
var
  Existe: Boolean;
begin
  //¿ya está registrado el archivo?
  with zqArchivoExiste do
  begin
    ParamByName('arc').AsString := Archivo;
    Open;
    Existe := RecordCount = 1;
    Close;
  end;
  if not Existe then
  begin
    with zqArchivoAlta do
    begin
      ParamByName('dir').AsInteger :=  FDirectorioID;
      ParamByName('arc').AsString := Archivo;
      ExecSQL;
    end;
  end;
end;

procedure TdmDatos.EliminaDestino(id: Integer);
begin
  zqEliminaDestino.ParamByName('id').AsInteger := id;
  zqEliminaDestino.ExecSQL;
end;

procedure TdmDatos.DirectorioAlta;
begin
  with zqDirectorioExiste do
  begin
    Close;
    ParamByName('dir').AsString := Directorio;
    Open;
    if RecordCount = 1 then
    begin
      FDirectorioID := FieldByName('id').AsInteger;
      Close;
      Exit;  //-->
    end;
    Close;
  end;
  with zqDirectorioAlta do
  begin
    ParamByName('dir').AsString := Directorio;
    ParamByName('hoy').AsFloat := Now;
    ExecSQL;
  end;
  //recuperar el ID del directorio insertado
  zqUltId.Open;
  FDirectorioID := zqUltId.FieldByName('id').AsInteger;
  zqUltId.Close;
end;

procedure TdmDatos.IniciaSeleccion(JPGs, Raws: TStringList);
var
  i: Integer;
  JPG,
  Raw,
  Ext: string;
  NomArchJPG,
  NomArchRaw,
  Seleccionables: TStringList;
begin
  Seleccionables := TStringList.Create;
  NomArchJPG := TStringList.Create;
  NomArchRaw := TStringList.Create;
  Ext := ExtRaw;
  for i := 0 to JPGs.Count - 1 do
    NomArchJPG.Add(ExtractFileName(JPGs.Strings[i]));
  for i := 0 to Raws.Count - 1 do
    NomArchRaw.Add(ExtractFileName(Raws.Strings[i]));
  //verificar paridad JPG-Raw y guardar jpg seleccionables
  for i := 0 to JPGs.Count - 1 do
  begin
    JPG := NomArchJPG.Strings[i];
    Raw := ChangeFileExt(JPG, '.' + Ext);
    //¿hay un raw contraparte del jpg?
    if NomArchRaw.IndexOf(Raw) > - 1 then
      Seleccionables.Add(JPGs.Strings[i])
  end;
  //agregar archivos a base de datos
  for i := 0 to Seleccionables.Count - 1 do
    ArchivoAlta(Seleccionables.Strings[i]);
  Seleccionables.Free;
  NomArchRaw.Free;
  NomArchJPG.Free;
  //crear selecciones por omisión
  if not HaySelecciones then
  begin
    for i := 1 to 6 do
      SeleccionAlta('Cambio ' + IntToStr(i));
  end;
  //desplegar selecciones
  with zqSelecciones do
  begin
    Close;
    ParamByName('dir').AsInteger := FDirectorioID;
    Open;
  end;
  //llenar listado de archivos
  with zqArchivos do
  begin
    Close;
    ParamByName('dir').AsInteger := FDirectorioID;
    Open;
  end;
end;

procedure TdmDatos.SeleccionAlta(Descripcion: string);
begin
  with zqSeleccionAlta do
  begin
    ParamByName('dir').AsInteger := FDirectorioID;
    ParamByName('des').AsString := Descripcion;
    ExecSQL;
  end;
end;

procedure TdmDatos.AgregaCambio;
var
  SeleccionActual,
  Total: Integer;
begin
  SeleccionActual := zqSelecciones.RecNo;
  Total := Cambios;
  zqSelecciones.Close;
  SeleccionAlta('Cambio ' + IntToStr(Total + 1));
  zqSelecciones.Open;
  zqSelecciones.RecNo := SeleccionActual;
end;

procedure TdmDatos.BorraCambio;
var
  id: Integer;
begin
  id := zqSelecciones.FieldByName('id').AsInteger;
  zqSelecciones.Close;
  zqSeleccionBaja.ParamByName('id').AsInteger := id;
  zqSeleccionBaja.ExecSQL;
  zqDeselecciona.ParamByName('sel').AsInteger := id;
  zqDeselecciona.ExecSQL;
  zqSelecciones.Open;
end;

end.

