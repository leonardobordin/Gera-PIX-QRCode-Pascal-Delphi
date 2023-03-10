unit U_GeraPix;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.ShellAPI,
  dxGDIPlusClasses;

type
  TFrmGeraPix = class(TForm)
    LabelChavePix: TLabel;
    LabelValor: TLabel;
    LabelBeneficiario: TLabel;
    LabelCidade: TLabel;
    EditChavePix: TEdit;
    EditValor: TEdit;
    EditBeneficiario: TEdit;
    EditCidade: TEdit;
    LabelInstrucaoChave: TLabel;
    LabelInstrucaoValor: TLabel;
    LabelInstrucaoIdPag: TLabel;
    LabelDescricao: TLabel;
    EditDescricao: TEdit;
    LabelIdentificadorPagamento: TLabel;
    EditIdentificadorPagamento: TEdit;
    MemoPIX: TMemo;
    QRCode: TImage;
    BtnGeraPix: TButton;
    BtnGerarQR: TButton;
    LabelOndeTestar: TLabel;
    LabelSiteTeste: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BtnGeraPixClick(Sender: TObject);
    function CRC16CCITT(texto: string): WORD;
    function gerapix(chavepix: String; valor: String; beneficiario: String;
                cidade: String; descricao: String; identificador: String): string;
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
  ACBrDelphiZXingQRCode;

{$R *.dfm}

 // CRC16
function TFrmGeraPix.CRC16CCITT(texto: string): WORD;
const
  polynomial = $1021;
var
  crc: WORD;
  i, j: Integer;
  b: Byte;
  bit, c15: Boolean;
begin
  crc := $FFFF;
  for i := 1 to length(texto) do
  begin
    b := Byte(texto[i]);
    for j := 0 to 7 do
    begin
      bit := (((b shr (7 - j)) and 1) = 1);
      c15 := (((crc shr 15) and 1) = 1);
      crc := crc shl 1;
      if (c15 xor bit) then
        crc := crc xor polynomial;
    end;
  end;
  Result := crc and $FFFF;
end;

function TFrmGeraPix.gerapix(chavepix: String; valor: String; beneficiario: String;
                cidade: String; descricao: String; identificador: String): string;
var
  linkpix: String;
  templink, ident, tempident: String;
  TamanhoChave: Integer;
  TamanhoDesc : Integer;
  TamanhoValor: Integer;
  TamanhoBeneficiario : Integer;
  TamanhoCidade, TamanhoTempLink, TamanhoIdentificador, TamanhoCompletoIdentificador: Integer;
  CRC16, desc: String;
begin
  // Predefinido inicio  PADRAO ID + TAMANHO + VALOR
  linkpix := '000201'; // versão do payload QRCPS-MPM, fixo em “01”
  linkpix := linkpix + '010211'; // “11” (QR reutilizavel) ou “12” (QR utilizavel apenas uma vez)

  linkpix := linkpix + '26';  // “26” – indica arranjo especifico - Merchant Account Information

  // AQUI ENTRA O TAMANHO DE CARACTERES ATE O FINAL DA DESCRICAO POR ISSO A CRIACAO DO TEMPLINK
  templink := '0014br.gov.bcb.pix'; //  “00” (GUI) obrigatório e "14" tamanho do "br.gov.bcb.pix"

  // Se possuir chave adicionar 01 + Numero de Caracteres da Chave + Chave SE NAO finalizar PROCESSO
  TamanhoChave := Length(chavepix); // Verificando Tamanho da Chave PIX
  if (TamanhoChave > 0) and (TamanhoChave <= 77) then  // chave de enderecamento  NAXIMO de 77 caracteres segundo documentacao
  begin
    if Length(IntToStr(TamanhoChave)) = 1 then     // Adicionando ZERO caso o tamanho seja menor que 10
    begin
      templink := templink + '01' + '0' + IntToStr(TamanhoChave) + chavepix;
    end
    else
    begin
      templink := templink + '01' + IntToStr(TamanhoChave) + chavepix;
    end;
  end
  else
  begin
    Application.MessageBox('Você deve cadastrar uma Chave PIX válida com tamanho máximo de 77 caracteres!',
      'Erro', MB_ICONERROR + MB_OK + MB_SYSTEMMODAL);
    Exit;
  end;

  // Contem Descrição adicionar 02 + Numero de Caracteres da Descricao + Descricao
  desc := copy(descricao, 1, 25);
  TamanhoDesc := Length(desc);
  if (TamanhoDesc > 0) and (TamanhoDesc <= 72) then   // conjunto livre de caracteres com limite de tamanho de 72
  begin
    if Length(IntToStr(TamanhoDesc)) = 1 then
    begin
      templink := templink + '02'+ '0' + IntToStr(TamanhoDesc) + desc;  // Adicionando ZERO caso o tamanho da DESC seja menor que 10 (OBRIGATORIO)
    end
    else
    begin
      templink := templink + '02' + IntToStr(TamanhoDesc) + desc;
    end;
  end;

  // Contando caracteres do inicio do 0014br.gov.bcb ate descricao
  TamanhoTempLink := Length(templink);
  linkpix := linkpix + IntToStr(TamanhoTempLink) + templink;

  // Adicionando predefinicao ID:52 e ID:53
  linkpix := linkpix + '52040000'; // Merchant Category Code
  linkpix := linkpix + '5303986';  // Transaction Currency = 986(R$)

  // Adicionando Valor  ID:54
  TamanhoValor := Length(valor);
  if (TamanhoValor > 0) and (TamanhoValor < 10) and (valor <> '0.00') then  // Transaction Amount - Valor da Transação Tamanho maximo de 13 caracteres
  begin
    linkpix := linkpix + '54' + '0' + IntToStr(TamanhoValor) + valor;  // Adicionando ZERO caso o tamanho do campo valor seja menor que 10
  end
  else if (TamanhoValor >= 10) then
  begin
     linkpix := linkpix + '54' + IntToStr(TamanhoValor) + valor;  // Adicionando apenas tamanho do campo e valor caso o tamanho seja maior que 10
  end
  else
  begin
    Application.MessageBox('Você deve fazer o PIX com um VALOR válido e MAIOR que ZERO!',
      'Erro', MB_ICONERROR + MB_OK + MB_SYSTEMMODAL);
    Exit;
  end;

  // Adicionado predefinicao ID:58 TAMANHO:02 VALOR:BR - Country Code - CODIGO DO PAIS
  linkpix := linkpix + '5802BR';

  // Adicionando Beneficiario - Merchant Name - ID: 59
  TamanhoBeneficiario := Length(beneficiario); // Verificando Tamanho do Beneficiario
  if  (TamanhoBeneficiario > 0) and (TamanhoBeneficiario < 10) then
  begin
    linkpix := linkpix + '59' + '0' + IntToStr(TamanhoBeneficiario) + beneficiario;
  end
  else if (TamanhoBeneficiario >= 10) and (TamanhoBeneficiario <= 25) then
  begin
    linkpix := linkpix + '59' + IntToStr(TamanhoBeneficiario) + beneficiario;
  end
  else if (TamanhoBeneficiario > 25) then
  begin
     Application.MessageBox('O Beneficiário não deve ultrapassar 25 caracteres!',
      'Erro', MB_ICONERROR + MB_OK + MB_SYSTEMMODAL);
    Exit;
  end
  else
  begin
    Application.MessageBox('Você deve cadastrar um Beneficiário com tamanho máximo de 25 caracteres!',
      'Erro', MB_ICONERROR + MB_OK + MB_SYSTEMMODAL);
    Exit;
  end;

  // Adicionando Cidade - Merchant City - ID:60
  TamanhoCidade := Length(cidade); // Pegando Cidade do Cliente
  if (TamanhoCidade > 0) and (TamanhoCidade <= 15) then
  begin
    if Length(IntToStr(TamanhoCidade)) = 1 then
    begin
      linkpix := linkpix + '60' + '0' +IntToStr(TamanhoCidade) + cidade;
    end
    else
    begin
      linkpix := linkpix + '60' + IntToStr(TamanhoCidade) + cidade;
    end;
  end
  else
  begin
    Application.MessageBox('Para gerar o PIX adicione uma CIDADE no Dados da Empresa!',
      'Erro', MB_ICONERROR + MB_OK + MB_SYSTEMMODAL);
    Exit;
  end;

  ident := StringReplace(identificador,' ','',[rfReplaceAll]);
  TamanhoIdentificador := length(identificador); // Pegando dos dados do Cliente - IDENTIFICADOR
  if (TamanhoIdentificador > 0) and (TamanhoIdentificador <= 20) then
  begin
    if Length(IntToStr(TamanhoIdentificador)) = 1 then
    begin
      tempident := '05' + '0' +IntToStr(TamanhoIdentificador) + identificador;
    end
    else
    begin
      tempident := '05' + IntToStr(TamanhoIdentificador) + identificador;
    end;
  end
  else
  begin
     tempident := '05' + '03' + '***';
  end;


  TamanhoCompletoIdentificador := length(tempident); // Pegando dos dados do Cliente - IDENTIFICADOR
  if (TamanhoCompletoIdentificador > 0) then
  begin
    if Length(IntToStr(TamanhoCompletoIdentificador)) = 1 then
    begin
      linkpix := linkpix + '62' + '0' +IntToStr(TamanhoCompletoIdentificador) + tempident;
    end
    else
    begin
      linkpix := linkpix + '62' + IntToStr(TamanhoCompletoIdentificador) + tempident;
    end;
  end;

  // Adicionando ID6304 ANTES PARA FORMULAR CRC16
  linkpix := linkpix + '6304';
  // Adicionando CRC16 - Campo Mandatorio - ID:63
  CRC16 := inttohex(CRC16CCITT(linkpix),4);
  linkpix := linkpix + CRC16;

  Result := linkpix;
end;


 procedure TFrmGeraPix.LabelSiteTesteClick(Sender: TObject);
begin
    ShellExecute(handle,'open','https://pix.nascent.com.br/tools/pix-qr-decoder/',nil,nil,sw_show);
end;

// Botao para adicionar pix ao memo
procedure TFrmGeraPix.BtnGeraPixClick(Sender: TObject);
begin
  pix := '';
  pix := gerapix(EditChavePix.Text, EditValor.Text, EditBeneficiario.Text, EditCidade.Text, EditDescricao.Text, EditIdentificadorPagamento.Text);
  if pix <> '' then
  begin
    MemoPIX.Lines.Clear;
    MemoPIX.Lines.Add(pix);
  end;
end;



procedure TFrmGeraPix.BtnGerarQRClick(Sender: TObject);
begin
  BtnGeraPixClick(Sender);
  if pix <> '' then
  begin
    PintarQRCode(QRCode.Picture, MemoPIX.Lines.Text);
  end;
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
