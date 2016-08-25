program FotoFlu;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, uPrincipalFrm, uEstructuraFrm, uOpcionesFrm, uCopiar,
  udatosdm
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmDatos, dmDatos);
  Application.CreateForm(TfrmOpciones, frmOpciones);
  Application.Run;
end.

