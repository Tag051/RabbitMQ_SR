program Producer;

uses
  Vcl.Forms,
  FrmProducer in 'FrmProducer.pas' {FmProducer},
  StompClient in 'StompClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFmProducer, FmProducer);
  Application.Run;
end.
