# Gerador de PIX Estático e QR Code em Pascal(Delphi) 
Função em Pascal para Gerar PIX e QR Code

Está função foi feita para uso didático e você está livre para usa-lo em seu software

O Projeto foi feito em cima da Documentação do Banco Central de Padronização do Pix

# Documentação

A Documentação de Iniciação do PIX segue a Padronização de ID + TAMANHO + VALOR
Essas informações foram tiradas do Manual De Padroes ParaIniciacao Do Pix do Banco Central
 
 '000201' -> versão do payload QRCPS-MPM, fixo em “01”
 '010211' -> “11” (QR reutilizavel) ou “12” (QR utilizavel apenas uma vez)
 '26'     -> indica arranjo especifico - Merchant Account Information
 
 Neste momento entra o TAMANHO DE CARACTERES ATE O FINAL DA DESCRICAO
 
 '0014br.gov.bcb.pix' ->  “00” (GUI) obrigatório e "14" tamanho do "br.gov.bcb.pix"
 
 PARA OBTER MAIS INSTRUÇÕES BAIXE O PROJETO

# Gerador de PIX e QR Code

![GeraPix](https://user-images.githubusercontent.com/83251822/224440252-989f2aaa-32f1-4fa6-853f-f906d5262940.png)


# Créditos

-> ACBr e Foxit Software por disponibilizarem o gerador de QRCode DelphiZXingQRCode

-> Ao Usuario <a href="https://github.com/natanvferreira/">natanvferreira</a> por me auxiliar durante o processo

-> Ao Usuario <a href="https://github.com/renatomb/">renatomb</a> do GitHub por disponibilizar codigo em PHP para geração do PIX que serviu de grande ajuda
