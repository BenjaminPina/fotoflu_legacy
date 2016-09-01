unit uPrincipalFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ShellCtrls, ValEdit, DefaultTranslator,
  DBGrids, udatosdm, ComCtrls, DbCtrls;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    BitBtn1: TBitBtn;
    btbDistribuir: TBitBtn;
    btbExportarSelectas: TBitBtn;
    btbExplorarImagenes: TBitBtn;
    btbCrearEstructura: TBitBtn;
    dbeCambio: TDBEdit;
    dbgSelecciones: TDBGrid;
    dbtArchivo: TDBText;
    dbtSel: TDBText;
    grbDirectorio: TGroupBox;
    grbAcciones: TGroupBox;
    grbImagen: TGroupBox;
    grbEstadisticas: TGroupBox;
    imgImagen: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    scbPosicion: TScrollBar;
    spbIzq: TSpeedButton;
    spbDer: TSpeedButton;
    spbRotarAH: TSpeedButton;
    spbRotarH: TSpeedButton;
    spbNoRotar: TSpeedButton;
    spbAgregaSeleccion: TSpeedButton;
    spbEliminaSeleccion: TSpeedButton;
    spbFiltrar: TSpeedButton;
    spbSeleccionar: TSpeedButton;
    spbDeseleccionar: TSpeedButton;
    spbBorrar: TSpeedButton;
    sttFiltro: TStaticText;
    sttTotal: TStaticText;
    sttPos: TStaticText;
    sttCambios: TStaticText;
    sttBorrar: TStaticText;
    stvDir: TShellTreeView;
    spbOpciones: TSpeedButton;
    procedure btbCrearEstructuraClick(Sender: TObject);
    procedure btbDistribuirClick(Sender: TObject);
    procedure btbExplorarImagenesClick(Sender: TObject);
    procedure btbExportarSelectasClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure imgImagenClick(Sender: TObject);
    procedure scbPosicionChange(Sender: TObject);
    procedure spbAgregaSeleccionClick(Sender: TObject);
    procedure spbDerClick(Sender: TObject);
    procedure spbEliminaSeleccionClick(Sender: TObject);
    procedure spbNoRotarClick(Sender: TObject);
    procedure spbOpcionesClick(Sender: TObject);
    procedure spbIzqClick(Sender: TObject);
    procedure spbRotarAHClick(Sender: TObject);
    procedure spbRotarHClick(Sender: TObject);
    procedure stvDirChange(Sender: TObject; Node: TTreeNode);
  private
    { private declarations }
    procedure CreaEstructura;
    procedure ObtenListaArchivos(Directorio, Filtro: string; Lista: TStringList);
    procedure IniciaSeleccion;
    procedure DespliegaFoto;
    procedure DespliegaEstadisticas;
    procedure Marca(Cambio: Integer);
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uOpcionesFrm, uCopiar, LCLType, RotaImg, db;

{$R *.lfm}

{ TfrmPrincipal }


procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  grbImagen.Enabled := False;
  grbEstadisticas.Enabled := False;
  sttPos.Caption := '0/0';
  sttCambios.Caption := '';
  sttTotal.Caption := '';
  sttBorrar.Caption := '';
  Caption := Caption + dmDatos.Version;
  if DirectoryExists(dmDatos.Directorio) then
    stvDir.Path := dmDatos.Directorio;
  if dmDatos.Ventana = 1 then
    WindowState := wsMaximized
  else
    WindowState := wsNormal;
end;

procedure TfrmPrincipal.FormWindowStateChange(Sender: TObject);
begin
  if WindowState = wsMaximized then
    dmDatos.Ventana := 1
  else
    dmDatos.Ventana := 0;
end;

procedure TfrmPrincipal.imgImagenClick(Sender: TObject);
begin
  spbDerClick(Self);
end;

procedure TfrmPrincipal.scbPosicionChange(Sender: TObject);
begin
  if scbPosicion.Focused then
    DespliegaFoto;
end;

procedure TfrmPrincipal.spbAgregaSeleccionClick(Sender: TObject);
begin
  dmDatos.AgregaCambio;
end;

procedure TfrmPrincipal.spbDerClick(Sender: TObject);
begin
  //si es la última foto, regresar a la primera
 { if Pos < JPGs.Count then
    Inc(Pos)
  else
    Pos := 1;
  DespliegaFoto;  }
end;

procedure TfrmPrincipal.spbEliminaSeleccionClick(Sender: TObject);
var
  Cambio: string;
begin
  Cambio := dmDatos.zqSelecciones.FieldByName('descripcion').AsString;
  if MessageDlg('¿Estás seguro de elminar el cambio "' + Cambio + '"?',
      mtConfirmation, mbYesNo, 0) = mrYes then
    dmDatos.BorraCambio;
end;

procedure TfrmPrincipal.spbNoRotarClick(Sender: TObject);
begin
  spbRotarAH.Down := False;
  spbRotarH.Down := False;
  DespliegaFoto;
end;

procedure TfrmPrincipal.spbOpcionesClick(Sender: TObject);
begin
  frmOpciones.ShowModal;
end;

procedure TfrmPrincipal.spbIzqClick(Sender: TObject);
begin
  //si es la primer foto, saltar a la última
  {if Pos > 1 then
    Dec(Pos)
  else
    Pos := JPGs.Count;
  DespliegaFoto; }
end;

procedure TfrmPrincipal.spbRotarAHClick(Sender: TObject);
begin
  //Si está seleccionado rotar H, enderezar
  if spbRotarH.Down then
    spbNoRotarClick(Self)
  else
  begin
    RotateBitmap90(imgImagen.Picture.Bitmap);
    spbRotarAH.Down := True;
   // spbRotarH.Down := False;
  end;
end;

procedure TfrmPrincipal.spbRotarHClick(Sender: TObject);
begin
  //Si está seleccionado rotar AH, enderezar
  if spbRotarAH.Down then
    spbNoRotarClick(Self)
  else
  begin
    RotateBitmap180(imgImagen.Picture.Bitmap);
    spbRotarH.Down := True;
    //spbRotarAH.Down := False;
  end;
end;

procedure TfrmPrincipal.stvDirChange(Sender: TObject; Node: TTreeNode);
begin
  dmDatos.Directorio := stvDir.Path;
end;

procedure TfrmPrincipal.CreaEstructura;
var
  Dir, s: string;
begin
  Dir := stvDir.Path;
  Dir := Dir + DirectorySeparator;
  with dmDatos.zqDestinos do
  begin
    First;
    while not EOF do
    begin
      s := Dir + FieldByName('descripcion').AsString;
      if not DirectoryExists(s) then
        if not CreateDir(s) then
          MessageDlg('Error', 'No se pudo crear el directorio "' + s + '"', mtError, [mbOK], 0);
      Next;
    end;
  end;
  MessageDlg('Creación de estructura de directorios finalizada.', mtInformation, [mbOK], 0);
end;

procedure TfrmPrincipal.ObtenListaArchivos(Directorio, Filtro: string;
  Lista: TStringList);
var
  SR: TSearchRec;
  Encontrado: Boolean;
begin
  Lista.Clear;
  Encontrado:=
    FindFirst(Directorio + Filtro, faAnyFile - faDirectory, SR) = 0;
  while Encontrado do
  begin
    Lista.Add(Directorio + SR.Name);
    Encontrado := FindNext(SR) = 0;
  end;
  FindClose(SR);
end;

procedure TfrmPrincipal.IniciaSeleccion;
begin
  //Inicializar indicadores de posición
  sttPos.Caption := '1/' + IntToStr(dmDatos.TotalArchivos);
  scbPosicion.Max := dmDatos.TotalArchivos;
  scbPosicion.Position := 1;
  DespliegaFoto;
  DespliegaEstadisticas;
  grbImagen.Enabled := True;
  grbEstadisticas.Enabled := True;
  grbImagen.SetFocus;
end;

procedure TfrmPrincipal.DespliegaFoto;
begin
 sttPos.Caption := IntToStr(dmDatos.FotoActual) + '/'
    + IntToStr(dmDatos.TotalArchivos);
 scbPosicion.Position := dmDatos.FotoActual;
 imgImagen.Picture.LoadFromFile(dbtArchivo.Caption);
 if spbRotarAH.Down then
  RotateBitmap90(imgImagen.Picture.Bitmap);
 if spbRotarH.Down then
  RotateBitmap180(imgImagen.Picture.Bitmap);
end;

procedure TfrmPrincipal.DespliegaEstadisticas;
begin
  with dmDatos do
  begin
    sttCambios.Caption := IntToStr(Cambios);
    sttTotal.Caption := IntToStr(Seleccionadas);
    sttBorrar.Caption := IntToStr(ParaBorrar);
  end;
end;

procedure TfrmPrincipal.Marca(Cambio: Integer);
begin
 { if Selectas[Pos - 1] = -1 then //¿estaba marcada para borrado?
    Selectas[Pos - 1] := 0;
  if Selectas[Pos - 1] <> 0 then //¿ya estaba seleccionada?
    Dec(Contadores[Selectas[Pos - 1]]);
  Selectas[Pos - 1] := Cambio;
  if Cambio > 0 then
    Inc(Contadores[Cambio]);
  sttSel.Caption := IntToStr(Cambio);
  DespliegaEstadisticas;}
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  frmOpciones.Free;
end;

procedure TfrmPrincipal.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {
  case Key of
    VK_RIGHT, VK_SPACE: spbDerClick(Self);
    VK_LEFT: spbIzqClick(Self);
    VK_UP: spbRotarAHClick(Self);
    VK_DOWN: spbRotarHClick(Self);
    VK_SHIFT: spbNoRotarClick(Self);
    VK_DELETE, 110: Marca(-1); //110 = punto de teclado numérico (Supr)
    96..105: Marca(Key - 96); //0..9 teclado numérico
    48..57: Marca(Key - 48); //0..9 teclado qwerty
  end; }
end;

procedure TfrmPrincipal.btbCrearEstructuraClick(Sender: TObject);
begin
  if DirectoryExists(stvDir.Path) then
    CreaEstructura
  else
    MessageDlg('Error', 'No existe el directorio especificado.', mtError, [mbOK], 0);
end;

procedure TfrmPrincipal.btbDistribuirClick(Sender: TObject);
var
  DirOri,
  DirDest: string;
  i: Integer;
  Origenes,
  Destinos: TStringList;
begin
  Origenes := TStringList.Create;
  Destinos := TStringList.Create;
  DirOri := dmDatos.Directorio;
  //copiar archivos JPG al subdirectorio correspondiente
  DirDest := dmDatos.DestinoJPG;
  if not DirectoryExists(DirDest) then
  begin
    MessageDlg('Error', 'No se ha creado el directorio destino para JPG.', mtError, [mbOK], 0);
    Exit; //-->
  end;
  ObtenListaArchivos(DirOri, '*.JPG', Origenes);
  for i := 0 to Origenes.Count - 1 do
    Destinos.Add(DirDest + ExtractFileName(Origenes.Strings[i]));
  frmCopiar := TfrmCopiar.Create(Self);
  frmCopiar.Origenes := Origenes;
  frmCopiar.Destinos := Destinos;
  frmCopiar.bPreservar := False;
  frmCopiar.ShowModal;
  frmCopiar.Free;
  Origenes.Clear;
  Destinos.Clear;
  //copiar archivos RAW al subdirectorio correspondiente
  DirDest := dmDatos.DestinoRaw;
  if not DirectoryExists(DirDest) then
  begin
    MessageDlg('Error', 'No se ha creado el directorio destino para RAW.', mtError, [mbOK], 0);
    Exit; //-->
  end;
  ObtenListaArchivos(DirOri, '*.' + dmDatos.ExtRaw, Origenes);
  for i := 0 to Origenes.Count - 1 do
    Destinos.Add(DirDest + ExtractFileName(Origenes.Strings[i]));
  frmCopiar := TfrmCopiar.Create(Self);
  frmCopiar.Origenes := Origenes;
  frmCopiar.Destinos := Destinos;
  frmCopiar.bPreservar := False;
  frmCopiar.ShowModal;
  frmCopiar.Free;
  Origenes.Free;
  Destinos.Free;
  MessageDlg('Los archivos fueron distribuidos.', mtInformation, [mbOK], 0);
end;

procedure TfrmPrincipal.btbExplorarImagenesClick(Sender: TObject);
var
  DirJPG,
  DirRaw: string;
  JPGs,
  Raws: TStringList;
  //Seleccionables contiene todos los JPG's que tienen su correspondiente raw
begin
  //obtener listas de archivos
  DirJPG := dmDatos.DestinoJPG;
  DirRaw := dmDatos.DestinoRaw;
  if not DirectoryExists(DirJPG) then
  begin
    MessageDlg('No existe el directorio de JPG.', mtError, [mbOK], 0);
    Exit; //-->
  end;
  if not DirectoryExists(DirRaw) then
  begin
    MessageDlg('No existe el directorio de Raw.', mtError, [mbOK], 0);
    Exit; //-->
  end;
  dmDatos.DirectorioAlta;
  JPGs := TStringList.Create;
  Raws := TStringList.Create;
  ObtenListaArchivos(DirJPG, '*.JPG', JPGs);
  ObtenListaArchivos(DirRaw, '*.' + dmDatos.ExtRaw, Raws);
  //verificar al menos un JPG
  if JPGs.Count = 0 then
  begin
    MessageDlg('No se encontraron achivos JPG para explorar.', mtError, [mbOK], 0);
    JPGs.Free;
    Raws.Free;
    Exit; //-->
  end;
  //verificar paridad JPG/RAW
  if JPGs.Count <> Raws.Count then
  begin
    MessageDlg('No coinciden las cantidades de archivos JPG y archivos Raw.' + #13#10
        + 'Las imágenes sin archivo Raw no serán desplegadas.', mtWarning, [mbOK], 0);
  end;
  //iniciar revisión de archivos
  dmDatos.IniciaSeleccion(JPGs, Raws);
  IniciaSeleccion;
  JPGs.Free;
  Raws.Free;
end;

procedure TfrmPrincipal.btbExportarSelectasClick(Sender: TObject);
{var
  ContBorr,
  i: Integer;
  ListaPorBorrar: TStringList;
  DirDest: string; }
begin
  {ContBorr := 0;
  ListaPorBorrar := TStringList.Create;
  Origenes.Clear;
  Destinos.Clear;
  for i := 0 to JPGs.Count - 1 do
  begin
    if Selectas[i] > 0 then
      Origenes.Add(Raws.Strings[i])
    else
    begin
      if Selectas[i] = - 1 then
      begin
        Inc(ContBorr);
        ListaPorBorrar.Add(JPGs.Strings[i]);
        ListaPorBorrar.Add(Raws.Strings[i]);
      end;
    end;
  end;
//  DirDest := stvDir.Path + DirectorySeparator + frmOpciones.cmbDSelectas.Text + DirectorySeparator;
  if not DirectoryExists(DirDest) then
  begin
   MessageDlg('No existe el directorio SELECTOS.', mtError, [mbOK], 0);
   ListaPorBorrar.Free;
   Exit; //-->
  end;

  //llenar lista de archivos destino
  for i := 0 to Origenes.Count - 1 do
    Destinos.Add(DirDest + ExtractFileName(Origenes.Strings[i]));

  //si se marcaron archivos para borrar pedir confirmación
  if ContBorr > 0 then
  begin
   if MessageDlg('¿Borrar archivos?'
       , 'Se marcaron ' + IntToStr(ContBorr) + ' archivos para ser borrados.'
       + '¿Confirma que desea eliminarlos?', mtConfirmation, mbYesNo, 0) = mrYes then
   begin
     for i := 0 to ListaPorBorrar.Count - 1 do
       DeleteFile(ListaPorBorrar.Strings[i]);
     MessageDlg('Los archivos marcados fueron eliminados.', mtInformation, [mbOK], 0);
   end;
  end;

  //exportar los raw selectos
  frmCopiar := TfrmCopiar.Create(Self);
  frmCopiar.Origenes := Origenes;
  frmCopiar.Destinos := Destinos;
  frmCopiar.bPreservar := True;
  frmCopiar.ShowModal;
  frmCopiar.Free;

  ListaPorBorrar.Free;
  bExportados := True;

  if MessageDlg('FotoFlu', 'Se exportaron los archivos selectos.'
      + '"Aceptar" parsa continuar en FotoFlu; "Cerrar" para salir'
      , mtConfirmation, [mbOK, mbClose], 0) = mrOK then
    btbExplorarImagenesClick(Self)
  else
    Close;  }
end;

end.

