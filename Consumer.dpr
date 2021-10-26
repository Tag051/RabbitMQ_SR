program Consumer;

uses
  Vcl.Forms,
  UConsumer in 'UConsumer.pas' {FrmConsumer},
  StompClient in 'StompClient.pas' {$R *.res};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmConsumer, FrmConsumer);
  Application.Run;
end.
