object FmProducer: TFmProducer
  Left = 0
  Top = 0
  Caption = 'Producer'
  ClientHeight = 360
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    488
    360)
  PixelsPerInch = 96
  TextHeight = 13
  object GBSettings: TGroupBox
    Left = 8
    Top = 1
    Width = 472
    Height = 64
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 22
      Height = 13
      Caption = 'Host'
    end
    object Label2: TLabel
      Left = 135
      Top = 16
      Width = 32
      Height = 13
      Caption = 'Queue'
    end
    object Label3: TLabel
      Left = 264
      Top = 16
      Width = 73
      Height = 13
      Caption = 'Producer Name'
    end
    object BtEnter: TButton
      Left = 389
      Top = 33
      Width = 75
      Height = 25
      Caption = 'Enter'
      TabOrder = 0
      OnClick = BtEnterClick
    end
    object EHost: TEdit
      Left = 8
      Top = 35
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'localhost'
    end
    object EProducerName: TEdit
      Left = 262
      Top = 35
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Producer1'
    end
    object EQueue: TEdit
      Left = 137
      Top = 35
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'gpn'
    end
  end
  object GBSendMessages: TGroupBox
    Left = 8
    Top = 71
    Width = 472
    Height = 287
    Anchors = [akLeft, akTop, akRight, akBottom]
    Enabled = False
    TabOrder = 1
    ExplicitWidth = 465
    ExplicitHeight = 293
    DesignSize = (
      472
      287)
    object BtSend: TButton
      Left = 394
      Top = 233
      Width = 75
      Height = 50
      Anchors = [akRight, akBottom]
      Caption = 'Send'
      Enabled = False
      TabOrder = 0
      OnClick = BtSendClick
    end
    object MSentMessage: TMemo
      Left = 3
      Top = 233
      Width = 387
      Height = 47
      Anchors = [akLeft, akRight, akBottom]
      Enabled = False
      Lines.Strings = (
        'Message')
      TabOrder = 1
      ExplicitTop = 239
      ExplicitWidth = 380
    end
    object MMessages: TMemo
      Left = 2
      Top = 15
      Width = 468
      Height = 212
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Enabled = False
      TabOrder = 2
      ExplicitLeft = 3
    end
  end
end
