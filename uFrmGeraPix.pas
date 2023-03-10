unit uFrmGeraPix;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.ShellAPI,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;
type
  TFrmGeraPix = class(TForm)
    LabelInstrucaoChave: TLabel;
    LabelInstrucaoValor: TLabel;
    LabelInstrucaoIdPag: TLabel;
    MemoPIX: TMemo;
    QRCode: TImage;
    BtnGeraPix: TButton;
    BtnGerarQR: TButton;
    LabelOndeTestar: TLabel;
    LabelSiteTeste: TLabel;
    lblCriadoPor: TLabel;
    lblCreditos: TLabel;
    lblCriadoTestado: TLabel;
    pnlPrincipal: TPanel;
    imgLogoPix: TImage;
    edtChavePix: TLabeledEdit;
    edtValor: TLabeledEdit;
    edtNome: TLabeledEdit;
    edtCidade: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    edtIdentificador: TLabeledEdit;
    procedure BtnGeraPixClick(Sender: TObject);
    procedure BtnGerarQRClick(Sender: TObject);
    procedure PintarQRCode(APict: TPicture; Pix: String);
    procedure LabelSiteTesteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pix: String;
  end;
var
  FrmGeraPix: TFrmGeraPix;
implementation
uses
  ACBrDelphiZXingQRCode, uClassePix;
{$R *.dfm}
 procedure TFrmGeraPix.LabelSiteTesteClick(Sender: TObject);
begin
    ShellExecute(handle,'open','https://pix.nascent.com.br/tools/pix-qr-decoder/',nil,nil,sw_show);
end;
// Botao para adicionar pix ao memo
procedure TFrmGeraPix.BtnGeraPixClick(Sender: TObject);
var
  chavePix: String;
begin
  var infoPix := TInformacoesPix.Create;
  try
    with infoPix do
    begin
      ChavePix      := edtChavePix.Text;
      Valor         := edtValor.Text;
      Nome          := edtNome.Text;
      Cidade        := edtCidade.Text;
      Descricao     := edtDescricao.Text;
      Identificador := edtIdentificador.Text;
    end;
    chavePix := infoPix.GerarPix;
  finally
    FreeAndNil(infoPix);
  end;
  if chavePix <> '' then
  begin
    MemoPIX.Lines.Clear;
    MemoPIX.Lines.Add(chavePix);
  end;
end;
procedure TFrmGeraPix.BtnGerarQRClick(Sender: TObject);
begin
  if MemoPIX.Lines.Text <> '' then
    PintarQRCode(QRCode.Picture, MemoPIX.Lines.Text)
  else
    raise Exception.Create('Atenção! Gere o PIX antes de gerar o QRCode!');
end;
//Créditos: ACBr e Foxit Software por disponibilizarem o gerador de QRCode DelphiZXingQRCode
procedure TFrmGeraPix.PintarQRCode(APict: TPicture; Pix: String);
var
  QRCode: TDelphiZXingQRCode;
  QRCodeBitmap: TBitmap;
  Row, Column: Integer;
begin
  QRCode       := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  try
   // QRCode.Encoding  := qrUTF8NoBOM;
    QRCode.QuietZone := 1;
    QRCode.Data      := AnsiToUTF8(Trim(Pix));
    //QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    QRCodeBitmap.Width  := QRCode.Columns;
    QRCodeBitmap.Height := QRCode.Rows;
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack
        else
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
      end;
    end;
    APict.Assign(QRCodeBitmap);
  finally
    QRCode.Free;
    QRCodeBitmap.Free;
  end;
end;
end.
