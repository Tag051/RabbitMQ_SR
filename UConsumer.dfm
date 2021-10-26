object FrmConsumer: TFrmConsumer
  Left = 0
  Top = 0
  Caption = 'Consumer'
  ClientHeight = 239
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  DesignSize = (
    485
    239)
  PixelsPerInch = 96
  TextHeight = 13
  object MMessages: TMemo
    Left = 8
    Top = 75
    Width = 469
    Height = 156
    Anchors = [akLeft, akTop, akRight, akBottom]
    Enabled = False
    TabOrder = 0
  end
  object GBSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 472
    Height = 64
    TabOrder = 1
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
      Top = 36
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
end
