unit FrmProducer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  StompClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TFmProducer = class(TForm)
    EHost: TEdit;
    EQueue: TEdit;
    EProducerName: TEdit;
    BtEnter: TButton;
    BtSend: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GBSettings: TGroupBox;
    GBSendMessages: TGroupBox;
    MSentMessage: TMemo;
    MMessages: TMemo;
    procedure BtEnterClick(Sender: TObject);
    procedure BtSendClick(Sender: TObject);
  private
    { Private declarations }
    stomp: IStompClient;
    queue: string;
    procedure InsertToBD(Queuename: string; ProduserName: string; Msg: string; sentDateTime: TDateTime);
    procedure InsertToMemo(Queuename: string; ProduserName: string; Msg: string; sentDateTime: TDateTime);
  public
    { Public declarations }
  end;

var
  FmProducer: TFmProducer;
  const DateTimeFormat = 'yyyy/mm/dd hh:mm:ss';

implementation

{$R *.dfm}

procedure TFmProducer.BtEnterClick(Sender: TObject);
begin
  stomp:= StompUtils.StompClient(); //Create Stomp client
  //stomp.SetUserName('guest');
  //stomp.SetPassword('quest');
  stomp.SetHost(EHost.Text);
  queue:= '/queue/'+EQueue.Text;

  //Disable setting controls
  GBSettings.Enabled:= false;
  Label1.Enabled:= false;
  Label2.Enabled:= false;
  Label3.Enabled:= false;
  EHost.Enabled:= false;
  EQueue.Enabled:= false;
  EProducerName.Enabled:= false;
  BtEnter.Enabled:= false;

  //Enable message contlors
  GBSendMessages.Enabled:= true;
  MMessages.Enabled:= true;
  MSentMessage.Enabled:= true;
  BtSend.Enabled:= true;
end;

procedure TFmProducer.BtSendClick(Sender: TObject);
var
  producerName, msg, sentDateTimestr: string;
  headers: IStompHeaders;
  sentDateTime: TDateTime;
begin
  msg:= MSentMessage.Lines.Text;  //sender message
  producerName:= EProducerName.Text;
  headers:= StompUtils.Headers;  //Create Headers;
  sentDateTime := now;
  sentDateTimestr:= FormatDateTime('yyyy/mm/dd hh:mm:ss',sentDateTime);
  //send message
  headers.add('sender', producerName);
  headers.Add('sentDateTime', sentDateTimestr);

  stomp.Connect;
  stomp.Send(queue, msg, Headers);
  stomp.Disconnect;
  InsertToMemo(queue, producerName, msg, sentDateTime);
  //add to DB
  InsertToBD(queue, producerName, msg, sentDateTime);
  MSentMessage.Lines.Clear();
end;

procedure TFmProducer.InsertToBD(Queuename, ProduserName, Msg: string;
  sentDateTime: TDateTime);
var
  FDConnection: TFDConnection;
  DatetimeStr: string;
  sql: string;
begin

  FDConnection:= TFDConnection.Create(self);
  FDConnection.DriverName:= 'SQLite';
  FDConnection.Params.Add('DriverID=SQLite');
  FDConnection.Params.Add('Database=DBProducer.db');
  FDConnection.LoginPrompt:= false;
  FDConnection.Open();
  DateTimeStr:= FormatDateTime(DateTimeFormat,sentDateTime);
  sql:= 'INSERT INTO SentMessages(queue, owner, message, send_date)'+
  ' VALUES("'+Queuename+ '", "'+ProduserName+'", "'+Msg+'", "'+DateTimeStr+'")';
  FDConnection.ExecSQL(sql);

  FDConnection.Close;
end;

procedure TFmProducer.InsertToMemo(Queuename, ProduserName, Msg: string;
  sentDateTime: TDateTime);
var
  sentDateTimestr :string;
begin
  sentDateTimestr:= FormatDateTime(DateTimeFormat,sentDateTime);
  MMessages.Lines.Add('['+sentDateTimestr+' '+ProduserName+']'+sLineBreak+msg);
end;

end.
