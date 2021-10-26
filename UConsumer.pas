unit UConsumer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, StompClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TFrmConsumer = class(TForm, IStompClientListener)
    MMessages: TMemo;
    GBSettings: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BtEnter: TButton;
    EHost: TEdit;
    EProducerName: TEdit;
    EQueue: TEdit;
    procedure BtEnterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Fstomp: IStompClient;
    Fqueue: string;
    FSTOMPListener: IStompListener;
    procedure FlashWindow();
    procedure InsertToBD(Queuename, ProduserName, Msg, sentDateTimeStr: string;
  receivedDateTime: TDateTime);
    procedure InsertToMemo(Queuename, ProduserName, Msg, sentDateTimeStr: string;
  receivedDateTime: TDateTime);
  public
    { Public declarations }
    procedure OnMessage(StompFrame: IStompFrame; var TerminateListener: Boolean);
    procedure OnListenerStopped(StompClient: IStompClient);
  end;

var
  FrmConsumer: TFrmConsumer;
  const DateTimeFormat = 'yyyy/mm/dd hh:mm:ss';

implementation

{$R *.dfm}

procedure TFrmConsumer.BtEnterClick(Sender: TObject);
begin
    Fstomp:= StompUtils.StompClient(); //Create Stomp client
  //  stomp.SetUserName('admin');
  //  stomp.SetPassword('password');
  Fstomp.SetHost(EHost.Text);
  Fstomp.Connect();
  Fqueue:= '/queue/'+EQueue.Text;  // /queue/ is queue list in rabbitmq, EQueue.Text is queue name
  Fstomp.Subscribe(Fqueue, amAuto); //subscribe to queue
  //subscription to events
  FSTOMPListener := StompUtils.CreateListener(FStomp, Self);
  FSTOMPListener.StartListening;
  //Disable setting controls
  GBSettings.Enabled:= false;
    //Enable message contlors
  MMessages.Enabled:= true;
 //Timer1.Enabled:= true;
end;

procedure TFrmConsumer.FlashWindow;
var
  fw: FLASHWINFO;
begin
  if (WindowState = wsMinimized) or (Application.ActiveFormHandle <> self.Handle) then
    begin
      fw.cbSize := SizeOf(FLASHWINFO);
      fw.hwnd := self.Handle;
      fw.dwFlags := FLASHW_ALL;
      fw.uCount := 5;
      fw.dwTimeout := 500;
      FlashWindowEx(fw);
    end;
end;

procedure TFrmConsumer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FSTOMPListener) then FSTOMPListener.StopListening;
  FSTOMPListener:= nil;
  if assigned(Fstomp) then
    if Fstomp.Connected then
      Fstomp.Disconnect;

end;

procedure TFrmConsumer.InsertToBD(Queuename, ProduserName, Msg, sentDateTimeStr: string;
  receivedDateTime: TDateTime);
var
  FDConnection: TFDConnection;
  receivedDateTimestr: string;
  sql: string;
begin
  FDConnection:= TFDConnection.Create(self);
  FDConnection.DriverName:= 'SQLite';
  FDConnection.Params.Add('DriverID=SQLite');
  FDConnection.Params.Add('Database=DBConsumer.db');
  FDConnection.LoginPrompt:= false;
  FDConnection.Open();

  receivedDateTimeStr:= FormatDateTime(DateTimeFormat, receivedDateTime);
  sql:= 'INSERT INTO ReceivedMessages(queue, owner, message, send_datetime, received_datetime)'+
  ' VALUES("'+Queuename+ '", "'+ProduserName+'", "'+Msg+'", "'+sentDateTimeStr+
  '", "'+receivedDateTimestr+'")';
  FDConnection.ExecSQL(sql);

  FDConnection.Close;
end;

procedure TFrmConsumer.InsertToMemo(Queuename, ProduserName, Msg, sentDateTimeStr: string;
  receivedDateTime: TDateTime);
var
  reciveDateTimeStr :string;
begin
  reciveDateTimeStr:= FormatDateTime(DateTimeFormat,receivedDateTime);
  MMessages.Lines.Add('['+sentDateTimestr+' / '+ reciveDateTimeStr+' '+
  ProduserName+']'+sLineBreak+msg);
end;


procedure TFrmConsumer.OnListenerStopped(StompClient: IStompClient);
begin
  MMessages.Lines.Add('Listener Stopped');
end;

procedure TFrmConsumer.OnMessage(StompFrame: IStompFrame;
  var TerminateListener: Boolean);
var
  producerName, msg, sentDateTimestr: string;
  headers: IStompHeaders;
  recieveDateTime: TDateTime;
begin
  if assigned(StompFrame) then
  begin
    headers:=StompFrame.Headers;
    producerName:= StompFrame.Headers.Value('sender');
    sentDateTimestr:= StompFrame.Headers.Value('sentDateTime');
    msg:=StompFrame.GetBody;
    recieveDateTime:= now();
    InsertToMemo(Fqueue, producerName, msg, sentDateTimeStr, recieveDateTime);
    InsertToBD(Fqueue, producerName, msg, sentDateTimeStr, recieveDateTime);
    FlashWindow();
  end;
  TerminateListener := false;
end;

end.
