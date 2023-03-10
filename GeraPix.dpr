program GeraPix;
uses
  Vcl.Forms,
  ACBrDelphiZXingQRCode in 'ACBrDelphiZXingQRCode.pas',
  Vcl.Themes,
  Vcl.Styles,
  uFrmGeraPix in 'uFrmGeraPix.pas' {FrmGeraPix},
  uClassePix in 'uClassePix.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TFrmGeraPix, FrmGeraPix);
  Application.Run;
end.
