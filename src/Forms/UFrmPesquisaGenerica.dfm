object FrmPesquisaGenerica: TFrmPesquisaGenerica
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pesquisa'
  ClientHeight = 350
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 10
    Top = 10
    Width = 47
    Height = 15
    Caption = 'Pesquisa'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtFiltro: TEdit
    Left = 10
    Top = 35
    Width = 350
    Height = 23
    TabOrder = 0
    OnChange = edtFiltroChange
  end
  object btnSelecionar: TButton
    Left = 380
    Top = 33
    Width = 90
    Height = 28
    Caption = 'Selecionar'
    TabOrder = 1
    OnClick = btnSelecionarClick
  end
  object dbgResultado: TDBGrid
    Left = 10
    Top = 70
    Width = 580
    Height = 260
    DataSource = dsResultado
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = dbgResultadoDblClick
  end
  object dsResultado: TDataSource
    Left = 104
    Top = 88
  end
end
