unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  UITypes, uVersaoAplicativo;

type
  TfmPrincipal = class(TForm)
    odBuscarArquivo: TOpenDialog;
    TimerMonitor: TTimer;
    gbCompactador: TGroupBox;
    Image1: TImage;
    edDirArquivo: TEdit;
    btCompactar: TButton;
    lbProcessando: TLabel;
    procedure btCompactarClick(Sender: TObject);
    procedure TimerMonitorTimer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FVersaoAplicativo: String;
    FArquivoBATCompactar: TextFile;
    FArquivoEXE: String;
    FArquivoUPX: String;
    FCaminhoArquivoEXE: String;
    FComandoCompactar: String;
    function CriarArquivoBAT(): Boolean;
    procedure Processando();
    procedure PegarCaminhoEXE();
    procedure ExecComandoCompactar();
    procedure ValidarArquivos();
  public
    { Public declarations }
  end;

var
  fmPrincipal: TfmPrincipal;

const
   COMANDO_COMPACTAR = 'upx compress ';

implementation

{$R *.dfm}

function TfmPrincipal.CriarArquivoBAT: Boolean;
begin
   try
      FComandoCompactar := COMANDO_COMPACTAR + '"' + FCaminhoArquivoEXE + '"';
      AssignFile(FArquivoBATCompactar, 'compactar.bat');
      Rewrite(FArquivoBATCompactar);
      WriteLn(FArquivoBATCompactar, FComandoCompactar);
      CloseFile(FArquivoBATCompactar);

      Exit(True);
   except
      Exit(False);
   end;
end;

procedure TfmPrincipal.ExecComandoCompactar;
begin
   try
      gbCompactador.Enabled := False;
      WinExec('compactar.bat', SW_HIDE);
      TimerMonitor.Enabled := True;
      lbProcessando.Caption := 'Compactando...';
   except
      MessageDlg('Erro para compactar o arquivo!', mtError, [mbOK], 0);
   end;
end;

procedure TfmPrincipal.FormActivate(Sender: TObject);
begin
   Caption := Caption + ' - ' + FVersaoAplicativo;
end;

procedure TfmPrincipal.FormCreate(Sender: TObject);
begin
   FVersaoAplicativo := TVersaoAplicativo.GetVersaoAplicacao();
end;

procedure TfmPrincipal.PegarCaminhoEXE;
begin
   lbProcessando.Caption := EmptyStr;
   odBuscarArquivo.Execute();
   FCaminhoArquivoEXE := odBuscarArquivo.FileName;
   FArquivoUPX := StringReplace(FCaminhoArquivoEXE, '.exe', '.upx', [rfReplaceAll]);
   FArquivoEXE := ExtractFileName(odBuscarArquivo.FileName);
end;

procedure TfmPrincipal.Processando;
begin
   if (not FileExists(FArquivoUPX)) then
   begin
      lbProcessando.Caption := 'Arquivo compactado com sucesso!';
      btCompactar.Enabled := True;
      TimerMonitor.Enabled := False;
      gbCompactador.Enabled := True;
   end;

end;

procedure TfmPrincipal.ValidarArquivos;
begin
   if (not FileExists(FCaminhoArquivoEXE)) then
      Abort();
end;

procedure TfmPrincipal.TimerMonitorTimer(Sender: TObject);
begin
   Processando();
end;

procedure TfmPrincipal.btCompactarClick(Sender: TObject);
begin
   ValidarArquivos();

   if (CriarArquivoBAT()) then
      ExecComandoCompactar();
end;

procedure TfmPrincipal.Image1Click(Sender: TObject);
begin
   PegarCaminhoEXE();
   edDirArquivo.Text := FCaminhoArquivoEXE;
end;

end.
