object Form2: TForm2
  Left = 207
  Top = 651
  Width = 257
  Height = 250
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 144
    Width = 119
    Height = 13
    Caption = #1055#1086#1088#1090' '#1076#1083#1103' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103':'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 121
    Caption = ' '#1041#1091#1076#1080#1083#1100#1085#1080#1082#1080': '
    TabOrder = 0
    object Edit2: TEdit
      Left = 112
      Top = 24
      Width = 113
      Height = 21
      TabOrder = 0
      Text = 'Kursk'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 24
      Width = 73
      Height = 17
      Caption = #1055#1086' '#1082#1072#1088#1090#1077':'
      TabOrder = 1
      OnClick = CheckBox1Click
    end
    object SpinEdit1: TSpinEdit
      Left = 112
      Top = 56
      Width = 49
      Height = 22
      MaxValue = 64
      MinValue = 1
      TabOrder = 2
      Value = 2
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 56
      Width = 97
      Height = 17
      Caption = #1055#1086' '#1082#1086#1083'. '#1085#1072#1088#1086#1076#1091
      TabOrder = 3
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 88
      Width = 145
      Height = 17
      Caption = #1053#1072' '#1089#1083#1077#1076#1091#1102#1097#1077#1081' '#1082#1072#1088#1090#1077
      TabOrder = 4
    end
  end
  object Button1: TButton
    Left = 80
    Top = 184
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 1
    OnClick = Button1Click
  end
  object SpinEdit2: TSpinEdit
    Left = 136
    Top = 144
    Width = 81
    Height = 22
    MaxValue = 65535
    MinValue = 1
    TabOrder = 2
    Value = 23000
  end
end
