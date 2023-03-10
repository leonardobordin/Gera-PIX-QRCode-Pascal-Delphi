unit uClassePix;

interface

uses SysUtils;

type TInformacoesPix = class
  private
    FChavePix: String;
    FValor: String;
    FNome: String;
    FCidade: String;
    FDescricao: String;
    FIdentificador: String;
  public
    property ChavePix: String read FChavePix write FChavePix;
    property Valor: String read FValor write FValor;
    property Nome: String read FNome write FNome;
    property Cidade: String read FCidade write FCidade;
    property Descricao: String read FDescricao write FDescricao;
    property Identificador: String read FIdentificador write FIdentificador;

    function GerarPix: String;
    function CRC16CCITT(texto: string): WORD;
    function RetornaQtdeZeroEsquerda(Str: String): String;


end;

implementation

{ TInformacoesPix }

function TInformacoesPix.GerarPix: String;
var
  pix, temp: String;
  tamanhoCampo: Integer;
  CRC16: String;
begin
  pix := '000201';        // Predefinido inicio  PADRAO ID + TAMANHO + VALOR - versão do payload QRCPS-MPM, fixo em “01”
  pix := pix + '010211';  // “11” (QR reutilizavel) ou “12” (QR utilizavel apenas uma vez)
  pix := pix + '26';      // “26” – indica arranjo especifico - Merchant Account Information
  temp := '0014br.gov.bcb.pix'; //  “00” (GUI) obrigatório e "14" tamanho do "br.gov.bcb.pix"  - AQUI ENTRA O TAMANHO DE CARACTERES ATE O FINAL DA DESCRICAO POR ISSO A CRIACAO DO TEMP
  // Se possuir chave adicionar 01 + Numero de Caracteres da Chave
  // Verificando Tamanho da Chave PIX - chave de enderecamento MAXIMO de 77 caracteres segundo documentacao
  temp := temp + '01' + RetornaQtdeZeroEsquerda(FChavePix) + FChavePix;
  // Contem Descrição adicionar 02 + Numero de Caracteres da Descricao + Descricao - conjunto livre de caracteres com limite de tamanho de 72
  temp := temp + '02' + RetornaQtdeZeroEsquerda(FDescricao) + FDescricao;
  // Contando caracteres do inicio do 0014br.gov.bcb ate descricao
  pix := pix + RetornaQtdeZeroEsquerda(temp) + temp;
  // Adicionando predefinicao ID:52 e ID:53
  pix := pix + '52040000'; // Merchant Category Code
  pix := pix + '5303986';  // Transaction Currency = 986(R$)
  // Adicionando Valor  ID:54 - Transaction Amount - Valor da Transação Tamanho maximo de 13 caracteres
  pix := pix + '54' + RetornaQtdeZeroEsquerda(FValor) + FValor;
  // Adicionado predefinicao ID:58 TAMANHO:02 VALOR:BR - Country Code - CODIGO DO PAIS
  pix := pix + '5802BR';
  // Adicionando Beneficiario - Merchant Name - ID: 59
  pix := pix + '59' + RetornaQtdeZeroEsquerda(FNome) + FNome;
  pix := pix + '60' + RetornaQtdeZeroEsquerda(FCidade) + FCidade;
  // IDENTIFICADOR
  temp := '05' + RetornaQtdeZeroEsquerda(FIdentificador) + FIdentificador;
  pix := pix + '62' + RetornaQtdeZeroEsquerda(temp) + temp;
  // Adicionando ID6304 ANTES PARA FORMULAR CRC16
  pix := pix + '6304';
 // Adicionando CRC16 - Campo Mandatorio - ID:63
  CRC16 := inttohex(CRC16CCITT(pix),4);
  pix := pix + CRC16;
  Result := pix;
end;

function TInformacoesPix.CRC16CCITT(texto: string): WORD;
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

function TInformacoesPix.RetornaQtdeZeroEsquerda(Str: String): String;
begin
  result := '00';
  var LengthStr := Length(Str);

  if (LengthStr > 0) And (LengthStr < 10) then
    result := '0' + IntToStr(LengthStr)
  else if LengthStr >= 10 then
    result := IntToStr(LengthStr);
end;


end.
