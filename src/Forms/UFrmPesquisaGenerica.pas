unit UFrmPesquisaGenerica;

interface

uses
  winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Data.DB,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Datasnap.DBClient,
  Vcl.Grids;

type
  TFrmPesquisaGenerica = class(TForm)
    lblTitulo: TLabel;
    edtFiltro: TEdit;
    btnSelecionar: TButton;
    dbgResultado: TDBGrid;
    dsResultado: TDataSource;
    procedure btnSelecionarClick(Sender: TObject);
    procedure dbgResultadoDblClick(Sender: TObject);
    procedure edtFiltroChange(Sender: TObject);
  private
    FCampoRetorno: string;
    FValorRetorno: Variant;
    FDataSetBase: TClientDataSet;
    FCampoFiltro: string;
    procedure FiltrarGrid(const Texto: string);
  public
    class function ExecutarPesquisa(const Titulo, CampoRetorno, CampoFiltro: string; DataSet: TClientDataSet; var ValorRetorno: Variant): Boolean;
  end;

var
  FrmPesquisaGenerica: TFrmPesquisaGenerica;

implementation

{$R *.dfm}

class function TFrmPesquisaGenerica.ExecutarPesquisa(const Titulo, CampoRetorno, CampoFiltro: string; DataSet: TClientDataSet; var ValorRetorno: Variant): Boolean;
begin
  with TFrmPesquisaGenerica.Create(nil) do
  try
    lblTitulo.Caption := Titulo;
    FCampoRetorno := CampoRetorno;
    FCampoFiltro := CampoFiltro;
    FDataSetBase := DataSet;
    dsResultado.DataSet := FDataSetBase;
    Result := (ShowModal = mrOk);

    if Result then
      ValorRetorno := FValorRetorno;
  finally
    Free;
  end;
end;

procedure TFrmPesquisaGenerica.btnSelecionarClick(Sender: TObject);
begin
  if not dsResultado.DataSet.IsEmpty then
  begin
    FValorRetorno := dsResultado.DataSet.FieldByName(FCampoRetorno).Value;
    ModalResult := mrOk;
  end;
end;

procedure TFrmPesquisaGenerica.dbgResultadoDblClick(Sender: TObject);
begin
  btnSelecionarClick(Sender);
end;

procedure TFrmPesquisaGenerica.edtFiltroChange(Sender: TObject);
begin
  FiltrarGrid(edtFiltro.Text);
end;

procedure TFrmPesquisaGenerica.FiltrarGrid(const Texto: string);
var
  Campo: TField;
  Num: Integer;
begin
  if Assigned(FDataSetBase) then
  begin
    FDataSetBase.Filtered := False;

    if Trim(Texto) <> '' then
    begin
      Campo := FDataSetBase.FieldByName(FCampoFiltro);

      if Campo.DataType in [ftInteger, ftSmallint, ftWord, ftLargeint] then
      begin
        if TryStrToInt(Texto, Num) then
          FDataSetBase.Filter := Format('%s = %d', [FCampoFiltro, Num])
        else
          FDataSetBase.Filter := '1=0';
      end
      else
      begin
        FDataSetBase.Filter := Format('%s LIKE ''%%%s%%''', [FCampoFiltro, Texto]);
      end;

      FDataSetBase.Filtered := True;
    end;
  end;
end;

end.

