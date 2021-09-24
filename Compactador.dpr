program Compactador;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {fmPrincipal},
  uVersaoAplicativo in 'uVersaoAplicativo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmPrincipal, fmPrincipal);
  Application.Run;
end.
